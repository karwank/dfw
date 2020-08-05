#!/usr/bin/env ruby

require 'httparty'
require 'faker'
require 'uri'

hosts = (1..20).map {|i| "host#{i}.test" }
paths = (1..200).map {|i| "/#{Faker::File.file_name}" }
agents = (1..20).map {|i| Faker::Internet.user_agent }

100_000.times do
  uri = URI::HTTP.build(host: hosts.sample, path:paths.sample)
  HTTParty.get(uri, headers: { "User-Agent": agents.sample} )
end