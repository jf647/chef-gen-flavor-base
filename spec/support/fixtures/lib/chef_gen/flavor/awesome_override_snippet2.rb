require 'chef_gen/flavor/awesome'

require 'chef_gen/snippet/override_declare_resources'

module ChefGen
  module Flavor
    class AwesomeOverrideSnippet2 < ChefGen::Flavor::Awesome
      NAME = 'awesome_override_snippet2'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        # add a snippet that removes ExampleFile and ExampleTemplate
        @snippets << ChefGen::Snippet::OverrideDeclareResources
      end
    end
  end
end
