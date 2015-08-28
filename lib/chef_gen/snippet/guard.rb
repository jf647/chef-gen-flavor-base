require 'chef_gen/snippet_base'

require 'chef/mixin/params_validate'

module ChefGen
  module Snippet
    # creates a guardfile and an accessor to define guard sets
    class Guard < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'guard'

      # @!attribute [rw] :guard_sets
      #   @return [Hash<String,String>] a map of set names to Guardfile bodies

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
        add_accessors
        declare_guardfile
        declare_chefignore_patterns
      end

      # adds accessors to the flavor for guard sets
      # @return [void]
      # @api private
      def add_accessors
        @flavor.class.send(:attr_accessor, :guard_sets)
        @flavor.guard_sets = {}
      end

      # declares the Guardfile with lazy evaluation of the guards
      # @return [void]
      # @api private
      def declare_guardfile
        @flavor.class.do_declare_resources do
          # :nocov:
          lazy_vars = Chef::DelayedEvaluator.new do
            { guards: guard_sets }
          end
          # :nocov:
          add_templates(%w(Guardfile), :create, variables: lazy_vars)
        end
      end

      # adds patterns to chefignore patterns
      # @return [void]
      # @api private
      def declare_chefignore_patterns
        @flavor.class.do_declare_resources do
          chefignore_patterns << 'Guardfile' if snippet?('standard_ignore')
        end
      end
    end
  end
end
