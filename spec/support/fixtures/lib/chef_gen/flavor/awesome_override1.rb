require 'chef_gen/flavor/awesome'

module ChefGen
  module Flavor
    class AwesomeOverride1 < ChefGen::Flavor::Awesome
      NAME = 'awesome_override1'
      DESC = 'overrides content in the flavor'
      VERSION = '0.0.0'

      # hooking into before_copy_content ensures we end up after
      # normal flavor and snippet files in the @tocopy list
      before_copy_content do
        @tocopy << [File.expand_path(File.join(static_content_path(__FILE__, 'awesome_override1'))) + '/.']
      end
    end
  end
end
