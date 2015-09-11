require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # sets up style testing using Tailor
    class StyleTailor < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'style_tailor'

      private

      # initializes the snippet in generate mode
      # @return [void]
      # @api private
      def initialize_generate
        super
        declare_cookbook_gems
        declare_rake_tasks
      end

      # declares cookbook_gems if the flavor supports it
      # @return [void]
      # @api private
      def declare_cookbook_gems
        @flavor.class.do_declare_resources do
          if snippet?('cookbook_base')
            cookbook_gems['tailor'] = '~> 1.4'
            cookbook_gems['guard-rake'] = '~> 0.0'
          end
        end
      end

      # declares rake tasks if the flavor supports it
      # @return [void]
      # @api private
      def declare_rake_tasks
        @flavor.class.do_declare_resources do
          rake_tasks['tailor'] = <<'END' if snippet?('cookbook_base')
require 'tailor/rake_task'
Tailor::RakeTask.new do |t|
  {
    spec:        'spec/recipes/*_spec.rb',
    spec_helper: 'spec/spec_helper.rb',
    attributes:  'attributes/*.rb',
    resources:   'resources/*.rb',
    providers:   'providers/*.rb',
    libraries:   'libraries/**/*.rb',
    recipes:     'recipes/*.rb',
    metadata:    'metadata.rb'
  }.each do |name, glob|
    t.file_set glob, name do |s|
      s.max_line_length 1000
      s.max_code_lines_in_method 1000
      s.max_code_lines_in_class 1000
    end
  end
end
task style: :tailor
END
        end
      end
    end
  end
end
