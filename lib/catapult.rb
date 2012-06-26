require 'pathname'
require 'sprockets'
require 'sprockets/commonjs'
require 'stylus'
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
      Stylus.setup(env)

      env
    end
  end
end
