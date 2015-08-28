require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # a sample cookbook_file source
    class ExampleFile < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'example_file'

      private

      # initializes the snippet in setup mode
      # @return [void]
      # @api private
      def initialize_setup
        snippet_content_path = File.expand_path(File.join(static_content_path(__FILE__))) + '/.'
        @flavor.class.do_add_content do
          tocopy << [snippet_content_path]
        end
      end

      # initializes the snippet in generate mode
      # @return [void]
      # @api private
      def initialize_generate
        @flavor.class.do_declare_resources do
          directories << 'files'
          directories << File.join('files', 'default')
          files_if_missing << File.join('files', 'default', 'example.conf')
        end
      end
    end
  end
end
