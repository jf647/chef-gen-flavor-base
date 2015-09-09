require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # a sample template source
    class ExampleTemplate < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'example_template'

      private

      # initializes the snippet in setup mode
      # @return [void]
      # @api private
      def initialize_setup
        super
        snippet_content_path = File.expand_path(File.join(static_content_path(__FILE__))) + '/.'
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
          directories << 'templates'
          directories << File.join('templates', 'default')
          files_if_missing << File.join('templates', 'default', 'example.conf.erb')
        end
      end
    end
  end
end
