require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class ResourceProvider < ChefGen::FlavorBase
      NAME = 'resource_provider'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::ResourceProvider
      end
    end
  end
end

# rubocop:disable Style/RegexpLiteral
RSpec.describe ChefGen::Snippet::ResourceProvider do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should copy the static content' do
    expect(FileUtils).to receive(:cp_r).with(%r{/resource_provider/\.}, '/nonexistent')
    flavor = ChefGen::Flavor::ResourceProvider.new(temp_path: '/nonexistent')
    flavor.add_content
  end

  %w(resources providers).each do |dname|
    it "should create the directory #{dname}" do
      allow(@recipe).to receive(:directory)
      expect(@recipe).to receive(:directory).with(%r{#{dname}$})
      flavor = ChefGen::Flavor::ResourceProvider.new(type: 'cookbook', recipe: @recipe)
      flavor.declare_resources
    end
  end

  %w(resources/default.rb providers/default.rb).each do |fname|
    it "should add a template for #{fname}" do
      allow(@recipe).to receive(:template)
      expect(@recipe).to receive(:template).with(%r{#{fname}$})
      flavor = ChefGen::Flavor::ResourceProvider.new(type: 'cookbook', recipe: @recipe)
      flavor.declare_resources
    end
  end
end
