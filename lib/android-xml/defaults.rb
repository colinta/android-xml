require 'android-xml'


module AndroidXml
  module_function

  def setup_defaults
    setup do
      # assign the xmlns to all root nodes
      root do
        defaults 'xmlns:android' => 'http://schemas.android.com/apk/res/android'
      end

      all do
        # suppress 'android:' prefix to all style attributes
        rename :style
        rename context: 'tools:context'
      end

      # disable the xmlns attribute on the resource node
      tag :resources do
        defaults 'xmlns:android' => nil
      end

      # remove the 'android:' prefix
      tag :string, :style, :item, :color, :array do
        rename :name
      end
      tag :item do
        rename :type
      end
      tag :style do
        rename :parent
      end
      tag :manifest do
        rename :package
      end

      # creates a couple "tag shortcuts"
      tag :main_action => 'action' do
        defaults name: 'android.intent.action.MAIN'
      end
      tag :launcher_category => 'category' do
        defaults name: 'android.intent.category.LAUNCHER'
      end
    end
  end
end
