require 'chef_gen/flavor/awesome'

module ChefGen
  module Flavor
    class AwesomeDerived < ChefGen::Flavor::Awesome
      NAME = 'awesome_derived'
      DESC = 'an awesome derived cookbook template'
      VERSION = '0.0.0'

      before_copy_content do
        @tocopy << [File.expand_path(File.join(static_content_path(__FILE__, 'awesome_derived'))) + '/.']
      end
    end
  end
end
