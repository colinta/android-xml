require 'android-xml'


describe 'Creating a tag with AndroidXml.any_tag' do

  before do
    AndroidXml.reset
  end

  it 'should create a tag if no filename is given' do
    tag = AndroidXml.any_tag(id: '@+id/any_id') do
      nested tag: 'also works'
      nested tags: 'also work' do
        yup they: 'work'
      end
    end

    expect(tag.to_s).to eql(<<-XML
<any-tag android:id="@+id/any_id">
    <nested android:tag="also works" />
    <nested android:tags="also work">
        <yup android:they="work" />
    </nested>
</any-tag>
XML
)
  end

end
