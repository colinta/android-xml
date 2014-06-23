require 'android-xml'


describe 'tag attributes' do

  before do
    AndroidXml.reset
  end

  it 'should generate <any-tag tag="value" />' do
    xml = AndroidXml.file('tmp/test.xml') do
      any_tag(tag: "value")
    end

    expect(xml.to_s).to match %r{<any-tag android:tag="value" />}
  end

  it 'should generate <any-tag tag="value-with-quotes" />' do
    xml = AndroidXml.file('tmp/test.xml') do
      any_tag(tag: %q{value-"'<>&-with-quoted})
    end

    expect(xml.to_s).to match %r{<any-tag android:tag="value-&quot;&apos;&lt;&gt;&amp;-with-quoted" />}
  end

end
