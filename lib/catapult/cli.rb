require 'pathname'
require 'fileutils'
require 'listen'
require 'rack'
require 'thor'

module Catapult
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path('../../..', __FILE__)
    end

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

    desc 'server', 'Serve up project'

    method_option :port, :aliases => '-p', :desc => 'Port'

    def server
      if File.exists?('config.ru')
        Rack::Server.start(
          :Port => options[:port] || 9292,
          :config => 'config.ru'
        )
      else
        Rack::Server.start(
          :Port => options[:port] || 9292,
          :app  => Catapult.app
        )
      end
    end

    desc 'watch', 'Build project whenever it changes'

    def watch
      puts "Watching: #{Catapult.root}"

      build

      paths = Catapult.environment.paths
      paths = paths.select {|p| File.exists?(p) }

      Listen.to(*paths) { build }
    end

    desc 'new', 'Create a new project'

    def new(name)
      directory('templates/app', name)
    end
  end
end