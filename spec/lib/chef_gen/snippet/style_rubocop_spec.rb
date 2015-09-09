require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class StyleRubocop < ChefGen::FlavorBase
      NAME = 'style_rubocop'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::CookbookBase
        @snippets << ChefGen::Snippet::StandardIgnore
        @snippets << ChefGen::Snippet::Guard
        @snippets << ChefGen::Snippet::StyleRubocop
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::StyleRubocop do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should copy the static content' do
    expect(FileUtils).to receive(:cp_r).with(%r{/cookbook_base/\.}, '/nonexistent')
    expect(FileUtils).to receive(:cp_r).with(%r{/guard/\.}, '/nonexistent')
    expect(FileUtils).to receive(:cp_r).with(%r{/style_rubocop/\.}, '/nonexistent')
    flavor = ChefGen::Flavor::StyleRubocop.new(temp_path: '/nonexistent')
    flavor.add_content
  end

  it 'should add a .rubocop.yml file' do
    allow(@recipe).to receive(:template)
    expect(@recipe).to receive(:template).with(/\.rubocop.yml$/)
    flavor = ChefGen::Flavor::StyleRubocop.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
  end

  it 'should add the rubocop gems' do
    flavor = ChefGen::Flavor::StyleRubocop.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.cookbook_gems.keys).to include('rubocop')
    expect(flavor.cookbook_gems.keys).to include('guard-rubocop')
  end

  it 'should add the rubocop rake tasks' do
    flavor = ChefGen::Flavor::StyleRubocop.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.rake_tasks.keys).to include('rubocop')
  end

  it 'should add the rubocop guard sets' do
    flavor = ChefGen::Flavor::StyleRubocop.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.guard_sets.keys).to include('rubocop')
  end
end
