# notes - 2025

## Day 1
This gave me a surprising amount of trouble for a Day 1 problem. I'm _sure_ there's a mathematical way to solve Part 2 - floor division should give the number of times that the lock passes 0. But I got frustrated trying to account for edge cases like the dial landing at zero.

I did realize after the fact that my  initial test cases were slightly wrong, I failed to notice in the example that when the dial _lands_ at 0 it should still count. Maybe worth another shot.

Ok, messed with it a little - there's still some sort of edge case tripping up my naive math approach.

So anyway, as the comment in the code says, fuck it, loop. Feels a bit wasteful but whatever, it's day 1.

Oh, also this bit of code is cute. too cute for production code, probably, but what the hell, it's AOC.

```
    op = case direction do
      "L" ->
        &-/2
      "R" ->
        &+/2
    end
```

