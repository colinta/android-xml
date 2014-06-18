module AndroidXml

  class Tag
    attr_accessor :is_root

    def initialize(tag, *args, &block)
      @buffer = []
      @attrs = {}
      @raw_tag = tag.to_s
      @text = nil

      if rename = AndroidXml.tags[tag.to_s][:rename]
        @tag = rename
      else
        @tag = tag.to_s.gsub('_', '-')
      end

      args.each do |arg|
        if arg.is_a?(Hash)
          @attrs.merge!(arg)
        elsif arg.is_a?(String)
          @text = arg
        else
          raise ArgumentError.new("Unknown argument #{arg.inspect} in #{self.class}#new")
        end
      end

      @generate = block
    end

    def method_missing(method_name, *args, &block)
      tag = Tag.new(method_name, *args, &block)
      @buffer << tag
      tag
    end

    def attrs(whitespace)
      attrs = {}

      attrs.merge!(AndroidXml.all_tag[:defaults])
      if is_root
        attrs.merge!(AndroidXml.root_tag[:defaults])
      end

      attrs.merge!(AndroidXml.tags[@raw_tag][:defaults])
      attrs.merge!(@attrs)

      output = ''
      is_first = true
      attrs.each do |key, value|
        next if value.nil?

        key = key.to_s

        if AndroidXml.tags[@tag][:attrs].key?(key)
          xml_key = AndroidXml.tags[@tag][:attrs][key]
        elsif AndroidXml.all_tag[:attrs].key?(key)
          xml_key = AndroidXml.all_tag[:attrs][key]
        elsif key.to_s.include?(':')
          xml_key = key.to_s
        else
          xml_key = "android:#{key}"
        end

        if is_first
          output << " #{xml_key}=\"#{value}\""
          is_first = false
        else
          output << "\n#{whitespace}#{xml_key}=\"#{value}\""
        end
      end
      output
    end

    def generate(tab='')
      whitespace = "#{tab}  #{' ' * @tag.length}"
      output = "#{tab}<#{@tag}#{attrs(whitespace)}"
      if @generate
        inside = generate_block(tab + AndroidXml.tab)
        if !inside || inside.strip.empty?
          output << " />\n"
        else
          output << ">"
          if inside.lstrip.start_with?('<')
            output << "\n" << inside << "#{tab}</#{@tag}>\n"
          else
            output << inside << "</#{@tag}>\n"
          end
        end
      else
        output << " />\n"
      end

      output
    end

    def generate_block(tab='')
      return @block_output if @block_output

      output = ''
      if @generate
        text = instance_exec(&@generate)
        @buffer.each do |tag|
          output << tag.generate(tab)
        end
        if text.is_a?(String)
          if output.empty?
            output << text
          else
            output << tab << text << "\n"
          end
        end
      end

      @block_output = output
    end

    def to_s
      generate
    end

    def to_ary
      [to_s]
    end

    def out
      puts to_s
    end

  end

end
