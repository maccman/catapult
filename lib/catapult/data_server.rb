require "sinatra"

module Catapult
  class DataServer < Sinatra::Base
    Dir["./data/*"].each do |file|
      path = file.scan(/\/\w*\.json$/).first
      puts "Loading resource: #{path}"
      get path do
        File.open(file).read
      end
    end
  end
end
