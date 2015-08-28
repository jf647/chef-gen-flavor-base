require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class Attributes < ChefGen::FlavorBase
      NAME = 'attributes'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::Attributes
        @snippets << ChefGen::Snippet::ActionsTaken
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::Attributes do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should copy the static content' do
    expect(FileUtils).to receive(:cp_r).with(%r{/attributes/\.}, '/nonexistent')
    flavor = ChefGen::Flavor::Attributes.new(temp_path: '/nonexistent')
    flavor.add_content
  end

  it 'should create the attributes directory' do
    allow(@recipe).to receive(:directory)
    expect(@recipe).to receive(:directory).with(/attributes$/)
    flavor = ChefGen::Flavor::Attributes.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
  end

  it 'should add a template for attributes/default.rb' do
    allow(@recipe).to receive(:template)
    expect(@recipe).to receive(:template).with(%r{attributes/default.rb$})
    flavor = ChefGen::Flavor::Attributes.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
  end
end
