module AndroidXml

  class Tag
    attr_accessor :is_root

    def initialize(tag, attrs={}, &block)
      @buffer = []
      @attrs = {}.merge(attrs)
      @raw_tag = tag.to_s

      if rename = Setup.tags[tag.to_s][:rename]
        @tag = rename
      else
        @tag = tag.to_s.gsub('_', '-')
      end

      @generate = block
    end

    def method_missing(method_name, attrs={}, &block)
      tag = Tag.new(method_name, attrs, &block)
      include tag
      tag
    end

    def clone(attrs={}, &block)
      block ||= @generate
      Tag.new(@tag, @attrs.merge(attrs), &block)
    end

    def include(tag, &block)
      if tag.is_a?(Tag)
        if block_given?
          tag = tag.clone(&block)
        end
        @buffer << tag
      else
        super
      end
    end

    def attrs(whitespace)
      attrs = {}

      attrs.merge!(Setup.all_tag[:defaults])
      if is_root
        attrs.merge!(Setup.root_tag[:defaults])
      end

      attrs.merge!(Setup.tags[@raw_tag][:defaults])
      attrs.merge!(@attrs)

      output = ''
      is_first = true
      attrs.each do |key, value|
        next if value.nil?

        key = key.to_s

        if Setup.tags[@tag][:attrs].key?(key)
          xml_key = Setup.tags[@tag][:attrs][key]
        elsif Setup.all_tag[:attrs].key?(key)
          xml_key = Setup.all_tag[:attrs][key]
        elsif key.to_s.include?(':')
          xml_key = key.to_s
        else
          xml_key = "android:#{key}"
        end

        if value =~ /^@string\/(\w+)$/
          Tag.found_strings << $1
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
        inside = generate_block(tab + Setup.tab)
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
