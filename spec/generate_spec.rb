require 'android-xml'


describe AndroidXml do

  before do
    AndroidXml.reset
  end

  it 'should generate <any-tag />' do
    xml = AndroidXml.file('tmp/test.xml') do
      any_tag
    end

    expect(xml.to_s).to eql <<-XML
<!-- Do not edit this file. It was generated by AndroidXml. -->
<any-tag />
XML
  end

  it 'should generate <any-tag with="properties" />' do
    xml = AndroidXml.file('tmp/test.xml') do
      any_tag with: 'properties'
    end

    expect(xml.to_s).to eql <<-XML
<!-- Do not edit this file. It was generated by AndroidXml. -->
<any-tag android:with="properties" />
XML
  end

  it 'should generate <any-tag>with text</any-tag>' do
    xml = AndroidXml.file('tmp/test.xml') do
      any_tag { 'with text' }
    end

    expect(xml.to_s).to eql <<-XML
<!-- Do not edit this file. It was generated by AndroidXml. -->
<any-tag>with text</any-tag>
XML
  end

  it 'should generate <nested><tags /></nested>' do
    xml = AndroidXml.file('tmp/test.xml') do
      nested do
        tags
        tags
        tags
      end
    end

    expect(xml.to_s).to eql <<-XML
<!-- Do not edit this file. It was generated by AndroidXml. -->
<nested>
    <tags />
    <tags />
    <tags />
</nested>
XML
  end

  it 'should generate <nested><tags /></nested> with custom whitespace' do
    xml = AndroidXml.file('tmp/test.xml') do
      nested do
        tags
        tags
        tags
      end
    end
    AndroidXml.setup do
      tabs '  '
    end

    expect(xml.to_s).to eql <<-XML
<!-- Do not edit this file. It was generated by AndroidXml. -->
<nested>
  <tags />
  <tags />
  <tags />
</nested>
XML
  end

  it 'should generate <nested><tags />with text</nested>' do
    xml = AndroidXml.file('tmp/test.xml') do
      nested do
        tags
        tags
        'with text'
      end
    end

    expect(xml.to_s).to eql <<-XML
<!-- Do not edit this file. It was generated by AndroidXml. -->
<nested>
    <tags />
    <tags />
    with text
</nested>
XML
  end

  it 'should generate <nested with="" many="properties"><tags with="" many="properties" /></nested>' do
    xml = AndroidXml.file('tmp/test.xml') do
      nested with: '', many: 'properties' do
        tags with: '', many: 'properties'
      end
    end

    expect(xml.to_s).to eql <<-XML
<!-- Do not edit this file. It was generated by AndroidXml. -->
<nested android:with=""
        android:many="properties">
    <tags android:with=""
          android:many="properties" />
</nested>
XML
  end

end
