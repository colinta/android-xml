require 'android-xml'


describe 'Cloning a tag' do

  before do
    AndroidXml.reset
  end

  it 'should be able to clone a tag' do
    tag = AndroidXml.any_tag(id: '@+id/any_id', text: 'tag-text') do
      nested tag: 'also works'
      nested tags: 'also work' do
        yup they: 'work'
      end
    end

    clone = tag.clone

    expect(clone.to_s).to eql(<<-XML
<any-tag android:id="@+id/any_id"
         android:text="tag-text">
    <nested android:tag="also works" />
    <nested android:tags="also work">
        <yup android:they="work" />
    </nested>
</any-tag>
XML
)
  end

  it 'should be able to clone a tag and replace attrs' do
    tag = AndroidXml.any_tag(id: '@+id/any_id', text: 'tag-text') do
      nested tag: 'also works'
      nested tags: 'also work' do
        yup they: 'work'
      end
    end

    clone = tag.clone(text: 'clone-text')

    expect(clone.to_s).to eql(<<-XML
<any-tag android:id="@+id/any_id"
         android:text="clone-text">
    <nested android:tag="also works" />
    <nested android:tags="also work">
        <yup android:they="work" />
    </nested>
</any-tag>
XML
)
  end

  it 'should be able to clone a tag and replace content' do
    tag = AndroidXml.any_tag(id: '@+id/any_id', text: 'tag-text') do
      nested tag: 'also works'
      nested tags: 'also work' do
        yup they: 'work'
      end
    end

    clone = tag.clone(text: 'clone-text') do
      cloned tag: 'also works'
    end

    expect(clone.to_s).to eql(<<-XML
<any-tag android:id="@+id/any_id"
         android:text="clone-text">
    <cloned android:tag="also works" />
</any-tag>
XML
)
  end

end
