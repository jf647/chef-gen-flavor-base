require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # a cookbook that has provides resources and providers
    class ResourceProvider < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'resource_provider'

      private

      # initializes the snippet in setup mode
      # @return [void]
      # @api private
      def initialize_setup
        super
        snippet_content_path = File.expand_path(File.join(static_content_path(__FILE__, 'resource_provider'))) + '/.'
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
          directories << 'resources'
          directories << 'providers'
          templates_if_missing << File.join('resources', 'default.rb')
          templates_if_missing << File.join('providers', 'default.rb')
        end
      end
    end
  end
end
