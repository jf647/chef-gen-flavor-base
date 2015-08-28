require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class Debugging < ChefGen::FlavorBase
      NAME = 'debugging'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::CookbookBase
        @snippets << ChefGen::Snippet::Debugging
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::CookbookBase do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should add the debugging gems' do
    flavor = ChefGen::Flavor::Debugging.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.cookbook_gems.keys).to include('pry')
    expect(flavor.cookbook_gems.keys).to include('pry-byebug')
    expect(flavor.cookbook_gems.keys).to include('pry-stack_explorer')
  end
end
