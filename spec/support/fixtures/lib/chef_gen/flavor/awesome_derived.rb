require 'chef_gen/flavor/awesome'

module ChefGen
  module Flavor
    class AwesomeDerived < ChefGen::Flavor::Awesome
      NAME = 'awesome_derived'
    end
  end
end
