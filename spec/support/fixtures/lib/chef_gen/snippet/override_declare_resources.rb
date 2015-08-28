require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    # a testing snippet that overrides using #declare_resources
    class OverrideDeclareResources < ChefGen::SnippetBase
      NAME = 'override_declare_resources'

      private

      def initialize_generate
        @flavor.class.do_declare_resources do
          directories.reject! do |e|
            %w(files files/default templates templates/default).include?(e)
          end
          files_if_missing.reject! do |e|
            %w(files/default/example.conf templates/default/example.conf.erb).include?(e)
          end
        end
      end
    end
  end
end
