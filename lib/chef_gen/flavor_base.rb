require 'chef-dk/generator'
require 'hooks'

require 'chef_gen/flavor_base/copy_helpers'
require 'chef_gen/flavor_base/resource_helpers'

module ChefGen
  # a base for ChefDK Template Flavors
  class FlavorBase
    include Hooks
    include ChefGen::FlavorBase::CopyHelpers
    include ChefGen::FlavorBase::ResourceHelpers

    # the version of the gem
    VERSION = '0.9.2'

    # define common hooks
    define_hooks :before_initialize, :after_initialize,
                 :before_snippet_construct, :after_snippet_construct

    # define setup hooks
    define_hooks :before_add_content, :after_add_content,
                 :do_add_content,
                 :before_copy_content, :after_copy_content

    # define generate hooks
    define_hooks :before_declare_resources, :after_declare_resources,
                 :do_declare_resources,
                 :before_add_resources, :after_add_resources,
                 :before_add_directories, :after_add_directories,
                 :before_add_files, :after_add_files,
                 :before_add_templates, :after_add_templates

    # the type of object being generated (cookbook, repo, etc.)
    # @return [String] the type of object being generated
    attr_reader :type

    # a list of snippet classes to mix in
    # @return [Array<Class>] list of snippet classes
    attr_reader :snippets

    # a list of pairs of src/dst files or directories to copy into
    # the temporary directory.
    # @return [Array<Array>] list of [src, dst] pairs
    attr_reader :tocopy

    # a list of directory resources
    # @return [Array<String>] target path relative to cookbook root
    attr_reader :directories

    # a list of file resources with action :create
    # @return [Array<String>] target path relative to cookbook root
    attr_reader :files

    # a list of file resources with action :create_if_missing
    # @return [Array<String>] target path relative to cookbook root
    attr_reader :files_if_missing

    # a list of template resources with action :create
    # @return [Array<String>] target path relative to cookbook root
    attr_reader :templates

    # a list of template resources with action :create_if_missing
    # @return [Array<String>] target path relative to cookbook root
    attr_reader :templates_if_missing

    # @overload initialize(temp_path)
    #   initializes the flavor in setup mode
    #   @param temp_path [String] the temporary directory provided
    #     by chef-gen-flavors
    #   @return [self]
    # @overload initialize(type, recipe)
    #   initializes the flavor in generate mode
    #   @param type [String] the type of object being generated
    #     when constructed by ChefDK
    #   @param recipe [Chef::Recipe] the recipe into which to inject
    #     resources when constructed by ChefDK
    #   @return [self]
    def initialize(temp_path: nil, type: nil, recipe: nil)
      # run before hook
      run_hook :before_initialize

      # set up instance variables
      @recipe = recipe

      # start with an empty list of snippets
      @snippets = []
      @enabled_snippets = {}

      if setup_mode?
        @temp_path = temp_path
        # in setup mode, start with an empty list of things to copy
        @tocopy = []
      else
        @type = type
        # in generate mode, start empty dir, file and template lists
        @directories = []
        @files = []
        @files_if_missing = []
        @templates = []
        @templates_if_missing = []
      end

      # run after hook
      run_hook :after_initialize
    end

    # determines if the flavor is in setup mode
    # @return [Boolean] true if the flavor is in setup mode, creating
    #   the temporary directory
    def setup_mode?
      @recipe.nil?
    end

    # determines if the flavor is in generate mode
    # @return [Boolean] true if the flavor is in generate mode, used
    #   by ChefDK to create an object
    def generate_mode?
      !setup_mode?
    end

    # constructs and calls the #add_content of each snippet, then calls
    # #copy_content to copy the files to the temporary directory
    # @return [void]
    def add_content
      # construct each snippet in setup mode
      run_hook :before_snippet_construct
      snippets.map! { |s| s.new(flavor: self) }
      mark_enabled_snippets
      run_hook :after_snippet_construct

      # call hooks to add content
      run_hook :before_add_content
      run_hook :do_add_content
      run_hook :after_add_content

      # copy queued content
      run_hook :before_copy_content
      copy_content
      run_hook :after_copy_content
    end

    # constructs and calls the #declare_resources method of each snippet,
    # then calls #add_resources to add the resources to the recipe
    # @return [void]
    def declare_resources
      # declare the target directory
      @recipe.send(:directory, destination_path('.'))

      # construct each snippet in generate mode
      run_hook :before_snippet_construct
      snippets.map! { |s| s.new(flavor: self, recipe: @recipe) }
      mark_enabled_snippets
      run_hook :after_snippet_construct

      # call hooks to add content
      run_hook :before_declare_resources
      run_hook :do_declare_resources
      run_hook :after_declare_resources

      # add queued resources to the recipe
      run_hook :before_add_resources
      add_resources
      run_hook :after_add_resources
    end

    # a predicate to determine if a snippet has been included in a flavor
    # @param [String] name the NAME constant of the snippet
    # @return [Boolean] true if the snippet has been enabled
    def snippet?(name)
      @enabled_snippets.key?(name)
    end

    private

    # populates a hash of enabled snippets for use in snippet?
    # @return [void]
    # @api private
    def mark_enabled_snippets
      @enabled_snippets = snippets.map do |s|
        [s.class.const_get(:NAME), 1]
      end.to_h
    end
  end
end
