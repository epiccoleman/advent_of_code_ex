## notes - 2021

## day 7
pretty straightforward - it's good to remember that computers can do simple math very very quickly. a few million subtractions and multiplications is nothing to even think twice about.

kinda cool to learn about triangular numbers: https://math.stackexchange.com/questions/60578/what-is-the-term-for-a-factorial-type-operation-but-with-summation-instead-of-p - i think I had been exposed to this before but
I doubt i'd have been able to derive the formula on my own with my current crummy math skills.

Just for funz, it's apparently possible to embed some light latex in GH flavored markdown - the formula for calculating the
nth triangular number is this: $$\frac{n^2 + 1}{2}$$ Turns out it's a little cleaner to just write it as: $$\frac{n(n+1)}{2}$$ (which even _I_ can see is equivalent) when it comes to expressing that in Elixir - you can either have
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
