# chef-gen-flavor-base

* home :: https://github.com/jf647/chef-gen-flavor-base
* license :: [Apache2](http://www.apache.org/licenses/LICENSE-2.0)
* gem version :: [![Gem Version](https://badge.fury.io/rb/chef-gen-flavor-base.png)](http://badge.fury.io/rb/chef-gen-flavor-base)
* build status :: [![Circle CI](https://circleci.com/gh/jf647/chef-gen-flavor-base.svg?style=svg)](https://circleci.com/gh/jf647/chef-gen-flavor-base)
* code climate :: [![Code Climate](https://codeclimate.com/github/jf647/chef-gen-flavor-base/badges/gpa.svg)](https://codeclimate.com/github/jf647/chef-gen-flavor-base)
* docs :: [![Inline docs](http://inch-ci.org/github/jf647/chef-gen-flavor-base.svg?branch=master)](http://inch-ci.org/github/jf647/chef-gen-flavor-base)

## DESCRIPTION

chef-gen-flavor-base is a base class to make it easy to create 'flavors'
for use with
[chef-gen-flavors](https://github.com/jf647/chef-gen-flavors).

chef-gen-flavors plugs into the 'chef generate' command provided by
ChefDK to let you provide an alternate template for cookbooks and other
chef components.

This gem simply provides a class your flavor can derive from; templates
are provided by separate gems, which you can host privately for use
within your organization or publicly for the Chef community to use.

An example flavor that demonstrates how to use this gem is distributed
separately:
[chef-gen-flavor-example](https://github.com/jf647/chef-gen-flavor-example)

At present this is focused primarily on providing templates for
generation of cookbooks, as this is where most organization-specific
customization takes place. Support for the other artifacts that ChefDK
can generate may work, but is not the focus of early releases.

## INSTALLATION

You should not install this gem directly; it will be installed as a
dependency of a flavor gem.  If you are developing a flavor, declare
this gem a dependency of your gem in your gemspec file:

```ruby
Gem::Specification.new do |s|
  s.name = 'chef-gen-flavor-awesome'
  s.add_runtime_dependency('chef-gen-flavor-base', ['~> 0.9'])
  ...
end
```

Then make bundler read your gemspec:

```ruby
source 'https://rubygems.org/'
gemspec
```

And use bundler to install your dependencies:

```bash
$ bundle
```

## ANATOMY OF A FLAVOR

First, some terminology:

* a `flavor` is a class that chef-gen-flavors can use to create a directory suitable for passing as the value of `chefdk.generator_cookbook`.
* `setup mode` is the life of a flavor object constructed by chef-gen-flavors
* `generate mode` is the life of a flavor object constructed by ChefDK
* a `snippet` is a class that augments a flavor by defining hooks into the setup and generate workflow.  Snippets tend to have a specific purpose, like adding support for Test Kitchen or Rubocop to a cookbook template.
* setup hooks are called during setup mode to add files (typically templates) to a temporary directory set up by chef-gen-flavors
* resource hooks are called during generate mode to declare chef resources, typically of type `directory`, `cookbook_file` and `template`.

Flavors and Snippets are typically distributed as Rubygems.  Because
snippets are useful to more than one flavor, they are usually
distributed separately.  This gem contains many generic snippets that
you can use to start creating a flavor to suit your needs.

## A CHEF GENERATE RUN

A flavor is constructed twice when you run `chef generate`:

First, chef-gen-flavor-base constructs the object, passing a temporary
directory where files can be copied to.  This is called setup mode.
chef-gen-flavors then calls `#add_content` in the flavor, which
constructs each snippet.  Along the way, various setup hooks are called
that lets flavors and snippets modify the files copied into the
temporary directory.

Then, chef-dk constructs the object (or more accurately, your generator
recipe does), passing the type of chef artifact being created (e.g.
'cookbook') and a reference to the recipe that resources should be added
to.  This is called generate mode.  The generator recipe then calls
`#declare_resources`, which constructs each snippet.  Like setup mode,
various generate hooks are called to let flavors and snippets modify the
resources that are used to generate your cookbook

## DIRECTORY LAYOUT

This example defines a flavor named `Example`. The full source for this
example is [available on
rubygems](https://rubygems.org/gems/chef-gen-flavor-example).

The directory structure of a flavor looks like this:

```
chef-gen-flavor-example
├── chef-gen-flavor-example.gemspec
├── lib
│   └── chef_gen
│       └── flavor
│           └── example.rb
└── shared
    └── flavor
        └── example
            ├── metadata.rb
            └── recipes
                └── cookbook.rb
```

(we are intentionally skipping over some of the ancillary files like
Rakefile, Gemfile, and unit tests)

## FLAVOR FILES

The file `lib/chef_gen/flavor/example.rb` contains the definition of the
'example' flavor.  It requires the base flavor and the core snippets,
and inherits from FlavorBase:

```ruby
require 'chef_gen/flavor_base'
require 'chef_gen/snippets'

module ChefGen
  module Flavor
    class Example < ChefGen::FlavorBase
      NAME = 'example'
      ...
    end
  end
end
```

In the constructor, it declares which snippets to mix in, then calls
initialize in the base class.  Order is important here - the base class
constructs the snippets, so if you call it first, nothing gets
initialized.

```ruby
def initialize(temp_path: nil, target_path: nil, type: nil, recipe: nil)
  super
  @snippets << ChefGen::Snippet::CookbookBase
  @snippets << ChefGen::Snippet::Attributes
  ...
end
```

The flavor also defines the do_add_content hook to copy files into the temporary
directory that chef-gen-flavors will pass to ChefDK:

```ruby
do_add_content do
  @tocopy << [File.expand_path(File.join(static_content_path(__FILE__))) + '/.']
end
```

`#add_content` is defined in FlavorBase, and is the mechanism by which
the contents hooks in the snippets get called, so it is important to
also call the method in the base class.

 `#static_content_path` is a helper method that returns the standard
 path to static content, which is
 `$FILE/../../../shared/flavor/$FLAVORNAME`.  For example, when called
 as in the example above (which is in `lib/chef_gen/flavor/example.rb`),
 the path returned is `shared/flavor/example`.

 For a simple flavor that just uses the shared snippets, the static
 content will typically just be a `metadata.rb` file and the generator
 recipes (`recipes/cookbook.rb` in our example).  It is important that
 the cookbook name in metadata.rb match the name of the flavor, or
 ChefDK will not be able to find the cookbook:

 ```ruby
 name 'example'
 version '0.0.0'
 ```

The generator recipes typically just construct an object and call
`#declare_resources` on it:

```ruby
ChefGen::Flavor::Awesome.new(
  type: 'cookbook', recipe: self
).declare_resources
```

`#declare_resources` is defined in FlavorBase, and is the mechanism by
which the contents hooks in the snippets get called, so it is important
to also call the method in the base class.  A flavor can also declare
resources at generate time:

```ruby
do_declare_resources do
  @recipe.send(:directory, 'test')
end
```

It is more common for resources to be declared via snippets though.

## SIMPLE RESOURCES

FlavorBase provides five accessors for adding simple resources to a
recipe when running in generate mode:

* directories
* files
* files_if_missing
* templates
* templates_if_missing

Each element of these lists is a path to the target in the generated
cookbook, so to set up a template to create a recipes/default.rb file,
just push that value onto the @templates_if_missing list:

```ruby
do_declare_resourced do
  templates_if_missing << File.join('recipes', 'default.rb')
end
```

The source of files and directories is a mangled form of the
destination, with slashes and dots replaced by underscores.  Templates
additionally have `.erb` appended to the source.  The template resource
set up by the above declaration looks like this:

```ruby
template "#{dest_path}/recipes/default.rb" do
  source 'recipes_default_rb.erb'
  helpers ChefDK::Generator::TemplateHelper
end
```

If you need to construct more complex files and templates, you can call
`#add_files` or `#add_templates` directly; look at the CookbookBase
snippet for examples of how this is done.

## FLAVOR HOOKS

Flavors have two main entry points: `#add_content`, called during setup
mode and `#declare_resources`, called during generate mode.  In each mode,
there are various hook points to allow flavors and snippets to modify what
happens.

Hooks are called in the context of the flavor object.  Some hooks are
passed arguments.

In practice, the `do_add_content` and `do_declare_resources` hooks are
where most customization takes place.

Note that when declaring a hook directly in a flavor, you just add the
block as part of the class definition:

```ruby
module ChefGen
  module Flavor
    class AwesomeOverride1 < ChefGen::Flavor::Awesome
      NAME = 'awesome_override1'

      before_copy_content do
        @tocopy << [File.expand_path(File.join(static_content_path(__FILE__))) + '/.']
      end
    end
  end
end
```

To get the same effect in a snippet, you have to add the hook to the
flavor's class using one of the initializers:

```ruby
module ChefGen
  module Snippet
    class BeforeCopyContent < ChefGen::SnippetBase
      NAME = 'before_copy_content'

      private

      def initialize_generate
        @flavor.class.before_copy_content do
          @tocopy << [File.expand_path(File.join(static_content_path(__FILE__))) + '/.']
        end
      end
    end
  end
end
```

### COMMON HOOKS

These hooks are called in both setup and generate mode:

#### before_initialize

Called before any flavor initialization has taken place in
ChefGen::FlavorBase.

#### after_initialize

Called after flavor initialization has taken place in
ChefGen::FlavorBase.

#### before_snippet_construct

Called before snippets are constructed.

#### after_snippet_construct

Called afetr snippets have been constructed and marked as active.

### SETUP HOOKS

These hooks are called in setup mode when `#add_content` is called.

#### before_add_content

Called immediately before the do_add_content hooks are invoked.

#### do_add_content

Called to add content to the temporary directory.  Typically this is
used to copy static files (templates, etc.) from a flavor or snippet.

#### after_add_content

Called immediately after the do_add_content hooks are invoked.

#### before_copy_content

Called immediately before `#copy_content` is invoked to copy files to the
temporary directory.

#### after_copy_content

Called immediately after `#copy_content` is invoked.  Typically this is
used to replace a file that comes from a parent flavor or another
snippet, ensuring that the replacement gets copied over the other file.

### GENERATE HOOKS

These hooks are called in generate mode when `#declare_resources` is
called.

#### before_declare_resources

Called immediately before the do_declare_resources are invoked.

#### do_declare_resources

Called to add resources to the recipe.  Typically this is used to
manipulate the @directories, @files and @templates lists, but more
complex use cases are possible.

#### after_declare_resources

Called immediately after the do_declare_resources are invoked.

#### before_add_resources

Called immediately before `#add_resources` adds the entries in the
@directories, @files, and @templates lists to the recipe.

#### after_add_resources

Called immediately after `#add_resources` adds the entries in the
@directories, @files, and @templates lists to the recipe.

#### before_add_directories(directories)

Called before `#add_resources` adds directories to the recipe.  Passed a
list of directories that will be added.

#### after_add_directories(directories)

Called after `#add_resources` adds directories to the recipe.  Passed a
list of directories that will be added.  Can be used for reporting
purposes (see the ActionsTaken snippet for an example).

#### before_add_files(files, resource_action, type, attrs)

Called before `#add_resources` adds files to the recipe.  Passed a list
of files, the action to give the resource, the resource type (:file or
:cookbook_file) and a hash of additional attributes.  Can be used to
implement protection schemes (see the NoClobber snippet for an example).

#### after_add_files(files, resource_action, type, attrs)

Called after `#add_resources` adds files to the recipe.  Passed a list
of files, the action to give the resource, the resource type  (:file or
:cookbook_file) and a hash of additional attributes.  Can be used for
reporting purposes (see the ActionsTaken snippet for an example).

#### before_add_templates(templates, resource_action, attrs)

Called before `#add_resources` adds templates to the recipe.  Passed a
list of files, the action to give the resource and a hash of additional
attributes.  Can be used to implement protection schemes (see the
NoClobber snippet for an example).

#### after_add_templates(templates, resource_action, attrs)

Called after `#add_resources` adds templates to the recipe.  Passed a
list of files, the action to give the resource and a hash of additional
attributes.  Can be used for reporting purposes (see the ActionsTaken
snippet for an example).

## SNIPPET FILES

A snippet is a class that derives from `ChefGen::SnippetBase`:

```ruby
require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    class Attributes < ChefGen::SnippetBase
      NAME = 'attributes'
      ...
    end
  end
end
```

A snippet typically alters a flavor in one of three ways: by adding
accessors, such as a list of gems to write to a Gemfile:

The snippet base class provides a constructor that invokes
`#initialize_setup` in setup mode and `#intialize_generate` in generate
mode.

Snippets can add accessors to the flavor:

```ruby
def initialize_generate
  @flavor.class.send(:attr_accessor, :cookbook_gems)
  @flavor.cookbook_gems = { 'rake' => '~> 10.4' }
end
```

Or add a hook to copy content to the temporary directory.  Like a
flavor, `ChefGen::SnippetBase` provides a `#static_content_path` method
that finds the standard location of files packaged with the snippet,
using the name.

```ruby
def initialize_setup
  snippet_content_path = File.expand_path(File.join(static_content_path(__FILE__))) + '/.'
  @flavor.class.do_add_content do
    tocopy << [snippet_content_path]
  end
end
```

(Note how the static content path is calculated outside the hook block,
to ensure that we use `#static_content_path` defined in SnippetBase.  If
it were inside the hook block, which executes in the scope of the flavor
object, then `#static_content_path` in FlavorBase would be used.)

A snippet might also add a hook to declare resources at generate time:

```ruby
def initialize_generate
  @flavor.class.do_declare_resources do
    directories << 'spec'
    directories << File.join('spec', 'recipes')
    templates << '.rspec'
    templates_if_missing << File.join('spec', 'spec_helper.rb')
    templates_if_missing << File.join('spec', 'recipes', 'default_spec.rb')
    templates_if_missing << File.join('spec', 'chef_runner_context.rb')
  end
end
```

## BUILT-IN SNIPPETS

chef-gen-flavor-base comes with snippets that can be mixed and matched
to create a complete cookbook skeleton.  Also take a look at the
[example flavor](https://github.com/jf647/chef-gen-flavor-example) to
see how to use them.

For full documentation, run `bundle exec rake doc` in the source repo
then open `doc/index.html`.

### CookbookBase

* declares and provides a template for the basic files that any cookbook needs:
  * Gemfile
  * Berksfile
  * Rakefile
  * metadata.rb
  * README.md
  * CHANGELOG.md
* provides an accessor `#cookbook_gems` which is a hash with gem names as keys and constraints as values, defaulting to rake and berkshelf
* provides an accessor `#gem_sources`, which is a list preloaded with https://rubygems.org
* provides an accessor `#berks_sources`, which is a list preloaded with https://supermarket.chef.io
* provides an accessor `#rake_tasks`, which is a hash with task names as keys and full task definitions as values

### ActionsTaken

* provides an accessor `#actions_taken`, which is a list of strings representing what actions the flavor took
* adds before hooks to `#add_files`, `#add_templates` and `#add_directories` to add those actons to the actions_taken list
* adds an after hook to `#declare_resources` that adds a ruby_block to the recipe to report on what actions the flavor took

Any resources that you add to a flavor manually (not using the add_*
helpers) should be added to the actions_taken list manually:

```ruby
def initialize_generate
  @recipe.send(:execute, 'initialize git repo') do
    command('git init .')
  end
  actions_taken << 'initialize git repo' if snippet?('actions_taken')
```

### Attributes

* declares and provides a template for attributes/default.rb

### ChefSpec

* declares and provides a template for ChefSpec files:
  * .rspec
  * spec/spec_helper.rb
  * spec/chef_run_context.rb
  * spec/recipes/default_spec.rb
* adds the ChefSpec gems
* adds the ChefSpec rake tasks
* adds the ChefSpec guard set

### Debugging

* adds the pry, pry-byebug and pry-stack_explorer gems, to make debugging cookbooks easier

### ExampleFile

* declares and provides a cookbook_file for files/default/example.conf

### ExampleTemplate

* declares and provides a cookbook_file for templates/default/example.conf.erb

### GitInit

* executes 'git init .' after generation if git is installed and the `--skip-git-init` switch has not been passed

### Guard

* provides an accessor `#guard_sets`, which is a hash with set names as keys and full set definitions as values

### NextSteps

* provides an accessor `#next_steps`, which can be used to display some guidance to the user on how to proceed

To set next steps in a recipe, define it in your generate recipe like so:

```ruby
f = ChefGen::Flavor::Awesome.new(
  type: 'cookbook', recipe: self
)
f.class.after_declare_resources do
  self.next_steps = <<END

go forth and conquer

END
end
f.declare_resources
```

### NoClobber

* provides an accessor `#fail_on_clobber`, which is a boolean.  If true, then attempts to add files or templates with an action of :create (i.e. not @files_if_missing or @templates_if_missing) will cause the generate to fail.  To allow for files to be clobbered, users need to pass `-a clobber` to `chef generate`

### Recipes

* declares and provides a cookbook_file for recipes/default.rb

### ResourceProvider

* declares and provides a cookbook_file for:
  * resources/default.rb
  * providers/default.rb

### StandardIgnore

* declares the two ignore files used by chef cookbook repos:
  * chefignore
  * .gitignore
* provides two accessors: `#chefignore_patterns` and `#gitignore_patterns`, both of which are lists of patterns to write to `chefignore` and `.gitignore` respectively
* preloads the standard ignore patterns for chefignore and .gitignore

### StyleFoodcritic

* adds the Foodcritic gems
* adds the Foodcritic rake task
* adds the Foodcritic guard set

### StyleRubocop

* declares and provides a template for .rubocop.yml
* adds the Rubocop gems
* adds the Rubocop rake task
* adds the Rubocop guard set

### StyleTailor

* adds the Tailor gems
* adds the Tailor rake task

### TestKitchen

* declares and provides a template for ChefSpec files:
  * .kitchen.yml
  * test/integration/default/serverspec/spec_helper.rb
  * test/integration/default/serverspec/recipes/default_spec.rb
* adds the Test Kitchen gems
* adds the Test Kitchen rake tasks
* adds the Test Kitchen guard set

## SNIPPET DEPENDENCIES

Sometimes snippets need to depend on features provided by another
snippet.  For example, the CookbookBase snippet will add patterns to the
.gitignore and chefignore files, but only if the StandardIgnore snippet
has also been included in the flavor.  A common pattern is to test
whether a snippet has been enabled during generation like so:

```ruby
def initialize_generate
  @flavor.class.do_declare_resources do
    chefignore_patterns << '.rubocop.yml' if snippet?('standard_ignore')
  end
end
```

## EXAMPLE OVERRIDES

Because flavors and snippets are just ruby classes, you can override
them using normal object techniques.  It is important to call the
superclass method in FlavorBase or SnippetBase, as this is where the
important work tends to happen, but you have some flexibility around
whether you call it before or after the code in your flavor or snippet.

### Deriving one flavor from another

Rather than inheriting from ChefGen::FlavorBase, your flavor can inherit
from another flavor that inherits from ChefGen::FlavorBase.  In this way
you get all of the declarations and content of your parent flavor, plus
have the ability to tweak and change one or two little things that don't
fit your environment.

```ruby
module ChefGen
  module Flavor
    class MoarAwesome < ChefGen::Flavor::Awesome
      NAME = 'moar_awesome'
    end
  end
end
```

### Removing a snippet from the parent flavor

Perhaps a flavor does everything you want, but there's one thing you
don't like about it.  You can remove that snippet from the list of
snippets by hooking after_initialize:

```ruby
module ChefGen
  module Flavor
    class LessAwesome < ChefGen::Flavor::Awesome
      NAME = 'less_awesome'

      after_initialize do
        @snippets.reject! do |e|
          e == ChefGen::Snippet::ExampleFile || e == ChefGen::Snippet::ExampleTemplate
        end
      end
    end
  end
end
```

### Changing a template file in the parent flavor

If you want to keep a declaration but change the source file used for a
flavor, you can hook before_copy_content (or after_add_content):

```ruby
module ChefGen
  module Flavor
    class AlmostPerfect < ChefGen::Flavor::Awesome
      NAME = 'almost_perfect'

      before_copy_content do
        @tocopy << [File.expand_path(File.join(static_content_path(__FILE__))) + '/.']
      end
    end
  end
end
```

This example assumes that the awesome flavor includes the TestKitchen
snippet (which declares the serverspec spec_helper.rb file) and that you
package an alternate template with your flavor in
`shared/flavor/almost_perfect/templates/default/test_integration_default_serverspec_spec_helper_rb.erb`

### Adding a Rake task

To add an additional Rake task to a flavor:

```ruby
module ChefGen
  module Flavor
    class NeedsATask < ChefGen::Flavor::Awesome
      NAME = 'needs_a_task'

      do_declare_resources do
        rake_tasks['foo'] = <<'END'
task :foo do
  sh 'echo foo'
end
END
      end
    end
  end
end

```

### Removing a resource using a snippet

Here, we've used a snippet to remove resources from an snippet that
was run earlier:

```ruby
require 'chef_gen/flavor_base'
require 'chef_gen/snippet_base'

module ChefGen
  module Snippet
    class RemoveExamples < ChefGen::SnippetBase
      NAME = 'remove_examples'

      private

      def initialize_generate
        @flavor.class.after_declare_resources do
          directories.reject! do |e|
            %w(files files/default templates templates/default).include?(e)
          end
          files_if_missing.reject! do |e|
            %w(files/default/example.conf templates/default/example.conf.erb).include?(e)
          end
        end
      end
    end
  end
end

module ChefGen
  module Flavor
    class DoNotLikeExamples < ChefGen::Flavor::Awesome
      NAME = 'do_not_like_examples'

      def initialize(temp_path: nil, type: nil, recipe: nil)
        super
        @snippets << ChefGen::Snippet::RemoveExamples
      end
    end
  end
end
```

Note that when we manipulate the resource lists in a snippet, we have
to use `@flavor.resource_type`, not just `@resource_type`, as the
resource lists are members of the flavor, not the snippet.

## TESTING A FLAVOR

chef-gen-flavors provides a number of useful step definitions for Aruba
(a CLI driver for Cucumber) to make it easier to test flavors. To access
these definitions, add the following line to your
`features/support/env.rb` file:

    require 'chef_gen/flavors/cucumber'

For an example of how to use these steps in your features, refer to the
features in the `features` directory and the fixtures in
`spec/support/fixtues`.

## AUTHOR

[James FitzGibbon](https://github.com/jf647)

## LICENSE

Copyright 2015 Nordstrom, Inc.

Copyright 2015 James FitzGibbon

Licensed under the Apache License, Version 2.0 (the "License"); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
