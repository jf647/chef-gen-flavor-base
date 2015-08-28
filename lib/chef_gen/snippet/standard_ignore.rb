require 'chef_gen/snippet_base'

require 'chef/mixin/params_validate'

module ChefGen
  module Snippet
    # populates the list of ignore patterns for chefignore and .gitignore
    class StandardIgnore < ChefGen::SnippetBase
      # the name of the snippet
      NAME = 'standard_ignore'

      # @!attribute [rw] chefignore_patterns
      #   @return [Array<String>] a list of patterns for chefignore

      # @!attribute [rw] gitignore_patterns
      #   @return [Array<String>] a list of patterns for .gitignore

      private

      # initializes the snippet in generate mode
      # @return [void]
      # @api private
      def initialize_generate
        add_accessors
        declare_chefignore
        declare_gitignore
      end

      # adds accessors to the flavor for chefignore and gitignore patterns
      # @return [void]
      # @api private
      def add_accessors
        @flavor.class.send(:attr_accessor, :chefignore_patterns)
        @flavor.chefignore_patterns = %w(
          .DS_Store Icon? nohup.out ehthumbs.db Thumbs.db
          .sasscache \#* .#* *~ *.sw[az] *.bak REVISION TAGS*
          tmtags *_flymake.* *_flymake *.tmproj .project .settings
          mkmf.log a.out *.o *.pyc *.so *.com *.class *.dll
          *.exe */rdoc/ .watchr  test/* features/* Procfile
          .git */.git .gitignore .gitmodules .gitconfig .gitattributes
          .svn */.bzr/* */.hg/* tmp/*
        )

        @flavor.class.send(:attr_accessor, :gitignore_patterns)
        @flavor.gitignore_patterns = %w(
          *~ *# .#* \#*# .*.sw[az] *.un~
          bin/* .bundle/* tmp/*
        )
      end

      # add the chefignore file resource, with content from the list
      # of patterns in the instance var set to reasonable defaults
      # and lazily evaluated
      # @return [void]
      # @api private
      def declare_chefignore
        @flavor.class.do_declare_resources do
          # :nocov:
          content = Chef::DelayedEvaluator.new do
            chefignore_patterns.sort.uniq.join("\n") + "\n"
          end
          # :nocov:
          add_files(%w(chefignore), :create_if_missing, :file, content: content)
        end
      end

      # add the .gitignore file resource, with content from the list
      # of patterns in the instance var set to reasonable defaults
      # and lazily evaluated
      # @return [void]
      # @api private
      def declare_gitignore
        @flavor.class.do_declare_resources do
          # :nocov:
          content = Chef::DelayedEvaluator.new do
            gitignore_patterns.sort.uniq.join("\n") + "\n"
          end
          # :nocov:
          add_files(%w(.gitignore), :create_if_missing, :file, content: content)
        end
      end
    end
  end
end
