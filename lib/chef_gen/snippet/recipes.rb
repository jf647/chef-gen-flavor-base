require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # a cookbook that has recipes
    class Recipes < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'recipes'

      private

      # initializes the snippet in setup mode
      # @return [void]
      # @api private
      def initialize_setup
        super
        snippet_content_path = File.expand_path(File.join(static_content_path(__FILE__, 'recipes'))) + '/.'
        @flavor.class.do_add_content do
          tocopy << [snippet_content_path]
        end
      end

      # initializes the snippet in generate mode
      # @return [void]
      # @api private
      def initialize_generate
        super
        @flavor.class.do_declare_resources do
          directories << 'recipes'
          templates_if_missing << File.join('recipes', 'default.rb')
        end
      end
    end
  end
end
