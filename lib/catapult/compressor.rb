module Catapult
  module Compressor
    class JS
      def compress(source, options = {})
        require 'uglifier'
        Uglifier.compile(source, options)
      end
    end

    class CSS
      def compress(source, options = {})
        require 'yui/compressor'
        compressor = YUI::CssCompressor.new(options)
        compressor.compress(source)
      end
    end
  end
end