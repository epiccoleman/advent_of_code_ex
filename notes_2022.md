# notes - 2022

# day 5
another pretty straightforward one. I rejected the challenge of writing a parser for the annoyingly formatted input and just fixed it up with Vim, which saved a lot of effort.

I also got a free capture regex from ChatGPT for this one (this is timesaving in the best possible way, really great use for it). I also used it at one point to point me towards the Enum function I wanted by asking "is there an elixir function which slices a list and returns both sides?". It informed me very kindly of the existence of `Enum.split`.

Again, sure I could have found it with the REPL, but it's nice to just ask the question and get a good answer. Awesome stuff.
# day 4
pretty straightforward if you can use sets. I had ChatGPT write me this regex: `~r/(?<a>\d+)-(?<b>\d+),(?<c>\d+)-(?<d>\d+)/x`. One of those things where you already know what you want but it's a pain to write it out. Nice.
# day 3
this is just the kind of thing that's mildly annoying in elixir i guess. worked fine though.
# day 2
also fairly easy. I actually had ChatGPT help me out a bit on this one, mostly for fun. See [this]() for more info.
# day 1
sup aoc!

pretty easy one. it always feels a bit gross though to have to run like a triply nested map to process the input. oh well though.

also, if you want a reverse sort, you're either doing
```
thing
|> Enum.sort()
|> Enum.reverse()
```

or

```
Enum.sort_by(&(1), &>=/2)
```

That second one is pretty overly clever and the top is obviously more readable. But it's AOC so wheeeeeeee! (also, I think the second one is more performant, but unlikely to matter here)