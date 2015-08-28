module ChefGen
  # a base for ChefDK Template Flavors
  class FlavorBase
    # helpers to add resources to recipes; used in the generate phase
    module ResourceHelpers
      # adds directories to the recipes
      # @param [Array<String>] directories the directories to create
      # @return [void]
      # @api private
      def add_directories(directories)
        run_hook :before_add_directories, directories
        directories.each do |dir|
          dst = destination_path(dir)
          @recipe.send(:directory, dst)
        end
        run_hook :after_add_directories, directories
      end

      # adds files to the recipes.  Without content, creates a cookbook_file
      # resource, otherwise creates a file resource.
      # @param files [Array<String>] list of files relative to target root.
      #   If content is provided, this should only contain one file
      # @param resource_action [Symbol] the action to send to the resource
      # @param type [Symbol] the type of resource, :file or :cookbook_file
      # @param attrs [Hash] additional attributes to pass to the resource
      # @return [void]
      # @api private
      def add_files(files, resource_action = :create_if_missing, type = :cookbook_file, attrs = {})
        run_hook :before_add_files, files, resource_action, type, attrs
        files.each do |file|
          src = source_path(file)
          # :nocov:
          @recipe.send(type, destination_path(file)) do
            action resource_action
            source src if :cookbook_file == type
            attrs.each { |a, v| send a, v }
          end
          # :nocov:
        end
        run_hook :after_add_files, files, resource_action, type, attrs
      end

      # adds templates to the recipes
      # @param templates [Array<String>] list of templates relative to target root
      # @param resource_action [Symbol] the action to send to the resource
      # @param attrs [Hash] additional attributes to pass to the resource
      # @return [void]
      # @api private
      def add_templates(templates, resource_action = :create_if_missing, attrs = {})
        run_hook :before_add_templates, templates, resource_action, attrs
        templates.each do |template|
          src = "#{source_path(template)}.erb"
          # :nocov:
          @recipe.send(:template, destination_path(template)) do
            source src
            action resource_action
            helpers ChefDK::Generator::TemplateHelper
            attrs.each { |a, v| send a, v }
          end
          # :nocov:
          run_hook :after_add_templates, templates, resource_action, attrs
        end
      end

      private

      # given a destination file, returns a flattened source
      # filename by replacing / and . with _
      # @param path [String] the destination file
      # @return [String] the flattened source file
      # @example convert a destination file
      #   source_path('spec/spec_helper.rb') #=> 'spec_spec_helper_rb'
      def source_path(path)
        path.tr('/.', '_')
      end

      # returns the destination path for a file in the `chef generate`
      #   target directory
      # @param path [String] a path to append to the target dir
      # @return [String] the absolute destination path
      # @api private
      def destination_path(path = '')
        File.expand_path(File.join(generate_target, path))
      end

      # returns the target directory of `chef generate`
      # @return [String]
      # @api private
      def generate_target
        @generate_target ||= begin
          ctx = ChefDK::Generator.context
          File.expand_path(
            File.join(ctx.cookbook_root, ctx.cookbook_name)
          )
        end
      end

      # adds declared directories / files / templates resources to the recipe
      # @return [void]
      # @api private
      def add_resources
        add_directories(@directories)
        add_files(@files, :create)
        add_files(@files_if_missing)
        add_templates(@templates, :create)
        add_templates(@templates_if_missing)
      end
    end
  end
end
