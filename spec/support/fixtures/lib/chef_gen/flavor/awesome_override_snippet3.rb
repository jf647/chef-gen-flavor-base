require 'chef_gen/flavor/awesome'

module ChefGen
  module Flavor
    class AwesomeOverrideSnippet3 < ChefGen::Flavor::Awesome
      NAME = 'awesome_override_snippet3'
      DESC = 'removes snippets from a parent flavor'
      VERSION = '0.0.0'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        # remove ExampleFile and ExampleTemplate snippets
        @snippets.reject! do |e|
          e == ChefGen::Snippet::ExampleFile || e == ChefGen::Snippet::ExampleTemplate
        end
      end

      before_copy_content do
        @tocopy << [File.expand_path(File.join(static_content_path(__FILE__, 'awesome_override_snippet3'))) + '/.']
      end
    end
  end
end
