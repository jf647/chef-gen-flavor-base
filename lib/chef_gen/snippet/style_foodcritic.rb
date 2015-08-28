require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # sets up style testing using Foodcritic
    class StyleFoodcritic < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'style_foodcritic'

      private

      # initializes the snippet in generate mode
      # @return [void]
      # @api private
      def initialize_generate
        declare_cookbook_gems
        declare_rake_tasks
        declare_guard_sets
      end

      # declares cookbook_gems if the flavor supports it
      # @return [void]
      # @api private
      def declare_cookbook_gems
        @flavor.class.do_declare_resources do
          if snippet?('cookbook_base')
            cookbook_gems['foodcritic'] = '~> 4.0'
            cookbook_gems['guard-foodcritic'] = '~> 1.1'
          end
        end
      end

      # declares rake tasks if the flavor supports it
      # @return [void]
      # @api private
      def declare_rake_tasks
        @flavor.class.do_declare_resources do
          if snippet?('cookbook_base')
            rake_tasks['foodcritic'] = <<'END'
require 'foodcritic'
require 'foodcritic/rake_task'

FoodCritic::Rake::LintTask.new(:foodcritic)
task style: :foodcritic
END
          end
        end
      end

      # declares guard sets if the flavor supports it
      # @return [void]
      def declare_guard_sets
        @flavor.class.do_declare_resources do
          if snippet?('guard')
            guard_sets['foodcritic'] = <<'END'
guard :foodcritic,
      cookbook_paths: '.',
      cli: '-f any -X spec -X test -X features' do
  watch(%r{^attributes/.+\.rb$})
  watch(%r{^resources/.+\.rb$})
  watch(%r{^providers/.+\.rb$})
  watch(%r{^libraries/.+\.rb$})
  watch(%r{^recipes/.+\.rb$})
  watch(%r{^metadata\.rb$})
end
END
          end
        end
      end
    end
  end
end
