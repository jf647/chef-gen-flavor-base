require 'chef_gen/flavor/awesome'

require 'chef_gen/snippet/override_add_content'

module ChefGen
  module Flavor
    class AwesomeOverrideSnippet1 < ChefGen::Flavor::Awesome
      NAME = 'awesome_override_snippet1'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        # add a snippet that adds an Windows serverspec helper
        @snippets << ChefGen::Snippet::OverrideAddContent
      end
    end
  end
end
