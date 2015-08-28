require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class StandardIgnore < ChefGen::FlavorBase
      NAME = 'standard_ignore'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::StandardIgnore
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::StandardIgnore do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should create a chefignore file' do
    allow(@recipe).to receive(:file)
    expect(@recipe).to receive(:file).with(/chefignore$/)
    flavor = ChefGen::Flavor::StandardIgnore.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
  end

  it 'should create a .gitignore file' do
    allow(@recipe).to receive(:file)
    expect(@recipe).to receive(:file).with(/.gitignore$/)
    flavor = ChefGen::Flavor::StandardIgnore.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
  end
end
