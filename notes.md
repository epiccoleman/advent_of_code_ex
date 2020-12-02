# notes

## day 1

i think this code is kinda awful but oh well, that's the point of this exercise. found another solution in elixir and picked up a few ideas.

Enum.find_value is interesting, it takes a function. it returns the _value_ of the first time the function was invoked and that value was truthy. whereas find just returns the first element of the list for which _f_ was truthy.

Enum.reduce_while is also interesting, it has a mechanism for breaking out of the execution - it goes until _fun_ returns {:halt, term}.

Lastly a cool pattern matching trick - if you are writing a recursive function for chewing through a list, one of the signatures can be like this:
```elixir
def do_thing([front | rest], etc) do
```
this handles pulling the front element off the list, and then you can just pass `rest` to the recursive call to keep working through the list.