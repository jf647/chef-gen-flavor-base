require 'chef_gen/snippet_base'
require 'chef_gen/flavor_base/resource_helpers'

module ChefGen
  module Snippet
    # initializes a git repo
    class GitInit < ChefGen::SnippetBase
      include ChefGen::FlavorBase::ResourceHelpers

      # the name of the snippet
      NAME = 'git_init'

      private

      # initializes the snippet in generate mode
      # @return [void]
      # @api private
      def initialize_generate
        @flavor.class.do_declare_resources do
          c = ChefDK::Generator.context
          if c.have_git && !c.skip_git_init
            dst = destination_path
            # :nocov:
            @recipe.send(:execute, 'initialize git repo') do
              command('git init .')
              cwd dst
            end
            # :nocov:
            actions_taken << 'initialize git repo' if snippet?('actions_taken')
          end
        end
      end
    end
  end
end
