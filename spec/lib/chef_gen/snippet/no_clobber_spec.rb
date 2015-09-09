require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class NoClobber < ChefGen::FlavorBase
      NAME = 'no_clobber'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::NoClobber
      end

      do_declare_resources do
        files << 'a'
        templates << 'b'
      end
    end
  end
end

RSpec.describe ChefGen::Snippet::NoClobber do
  include ChefDKGeneratorContext
  include DummyRecipe
  include StdQuiet
  include ResetPlugins

  it 'should add the actions_taken accessor' do
    flavor = ChefGen::Flavor::NoClobber.new(type: 'cookbook', recipe: @recipe)
    flavor.declare_resources
    expect(flavor).to respond_to :fail_on_clobber
  end

  it 'should fail if a file exists and noclobber is enabled' do
    flavor = ChefGen::Flavor::NoClobber.new(type: 'cookbook', recipe: @recipe)
    allow(flavor).to receive(:destination_path).and_call_original
    allow(flavor).to receive(:destination_path).with('a').and_return('/nonexistent/foo/a')
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/nonexistent/foo/a').and_return(true)
    expect { flavor.declare_resources }.to raise_error(/tried to overwrite file a/)
  end

  it 'should fail if a template exists and noclobber is enabled' do
    flavor = ChefGen::Flavor::NoClobber.new(type: 'cookbook', recipe: @recipe)
    allow(flavor).to receive(:destination_path).and_call_original
    allow(flavor).to receive(:destination_path).with('b').and_return('/nonexistent/foo/b')
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/nonexistent/foo/b').and_return(true)
    expect { flavor.declare_resources }.to raise_error(/tried to overwrite file b/)
  end

  it 'should succeed if a template exists and noclobber is disabled' do
    flavor = ChefGen::Flavor::NoClobber.new(type: 'cookbook', recipe: @recipe)
    allow(flavor).to receive(:destination_path).and_call_original
    allow(flavor).to receive(:destination_path).with('b').and_return('/nonexistent/foo/b')
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/nonexistent/foo/b').and_return(true)
    allow(@ctx).to receive(:clobber).and_return(true)
    expect { flavor.declare_resources }.not_to raise_error
  end
end
