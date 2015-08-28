require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class CookbookBase < ChefGen::FlavorBase
      NAME = 'cookbook_base'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::CookbookBase
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::CookbookBase do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should copy the static content' do
    expect(FileUtils).to receive(:cp_r).with(%r{/cookbook_base/\.}, '/nonexistent')
    flavor = ChefGen::Flavor::CookbookBase.new(temp_path: '/nonexistent')
    flavor.add_content
  end

  %w(Gemfile Rakefile Berksfile README.md
     CHANGELOG.md metadata.rb).each do |fname|
    it "should add a template for #{fname}" do
      allow(@recipe).to receive(:template)
      expect(@recipe).to receive(:template).with(/#{fname}$/)
      flavor = ChefGen::Flavor::CookbookBase.new(type: 'cookbook', recipe: @recipe)
      flavor.declare_resources
    end
  end
end
