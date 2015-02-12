# Reusing

## Short Story

Reusing allows for the use of refinements directly from an core extension file.

```ruby
require 'reusing'

using 'some_extension_script'
```

## Long Story

Ruby introduced refinements in version 2.0. Refinements are essentially
a safe alternative to monkey-patching. Unfortunately, the degree to which
the syntax of refinements differs from writing traditional class extensions
is a sever hinderence to their adoption. Traditionally, if you wanted to add
a method to the String class, for instance, you simply open the class
and define the method.

```ruby
class String
  def some_method
    ...
  end
end
```

And that's it. You can put this code in a file and require it as needed.
Refinements, on the other hand, have much more *boiler-plate*. The
above would have to be written:

```ruby
module SomeModule
  refine String do
    def some_method
      ...
    end
  end
end

using SomeModule
```

The top portion can be put in an extension file too, but the `using SomeModule` part
will have to be reissued in every file the refinement is needed.

For a one-off, this isn't a big deal. But for a method library such as
Ruby Facets, this has huge implications. In fact, Facets does not yet support
refinements precisely becuase of this issue. To do so would require maintaining
a second copy of every method in refinement format. While doable, it is obviously
not DRY, and quite simply too much a pain in the ass to bother.

So I consder what, if anything, could be done about this problem. And the idea of
overriding the `using` method to accept a library file name was hatched.
With it, most extension scripts can be readily used as-is, without all
the boiler-plate. Usage is pretty simple. Let's say the example given
above is in a library file called `some_method.rb`, then we can do:

```ruby
require 'reusing'

using 'some_method'
```

The new using method will find the file, read it in, perform a transformation
converting `class String` into `refine String do` and wrap it all in a module
which it then passed to the original `using` method (which has been aliased
as `reusing`, btw, hence the name of this library).


## Caveats

Unfortunately the implementation of Reusing is necessarily a bit of a hack. Although
it works fine for basic extensions there are complications if, for instance,
the script requires another extension script. While the scripts extensions will become
refinements, the further requirements will not. There may also be issues if the
extenesion defines meta-methods (i.e. class level extensions).


## Thoughts

If Ruby Team were to take this issue to heat, than probably the ideal solution would
have refinement syntax use normal `class` and `module` keywords, instead of the
special `refine` clause.

```ruby
module M
  class String
    def important!
      self + "!"
    end
  end
end

# refinement
using M::*
```

In conjunction with this is should be possible to monkey patch with the same code as well.

```ruby
# core extension
patch M::*
```

In this way the both techniques could be used via the same code, while still being modular.
But that is a significant change to Ruby itself, and ultimately falls to Matz to decide.


## Copyrights

Copyright (c) 2014 Rubyworks (BSD-2 License)

See LICENSE.txt for details.
