require 'sinatra/base'

# FakeHttpServer is a virtual entrypoint for tests
# WebMock disables net traffic for RSpec
# this Sinatra small server provides responses for requests made by HTTParty
class FakeHttpServer < Sinatra::Base
  
  get '/:file' do

    filename = params[:file].to_s
    unless filename.empty?
      filepath = File.join(File.dirname(__FILE__) + '/fixtures/' + filename)
      # file musts exist
      if File.exists? filepath
        file = File.open(filepath, 'rb').read
      end
    end

    # if filename is given and file exists
    unless file.nil?
      status 200
      file
    else
      status 404
      "not found"
    end
  end

end