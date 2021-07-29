# Safe Object As JSON

This gem provides an enhancement to the fallback implementation for `as_json` on the core `Object` class in the ActiveSiupport library. The implementation provided by ActiveSupport just dumps the instance variables as name value pairs in a Hash. However, this is susceptible to infinite recursion when dumping an object that maintains references to other objects that then maintain back references to the original object.

So, for example, a tree structure where the parent has a list of the children and each child has a reference to its parent results in a `SystemStackError` when calling as_json on any node.

The fix provided by this gem maintains a state of the current stack of objects being used to construct the `as_json` hash. If an object has already been referenced in the current call to `Object#as_json`, it is left out of the hash in lieu of having it raise a stack level too deep error.

## Usage

No changes are needed to use this gem. It will just replace the method definition of `Object#as_json`. It will not impact any class that defines its own `as_json` or `to_hash` method which includes all the core Ruby classes (String, Numeric, Array, Hash) as well as ActiveModel classes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'safe_object_as_json'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install safe_object_as_json
```

## Contributing

Open a pull request on GitHub.

Please use the [standardrb](https://github.com/testdouble/standard) syntax and lint your code with `standardrb --fix` before submitting.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).