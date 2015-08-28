require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class GitInit < ChefGen::FlavorBase
      NAME = 'git_init'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::GitInit
        @snippets << ChefGen::Snippet::ActionsTaken
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::GitInit do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should execute git init' do
    allow(@recipe).to receive(:execute)
    expect(@recipe).to receive(:execute).with('initialize git repo')
    flavor = ChefGen::Flavor::GitInit.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
  end
end
