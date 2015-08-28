require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class StyleTailor < ChefGen::FlavorBase
      NAME = 'style_tailor'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::CookbookBase
        @snippets << ChefGen::Snippet::StyleTailor
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::StyleTailor do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should copy the static content' do
    expect(FileUtils).to receive(:cp_r).with(%r{/cookbook_base/\.}, '/nonexistent')
    flavor = ChefGen::Flavor::StyleTailor.new(temp_path: '/nonexistent')
    flavor.add_content
  end

  it 'should add the tailor gems' do
    flavor = ChefGen::Flavor::StyleTailor.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.cookbook_gems.keys).to include('tailor')
    expect(flavor.cookbook_gems.keys).to include('guard-rake')
  end

  it 'should add the tailor rake tasks' do
    flavor = ChefGen::Flavor::StyleTailor.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor.rake_tasks.keys).to include('tailor')
  end
end
