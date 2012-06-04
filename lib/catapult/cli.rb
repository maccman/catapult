require 'pathname'
require 'fileutils'
require 'listen'
require 'rack'
require 'thor'

module Catapult
  class CLI < Thor

    desc 'build', 'Build project'

    def build
      target = Pathname('./public/assets')

      puts "Building: #{Catapult.root}"

      Catapult.environment.each_logical_path do |logical_path|
        if asset = Catapult.environment.find_asset(logical_path)
          filename = target.join(logical_path)
          FileUtils.mkpath(filename.dirname)
          puts "Write asset: #{filename}"
          asset.write_to(filename)
        end
      end
    end

    desc 'serve', 'Serve up project'

    method_option :port, :aliases => '-p', :desc => 'Port'

    def serve
      Rack::Server.start(
        :Port => options[:port] || 9292,
        :app  => Catapult.app
      )
    end

    desc 'watch', 'build project whenever it changes'

    def watch
      puts "Watching: #{Catapult.root}"

      build

      paths = Catapult.environment.paths
      paths = paths.select {|p| File.exists?(p) }

      Listen.to(*paths) { build }
    end
  end
end