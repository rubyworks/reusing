# Reusing

Ruby introduced refinements in version 2.0. Refinements are essenitally
a safe alternative to monkey-patching. Unfrotunately, a serious problem
with the syntax of refinements is the degree to which they differ from
writing tradition class extensions. Traditionally, if you want to add
a method to the String class, for instance, you simply open the class
and define them method.

```ruby
class String
  def some_method
    ...
  end
end
```

And that's it. You could put that code in a file and require as needed.
Refinements, on the other hand, hand much more *boiler-plate*. The
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

This can be put in a file too, but the `using SomeModule` will have to 
be reissued in every file the refinment is needed.

For a one off use, this isn't a big deal. But for a method library such as
Ruby Facets, this has huge implications. In fact, Facets does not yet support
refinements precisely b/c of this issue. To do so would require maintaining
a second copy of every method in refinement format. While doable, it is obviously
not DRY, and quite simply a pain in the ass.

So the idea of overriding the `using` method to accept a library file name was
hatched. With it, most extension scripts can be redily used as-is, without all
the boiler-plate. Usage is pretty simple. Let's say the example given
above is in a library file called `some_method.rb`, then we can do:

```ruby
require 'reusing'

using 'some_method'
```

The refinement method will find the file, read it in, perform a transformation
converting `class String` into `refine String do` and wrap it all in a module
which it then passes to the original `using` method, which has been aliased, btw,
as `reusing` (hence the name of this library).

Granted, the code is a bit of a dirty hack --as is necessary to make it work.
Nonetheless, it should work just fine where needed.

