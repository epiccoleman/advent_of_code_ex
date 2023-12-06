## notes - 2023

## day 6

alright, this one looks amenable to brute force, or at least part 1 does.

yup, part 1 easy to brute force.

part 2 is obviously less amenable to brute force, but it only has to run 35,696,887 iterations to simulate the race, and then the Enum.filter is also linear time against all 35 million. It finishes in about 15 seconds though. Good enough for now.

## day 5
dammit, i should have known when i saw those giant numbers in the input that the "naive" approach wasn't going to work. since some of the range lengths given in the real input are in the hundreds of millions, i'm guessing that my current approach isn't going to work. although i am tempted to just run it and see how long it takes. for fun, i'm going to stick a timeout infinity on the test and just let it chooch. ns are huge, but i think processing each line is linear time, so i don't think we're looking at like... end of the universe kind of timelines here. but we'll see how long it takes. i think the real problem is we're going to be creating a bunch of maps with hundreds of millions of entries. Map access is O(log n) but with that amount of entries, that's still catastrophically slow. (edit: ran for at least 30 minutes, killing it.)

this is a good opportunity for the year's first benchmark test, i guess.

so the trick, instead, is going to be some way to translate those mappings into a
function which spits out the right number given an input.

so, given a source, i think i'd need to check if it's in any of the ranges given in the mappings, and then apply some transformation to the source.

Maybe there's another trick by utilizing only the known necessary ranges. we could
determine them for each step. so basically check the input seeds against the ranges for the seed-to-soil map and figure out which values would get handed to the soil-to-fertilizer map and so forth. i think we still have to solve basically the same problem to do that though, so maybe not much juice for the squeeze there.

skimming the code, i think that the process_input function and the part_1 logic are similar. but create_mapping has to be different, and probably get_destination changes as well to take advantage of that.

---

ok, got part 1. pretty happy with this solution. it may be slightly overly clever with creating a function to act as the "value" for each range as a key. you could probably just as easily find the correct range for the destination, and then use the source range start and end to figure out the answer. but this feels pretty neat, so works for me.

---

Part 2 - agh, wastl, you bastard.

So this is the same _kind_ of issue, but ... harder. We won't be able to work with individual seed numbers, since there will be over a billion of them. Even if it only takes like a microsecond per check, that's still 15-20 minutes of run time.

So one thought I had is that we only really need to check the lowest number in each source range. Any number higher than that lowest number would get a higher number in its destination range. UNLESS (and here's the tricky bit) the range of seeds corresponds to multiple ranges of destinations. And there's an additional complication, which is that there may be numbers in a range of seeds which don't correspond to any destination range, and one of those may be the lowest number.

So I guess what we'd need to do is ... for each range of input source numbers, figure out which of the source ranges in the mapping it could cover. then the lowest number in any of those ranges would be the input to the next part? but the problem there is that you would lose information on each round. so i guess the input to each round has to be a set of ranges. and any given starting range may break down into multiple ranges, and also into single values. UGH

---

ok so i walked away and did some thinkin

so what if instead of "get locations" we had a "get destination ranges"

we pass a set of ranges into one of the mapping
and out comes a set of ranges which can go into the next mapping.

for each range we need to figure out the set of destination ranges

so let's call range 1 a..b and range 2 x..y

easy case - a >= x and b <= y. a is fully inside b - destintions = a..b

but if a >= x and b >= y then only part of a is inside y - a..y
same idea for the other "overlap", you get x..b

so then once you get for example x..b of those you need to figure out the mapping for a..x. similar process.

at the end you may be left with numbers outside any range, gotta think about what to do with those.

---

ok, it's done. the code is pretty gnarly, but i'm honestly not sure how it could be made
less complicated - i think the problem is just complex! thank god for elixir's pattern matching
and range handling, because the amount of manual labor that would have been added if not
for those two things might have just made me give up.

overall, despite being very and complicated, i'm happy with my solution. it runs really fast so that's cool. and I think the recursion in destination_ranges was probably the best way
to solve the problem, even though the internals of the function are the most complicated part
of the code. i also still like the clever "map a range to a function" solution for part 1.

two things that would be interesting to try - see if there's a way to solve both parts with the part 2 input (which would reduce the amount of code pretty substantially). this feels like it might be more trouble than it's worth though. since you actually care about a specific value in a range for part 1, you'd have to maintain offsets through the whole pipeline to get it out the end.

another interesting thing would be to run benchmarks with the initial naive solution and the "good" one. but honestly i've already spent way too much time on this problem, so on to the next one.

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