## notes - 2024

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