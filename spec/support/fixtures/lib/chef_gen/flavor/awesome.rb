require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class Awesome < ChefGen::FlavorBase
      NAME = 'awesome'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::CookbookBase
        @snippets << ChefGen::Snippet::ActionsTaken
        @snippets << ChefGen::Snippet::Attributes
        @snippets << ChefGen::Snippet::ChefSpec
        @snippets << ChefGen::Snippet::Debugging
        @snippets << ChefGen::Snippet::ExampleFile
        @snippets << ChefGen::Snippet::ExampleTemplate
        @snippets << ChefGen::Snippet::Guard
        @snippets << ChefGen::Snippet::GitInit
        @snippets << ChefGen::Snippet::NextSteps
        @snippets << ChefGen::Snippet::NoClobber
        @snippets << ChefGen::Snippet::Recipes
        @snippets << ChefGen::Snippet::ResourceProvider
        @snippets << ChefGen::Snippet::StandardIgnore
        @snippets << ChefGen::Snippet::StyleFoodcritic
        @snippets << ChefGen::Snippet::StyleRubocop
        @snippets << ChefGen::Snippet::StyleTailor
        @snippets << ChefGen::Snippet::TestKitchen
      end

      do_add_content do
        @tocopy << [File.expand_path(File.join(static_content_path(__FILE__))) + '/.']
      end
    end
  end
end
