require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class Guard < ChefGen::FlavorBase
      NAME = 'guard'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::Guard
        @snippets << ChefGen::Snippet::StandardIgnore
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::Guard do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should copy the static content' do
    expect(FileUtils).to receive(:cp_r).with(%r{/guard/\.}, '/nonexistent')
    flavor = ChefGen::Flavor::Guard.new(temp_path: '/nonexistent')
    flavor.add_content
  end

  it 'should add a template for Guardfile' do
    allow(@recipe).to receive(:template)
    expect(@recipe).to receive(:template).with(/Guardfile$/)
    flavor = ChefGen::Flavor::Guard.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
  end
end
