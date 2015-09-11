# -*- encoding: utf-8 -*-
# stub: chef-gen-flavor-base 0.9.2.20150911125045 ruby lib

Gem::Specification.new do |s|
  s.name = "chef-gen-flavor-base"
  s.version = "0.9.2.20150911125045"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["James FitzGibbon"]
  s.date = "2015-09-11"
  s.description = "chef-gen-flavor-base is a base class to make it easy to create 'flavors'\nfor use with\n[chef-gen-flavors](https://github.com/jf647/chef-gen-flavors).\n\nchef-gen-flavors plugs into the 'chef generate' command provided by\nChefDK to let you provide an alternate template for cookbooks and other\nchef components.\n\nThis gem simply provides a class your flavor can derive from; templates\nare provided by separate gems, which you can host privately for use\nwithin your organization or publicly for the Chef community to use.\n\nAn example flavor that demonstrates how to use this gem is distributed\nseparately:\n[chef-gen-flavor-example](https://github.com/jf647/chef-gen-flavor-example)\n\nAt present this is focused primarily on providing templates for\ngeneration of cookbooks, as this is where most organization-specific\ncustomization takes place. Support for the other artifacts that ChefDK\ncan generate may work, but is not the focus of early releases."
  s.email = ["james@nadt.net"]
  s.extra_rdoc_files = ["History.md", "Manifest.txt", "README.md"]
  s.files = ["History.md", "LICENSE", "Manifest.txt", "README.md", "chef-gen-flavor-base.gemspec", "lib/chef_gen/flavor_base.rb", "lib/chef_gen/flavor_base/copy_helpers.rb", "lib/chef_gen/flavor_base/resource_helpers.rb", "lib/chef_gen/snippet/actions_taken.rb", "lib/chef_gen/snippet/attributes.rb", "lib/chef_gen/snippet/chef_spec.rb", "lib/chef_gen/snippet/cookbook_base.rb", "lib/chef_gen/snippet/debugging.rb", "lib/chef_gen/snippet/example_file.rb", "lib/chef_gen/snippet/example_template.rb", "lib/chef_gen/snippet/git_init.rb", "lib/chef_gen/snippet/guard.rb", "lib/chef_gen/snippet/next_steps.rb", "lib/chef_gen/snippet/no_clobber.rb", "lib/chef_gen/snippet/recipes.rb", "lib/chef_gen/snippet/resource_provider.rb", "lib/chef_gen/snippet/standard_ignore.rb", "lib/chef_gen/snippet/style_foodcritic.rb", "lib/chef_gen/snippet/style_rubocop.rb", "lib/chef_gen/snippet/style_tailor.rb", "lib/chef_gen/snippet/test_kitchen.rb", "lib/chef_gen/snippet_base.rb", "lib/chef_gen/snippets.rb", "shared/snippet/attributes/templates/default/attributes_default_rb.erb", "shared/snippet/chef_spec/templates/default/_rspec.erb", "shared/snippet/chef_spec/templates/default/spec_chef_runner_context_rb.erb", "shared/snippet/chef_spec/templates/default/spec_recipes_default_spec_rb.erb", "shared/snippet/chef_spec/templates/default/spec_spec_helper_rb.erb", "shared/snippet/cookbook_base/templates/default/Berksfile.erb", "shared/snippet/cookbook_base/templates/default/CHANGELOG_md.erb", "shared/snippet/cookbook_base/templates/default/Gemfile.erb", "shared/snippet/cookbook_base/templates/default/README_md.erb", "shared/snippet/cookbook_base/templates/default/Rakefile.erb", "shared/snippet/cookbook_base/templates/default/metadata_rb.erb", "shared/snippet/example_file/files/default/files_default_example_conf", "shared/snippet/example_template/files/default/templates_default_example_conf_erb", "shared/snippet/guard/templates/default/Guardfile.erb", "shared/snippet/recipes/templates/default/recipes_default_rb.erb", "shared/snippet/resource_provider/templates/default/providers_default_rb.erb", "shared/snippet/resource_provider/templates/default/resources_default_rb.erb", "shared/snippet/style_rubocop/templates/default/_rubocop_yml.erb", "shared/snippet/test_kitchen/libraries/kitchen_helper.rb", "shared/snippet/test_kitchen/templates/default/_kitchen_yml.erb", "shared/snippet/test_kitchen/templates/default/test_integration_default_serverspec_recipes_default_spec_rb.erb", "shared/snippet/test_kitchen/templates/default/test_integration_default_serverspec_spec_helper_rb.erb"]
  s.homepage = "https://github.com/jf647/chef-gen-flavor-base"
  s.licenses = ["apache2"]
  s.rdoc_options = ["--main", "README.md"]
  s.rubygems_version = "2.4.4"
  s.summary = "chef-gen-flavor-base is a base class to make it easy to create 'flavors' for use with [chef-gen-flavors](https://github.com/jf647/chef-gen-flavors)"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<chef-gen-flavors>, ["~> 0.9"])
      s.add_runtime_dependency(%q<hooks>, ["~> 0.4"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<chef-dk>, ["~> 0.7"])
      s.add_development_dependency(%q<hoe>, ["~> 3.13"])
      s.add_development_dependency(%q<hoe-gemspec>, ["~> 1.0"])
      s.add_development_dependency(%q<rake>, ["~> 10.3"])
      s.add_development_dependency(%q<rspec>, ["~> 3.1"])
      s.add_development_dependency(%q<guard>, ["~> 2.12"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 4.2"])
      s.add_development_dependency(%q<guard-rake>, ["~> 0.0"])
      s.add_development_dependency(%q<guard-rubocop>, ["~> 1.2"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.9"])
      s.add_development_dependency(%q<simplecov-console>, ["~> 0.2"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
      s.add_development_dependency(%q<aruba>, ["~> 0.6.2"])
      s.add_development_dependency(%q<rspec_junit_formatter>, ["~> 0.2"])
      s.add_development_dependency(%q<fakefs>, ["~> 0.6"])
    else
      s.add_dependency(%q<chef-gen-flavors>, ["~> 0.9"])
      s.add_dependency(%q<hooks>, ["~> 0.4"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<chef-dk>, ["~> 0.7"])
      s.add_dependency(%q<hoe>, ["~> 3.13"])
      s.add_dependency(%q<hoe-gemspec>, ["~> 1.0"])
      s.add_dependency(%q<rake>, ["~> 10.3"])
      s.add_dependency(%q<rspec>, ["~> 3.1"])
      s.add_dependency(%q<guard>, ["~> 2.12"])
      s.add_dependency(%q<guard-rspec>, ["~> 4.2"])
      s.add_dependency(%q<guard-rake>, ["~> 0.0"])
      s.add_dependency(%q<guard-rubocop>, ["~> 1.2"])
      s.add_dependency(%q<simplecov>, ["~> 0.9"])
      s.add_dependency(%q<simplecov-console>, ["~> 0.2"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
      s.add_dependency(%q<aruba>, ["~> 0.6.2"])
      s.add_dependency(%q<rspec_junit_formatter>, ["~> 0.2"])
      s.add_dependency(%q<fakefs>, ["~> 0.6"])
    end
  else
    s.add_dependency(%q<chef-gen-flavors>, ["~> 0.9"])
    s.add_dependency(%q<hooks>, ["~> 0.4"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<chef-dk>, ["~> 0.7"])
    s.add_dependency(%q<hoe>, ["~> 3.13"])
    s.add_dependency(%q<hoe-gemspec>, ["~> 1.0"])
    s.add_dependency(%q<rake>, ["~> 10.3"])
    s.add_dependency(%q<rspec>, ["~> 3.1"])
    s.add_dependency(%q<guard>, ["~> 2.12"])
    s.add_dependency(%q<guard-rspec>, ["~> 4.2"])
    s.add_dependency(%q<guard-rake>, ["~> 0.0"])
    s.add_dependency(%q<guard-rubocop>, ["~> 1.2"])
    s.add_dependency(%q<simplecov>, ["~> 0.9"])
    s.add_dependency(%q<simplecov-console>, ["~> 0.2"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
    s.add_dependency(%q<aruba>, ["~> 0.6.2"])
    s.add_dependency(%q<rspec_junit_formatter>, ["~> 0.2"])
    s.add_dependency(%q<fakefs>, ["~> 0.6"])
  end
end
