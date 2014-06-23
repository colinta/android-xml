require 'android-xml'


module AndroidXml

  class Tag

    class << self

      def found_strings
        @found_strings ||= []
      end

      def registered_strings
        @registered_strings ||= []
      end

    end

    def string(attrs={}, &block)
      tag = Tag.new('string', attrs, &block)
      string = attrs['name'] || attrs[:name]
      raise "name is required in a <string> tag" unless string && ! string.empty?
      Tag.registered_strings << (string)
      include tag
      tag
    end

  end

  module_function

  def missing_strings?
    p registered: Tag.registered_strings
    p found: Tag.found_strings
  end

end
