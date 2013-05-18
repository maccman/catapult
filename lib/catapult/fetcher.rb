require 'faraday'
require 'uri'

module Catapult
  class Fetcher
    LIBS = {
      'jquery'       => 'http://code.jquery.com/jquery-1.9.1.js',
      'backbone'   => 'http://backbonejs.org/backbone.js',
      'underscore'     => 'http://underscorejs.org/underscore.js',
      'handlebars'   => 'https://raw.github.com/wycats/handlebars.js/1.0.0-rc.3/dist/handlebars.js',
      'marionette'   => 'http://marionettejs.com/downloads/backbone.marionette.js'
    }

    def initialize(lib)
      @lib = lib
      @uri = URI::parse(LIBS[lib])
    end

    def download
      conn = Faraday::Connection.new "#{@uri.scheme}://#{@uri.host}"
      resp = conn.get "#{@uri.path}"
      puts resp.body
    end
  end
end
