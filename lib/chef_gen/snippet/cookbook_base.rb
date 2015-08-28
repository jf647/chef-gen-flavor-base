require 'chef_gen/snippet_base'

require 'chef/mixin/params_validate'

module ChefGen
  module Snippet
    # creates the basic files that every cookbook should have
    # each file is managed through a separate method to allow for
    # people to mix this in but turn off just one file
    class CookbookBase < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'cookbook_base'

      # @!attribute [rw] cookbook_gems
      #   @return [Hash<String,String>] a map of gem names to constraints

      # @!attribute [rw] gem_sources
      #   @return [Array<String>] a list of gem sources

      # @!attribute [rw] :berks_sources
      #   @return [Array<String>] a list of cookbook sources

      # @!attribute [rw] :rake_tasks
      #   @return [Hash<String,String>] a map of task names to Rakefile bodies

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
        @flavor.class.do_declare_resources do
          templates_if_missing << 'metadata.rb'
          templates_if_missing << 'README.md'
          templates_if_missing << 'CHANGELOG.md'
        end
        declare_gemfile
        declare_berksfile
        declare_rakefile
        declare_chefignore_patterns
      end

      # defines accessors on the flavor for cookbook gems, gem sources,
      # berks sources and rake tasks
      # @return [void]
      # @api private
      def add_accessors
        @flavor.class.send(:attr_accessor, :cookbook_gems)
        @flavor.cookbook_gems = {
          'rake' => '~> 10.4',
          'berkshelf' => '~> 3.3'
        }

        @flavor.class.send(:attr_accessor, :gem_sources)
        @flavor.gem_sources = %w(https://rubygems.org)

        @flavor.class.send(:attr_accessor, :berks_sources)
        @flavor.berks_sources = %w(https://supermarket.chef.io)

        @flavor.class.send(:attr_accessor, :rake_tasks)
        @flavor.rake_tasks = {}
      end

      # declares the Gemfile with lazy evaluation of the gem list
      # @return [void]
      # @api private
      def declare_gemfile
        @flavor.class.do_declare_resources do
          # :nocov:
          lazy_vars = Chef::DelayedEvaluator.new do
            { gems: cookbook_gems, sources: gem_sources }
          end
          # :nocov:
          add_templates(%w(Gemfile), :create, variables: lazy_vars)
        end
      end

      # declares the Berksfile with lazy evaluation of the sources
      # @return [void]
      # @api private
      def declare_berksfile
        @flavor.class.do_declare_resources do
          # :nocov:
          lazy_vars = Chef::DelayedEvaluator.new do
            { sources: berks_sources }
          end
          # :nocov:
          add_templates(%w(Berksfile), :create, variables: lazy_vars)
        end
      end

      # declares the Rakefile with lazy evaluation of the tasks
      # @return [void]
      # @api private
      def declare_rakefile
        @flavor.class.do_declare_resources do
          # :nocov:
          lazy_vars = Chef::DelayedEvaluator.new do
            { tasks: rake_tasks }
          end
          # :nocov:
          add_templates(%w(Rakefile), :create, variables: lazy_vars)
        end
      end

      # adds patterns to chefignore patterns
      # @return [void]
      # @api private
      def declare_chefignore_patterns
        @flavor.class.do_declare_resources do
          if snippet?('standard_ignore')
            %w(
              Gemfile Gemfile.lock Rakefile Berksfile Berksfile.lock
            ).each do |e|
              chefignore_patterns << e
            end
          end
        end
      end
    end
  end
end
