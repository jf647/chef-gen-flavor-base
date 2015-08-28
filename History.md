# Changelog for chef-gen-flavor-base

## 0.9.0

* extracted ChefGen::FlavorBase and the snippets in the namespace ChefGen::Snippets into a seperate gem
* change the mechanism for composing snippets into a flavor from Ruby module inclusion to a declarative method.  This allows flavor authors to control the order that snippets are applied.  Previously, snippet order was whatever random based on the return of `Object#public_methods`
