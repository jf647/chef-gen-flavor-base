# Changelog for chef-gen-flavor-base

## 0.9.2

* fix a couple of snippet guards that were referring to the wrong dependent

## 0.9.1

* update #static_content_path to take a flavor or snippet name arg rather than relying on the NAME constant in the class, because this fails when you have C < B < FlavorBase (B would try to copy files from a directory named for C)
* disable feature tests on CircleCI because it's failing with a bundler error that we don't see during local tests

## 0.9.0

* extracted ChefGen::FlavorBase and the snippets in the namespace ChefGen::Snippets into a seperate gem
* change the mechanism for composing snippets into a flavor from Ruby module inclusion to a declarative method.  This allows flavor authors to control the order that snippets are applied.  Previously, snippet order was whatever random based on the return of `Object#public_methods`
