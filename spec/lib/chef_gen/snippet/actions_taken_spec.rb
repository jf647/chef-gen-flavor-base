require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class ActionsTaken < ChefGen::FlavorBase
      NAME = 'actions_taken'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::ActionsTaken
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::ActionsTaken do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should add the actions_taken accessor' do
    flavor = ChefGen::Flavor::ActionsTaken.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor).to respond_to :actions_taken
  end
end
