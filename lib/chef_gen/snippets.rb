# Chef Cookbook Generation tools
module ChefGen
  # template snippets that flavors can compose to do common things
  module Snippet
    autoload :Attributes, 'chef_gen/snippet/attributes'
    autoload :ActionsTaken, 'chef_gen/snippet/actions_taken'
    autoload :ChefSpec, 'chef_gen/snippet/chef_spec'
    autoload :CookbookBase, 'chef_gen/snippet/cookbook_base'
    autoload :Debugging, 'chef_gen/snippet/debugging'
    autoload :ExampleFile, 'chef_gen/snippet/example_file'
    autoload :ExampleTemplate, 'chef_gen/snippet/example_template'
    autoload :GitInit, 'chef_gen/snippet/git_init'
    autoload :Guard, 'chef_gen/snippet/guard'
    autoload :NextSteps, 'chef_gen/snippet/next_steps'
    autoload :NoClobber, 'chef_gen/snippet/no_clobber'
    autoload :Recipes, 'chef_gen/snippet/recipes'
    autoload :ResourceProvider, 'chef_gen/snippet/resource_provider'
    autoload :StandardIgnore, 'chef_gen/snippet/standard_ignore'
    autoload :StyleFoodcritic, 'chef_gen/snippet/style_foodcritic'
    autoload :StyleRubocop, 'chef_gen/snippet/style_rubocop'
    autoload :StyleTailor, 'chef_gen/snippet/style_tailor'
    autoload :TestKitchen, 'chef_gen/snippet/test_kitchen'
  end
end
