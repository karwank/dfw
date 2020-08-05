Dir[File.join(File.dirname(__FILE__), 'structures/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), 'parsers/*.rb')].each { |f| require f }

module Feeds

  class Parser
  
    def initialize type
      # TODO it's not safe, it should be a case statement or it should have an additional condition to check if module is a parser
      parser_module = begin
        Feeds::const_get type
      rescue NameError
        raise Feeds::UnknownParserError
      end
      self.extend(parser_module)
    end

  end

  # Exception raised when you attempt to use initialize parser with unknown type of parser module
  class UnknownParserError < Error; end

  # Exception raised when parser can't parse file
  class ParsingError < Error; end

end
