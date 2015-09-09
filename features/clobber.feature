Feature: chef generate

  If a file or template with action :create is added to the recipe
  and that file already exists, fail to generate unless '-a clobber'
  is passed to 'chef generate'

  Scenario: try to clobber a file
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                           |
      |----------------|---------------------------------|
      | CHEFGEN_FLAVOR | awesome                         |
      | RUBYLIB        | ../../spec/support/fixtures/lib |
    Given a directory named "foo"
    Given a file named "foo/Gemfile" with:
      """
      source 'https://rubygems.org'
      """
    And I run `chef generate cookbook foo`
    Then the exit status should not be 0
    And the output should match each of:
      | tried to overwrite file.+Gemfile |

  Scenario: try to clobber a file with fail_on_clobber disabled
    Given a knife.rb that uses chef-gen-flavors
    And I set the environment variables to:
      | variable       | value                           |
      |----------------|---------------------------------|
      | CHEFGEN_FLAVOR | awesome                         |
      | RUBYLIB        | ../../spec/support/fixtures/lib |
    Given a directory named "foo"
    Given a file named "foo/Gemfile" with:
      """
      source 'https://rubygems.org'
      """
    And I run `chef generate cookbook foo -a clobber`
    Then the exit status should be 0
