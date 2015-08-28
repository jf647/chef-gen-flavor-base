Feature: chef generate

  Verifies that 'chef generate cookbook' can generate a cookbook
  using a flavor derived from another flavor

  Scenario: generate cookbook
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | awesome_derived                  |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I generate a cookbook named "foo"
    Then the exit status should be 0
    And I cd to "foo"
    And the following files should exist:
      | .gitignore                                                  |
      | .kitchen.yml                                                |
      | .rspec                                                      |
      | .rubocop.yml                                                |
      | attributes/default.rb                                       |
      | Berksfile                                                   |
      | CHANGELOG.md                                                |
      | chefignore                                                  |
      | files/default/example.conf                                  |
      | Gemfile                                                     |
      | Guardfile                                                   |
      | metadata.rb                                                 |
      | providers/default.rb                                        |
      | Rakefile                                                    |
      | README.md                                                   |
      | recipes/default.rb                                          |
      | resources/default.rb                                        |
      | spec/chef_runner_context.rb                                 |
      | spec/recipes/default_spec.rb                                |
      | spec/spec_helper.rb                                         |
      | templates/default/example.conf.erb                          |
      | test/integration/default/serverspec/recipes/default_spec.rb |
      | test/integration/default/serverspec/spec_helper.rb          |
    And the following directories should exist:
      | attributes                                  |
      | files                                       |
      | files/default                               |
      | providers                                   |
      | recipes                                     |
      | resources                                   |
      | spec                                        |
      | spec/recipes                                |
      | templates                                   |
      | templates/default                           |
      | test                                        |
      | test/integration                            |
      | test/integration/default                    |
      | test/integration/default/serverspec         |
      | test/integration/default/serverspec/recipes |
