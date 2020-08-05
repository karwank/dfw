#!/usr/bin/env ruby

require 'terminal-table'
require "#{File.dirname(__FILE__)}/lib/feeds/feeds.rb"

class String
  define_method :red do
    "\e[31m#{self}\e[0m"
  end
end

## Reading Varnish Log File

log_path = "#{File.dirname(__FILE__)}/varnishlog/varnishncsa.log"

if File.exists? log_path

  hosts = {}
  files = {}

  regexp = /https?:\/\/([^\/]+)(\/[^\s]*?)\s+/

  # I'm using foreach to read large files
  file = File.foreach(log_path)
  file.each_entry do |line|
    # match to regexp to find host and path
    match = line.match(regexp)
    unless match.nil?
      # creates object key if it is first appearance
      hosts[match[1]] ||= 0
      # increase amount of appearances
      hosts[match[1]] += 1

      # creates object key if it is first appearance
      files[match[2]] ||= 0
      # increase amount of appearances
      files[match[2]] += 1
    end
  end

  # show results in a table
  table_rows = hosts.sort_by {|k, v| v }.reverse
  table = Terminal::Table.new title: "Hosts", headings: ['Hostname', 'Amount'], rows: table_rows[0..4]
  puts table

  # show results in a table
  table_rows = files.sort_by {|k, v| v }.reverse
  table = Terminal::Table.new title: "Files", headings: ['File', 'Amount'], rows: table_rows[0..4]
  puts table
else
  puts "File #{log_path} does not exist".red
end

## Reading Feeds


# read list of feed files from feeds.yml file
feeds = YAML::load(File.open("#{File.dirname(__FILE__)}/feeds.yml").read).map {|f| f.transform_keys(&:to_sym) }

# for each feed file
feeds.each do |feed|
  
  products = begin
    # Retriever is responsible for grabbing file from source
    # depending on the type of source of feed file Retriever may use different Agent
    retriever = Feeds::Retriever.new(feed[:source], feed.fetch(:options, {}))
    # retiever gets content of file from the source
    content = retriever.retrieve!(feed[:file])
    # Parser is responsible for reading and mapping content to ProductList object with list of Products
    parser = Feeds::Parser.new(feed[:parser])
    # parse method returns an instance of ProductsList object
    products_list = parser.parse(content)
    # ProductsList object
    products_list.get_products_sorted_by_price
  rescue Feeds::Error => e
    puts e.message.red
    next
  end
  
  # show results in a table
  table_rows = products.map { |p| [:name, :price, :link].map {|attr| p.send(attr) } }
  table = Terminal::Table.new title: feed[:file], headings: ['Name', 'Price', 'Link'], rows: table_rows
  puts table

end
