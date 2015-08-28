require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # sets up style testing using Rubocop
    class StyleRubocop < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'style_rubocop'

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
          templates << '.rubocop.yml'
        end
        declare_chefignore_patterns
        declare_cookbook_gems
        declare_rake_tasks
        declare_guard_sets
      end

      # declares chefignore patterns if the flavor supports it
      # @return [void]
      # @api private
      def declare_chefignore_patterns
        @flavor.class.do_declare_resources do
          chefignore_patterns << '.rubocop.yml' if snippet?('standard_ignore')
        end
      end

      # declares cookbook_gems if the flavor supports it
      # @return [void]
      # @api private
      def declare_cookbook_gems
        @flavor.class.do_declare_resources do
          if snippet?('cookbook_base')
            cookbook_gems['rubocop'] = '~> 0.34'
            cookbook_gems['guard-rubocop'] = '~> 1.1'
          end
        end
      end

      # declares rake tasks if the flavor supports it
      # @return [void]
      # @api private
      def declare_rake_tasks
        @flavor.class.do_declare_resources do
          if snippet?('cookbook_base')
            rake_tasks['rubocop'] = <<'END'
require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop) do |t|
  t.formatters = ['progress']
  t.options = ['-D']
  t.patterns = %w(
    attributes/*.rb
    recipes/*.rb
    libraries/**/*.rb
    resources/*.rb
    providers/*.rb
    spec/**/*.rb
    test/**/*.rb
    ./metadata.rb
    ./Berksfile
    ./Gemfile
    ./Rakefile
  )
end
task style: :rubocop
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
            guard_sets['rubocop'] = <<'END'
guard :rubocop, all_on_start: true, cli: ['-f', 'p', '-D'] do
  watch(%r{^attributes/.+\.rb$})
  watch(%r{^recipes/.+\.rb$})
  watch(%r{^libraries/.+\.rb$})
  watch(%r{^resources/.+\.rb$})
  watch(%r{^providers/.+\.rb$})
  watch(%r{^spec/.+\.rb$})
  watch(%r{^test/.+\.rb$})
  watch(%r{^metadata\.rb$})
  watch(%r{^Berksfile$})
  watch(%r{^Gemfile$})
  watch(%r{^Rakefile$})
end
END
          end
        end
      end
    end
  end
end
