require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # creates a framework for ChefSpec unit testing
    class ChefSpec < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'chef_spec'

      private

      # initializes the snippet in setup mode
      # @return [void]
      # @api private
      def initialize_setup
        super
        snippet_content_path = File.expand_path(File.join(static_content_path(__FILE__, 'chef_spec'))) + '/.'
        @flavor.class.do_add_content do
          tocopy << [snippet_content_path]
        end
      end

      # initializes the snippet in generate mode
      # @return [void]
      # @api private
      def initialize_generate
        super
        declare_files_templates
        declare_chefignore_patterns
        declare_cookbook_gems
        declare_rake_tasks
        declare_guard_sets
      end

      # declares directories, files and templates
      # @return [void]
      # @api private
      def declare_files_templates
        @flavor.class.do_declare_resources do
          directories << 'spec'
          directories << File.join('spec', 'recipes')
          templates << '.rspec'
          templates_if_missing << File.join('spec', 'spec_helper.rb')
          templates_if_missing << File.join('spec', 'recipes', 'default_spec.rb')
          templates_if_missing << File.join('spec', 'chef_runner_context.rb')
        end
      end

      # declares chefignore patterns if the flavor supports it
      # @return [void]
      # @api private
      def declare_chefignore_patterns
        @flavor.class.do_declare_resources do
          if snippet?('standard_ignore')
            %w(
              .rspec spec/* spec/fixtures/*
            ).each do |e|
              chefignore_patterns << e
            end
          end
        end
      end

      # declares cookbook_gems if the flavor supports it
      # @return [void]
      # @api private
      def declare_cookbook_gems
        @flavor.class.do_declare_resources do
          if snippet?('cookbook_base')
            cookbook_gems['chefspec'] = '~> 4.1'
            cookbook_gems['guard-rspec'] = '~> 4.5'
            cookbook_gems['ci_reporter_rspec'] = '~> 1.0'
          end
        end
      end

      # declares rake tasks if the flavor supports it
      # @return [void]
      # @api private
      def declare_rake_tasks
        @flavor.class.do_declare_resources do
          if snippet?('cookbook_base')
            rake_tasks['chefspec'] = <<'END'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:chefspec)

desc 'Generate ChefSpec coverage report'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task[:chefspec].invoke
end
task spec: :chefspec
END
          end
        end
      end

      # declares guard sets if the flavor supports it
      # @return [void]
      # @api private
      def declare_guard_sets
        @flavor.class.do_declare_resources do
          if snippet?('guard')
            guard_sets['chefspec'] = <<'END'
rspec_command = ENV.key?('DISABLE_PRY_RESCUE') ? 'rspec' : 'rescue rspec'
guard :rspec, all_on_start: true, cmd: "bundle exec #{rspec_command}" do
  watch(%r{^spec/recipes/.+_spec\.rb$})
  watch(%r{^spec/spec_helper\.rb$}) { 'spec' }
  watch(%r{^attributes/.+\.rb$})    { 'spec' }
  watch(%r{^resources/.+\.rb$})     { 'spec' }
  watch(%r{^providers/.+\.rb$})     { 'spec' }
  watch(%r{^libraries/.+\.rb$})     { 'spec' }
  watch(%r{^recipes/(.+)\.rb$})     { |m| "spec/recipes/#{m[1]}_spec.rb" }
end
END
          end
        end
      end
    end
  end
end
