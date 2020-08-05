module Feeds

  module ParserJSON

    def parse content
      
      rows = begin
        JSON.parse(content)
      rescue JSON::ParserError => e
        raise Feeds::ParsingError.new("wrong format of JSON file")
      end
      
      products_list = ProductsList.new
      
      if rows.is_a? Array
        rows.each do |row|
          
          attributes = {}
          attributes[:data] = row
          attributes[:price] = row['price']
          attributes[:price_value] = lambda { |price| !price.nil? && price.to_f > 0 ? price.to_f : nil }.call(row['price'])
          attributes[:name] = row['title']
          attributes[:link] = row['full_url']
          
          product = Product.new(attributes)
          products_list.products << product

        end
      end
      products_list
    end

  end
end