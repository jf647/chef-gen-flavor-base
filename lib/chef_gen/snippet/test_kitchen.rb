require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # creates a framework for Test Kitchen integration testing
    class TestKitchen < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'test_kitchen'

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
      def initialize_generate
        super
        declare_directories
        declare_files_templates
        declare_chefignore_patterns
        declare_gitignore_patterns
        declare_cookbook_gems
        declare_rake_tasks
      end

      # declares directories
      # @return [void]
      # @api private
      def declare_directories
        @flavor.class.do_declare_resources do
          directories << 'test'
          directories << File.join('test', 'integration')
          directories << File.join('test', 'integration', 'default')
          directories << File.join(
            'test', 'integration', 'default', 'serverspec'
          )
          directories << File.join(
            'test', 'integration', 'default', 'serverspec', 'recipes'
          )
        end
      end

      # declares files and templates
      # @return [void]
      # @api private
      def declare_files_templates
        @flavor.class.do_declare_resources do
          templates_if_missing << '.kitchen.yml'
          templates_if_missing << File.join(
            'test', 'integration', 'default', 'serverspec', 'spec_helper.rb'
          )
          templates_if_missing << File.join(
            'test', 'integration', 'default', 'serverspec',
            'recipes', 'default_spec.rb'
          )
        end
      end

      # declares chefignore patterns if the flavor supports it
      # @return [void]
      # @api private
      def declare_chefignore_patterns
        @flavor.class.do_declare_resources do
          break unless snippet?('standard_ignore')
          %w(
            .vagrant .kitchen/* .kitchen.local.yml
          ).each do |e|
            chefignore_patterns << e
          end
        end
      end

      # declares .gitignore patterns if the flavor supports it
      # @return [void]
      # @api private
      def declare_gitignore_patterns
        @flavor.class.do_declare_resources do
          break unless snippet?('standard_ignore')
          %w(
            .vagrant .kitchen/* .kitchen.local.yml
          ).each do |e|
            gitignore_patterns << e
          end
        end
      end

      # declares cookbook_gems if the flavor supports it
      # @return [void]
      # @api private
      def declare_cookbook_gems
        @flavor.class.do_declare_resources do
          break unless snippet?('cookbook_base')
          cookbook_gems['test-kitchen'] = '~> 1.4'
          cookbook_gems['kitchen-vagrant'] = '~> 0.16'
        end
      end

      # declares rake tasks if the flavor supports it
      # @return [void]
      # @api private
      def declare_rake_tasks
        @flavor.class.do_declare_resources do
          break unless snippet?('cookbook_base')
          rake_tasks['testkitchen'] = <<'END'
begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue
  desc 'placeholder Test Kitchen task when plugins are missing'
  task 'kitchen:all' do
    puts 'test-kitchen plugins not installed; this is a placeholder task'
  end
end
task integration: 'kitchen:all'
END
        end
      end
    end
  end
end
