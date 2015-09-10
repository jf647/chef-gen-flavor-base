require 'chef_gen/flavor/awesome'

require 'chef_gen/snippet/override_add_content'

module ChefGen
  module Flavor
    class AwesomeOverrideSnippet1 < ChefGen::Flavor::Awesome
      NAME = 'awesome_override_snippet1'
      DESC = 'adds a snippet that overrides content'
      VERSION = '0.0.0'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        # add a snippet that adds an Windows serverspec helper
        @snippets << ChefGen::Snippet::OverrideAddContent
      end

      before_copy_content do
        @tocopy << [File.expand_path(File.join(static_content_path(__FILE__, 'awesome_override_snippet1'))) + '/.']
      end
    end
  end
end
