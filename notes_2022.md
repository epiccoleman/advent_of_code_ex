# notes - 2022

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