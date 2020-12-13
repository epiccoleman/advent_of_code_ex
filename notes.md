# notes

## day 12
pretty straightforward one, probably could have dried it a bit but oh well. good enough!

## day 11
this one took more effort than i thought it would from reading the description, but it turns out that there are some nice things about using a map instead of a 2d array. one neat thing was no writing bounds checking code, just check if the tuple key is in the map. curious about efficiency of something like that though. anyway i'm happy with this overall, it's a bit verbose and there are definitely some optimizations to be made but hey, it works.


## day 10
this one was tough. spent a lot more time than was necessary on the first part. it's funny because looking back i was so close to realizing that i could just sort the input.

i'm not sure i would have gotten the second part if not for a math tip from a friend - the key phrase of which was "you only have options when there's a difference of one". this was the key realization - anywhere in the chain of differences where there's a 3, there was only one choice to make there. likewise there was only one choice if [ 1 ]. But if you have a few 1 differences in a row you have more options, and these multiplicatively affect the total possible orderings.

## day 9
pretty happy that I could reuse day 1 code for the first part. Enum module and some nice pattern matching made the rest easy.

Part 2 is a little trickier, gonna try to brute force it. One observation - I will not need to chunk_every any higher than 617, because that's the line where the target number occurs, and everything after it appears to be larger (though they are not necessarily in ascending order).

welp, brute force worked. took a few seconds to run but ah well, good enough.

## day 8
not sure if this code is _good_ but by god it works and that's something. I'm happy to have come up with a solution for part 2 which didn't require me to trace any assembly! fun little problem to kinda brute force that out.

## day 7
having a good graph lib saved me here. friggin' recursion, man. at the end of writing it it makes such perfect sense but figuring out how to express it can be rough. took 2 or 3 runs at it before i figured out what i needed for part 2. overall happy with the code though at the end, the majority of code that had to be written was the string processing code and elixir makes that kind of stuff so easy.

## day 6
once again elixir made life easy, there was basically nothing i needed to do here that wasn't part of the standard library. whole thing is like 20 lines of code, feel great about this one.

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