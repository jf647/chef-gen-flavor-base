require 'chef_gen/flavor/awesome'

module ChefGen
  module Flavor
    class AwesomeOverrideSnippet3 < ChefGen::Flavor::Awesome
      NAME = 'awesome_override_snippet3'
      DESC = 'removes snippets from a parent flavor'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        # remove ExampleFile and ExampleTemplate snippets
        @snippets.reject! do |e|
          e == ChefGen::Snippet::ExampleFile || e == ChefGen::Snippet::ExampleTemplate
        end
      end
    end
  end
end
