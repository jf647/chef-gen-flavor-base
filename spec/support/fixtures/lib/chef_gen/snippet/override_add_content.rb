require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # a testing snippet that overrides using #add_content
    class OverrideAddContent < ChefGen::SnippetBase
      NAME = 'override_add_content'

      private

      def initialize_setup
        snippet_content_path = File.expand_path(File.join(static_content_path(__FILE__))) + '/.'
        @flavor.class.do_add_content do
          tocopy << [snippet_content_path]
        end
      end
    end
  end
end
