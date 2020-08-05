require 'nokogiri'
require 'active_support/core_ext/hash'

module Feeds

  module ParserRSS

    def parse content
      
      # transform content to document
      begin
        document = Nokogiri::XML(content)
      rescue => e
        Feeds::ParsingError.new(e.message)
      end

      raise Feeds::ParsingError.new('wrong format of RSS file') if document.xpath('/rss/channel').empty?
      
      documnent_hash = Hash.from_xml(document.to_s)

      rows = documnent_hash['rss']['channel']['item']

      products_list = ProductsList.new
      
      if rows.is_a? Array
        rows.each do |row|
          
          attributes = {}
          attributes[:data] = row
          attributes[:price] = row['price']
          attributes[:price_value] = lambda {|price| value = price.gsub(/[^0-9\.]/,'').to_f; value > 0 ? value : nil }.call(row['price'])
          attributes[:name] = row['title']
          attributes[:link] = row['link']
          
          product = Product.new(attributes)
          products_list.products << product

        end
      end
      products_list
    end

  end
end
