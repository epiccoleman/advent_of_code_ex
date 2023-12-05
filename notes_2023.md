## notes - 2023

## day 4
wooooooof. should have known with an easy part 1 that part 2 would be gnarly.

I think the "architecture" of the solution is good. Basically, for each card, update the copies of the next card, and just iterate through the whole deck. But damn that part_2 is some ugly code.

one pitfall here was trying to use reduce_while. I read one of the instructions in the puzzle as requiring me to stop early, but that added a bunch of needless complexity to the code. If you always update the subsequent cards, you basically only need to go through the deck once, so a regular reduce using the size of the "deck" works just fine.

another place that added some crufty code was using a map to represent the "matched" and "copies" properties on each card. this could have really just been a tuple and saved a good chunk of code in the middle.

actually, went back and did that - saves some code, but maybe at a slight readability cost. idk. did a couple other minor refactors too, not too shabby honestly.

last thing i'd note is that i'm basically simulating a nested for loop with the two reduces over ranges in the solution. doesn't feel super elixir-y but whatever.


## day 3

well, that turned out to be a fairly large solution. i am always so damn happy to be able to use my grid thing though. this is my favorite kind of advent of code problem, where all of a sudden once you've solved the first half, the second is pretty easy. i probably spent 95% of the time doing part one, but once I had the stuff for finding adjacent part locations, and for filtering down grid positions, part 2 was easy.

grid module got a new function - `matching_locs`, which returns a list of all the grid positions which return true for a given function. that's a pretty nifty thing to have. who knows if i'll ever use it again?!

preliminary brainstorming:
ok, this is an interesting one. and of course it's got a grid, which means I have to decide whether my grid module is useful or not.

in this case, i think the main value of it is just that it can save some work processing the input into a usable format

so the basic idea would be to get the list of all the symbols, and then for each one, search for adjacent numbers. that part is a bit tricky, because the current "grid methodology" doesn't really have any way to identify that a number stretches across multiple cells.

Grid has a "neighbors" and "neighbor_locs" function, which could be used to check cells adjacent to a symbol's position for digits. then the only tricky part is determining the numbers that those digits are part of.

one idea i have is that during the processing of the grid, i could set the value at each position occupied by a number to the "whole" number. so that for something like this:

```
.16.
....
```

we would get a grid with positions:
```
%{
    {1, 0} => 16,
    {2, 0} => 16
}
```

as opposed to the "naive":
```
%{
    {1,0} => 1,
    {2,0} => 6
}
```

the problem with that approach is that it potentially causes a duplication issue - with something like:

```
.16.
..#.
....
```
In that case, Grid.neighbors would return two 16s, and you'd have no real way of knowing that you were double-counting the same "part number". this is actually still a problem even with the "naive" approach, because you have to be able to tell if any given neighbor cell is (or is not) part of a bigger number.

so maybe the idea is something like this. take a symbol's location. add its neighbors to a list of cells to search for numbers. and for each of those cells, we need to search left and right. if, during that search, a cell is found to contain a number, then you'd need to remove that cell from the list of cells that need to be checked. that way, we'd avoid double-coutning.

## day 2
this one didn't feel especially difficult, but there was a lot of work around processing the input into a usable format. i guess the data structure i landed on was decent because writing the actual "business logic" of the puzzle didn't take all that long once i'd done that.

i went a little "extra mile" in terms of testing here, and i will say that that turned out _not_ to help me in one place - I had forgotten to put "ors" between the clauses in &game_within_limit, but my test cases didn't catch that problem. relatively easy to find and fix but feels like one of those things where i could easily have torn my hair out for an hour before noticing those simple missing "ors".

one way that this might be slightly improved would be to define a struct for "pulls" formally and to create them using a "new" function to handle the defaults. as it stands, some of this code only works because i know that i'm not going to make pulls in any place other than "process_pull". This is pretty minor and totally fine for AoC, but there's some instinct that fires off when I do something like that, that somewhere down the line some dummy is going to create a pull that violates my assumptions. (that dummy would be me, of course). since I'll probably never re-use this code that's a bit of a misfire of the code smell circuits, but still, it's there.

## day 1

this was a surprisingly hard day 1 puzzle, took me 30-40 minutes to get it done. i think the approach i chose was good though, since i didn't get hung up on the "overlapping numbers" issue that apparently tripped some other people up.

just for fun, i refactored it down to be a little "tighter" - although honestly, this refactor is optimizing for cleverness over readability, and it's entirely unnecessary - especially DRYing the "part" function.

I think I could get it down even further - could basically define everything in line, but it would start requiring me to delete tests, so I'm going to leave it here. It might also be possible to do some regex voodoo that would eliminate the need for reversing the string, which could further condense the need for "first" and "last" functions, and let me just pass regexes, but that's getting severely stupid at that point.