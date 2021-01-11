# notes - AOC 2015

# day 6
this one was fairly straightforward. i wrote this code pretty tersely and i'm not sure i'll be able to decipher it a few days from now, but oh well. on this initial implementation it is surprisingly slow. the big piece of work is probably the multiple map updates - wonder if that could be improved.

ok so another crack at this - initial idea was to reduce over the positions being updated with the state map as the accumulator. The next idea was to instead build a map of the updated positions, then use map.merge to generate the updated state (the logic being basically that the merge is probably more optimized under the hood than just repeatedly callin Map.update). this seems to have been a reasonable instinct because it reduced the runtime of part 1 by about half, which is not bad, but still leaves us with about a 20 second runtime.

embarking on a bit of a tangent with benchee here. marge version is faster. also, benchmarks run quite faster if you map over the instructions instead of reducing. so probably the insertions into the final map add quite a bit of time. which might account for a big chunk of the performance gains in the merge version.

so, tried this pmap implementation - not worth much in the context i was using it. the real issue i have here is probably insertion, so i almost need like a parallel insert.

so it looks like the winning implementation is the original merge one. ultimately the thing I think I need is some kind of parallel reduce that would let me insert multiple keys into the map at once.

# day 5
guess that the nasty regex one from 2020 prepared me a bit for this, i still had to get pretty gnarly though for the recurring pair thing. gross looking pipeline but hey, it works. for the rest, I was able to write either relatively simple functions or decent regex versions.

Another thing that was interesting about this problem - I had two functions which I first implemented with the Enum module (e.g. slice up array and do stuff to it). Then I came up with straightforward regexes that did the same thing. This made me curious as to the relative performance of the two different versions of the function, so I got to learn how to use Benchee. It was a fun experiment too, because I got two different results - in one case the Regex version was faster and in the other case it was slower. This will be a useful (or at least interesting) tool for future problems.

# day 4
another easy one, thanks to erlang for having an md5 function. I guess there's probably a clever way to do this but idk what it would be.

# day 3
pretty easy, but i'm afraid to say "was AOC easier in 2015?" because some real mf'er of one is probably coming up.

# day 2
Pretty simple, some nice benefits of pattern matching here for sure. Got a bit clever with the difference operator to get the minimum two sides, which is probably poor form if anyone else ever had to care about this code, luckily for me thats not the case.

# day 1
pattern matching is cool, i really like how simple the solution for day 1 is. i wonder a bit if reduce_while is a smell, but I think it's def the right tool for the job here.