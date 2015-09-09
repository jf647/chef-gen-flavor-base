require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class NextSteps < ChefGen::FlavorBase
      NAME = 'next_steps'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::NextSteps
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::NextSteps do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should add the actions_taken accessor' do
    flavor = ChefGen::Flavor::NextSteps.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor).to respond_to :next_steps
  end
end
