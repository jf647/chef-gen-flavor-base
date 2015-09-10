require 'chef_gen/flavor/awesome'

require 'chef_gen/snippet/override_declare_resources'

module ChefGen
  module Flavor
    class AwesomeOverrideSnippet2 < ChefGen::Flavor::Awesome
      NAME = 'awesome_override_snippet2'
      DESC = 'adds a snippet that declares resources'
      VERSION = '0.0.0'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        # add a snippet that removes ExampleFile and ExampleTemplate
        @snippets << ChefGen::Snippet::OverrideDeclareResources
      end

      before_copy_content do
        @tocopy << [File.expand_path(File.join(static_content_path(__FILE__, 'awesome_override_snippet2'))) + '/.']
      end
    end
  end
end
