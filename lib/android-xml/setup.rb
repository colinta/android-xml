module AndroidXml

  class Setup
    class << self
      ROOT = '__root_node_with_a_long_special_name__'
      ALL = '__all_node_with_a_long_special_name__'

      def setup(&block)
        instance_exec(&block)
      end

      def tabs(value)
        @tab = value
      end

      def tags
        @tags ||= Hash.new do |hash, key|
          hash[key] = {
            attrs: {},
            defaults: {},
            rename: nil,
          }
        end
      end

      def tab
        @tab ||= '    '
      end

      def reset
        @tab = nil
        @tags = nil
      end

      def root_tag
        tags[ROOT]
      end

      def root(&block)
        tag(ROOT, &block)
      end

      def all_tag
        tags[ALL]
      end

      def all(&block)
        tag(ALL, &block)
      end

      def tag(*names, &block)
        context_was = @context

        names.each do |name|
          if name.is_a?(Hash)
            @context = nil
            name.each do |shortcut, tag_name|
              raise "There can be only one key-value pair" if @context

              @context = shortcut.to_s
              tags[@context][:rename] = tag_name.to_s
            end
          else
            @context = name.to_s
          end

          instance_exec(&block)
        end

        @context = context_was
      end

      def rename(attrs)
        if attrs.is_a?(Hash)
          attrs.each do |attr_name, attr_rename|
            tags[@context][:attrs][attr_name.to_s] = attr_rename.to_s
          end
        else
          tags[@context][:attrs][attrs.to_s] = attrs.to_s
        end
      end

      def defaults(attrs)
        tags[@context][:defaults].merge!(attrs)
      end

    end
  end

end
