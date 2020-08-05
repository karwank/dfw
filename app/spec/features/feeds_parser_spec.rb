Dir[File.join(File.dirname(__FILE__), '../..', 'lib', 'feeds', '*.rb')].each { |f| require f }

require 'testftpd'

RSpec.describe Feeds::Parser, type: :feature do
  
  let(:fixtures_dir) { File.join(File.dirname(__FILE__), '..', 'support', 'fixtures') }
  let(:fixture_filename) { 'feed.json' }
  
  describe 'class initialization' do

    it 'should raise Feeds::UnknownParserError when parser is not known' do
      expect { Feeds::Parser.new('unknown') }.to raise_error(Feeds::UnknownParserError)
    end

    it 'should not raise error when parser is defined' do
      expect { Feeds::Parser.new('ParserRSS') }.to_not raise_error
    end

  end

  describe 'is a ParserJSON parser' do

    let(:parser) { Feeds::Parser.new('ParserJSON') }
    let(:content) { File.read(File.join(fixtures_dir, fixture_filename)) }

    it 'should parse file without errors' do
      expect { parser.parse(content) }.to_not raise_error
    end

    it 'should return a ProductsList' do
      expect(parser.parse(content)).to be_a ProductsList
    end

  end

end
