Feature: chef generate

  Verifies that a generate cookbook using the core snippets is
  CI clean when generated

  Scenario: gems can be bundled
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | awesome                          |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I generate a cookbook named "foo"
    Then the exit status should be 0
    When I cd to "foo"
    And I bundle gems
    Then the exit status should be 0

  Scenario: rake tasks can be listed
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | awesome                          |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I generate a cookbook named "foo"
    Then the exit status should be 0
    And I cd to "foo"
    And I bundle gems
    And I list the rake tasks
    Then the exit status should be 0
    And the output should match each of:
      | ^rake foodcritic  |
      | ^rake rubocop     |
      | ^rake tailor      |
      | ^rake spec        |
      | ^rake kitchen:all |
      | ^rake style       |

  Scenario: generated cookbook passes style checks
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | awesome                          |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I generate a cookbook named "foo"
    Then the exit status should be 0
    And I cd to "foo"
    And I bundle gems
    And I run a style test
    Then the exit status should be 0
    And the output should match /no offenses detected$/

  Scenario: generated cookbook passes style checks
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | awesome                          |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I generate a cookbook named "foo"
    Then the exit status should be 0
    And I cd to "foo"
    And I bundle gems
    And I run a style test
    Then the exit status should be 0
    And the output should match /no offenses detected$/

  Scenario: kitchen suites can be listed
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                            |
      |----------------|----------------------------------|
      | CHEFGEN_FLAVOR | awesome                          |
      | RUBYLIB        | ../../spec/support/fixtures/lib  |
    When I generate a cookbook named "foo"
    And I cd to "foo"
    And I bundle gems
    And I list the kitchen suites
    Then the exit status should be 0
    And the output should match each of:
      | ^default-ubuntu-1404 |
      | ^default-centos-66   |
