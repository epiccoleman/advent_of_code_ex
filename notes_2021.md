## notes - 2021

## further down the grid rabbit hole

alright so, at this point i've done a ton of work in Grid2D, I think it's come together quite nicely. The new api is a little nicer to use in some important ways, sticks closer to normally expected behaviors from functions with names like update and at and new.

We've gone a long way towards the goal of making Grid more flexible - we now support negative indices and sparsely populated grids in most of the major functions and transformations in the module. the rewritten transformation functions gain quite a bit in performance (the benchmark script in the grid test dir can attest to that).

The lowest difference I saw was one of the small cases where the new version is only about twice as fast as the old version. But with a large input, like a 1000x1000 grid, it's more like 30 times faster. And on a sparse grid the new version was _30,000_ times faster - pretty huge difference to not have to iterate over 1,000,000 values.

I still have a few improvements planned.

from_rows - should take a config like new to allow to set the origin. should have an option to ignore a given value or by default ignore nils - we shouldn't insert empty cells if they're not needed. basically, support construction of sparse grids.
from_cols - ditto above
from_cols - ditto above
append_grid - this should be updated to not use rows
print - have some ideas for this, basically to_strs but allow a bit more customization of the print, could make it less useless
slice - make sure this still works. should take a config to include or discard the cut line
merge - I think this should handle sparse and negative pretty well, needs some updates anyway though. should be able to get rid
of some of the exceptions and whatnot now that it accepts negative grids, and we could add some logic in merge to merge the smaller grid onto the larger grid. basically all this fiddling has been to enable a big rewrite of merge.

## digression - grid stuff
alright well.

i've been struggling to get the grid to work properly in the day 13 puzzle. so i had a crazy idea.

a lot of the grid module is written in a sort of naive "visually sensible" way. we can construct grids from rows and strings and even columns. we can also construct a grid by passing in dimensions and filling it with a certain value.

_however_

a lot of these operations are quite slow, especially on large grids. one of the reasons for this, especially in the case of day 13, is that grids often contain a lot of unneeded information. the grid in day 13 is 1311 x 854 (or maybe 1310?). This means we've got a map with over a million keys. There are only 907 dots in the puzzle input, so we're storing more information than we need by several orders of magnitude.

in many grids (maybe even _most_) it's really not necessary to store the values of unoccupied cells. we should be able to solve day 13 just by creating a map of the 907 dot positions, and transform the positions of appropriate dots mathematically. this would be way faster and probably also less error prone.

however, many of the functions in Grid currently work on the assumption that the grid is completely filled out. so what's a guy to do?

well, a sensible guy might just _not use_ the grid for a puzzle. but i guess i'm not sensible because i think what i'd like to do is to rewrite some of the grid functionality so that we can handle sparse grids as well as grids which are completely filled out.

now, this means that quite a few functions would have to be rewritten. we wouldn't be able to assume that a grid is complete, so any function which uses things like "rows" and "cols" to do transformations would have to be changed to instead perform any transforms mathematically. the upside though is that this should result in a dramatic speed increase in basically every way. further, it will allow us to handle merges more intelligently and probably reopen the idea of merges which extend the dimensions of the grid.

another thing i'd like to support is grids with negative indices. this would require adding y_min and x_min fields to the struct, and any of the currently existing grid construction functions would have to set those fields.

alright so... how to approach this. luckily we've got a pretty good test suite around existing functionality.

first order of business - let's try to list all the functions that would need to change

~~new - needs a new function head, docs, maybe some new logic~~
from_rows - needs to set min. i think we will still require same length rows
from_cols - needs to set min.
~~to_strs - would need logic to handle empty space~~
~~row and rows - would need to handle empty space~~
~~col and cols - would need to handle empty space~~
~~at - what happens when accessing empty space~~
~~update - already has logic for empty space, but should test~~
merge - needs updates anyway... think it already would handle this though? one thing is that it needs to be updated to allow extension
map - should map be allowed to change positions?
~~all? - how should all work on a sparse grid? - current decision is it just cares about populated values~~
~~neighbors - think this already handles empty, but might need a note in the doc~~
~~same for neighbor_locs~~
~~same for edge neighbors and edge_neighbor_locs~~
append_grid - how would this work with sparse grid? I guess it needs to assume squareness and recalculate coordinates
print - weird anyway, maybe we could reimplement using to_strs
slice - think this works the same? test

edge functions - would need to insert nils or something

transformations - all need rewritten to use math to transform coordinates

new code:
complete? / sparse? - tells you if grid is complete or spars


## day 13
well well well, if it isn't another excuse to work on Grid2D... :)

alright, well i chased my tail for a while on the merge functionality before deciding to just keep it simple. Time to actually do the puzzle...



## day 12
That was a hard one. The twist here turned out to be fairly tricky. Some ugliness in the solution but overall pretty cool. Need to remember that this has code for de-nestification of big ol' nasty lists.

Some good recursion in here.

More commentary in the module doc, I'm ready to move on from this one.

## day 11
This one turned out to be bigger than it initially seemed! A lot of the work went into implementing new functionality on `Grid2D`.

There are a couple of lessons I learned here. The first thing I did was to implement the `Enumerable` protocol on `Grid2D`. This was a pretty educational experience overall and taught me a lot about Elixir - I wound up actually pulling down the Elixir source to dig into how `Enumerable` was implemented for `Maps`, which seemed like it would get me closer to what I wanted. However, I eventually realized that `Enumerable` wasn't a silver bullet, because it does not preserve the shape of Maps (and other stuff) that are passed into the various functions in `Enum`. Still, it turned out to be useful in a few different places - for example, since it doesn't make sense to `filter` a Grid2D, so I was able to use `Enum.filter` where I needed it. Also learned how to define a custom Exception, which was prompted by the ass-pain of debugging some issues and proved to be fairly useful.

But what ultimately turned out to be more useful (or at least, get me closer to what I wanted) was to implement a few functions that shadow functions in `Enum` for `Grid2D` in particular, in a way that preserves the structure of the ... struct. For example, I added implementations of `all?`, `map`, and `update`, all of which were quite useful in solving this problem. There are some mildly confusing behaviors in some of these new functions, which might require

If I was going to go back and improve this solution, one thing I think I'd do would be to define a struct for the cell state - mostly just for "type" checking purposes. I had a few bugs which turned out to be caused by me just forgetting to return the cell state in the correct format, and a struct would have made some of it mildly more convenient to type out.

Arguably, I should have had a function that performed 1 full step which `do_steps` could have called, but it was easier to just call `do_steps(grid, 1)` in the body of the function that solves part 2. Still, I'm always happy when Part 2 is easy to implement, becasue it (seems to) mean that I did something right in the first part, and part 2 was quite easy to write using the existing simulation function and `Grid2D.all?` (at least, after I looked at my old notes and remembered how to use `Stream.iterate` and `Enum.reduce_while` to repeat code until some condition is met.

Overall I learned a ton from this one, even though I spent a ton more time on it than any of the other puzzles this year. Pretty happy with it.

## digression - protocols
I mentioned before that i was interested in implementing Enumerable for the Grid2D module, so I've spent some time digging into what it would take to do this. I started by reading the code that implements `Enumerable` for the `Map` struct, as this is basically the same thing I want to be able to do.

I am still a little confused about some of the Enumerable protocol, but the basic structure of what the `Map` impl does makes sense - essentially, it converts a map to a list and falls back to the list implementation of `reduce`. (the other three functions in the `Enumerable` protocol are slightly less interesting because you can just return `{:error, __MODULE__}` and let Elixir fall back to default implementations of those three that utilize `reduce`, which is good enough for me).

I was confused for a bit because I didn't understand why it wasn't necessary to convert the list back to a map as part of the reduce impl. But a little playing at the REPL helped me make some sense of it. I had forgotten that when you call an Enum function on a Map, you always get a list back. If you want a Map, your map function needs to return `{key, new_value}` pairs, and then you can pass that list of tuples to `Enum.into(%{})` or, maybe more clearly, to `Map.new`.

`Enum.into()` requires that the struct being passed implements `Collectable`, so if you want to use that then you need to look into that protocol, and the moduledoc for `Collectable` has a helpful `Why Collectable?` heading which has some philosophical discussion that was enlightening:

> In order to support a wide range of values, the functions provided by the Enumerable protocol do not keep shape.  For example, passing a map to Enum.map/2 always returns a list.
> This design is intentional. Enumerable was designed to support infinite collections, resources and other structures with fixed shape. For example, it doesn't make sense to insert values into a Range, as it has a fixed shape where only the range limits and step are stored.

> The Collectable module was designed to fill the gap left by the Enumerable protocol. Collectable.into/1 can be seen as the opposite of Enumerable.reduce/3.

So at the outset, we're already starting to get to a place where it's questionable whether it's really worthwhile to even bother with implementing `Enumerable` - after all, the whole goal here was to reduce the boilerplate code that pulls `grid_map` out of the grid to operate on it, and then reinserts it. There will always be some of this boilerplate, just like there is with `Map`s, just due to the nature of `Enumerable`'s design. If this was code for a client I might not bother since it's largely just gold-plating really.

But this isn't code for a client, so we'll joyfully continue down a somewhat pointless path for the sake of learning!

Now the question is, implement `Collectable`? Or, better yet, much like how `Map`s work, we are starting to need that `new` function that I bounced off of earlier. But again, just for learning, let's just do both, and learn both about implementing protocols and also whatever guard clause magic is necessary for `Grid2D.new` to just work with a variety of different forms.

Off the top of my head, the forms we'd want to support would be something like lists of {k,v} tuples, lists of lists (like `from_rows`), and lists of strings (like `from_strs`). One thing that jumps out is that implementing the tuples thing might not necessarily make sense, since the grid is expecting to have a certain shape. Is it necessary that a grid be rectangular though? I'd have to think about that one... one issue is that all the transformation functions wouldn't work on irregularly shaped grids. And also there's no use case for that. Idk.

After thinking about it for a while, maybe instead of worrying about guard clause magic, I should just write some functions to check the type of a list and use a cond in the new function.

Also this was of some use in figuring out the Enumerable stuff: https://blog.brettbeatty.com/elixir/custom_data_structures/enumerable

## day 10
i guess the secret sauce here is just knowing that a stack is the right data structure for the job. i always enjoy writing
recursive functions with pattern matching. overall pretty happy with this solution!

## day 9
this was cool, because it gave me an opportunity to pull the Grid class from 2020-20 out to Utils. There are a few things I'd like to improve in that module. For one, I think it would be pretty cool to make it implement Enumerable. This would eliminate a ton of boilerplate in both the module implementation and uses of Grid. Also, i'd like to get better with guard functions so that I could just have a `new` function that correctly chooses a way to construct the grid based on the type of the input. There are also a few functions in there which are not generically useful, and a few which assume sensible usage instead of having error handling to enforce it. My code for the traversal of the Grid that is used in this problem is a bit funky and required some annoying debugging. I kinda slapped a recursive function together without doing the usual structure, which makes tracing through it a bit confusing. I guess it's a sort of a breadth-first search so maybe I should have reviewed the canonical algorithm for that? But I've spent a good amount of time on this one so I'm going to move on.

## day 8
this was a cool one. figuring out _what_ code to write was harder than figuring out _how_ to write the code.
the function that does the deduction is quite long, but i don't see a lot of reason to try to break it down. wrote more prose than code just in the process of thinking it through.

## day 7
pretty straightforward - it's good to remember that computers can do simple math very very quickly. a few million subtractions and multiplications is nothing to even think twice about.

kinda cool to learn about triangular numbers: https://math.stackexchange.com/questions/60578/what-is-the-term-for-a-factorial-type-operation-but-with-summation-instead-of-p - i think I had been exposed to this before but
I doubt i'd have been able to derive the formula on my own with my current crummy math skills.

Just for funz, since it's apparently possible to embed some light latex in GH flavored markdown - the formula for calculating the
nth triangular number is this: $$\frac{n^2 + 1}{2}$$ Turns out it's a little cleaner to just write it as: $$\frac{n(n+1)}{2}$$ (which even _I_ can see is equivalent).

When it comes to expressing that in Elixir - you can either have
```
(n * (n + 1)) / 2
```
or
```
(:math.pow(n, 2) + 1) / 2
```

First looks nicer to me, so there it is.


## day 6
man, and i thought i was getting clever thinking about ways to memoize the calculation or to do data analysis to get the growth rate. i had to browse reddit for a hint. the trick is _not_ that you don't need to "simulate" the fish per se, it's just that you don't need each fish to be an individual item in a list. you just need to keep track of _how many_ fish are in each state, which is easy enough to do with a map (although i saw some clever uses of array rotation to do the job as well!)

this is a good problem to demonstrate that choosing the right data structure makes all the difference. I ran a benchmark and the original list-based solution is literally 17000 times slower than the map based solution.

I went back and extended the benchmarking suite, running the simulation with different numbers of iterations. Even with only 10 the map-based code is almost 10x faster than the list based solution. As you scale the input, the difference between the two approaches grows by something like an order of magnitude per 10-20 iterations.

Also for fun, I ran the map version with some larger inputs. Even with 10,000 iterations, it only takes 2 ms to run.

smart lanternfish sim 256         53.67 μs
smart lanternfish sim 1000        178.38 μs
smart lanternfish sim 10000       1885.77 μs

If we assume that the list-based version follows the same pattern I saw of increasing the difference by roughly an order of magnitude per 10 iterations, then we have something like a runtime of 2e+1000 ms for the list based version. By some very rough math this would take 3.3e+290 years to run the 10000 iterations.

## day 5
overall happy with my solution, although I'm curious as to whether there's some good math solution that would have been more elegant than my brutish solution of literally enumerating all the points and then counting the intersections. there are 500 lines, so even if you have to compare them all to each other that only comes out to 250000 comparisons. On the other hand, that might have made it a little harder to count the intersections since you'd have to watch out not to double count them. felt kinda 'clever' in a way just end-running around the math so good enough for me.

i played around with some new stuff in this one too around documentation - it's pretty cool to call `h` on your own function in the repl and see a big boy style doc get printed out. instead of writing unit tests for my functions i implemented them as doc tests. these are honestly just ok imo, it's a really neat concept but a bit clunky. it would be rad to have something like checkov in there so you could cut out some of the repetition, but overall i think it's a neat tool.

## day 4
I give my solution a solid B- , there are some parts that are a bit ugly. I'm happy overall, there are probably a few things that could have been expressed more cleanly in the game logic. My initial idea was to basically replicate the 2d grid module I built for 2020 day 20. And, as a matter of fact, I originally wrote that module with the idea that it could be reused for other puzzles. It turns out that the Grid module should probably have been called something like "2DCharacterGrid" or similar - it wasn't sufficiently adaptable to handle a grid of numbers instead. But honestly, that was kind of a red herring anyway, because it turns out that the 2D array style access really wasn't necessary for this problem. Once I settled on using the Bingo numbers as the keys in the "Board" map, writing the code for marking numbers and detecting Bingos was easy. Also got to write some mild recursion - it's kinda crazy to me how natural that feels now. I remember _really_ struggling to wrap my head around recursive functions way back in the college days. Turns out I just needed practice (and 10 years).

One other thing with this problem is that it feels like a natural one to try out an "actor model" approach. You could have a "bingo caller" actor and then a bunch of "players" with boards that receive messages with each number. Then when one detects a bingo it could send out a message to the "caller" (i.e. it could yell "BINGO!"), and then the caller could score it and spit out the result. One minor disadvantage of AOC is that you don't really _need_ to do anything like that, and the in-memory list approach is easier to code, but it could be a fun learning opportunity. Maybe I'll come back and revisit eventually.

## day 3
there is some definite slop here. this is an annoying puzzle for elixir :). One thing that might be helpful is to treat the inputs as integers, and then use Integer.digits and Integer.undigits to convert. This would get rid of some of the annoying string conversion logic and probably make everything a bit cleaner. Oh - but one problem with that, is you lose the padding. probably by the time you deal with that it's a wash between the two approaches. idk.

## day 1 and day 2
man i missed elixir.
