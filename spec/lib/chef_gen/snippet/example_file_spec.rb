require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class ExampleFile < ChefGen::FlavorBase
      NAME = 'example_file'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::ExampleFile
        @snippets << ChefGen::Snippet::ActionsTaken
      end
    end
  end
end

# rubocop:disable Style/RegexpLiteral
RSpec.describe ChefGen::Snippet::ExampleFile do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should copy the static content' do
    expect(FileUtils).to receive(:cp_r).with(%r{/example_file/\.}, '/nonexistent')
    flavor = ChefGen::Flavor::ExampleFile.new(temp_path: '/nonexistent')
    flavor.add_content
  end

  %w(files files/default).each do |dname|
    it "should create the directory #{dname}" do
      allow(@recipe).to receive(:directory)
      expect(@recipe).to receive(:directory).with(%r{#{dname}$})
      flavor = ChefGen::Flavor::ExampleFile.new(type: 'cookbook', recipe: @recipe)
      flavor.declare_resources
    end
  end

  %w(files/default/example.conf).each do |fname|
    it "should add a template for #{fname}" do
      allow(@recipe).to receive(:cookbook_file)
      expect(@recipe).to receive(:cookbook_file).with(%r{#{fname}$})
      flavor = ChefGen::Flavor::ExampleFile.new(type: 'cookbook', recipe: @recipe)
      flavor.declare_resources
    end
  end
end
