require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class StyleFoodcritic < ChefGen::FlavorBase
      NAME = 'style_foodcritic'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::CookbookBase
        @snippets << ChefGen::Snippet::StandardIgnore
        @snippets << ChefGen::Snippet::Guard
        @snippets << ChefGen::Snippet::StyleFoodcritic
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::StyleFoodcritic do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should add the foodcritic gems' do
    flavor = ChefGen::Flavor::StyleFoodcritic.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.cookbook_gems.keys).to include('foodcritic')
    expect(flavor.cookbook_gems.keys).to include('guard-foodcritic')
  end

  it 'should add the foodcritic rake tasks' do
    flavor = ChefGen::Flavor::StyleFoodcritic.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.rake_tasks.keys).to include('foodcritic')
  end

  it 'should add the foodcritic guard sets' do
    flavor = ChefGen::Flavor::StyleFoodcritic.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.guard_sets.keys).to include('foodcritic')
  end
end
