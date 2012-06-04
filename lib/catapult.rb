require 'pathname'
require 'sprockets'
require 'sprockets/commonjs'
require 'stylus/tilt'
require 'stylus/import_processor'
require 'coffee_script'

module Catapult
  autoload :CLI, 'catapult/cli'
  autoload :TryStatic, 'catapult/try_static'

  def self.root
    @root ||= Pathname('.').expand_path
  end

  def self.environment
    @environment ||= begin
      env = Sprockets::Environment.new(root)

      env.append_path(root.join('assets', 'javascripts'))
      env.append_path(root.join('assets', 'stylesheets'))
      env.append_path(root.join('assets', 'images'))

      env.append_path(root.join('vendor', 'assets', 'javascripts'))
      env.append_path(root.join('vendor', 'assets', 'stylesheets'))

      env.append_path(root.join('browser_modules'))

      env.register_engine '.styl', Tilt::StylusTemplate
      env.register_preprocessor 'text/css', Stylus::ImportProcessor

      env
    end
  end

  def self.app
    app = Rack::Builder.new do
      map '/assets' do
        run Catapult.environment
      end

      use Catapult::TryStatic,
          :root => Catapult.root.join('public'),
          :urls => %w[/],
          :try  => ['.html', 'index.html', '/index.html']

      run lambda {|env|
        [404, {}, ['Not found']]
      }
    end
  end
end