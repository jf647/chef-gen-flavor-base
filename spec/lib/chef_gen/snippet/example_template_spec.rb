require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class ExampleTemplate < ChefGen::FlavorBase
      NAME = 'example_template'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::ExampleTemplate
      end
    end
  end
end

# rubocop:disable Style/RegexpLiteral
RSpec.describe ChefGen::Snippet::ExampleTemplate do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should copy the static content' do
    expect(FileUtils).to receive(:cp_r).with(%r{/example_template/\.}, '/nonexistent')
    flavor = ChefGen::Flavor::ExampleTemplate.new(temp_path: '/nonexistent')
    flavor.add_content
  end

  %w(templates templates/default).each do |dname|
    it "should create the directory #{dname}" do
      allow(@recipe).to receive(:directory)
      expect(@recipe).to receive(:directory).with(%r{#{dname}$})
      flavor = ChefGen::Flavor::ExampleTemplate.new(type: 'cookbook', recipe: @recipe)
      flavor.declare_resources
    end
  end

  %w(templates/default/example.conf.erb).each do |fname|
    it "should add a template for #{fname}" do
      allow(@recipe).to receive(:cookbook_file)
      expect(@recipe).to receive(:cookbook_file).with(%r{#{fname}$})
      flavor = ChefGen::Flavor::ExampleTemplate.new(type: 'cookbook', recipe: @recipe)
      flavor.declare_resources
    end
  end
end
