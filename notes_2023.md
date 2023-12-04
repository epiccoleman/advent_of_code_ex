## notes - 2023


## day 2
this one didn't feel especially difficult, but there was a lot of work around processing the input into a usable format. i guess the data structure i landed on was decent because writing the actual "business logic" of the puzzle didn't take all that long once i'd done that.

i went a little "extra mile" in terms of testing here, and i will say that that turned out _not_ to help me in one place - I had forgotten to put "ors" between the clauses in &game_within_limit, but my test cases didn't catch that problem. relatively easy to find and fix but feels like one of those things where i could easily have torn my hair out for an hour before noticing those simple missing "ors".

one way that this might be slightly improved would be to define a struct for "pulls" formally and to create them using a "new" function to handle the defaults. as it stands, some of this code only works because i know that i'm not going to make pulls in any place other than "process_pull". This is pretty minor and totally fine for AoC, but there's some instinct that fires off when I do something like that, that somewhere down the line some dummy is going to create a pull that violates my assumptions. (that dummy would be me, of course). since I'll probably never re-use this code that's a bit of a misfire of the code smell circuits, but still, it's there.

## day 1

this was a surprisingly hard day 1 puzzle, took me 30-40 minutes to get it done. i think the approach i chose was good though, since i didn't get hung up on the "overlapping numbers" issue that apparently tripped some other people up.

just for fun, i refactored it down to be a little "tighter" - although honestly, this refactor is optimizing for cleverness over readability, and it's entirely unnecessary - especially DRYing the "part" function.

I think I could get it down even further - could basically define everything in line, but it would start requiring me to delete tests, so I'm going to leave it here. It might also be possible to do some regex voodoo that would eliminate the need for reversing the string, which could further condense the need for "first" and "last" functions, and let me just pass regexes, but that's getting severely stupid at that point.