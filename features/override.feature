Feature: chef generate

  Verifies that a flavor can override elements of another flavor
  using the content or resource hooks

  Scenario: override at setup time using #add_content
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | awesome_override1                |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I generate a cookbook named "foo"
    Then the exit status should be 0
    And the file "foo/test/integration/default/serverspec/spec_helper.rb" should match /^set :os, :windows$/

  Scenario: override at generate time using #declare_resources
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | awesome_override2                |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I generate a cookbook named "foo"
    Then the exit status should be 0
    And the file "foo/Gemfile" should match /^gem 'rubocop', '= 0.31.0'$/
