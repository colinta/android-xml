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

    def run_block(&block)
      text = instance_exec(&block)
      if text.is_a?(String)
        text = Tag.format_string(text)
      end
      text
    end

    # isn't there a method that does this for me!?
    def self.format_string(text)
      text = text.dup
      {
        '\\' => '\\\\',
        "\n" => '\n',
        "\t" => '\t',
        "\b" => '\b',
        '"' => '\"',
        "'" => "\\\\'",
      }.each do |find, replace|
        text.gsub!(find, replace)
      end
      text
    end

  end

  module_function

  def missing_strings?
    diff = Tag.found_strings - Tag.registered_strings
    unless diff.empty?
      diff.each do |name|
        puts "  string(name='#{Tag.format_string(name)}') { '#{Tag.format_string(name)}' }"
      end
    end
  end

end
