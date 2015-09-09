require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # provides an accessor with a block of text to be displayed at
    # the end of the generate phase; normally used to give the user
    # some information about how to proceed.  When used in conjunction
    # with the ActionsTaken snippet, care should be taken to put this
    # snippet after it in the list so that the next steps is the last
    # thing that the user sees
    class NextSteps < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'next_steps'

      private

      # @!attribute [rw] next_steps
      #   @return [String] the actions taken by the flavor

      # initializes the snippet in generate mode
      # @return [void]
      # @api private
      def initialize_generate
        super
        @flavor.class.send(:attr_accessor, :next_steps)
        hook_display_next_steps
      end

      # adds an after hook to declare resources to report on actions taken
      # @return [void]
      # @api private
      def hook_display_next_steps
        @flavor.class.after_add_resources do
          steps = next_steps
          @recipe.send(:ruby_block, 'display_next_steps') do
            # :nocov:
            block { $stdout.puts steps }
            # :nocov:
          end
        end
      end
    end
  end
end
