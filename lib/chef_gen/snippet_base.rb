module ChefGen
  # a base for ChefDK Template Flavor Snippets
  class SnippetBase
    # @overload initialize(flavor)
    #   initializes the snippet in setup mode
    #   @param [ChefGen::FlavorBase] flavor the flavor object
    #   @return [self]
    # @overload initialize(flavor, recipe)
    #   initializes the snippet in generate mode
    #   @param [ChefGen::FlavorBase] flavor the flavor object
    #   @param [Chef::Recipe] recipe the recipe object
    #   @return [self]
    def initialize(flavor: nil, recipe: nil)
      @recipe = recipe
      @flavor = flavor
      initialize_setup if flavor.setup_mode?
      initialize_generate if flavor.generate_mode?
    end

    private

    # @abstract declare {#initialize_setup} to add setup behaviour
    # @return [void]
    # @api private
    def initialize_setup
    end

    # @abstract declare {#initialize_generate} to add setup behaviour
    # @return [void]
    # @api private
    def initialize_generate
    end

    # returns the path to static content distributed with a snippet
    # @param file [String] the file to generate the path from
    # @return [String] the path the static content relative to the file
    # @api private
    def static_content_path(file)
      File.expand_path(
        File.join(
          File.dirname(file), '..', '..', '..', 'shared', 'snippet', self.class::NAME
        )
      )
    end
  end
end
