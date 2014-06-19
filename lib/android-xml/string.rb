module AndroidXml

  class Tag

    def string(attrs={}, &block)
      tag = Tag.new('string', attrs, &block)
      include tag
      tag
    end

  end

end
