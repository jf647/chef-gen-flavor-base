Feature: chef generate

  Verifies that a flavor can override elements of another flavor
  by deriving and adding another snippet

  Scenario: override using snippet that has #add_content
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | awesome_override_snippet1        |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I generate a cookbook named "foo"
    Then the exit status should be 0
    And the file "foo/test/integration/default/serverspec/spec_helper.rb" should match /^set :os, :windows$/

  Scenario: override using snippet that has #declare_resources
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | awesome_override_snippet2        |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I generate a cookbook named "foo"
    Then the exit status should be 0
    And I cd to "foo"
    And the following files should not exist:
      | files/default/example.conf         |
      | templates/default/example.conf.erb |
    And the following directories should not exist:
      | files             |
      | files/default     |
      | templates         |
      | templates/default |

  Scenario: override by removing a snippet during construction
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | awesome_override_snippet3        |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I generate a cookbook named "foo"
    Then the exit status should be 0
    And I cd to "foo"
    And the following files should not exist:
      | files/default/example.conf         |
      | templates/default/example.conf.erb |
    And the following directories should not exist:
      | files             |
      | files/default     |
      | templates         |
      | templates/default |
