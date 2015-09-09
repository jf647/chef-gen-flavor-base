require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class TestKitchen < ChefGen::FlavorBase
      NAME = 'TestKitchen'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::CookbookBase
        @snippets << ChefGen::Snippet::StandardIgnore
        @snippets << ChefGen::Snippet::TestKitchen
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::TestKitchen do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should copy the static content' do
    expect(FileUtils).to receive(:cp_r).with(%r{/cookbook_base/\.}, '/nonexistent')
    expect(FileUtils).to receive(:cp_r).with(%r{/test_kitchen/\.}, '/nonexistent')
    flavor = ChefGen::Flavor::TestKitchen.new(temp_path: '/nonexistent')
    flavor.add_content
  end

  %w(test test/integration test/integration/default
     test/integration/default/serverspec
     test/integration/default/serverspec/recipes).each do |dname|
    it "should create the directory #{dname}" do
      allow(@recipe).to receive(:directory)
      expect(@recipe).to receive(:directory).with(/#{dname}$/)
      flavor = ChefGen::Flavor::TestKitchen.new(type: 'cookbook', recipe: @recipe)
      flavor.declare_resources
    end
  end

  %w(.kitchen.yml test/integration/default/serverspec/spec_helper.rb
     test/integration/default/serverspec/recipes/default_spec.rb)
    .each do |fname|
    it "should add a template for #{fname}" do
      allow(@recipe).to receive(:template)
      expect(@recipe).to receive(:template).with(/#{fname}$/)
      flavor = ChefGen::Flavor::TestKitchen.new(type: 'cookbook', recipe: @recipe)
      flavor.declare_resources
    end
  end

  it 'should add the testkitchen gems' do
    flavor = ChefGen::Flavor::TestKitchen.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.cookbook_gems.keys).to include('test-kitchen')
    expect(flavor.cookbook_gems.keys).to include('kitchen-vagrant')
  end

  it 'should add the testkitchen rake tasks' do
    flavor = ChefGen::Flavor::TestKitchen.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.rake_tasks.keys).to include('testkitchen')
  end

  it 'should add patterns to gitignore' do
    flavor = ChefGen::Flavor::TestKitchen.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.gitignore_patterns).to include('.vagrant')
  end

  it 'should add patterns to chefignore' do
    flavor = ChefGen::Flavor::TestKitchen.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.chefignore_patterns).to include('.kitchen/*')
  end
end
