Dir[File.join(File.dirname(__FILE__), '../..', 'lib', 'feeds', '*.rb')].each { |f| require f }

require 'testftpd'

RSpec.describe Feeds::Retriever, type: :feature do
  
  let(:fixtures_dir) { File.join(File.dirname(__FILE__), '..', 'support', 'fixtures') }
  let(:fixture_filename) { 'feed.json' }
  
  describe 'class initialization' do

    it 'should raise Feeds::UnknownAgentError when agent is not known' do
      expect { Feeds::Retriever.new('unknown') }.to raise_error(Feeds::UnknownAgentError)
    end

  end

  describe 'is an ftp agent' do

    let(:ftp_port) { 21212 }
    let(:ftp_host) { '127.0.0.1' }
    let(:ftp_username) { 'username' }
    let(:ftp_password) { 'password' }

    let(:feeds_retriever) { Feeds::Retriever.new('ftp', {host: ftp_host, username: ftp_username, password: ftp_password, port: ftp_port }) }

    # run fake ftp server for AgentFtp tests
    before do
      @ftp_server = TestFtpd::Server.new(port: ftp_port, root_dir: fixtures_dir)
      @ftp_server.start
    end

    # close fake ftp server
    after do
      @ftp_server.shutdown
    end

    it "should retrieve existing file without errors" do
      expect { feeds_retriever.retrieve!(fixture_filename) }.to_not raise_error
    end

    it 'should raise Feeds::FeedNotFound for non existing file' do
      filename = Faker::File.file_name
      expect { feeds_retriever.retrieve!(filename) }.to raise_error(Feeds::FeedNotFound)
    end

    it 'should return content of file' do
      content = File.read(File.join(fixtures_dir, fixture_filename))
      expect(feeds_retriever.retrieve!(fixture_filename)).to eql(content)
    end

  end

  describe 'is an web agent' do

    let(:feeds_retriever) { Feeds::Retriever.new('web') }
    let(:domain) { Faker::Internet.domain_name }

    before(:each) do
      # all requests made by Retriever will go to Fake Web Server
      stub_request(:any, /#{domain}/).to_rack(FakeHttpServer)
    end

    it 'should retrieve existing file without errors' do
      url = Faker::Internet.url(host: domain, path: "/#{fixture_filename}")
      expect { feeds_retriever.retrieve!(url) }.to_not raise_error
    end

    it 'should raise Feeds::FeedNotFound for non existing file' do
      url = Faker::Internet.url(host: domain)
      expect { feeds_retriever.retrieve!(url) }.to raise_error(Feeds::FeedNotFound)
    end

    it 'should return content of file' do
      content = File.read(File.join(fixtures_dir, fixture_filename))
      url = Faker::Internet.url(host: domain, path: "/#{fixture_filename}")
      expect(feeds_retriever.retrieve!(url)).to eql(content)
    end

  end

end
