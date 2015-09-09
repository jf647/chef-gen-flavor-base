require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class ChefSpec < ChefGen::FlavorBase
      NAME = 'chef_spec'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::CookbookBase
        @snippets << ChefGen::Snippet::StandardIgnore
        @snippets << ChefGen::Snippet::Guard
        @snippets << ChefGen::Snippet::ChefSpec
      end
    end
  end
end

# rubocop:disable Style/RegexpLiteral
RSpec.describe ChefGen::Snippet::ChefSpec do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should copy the static content' do
    expect(FileUtils).to receive(:cp_r).with(%r{/cookbook_base/\.}, '/nonexistent')
    expect(FileUtils).to receive(:cp_r).with(%r{/guard/\.}, '/nonexistent')
    expect(FileUtils).to receive(:cp_r).with(%r{/chef_spec/\.}, '/nonexistent')
    flavor = ChefGen::Flavor::ChefSpec.new(temp_path: '/nonexistent')
    flavor.add_content
  end

  %w(spec spec/recipes).each do |dname|
    it "should create the directory #{dname}" do
      allow(@recipe).to receive(:directory)
      expect(@recipe).to receive(:directory).with(%r{#{dname}$})
      flavor = ChefGen::Flavor::ChefSpec.new(type: 'cookbook', recipe: @recipe)
      flavor.declare_resources
    end
  end

  %w(.rspec spec/spec_helper.rb spec/recipes/default_spec.rb).each do |fname|
    it "should add a flavor for #{fname}" do
      allow(@recipe).to receive(:template)
      expect(@recipe).to receive(:template).with(%r{#{fname}$})
      flavor = ChefGen::Flavor::ChefSpec.new(type: 'cookbook', recipe: @recipe)
      flavor.declare_resources
    end
  end

  it 'should add the chefspec gems' do
    flavor = ChefGen::Flavor::ChefSpec.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.cookbook_gems.keys).to include('chefspec')
    expect(flavor.cookbook_gems.keys).to include('guard-rspec')
    expect(flavor.cookbook_gems.keys).to include('ci_reporter_rspec')
  end

  it 'should add the chefspec rake tasks' do
    flavor = ChefGen::Flavor::ChefSpec.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.rake_tasks.keys).to include('chefspec')
  end

  it 'should add the chefspec guard sets' do
    flavor = ChefGen::Flavor::ChefSpec.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.guard_sets.keys).to include('chefspec')
  end
end
