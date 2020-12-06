# notes


## day 5
man elixir made this one easy, really happy with this solution.

## day 4
this seems reasonably good, except maybe in one place, which is the hgt_valid? function. not sure of a prettier way to handle that mess of a requirement though.

## day 3
reasonably happy with this one. figuring out how to translate the sorta typical 2d array reading and writing into elixir was interesting. Ultimately I think I chose a good approach that avoided having to do anything too weird.

I feel good also about how I handled the sled path stuff, it's cool to define it lazily with a stream and then use take_while to get the relevant pieces.

https://elixirforum.com/t/how-to-make-proper-two-dimensional-data-structures-in-elixir/872
https://blog.danielberkompas.com/2016/04/23/multidimensional-arrays-in-elixir/



## day 2
bit happier with this code. Elixir's pattern matching and good string library made this a lot less painful than it might be in other languages. probably a cleverer way to do the xor stuff at the end of the function for the second part.

## day 1

i think this code is kinda awful but oh well, that's the point of this exercise. found another solution in elixir and picked up a few ideas.

Enum.find_value is interesting, it takes a function. it returns the _value_ of the first time the function was invoked and that value was truthy. whereas find just returns the first element of the list for which _f_ was truthy.

Enum.reduce_while is also interesting, it has a mechanism for breaking out of the execution - it goes until _fun_ returns {:halt, term}.

Lastly a cool pattern matching trick - if you are writing a recursive function for chewing through a list, one of the signatures can be like this:
```elixir
def do_thing([front | rest], etc) do
```
this handles pulling the front element off the list, and then you can just pass `rest` to the recursive call to keep working through the list.