require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class Recipes < ChefGen::FlavorBase
      NAME = 'recipes'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::Recipes
      end
    end
  end
end

# rubocop:disable Style/RegexpLiteral
RSpec.describe ChefGen::Snippet::Recipes do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should copy the static content' do
    expect(FileUtils).to receive(:cp_r).with(%r{/recipes/\.}, '/nonexistent')
    flavor = ChefGen::Flavor::Recipes.new(temp_path: '/nonexistent')
    flavor.add_content
  end

  %w(recipes).each do |dname|
    it "should create the directory #{dname}" do
      allow(@recipe).to receive(:directory)
      expect(@recipe).to receive(:directory).with(%r{#{dname}$})
      flavor = ChefGen::Flavor::Recipes.new(type: 'cookbook', recipe: @recipe)
      flavor.declare_resources
    end
  end

  %w(recipes/default.rb).each do |fname|
    it "should add a template for #{fname}" do
      allow(@recipe).to receive(:template)
      expect(@recipe).to receive(:template).with(%r{#{fname}$})
      flavor = ChefGen::Flavor::Recipes.new(type: 'cookbook', recipe: @recipe)
      flavor.declare_resources
    end
  end
end
