## notes - 2024

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