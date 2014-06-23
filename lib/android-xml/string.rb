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
    diff = Tag.found_strings - Tag.registered_strings
    unless diff.empty?
      diff.each do |name|
        puts "  string(name='#{name}') { '#{name}' }"
      end
    end
  end

end
