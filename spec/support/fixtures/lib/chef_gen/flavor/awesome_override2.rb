require 'chef_gen/flavor/awesome'

module ChefGen
  module Flavor
    class AwesomeOverride2 < ChefGen::Flavor::Awesome
      NAME = 'awesome_override2'
      DESC = 'overrides resources in the flavor'
      VERSION = '0.0.0'

      before_copy_content do
        @tocopy << [File.expand_path(File.join(static_content_path(__FILE__, 'awesome_override2'))) + '/.']
      end

      # locks rubocop to v0.31, uses after hook to ensure we override
      # what the style_rubocop snippet sets as default
      after_declare_resources do
        @cookbook_gems['rubocop'] = '= 0.31.0'
      end
    end
  end
end
