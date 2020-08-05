Dir[File.join(File.dirname(__FILE__), 'agents/*.rb')].each { |f| require f }

module Feeds

  class Retriever
  
    def initialize source, options = {}
      agent_module = case source
      when 'web'
        Feeds::AgentWeb
      when 'ftp'
        Feeds::AgentFtp
      else
        raise Feeds::UnknownAgentError.new("Agent #{source} not found")
      end
      self.extend(agent_module)
      configure options
    end

  end

  # Feeds::UnknownAgentError is also an instance of Feeds::Error
  # Exception raised when you attempt to use initialize retriever with unknown type of agent module
  class UnknownAgentError < Error; end

  # Exception raised when agent can't find file
  class FeedNotFound < Error; end

  # Exception raised when agent configuration option is missing
  class MissingConfigurationOptionError < Error; end

end
