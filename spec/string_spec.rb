require 'android-xml'


describe AndroidXml do

  before do
    AndroidXml.reset
  end

  it 'should quote strings' do
    xml = AndroidXml.file('tmp/test.xml') do
      string(name: 'registered_string') { "newline \nsingle-quote ' double-quote \" tab\t"}
    end

    expect(xml.to_s).to include('newline \\nsingle-quote \\\' double-quote \\" tab\\t')
  end

  it 'should register strings' do
    xml = AndroidXml.file('tmp/test.xml') do
      string(name: 'registered_string') { 'registered'}
    end

    xml.generate
    expect(AndroidXml::Tag.registered_strings).to eql(['registered_string'])
  end

  it 'should find strings' do
    xml = AndroidXml.file('tmp/test.xml') do
      any_tag(tag: '@string/found_string')
    end

    xml.generate
    expect(AndroidXml::Tag.found_strings).to eql(['found_string'])
  end

end
