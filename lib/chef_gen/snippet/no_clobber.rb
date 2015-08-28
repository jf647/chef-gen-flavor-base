require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # disallows overwrite of @files and @templates unless -a clobber
    # is passed on the command line
    class NoClobber < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'no_clobber'

      # @!attribute [rw] fail_on_clobber
      #   @return [Boolean] whether to fail on attempted clobber

      private

      # initializes the snippet in generate mode
      # @return [void]
      # @api private
      def initialize_generate
        @flavor.class.send(:attr_accessor, :fail_on_clobber)

        # default is false if '-a clobber' was passed, true otherwise
        c = ChefDK::Generator.context
        @flavor.fail_on_clobber = !c.respond_to?(:clobber)

        hook_add_files
        hook_add_templates
      end

      # adds a hook before add_files to fail on clobber
      # @return [void]
      # @api private
      def hook_add_files
        @flavor.class.before_add_files do |files, resource_action|
          if :create == resource_action && fail_on_clobber
            files.each do |file|
              if File.exist?(destination_path(file))
                fail "tried to overwrite file #{file}; pass '-a clobber' to override"
              end
            end
          end
        end
      end

      # adds a hook before add_templates to fail on clobber
      # @return [void]
      # @api private
      def hook_add_templates
        @flavor.class.before_add_templates do |templates, resource_action|
          if :create == resource_action && fail_on_clobber
            templates.each do |template|
              if File.exist?(destination_path(template))
                fail "tried to overwrite file #{template}; pass '-a clobber' to override"
              end
            end
          end
        end
      end
    end
  end
end
