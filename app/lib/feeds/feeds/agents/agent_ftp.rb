require 'timeout'
require 'net/ftp'

module Feeds
  
  module AgentFtp

    attr_accessor :ftp, :host, :username, :password, :port

    def configure options = {}
      @options = options.transform_keys(&:to_sym)
      @options[:port] ||= 21
      [:host, :username, :password, :port].each do |key|
        unless @options[key].nil? or @options[key].to_s.empty?
          self.send("#{key}=", @options[key])
        else
          raise Feeds::MissingConfigurationOptionError.new("#{key} option must be given")
        end
      end
    end

    def retrieve! filename
      initialize_connection
      if file_exists? filename
        content = read_file filename
      else
        raise Feeds::FeedNotFound.new("File #{filename} not found on #{@host} server")
      end
      close_connection!
      content
    end
    
    private

      def read_file filename
        @ftp.getbinaryfile filename, nil
      end

      def file_exists? filename
        @ftp.nlst.include? filename
      end

      def close_connection!
        @ftp.quit
        @ftp.close unless @ftp.closed?
      end

      def initialize_connection
        tries = 0
        max_tries = 3
        begin
          Timeout::timeout(30) do
            begin
              @ftp = Net::FTP.new
              @ftp.connect @host, @port
              @ftp.login @username, @password
              @ftp.passive = true
              return true
            rescue EOFError
              retry
            rescue => e
              raise Feeds::FTPConnectionError.new(e.message)
            end
          end
        rescue EOFError
          if tries < max_tries
            tries += 1
            sleep 1
            retry
          end
        rescue Timeout::Error
          if tries < max_tries
            tries += 1
            sleep 1
            retry
          end
          raise Feeds::FTPConnectionError.new('connection timeout')
        end
        false
      end

  end

  # Exception raised when connection with FTP server can't be established
  class FTPConnectionError < Error; end
  
end
