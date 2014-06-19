require 'android-xml'


describe 'Including a tag' do

  before do
    AndroidXml.reset
  end

  it 'should be able to include a tag' do
    tag = AndroidXml.any_tag(id: '@+id/any_id')
    file = AndroidXml.file('tmp/test.xml') do
      resources do
        include tag
      end
    end

    expect(file.generate).to eql(<<-XML
<!-- Do not edit this file. It was generated by AndroidXml. -->
<resources>
    <any-tag android:id="@+id/any_id" />
</resources>
XML
)
  end

  it 'should be able to include a cloned tag' do
    tag = AndroidXml.any_tag(id: '@+id/any_id')
    file = AndroidXml.file('tmp/test.xml') do
      resources do
        include tag.clone(text: 'cloned text') do
          another_tag works: 'fine'
        end
      end
    end

    expect(file.generate).to eql(<<-XML
<!-- Do not edit this file. It was generated by AndroidXml. -->
<resources>
    <any-tag android:id="@+id/any_id"
             android:text="cloned text">
        <another-tag android:works="fine" />
    </any-tag>
</resources>
XML
)
  end

end
