require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # adds gems useful for debugging cookbooks to the Gemfile
    class Debugging < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'debugging'

      private

      # initializes the snippet in generate mode
      # @return [void]
      # @api private
      def initialize_generate
        @flavor.class.do_declare_resources do
          cookbook_gems['pry'] = '~> 0.10'
          cookbook_gems['pry-byebug'] = '~> 3.1'
          cookbook_gems['pry-rescue'] = '~> 1.4'
          cookbook_gems['pry-stack_explorer'] = '~> 0.4'
        end
      end
    end
  end
end
