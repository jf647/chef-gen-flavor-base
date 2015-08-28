require 'chef_gen/flavor/awesome'

module ChefGen
  module Flavor
    class AwesomeOverride2 < ChefGen::Flavor::Awesome
      NAME = 'awesome_override2'

      # locks rubocop to v0.31, uses after hook to ensure we override
      # what the style_rubocop snippet sets as default
      after_declare_resources do
        @cookbook_gems['rubocop'] = '= 0.31.0'
      end
    end
  end
end