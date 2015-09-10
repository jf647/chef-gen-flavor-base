require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class Awesome < ChefGen::FlavorBase
      NAME = 'awesome'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::CookbookBase
      end

      def add_content
        @tocopy << [File.expand_path(File.join(static_content_path(__FILE__, 'awesome'))) + '/.']
        super
      end
    end
  end
end

RSpec.describe ChefGen::FlavorBase do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'can be constructed' do
    flavor = ChefGen::Flavor::Awesome.new(type: 'cookbook', recipe: @recipe)
    expect(flavor).to be_a ChefGen::FlavorBase
  end

  it 'should copy the static content' do
    expect(FileUtils).to receive(:cp_r).with(%r{/cookbook_base/\.}, '/nonexistent')
    expect(FileUtils).to receive(:cp_r).with(%r{/awesome/\.}, '/nonexistent')
    flavor = ChefGen::Flavor::Awesome.new(temp_path: '/nonexistent')
    flavor.add_content
  end

  it 'creates files unconditionally' do
    include FakeFS::SpecHelpers

    expect(@recipe).to receive(:directory)
    expect(@recipe).to receive(:cookbook_file)
    flavor = ChefGen::Flavor::Awesome.new(type: 'cookbook', recipe: @recipe)
    flavor.files << 'README.md'
    flavor.declare_resources
  end

  it 'creates templates unconditionally' do
    include FakeFS::SpecHelpers

    expect(@recipe).to receive(:directory)
    expect(@recipe).to receive(:template)
    flavor = ChefGen::Flavor::Awesome.new(type: 'cookbook', recipe: @recipe)
    flavor.templates << 'README.md'
    flavor.declare_resources
  end
end
