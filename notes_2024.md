## notes - 2024

## day 8
argh. the worst thing that can happen is when your code works on the test input but not on the big one. because where do you start debugging?

initial answer was 297. i then submitted 350 to see if i was way off (establish an upper bound). 297 is too low and 350 is too large, so i don't seem to be _wildly_ off. that's a range of 53 so ... i could just binary search for the answer with 6 guesses. which honestly, i might - just because it would be nice to know the exact number for the sake of tuning the code. am i missing ... one? several?

idk if that even really helps me, though, tbh. because i still wouldn't know _which_ ones I'm missing.

--- hours later

holy shit, i just misread the problem. i _wasn't_ supposed to filter out locations that already had an antenna at them. god daimn.

on to part 2.

---

ok, well at first i thought this was going to be hard, but i had two realizations that made it feel easier than part 1 - which is a nice consolation prize for the time spent debugging on part 1 only to realize i just didn't read the puzzle right.

the first realization was that there's not really a need to worry about duplicate values or about the ordering of the pairs of points. in fact, it's easier to just do _permutations_ of points rather than combinations, because it eliminates the need to figure out the direction of the line between the two points. i guess i could go fix part 1 to use the same strategy, but i cbf. but anyway, the idea is that since we know we're going to see each pair of points in two arrangements (i.e. for some pair {{x_a, y_a}, {x_b, y_b}}, our function for finding antinodes will see both {a, b} and {b, a}) we can just get the offset between a and b and then the offset between b and a, and calculate the antinodes in the correct direction. that means we can just always get the next point by applying the offset between a and b. since we always start with {x1, y1}, we may wind up calculating the same antinode more than once - but who cares, `Enum.uniq`  exists.

The other thing that I learned (and this is a good piece of knowledge to have, and therefore sufficient reward for the annoyance of part 1) is about `Stream.take_while`. Although funnily enough from a quick search through this repo I've used that several times already, so I guesss it's not new knowledge per se. But either way, it made the problem easy. I think technically in this case, it should be an Enum.take_while, which avoids having to call `Enum.into` or `Enum.to_list` to resolve the sequence. For a sequence of this size it probably don't mattah, so I'm going to leave it as originally written for the sake of having an example for future me.

Woof. on to the next one.

## day 7

ok, so this turned out to not be as bad as i thought. special thanks to elixir for making me learn recursion i guess?

i let this one kinda stop me on the AOC path for a while and I turned out to solve it pretty quickly

I will give myself some "cleverness credit" for noticing what part 2 would be in the sample input.

because of that I ran a quick test on the input (which I think is a good idea for future reference) where I counted the number of operations it would take. For a digit string with n digits, the number of "attempts" you need to make is 2^n. The longest string of digits in the input has 11 digits, so to brute force it we need to try 2048 combinations of operators. (Side note - I could probably write the recursion in a more clever way that causes it to kick early if a set of operators goes over the limit, cutting some fat off the checking.)

Anyway, for 3 operators (add, mul, and concat), the number of attempts is 3^n, which of course increases faster. But even still, 3^11 is only 177,147. Totaling up all the "line tests" for the given input gave me 268,872 for part 1 and 16,361,982 for part 2. So I think brute force will be viable enough here.

Yup, its fine. No need to get fancy. Onward!

## day 6
looks like grid's back on the menu, boys

alright. part 1 relatively easy. but now, part two.


initial thoughts: a placement must be on one of the nodes that the guard
visits on the "default path"
(otherwise, the guard wouldn't it)
there is a certain shape that is always formed by a node being placed. it's this kind of staggered thingy.

```
.....
..#..
.#.#.
..#..
```

```
.....#...
.......#.
....#....
......#..
.........
```

i guess that first one sorta breaks the pattern - and also, i think rotations / reflections of that shape are also valid

the direction that you're traveling when you enter a loop matters too

so one way i can think of to do it is we could like, try to approach it geometrically. and i think we kind of have to do that either way.

but i think there's also something like a graph problem here? like, each obstacle is a vertex which leads either to the next obstacle or out of the grid

actually, each obstacle is up to 4 vertices, i guess. because you exit in a different direction based on which direction you hit the obstacle

so ... if we could set up a graph by traversing the grid, we might be able to use that graph to detect cycles. but the problem of course is you can't just take any three successive vertices, there's more than the fact of their connect that determines whether they have a potential loop. it's soemthing to do with their geometry. which means that maybe the graph idea doesn't help that much. (although an ordered list of visted obstacles might be of some use, and maybe the faced direction when we hit one).

i mean i wonder about bruteforce here. there are 16900 locations in the map.
could we just test every possible location? we could detect a cycle by checking for repetitions of 4 nodes in the list of visited obstacles.

maybe let's try coding up a cycle detection function and see if bruteforce is viable?

ok - so - i'm midway through coding up the brute force way. i'm not super optimistic about this, though it might be ok. there are 4500ish locations, so if checking a 'random' (brute force) placement takes .01 seconds that's still a 45 second run time. and if it's any worse than that we're pushing up into minutes. that probably still results in an _acceptable_ solution, but not a great one.

but i had a little revelation which is that we should be able to pretty easily check for a "corner" - basically something like this:

```
.....
....#
.#...
...#.
.....
```

That obstacle in the bottom is a "corner" because it's between two other nodes in a particular manner. i guess this is a "down-corner" (i.e. it's a corner if you hit the obstacle facing down).

so a down-corner is a node at (x,y) where there is some node on the line (x+1) and some node on the line (y-1)

well, fuck, though. isn't _every_ node that's not the exit node a corner already, somehow?

lets call the node on x+1 "n0" and the node at y-1 "n1" then the way that you convert a "down-corner" to a loop is by placing a node at a point (x_loop, y_loop), where x_loop is n1_x + 1 and y_loop is n0_y - 1.

so maybe instead of trying to detect a cycle, for each node, you see if there is an obstructed line from the last node in the corner (n1) to the place you need to put a loop point. if there's an obstacle on that line, then you can't form a loop there, and you move on.

so yeah - every node is a corner, and you can use your current direction to find the node you came from, your future direction to find the node you're going to, and then you can figure out the potential loop spot, and then you can check if the path to that spot is clear, and if so, you've found a spot where you can put an obstacle and force a loop.

the exit node and the start node are not corners. the second node... could be? actually the exit node maybe could be too. might have to special case those, idk.


that seems like a pain to code though, so let's continue with brute force for now.

ah. i have just discovered that it possible to have a cycle with 8 nodes as well. i think they always have to be multiples of 4? but they can be at least 8 nodes long, and possible arbitrarily so. brute force is looking bad but i do have an idea for the cycle detection function. but this is getting bad, i think.


---

alright, i got it. brute force seems fine, taking something like ~35 seconds to run for me.

i do have a couple of optimization ideas to knock the run time down.

i might be able to detect a cycle by keeping track of seen obstacles and a direction they were seen in. (because if you see the same obstacle from the same direction twice, you must be in a loop, i think??)

i might be able to avoid copying the whole list of obstacles by sort of "doping" the simulate guard function with an obstacle to add as an optional argument (instead of using Grid2D.update? although really that just calls Map.put, shouldn't be that expensive, idk)

i might be able to shave some cycles by not simulating each individual step, but by just going straight to the next obstacle. i might even able to store a list of obstacles for each row and column (not sure that would really speed things up)

anyway, good enough to commit for now. might come bac karound for optimizations, but i'm already getting behind the curve on this year's puzzles

## day 5
I guess I'll give myself a little bit of credit for noticing ahead of time that this was probably a graph problem of some kind. I couldn't quite suss out a good way to do it with a graph, so I did a sort of naive solution on Part 1 - but of course, as soon as Part 2 came up, I could tell I was going to have to change my approach a bit.

I've been trying to avoid doing much searching or using help from AI this year - even going so far as to write the code in VSCode instead of Cursor (which has become my default editor). But I did get a pointer to the concept of a topological sort - which I only vaguely remember from my algs class - which does exactly what I need, by producing a sorted list from a graph such that all the dependencies are in order.

Lucky for me, `libgraph` has a built in `topsort` which can be used to produce a topological sort of a directed graph. I decided to just use that instead of implementing it myself (I know, lazy). But I did have to solve the problem of taking an arbitrary update and rearranging it given a sort order. The way I went about that was just to iterate through the sort order and add each element to the 'rearranged' list if it existed in the update, which does effectively sort the update, although I bet there's a better algorithm for that - but it doesn't matter much given the relatively small sizes of the updates.

Another issue was that the whole set of rules for the 'real' problem is not possible to topologically sort. The way to solve that is to simply remove all the irrelevant rules from the set before making the graph, which (at least for this problem) eliminated any cycles in the graphs.

Really, the first part was harder, since I hadn't landed on a topsort implementation yet. I wonder if it would be any faster to use the topsort approach for Part 1, though I somewhat doubt it given the size of the data and the overhead of making the graph and performing the topsort. I'm not interested enough in that question to bother writing a benchmark, so I guess it'll remain a mystery.

Good problem though, this year has been fun so far!

## day 4
Good ol' Grid2D got some fancy new functionality, and now has a general purpose "pattern detector". Really need to bust that out into a separate lib at some point, it's got a lot of cool stuff in it now.

This one took longer than it strictly needed to because Grid2D is the one place in this repo where I try to, ya know, do things in a nice and maintainable way. But it did feel good when Part 2 was just detecting a different pattern and I didn't really have to do any new work.

One other thing I might do for fun is to switch AOC2020 Day 20 over to use the new pattern stuff, just to further justify its existence. Overall, liked this one a lot, it's quite satisfying to keep extending Grid.

## day 3
That was a nice one! Good refresher on Regex for me. Once again Elixir std lib just makes things easy.

I initially thought I would reduce over the list, and have a flag that kept track of whether we were in the do / don't state. But I had a nice realization which is that, with non-greedy matching, I could just strip out the sections of the string that shouldn't be multiplied (i.e. anything between a `don't()` and a `do()`). I also felt clever for realizing that approach might leave me with a trailing don't, and coded protection against that, but it didn't turn out to matter.

One other important thing was using the `/s` at the end of my Regex (see also the `[:dotall]` option for many `Regex` functions in Elixir), which causes the dot character to match newlines and therefore lets the Regex span across the entire input (which for some reason is broken into 6 lines).

So two good pieces of learning / reinforcement there on Regex. Good stuff.

## day 2
Pretty straightforward. There's probably a more performant way to do this, but eh.

Marry me, `Enum.chunk_every`. Our love can only stay secret for so long.


## day 1
Alright, nice. Got CLI submission working, although frankly it's clunky enough that it's debatable whether it's better than just pasting into the input box. But it does work, which is fun.

Easy Day 1 puzzle, standard pattern of enjoying Elixir Enum module, not much more to say.

## day 0

we're back baby

quickly - gonna write down some notes on how the answer request works. i may try to add a submit thingy to my mix tasks.

post to the the puzzle's URL / answer (i.e. `https://adventofcode.com/2024/day/1/answer`)

post body is a form data, with a level and answer field (e.g. `level=2&answer=10`)

right or wrong comes back in the html for the answer page - body > main > article > p