require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # provides an accumulator of the actions were taken by the
    # flavor during generation and a ruby_block resource to display
    # them at the end of the generate phase
    class ActionsTaken < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'actions_taken'

      private

      # @!attribute [rw] actions_taken
      #   @return [Array<String>] the actions taken by the flavor

      # initializes the snippet in generate mode
      # @return [void]
      # @api private
      def initialize_generate
        @flavor.class.send(:attr_accessor, :actions_taken)
        @flavor.actions_taken = []

        hook_add_directories
        hook_add_files
        hook_add_templates
        hook_report_actions
      end

      # adds a hook after add_directories to report on actions
      # @return [void]
      # @api private
      def hook_add_directories
        @flavor.class.after_add_directories do |directories|
          directories.each do |dir|
            actions_taken << "create directory #{dir}"
          end
        end
      end

      # adds a hook afer add_files to report on actions
      # @return [void]
      # @api private
      def hook_add_files
        @flavor.class.after_add_files do |files, resource_action, type|
          files.each do |file|
            actions_taken << "#{resource_action} #{type} #{file}"
          end
        end
      end

      # adds a hook after add_templates to report on actions
      # @return [void]
      # @api private
      def hook_add_templates
        @flavor.class.after_add_templates do |templates, resource_action|
          templates.each do |template|
            actions_taken << "#{resource_action} template #{template}"
          end
        end
      end

      # adds an after hook to declare resources to report on actions taken
      # @return [void]
      # @api private
      def hook_report_actions
        @flavor.class.after_add_resources do
          actions = actions_taken
          @recipe.send(:ruby_block, 'report_actions_taken') do
            # :nocov:
            block do
              $stdout.puts "\n\nactions taken:"
              actions.each { |a| $stdout.puts "  #{a}" }
            end
            # :nocov:
          end
        end
      end
    end
  end
end
