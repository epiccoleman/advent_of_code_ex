## notes - 2023

## day 1

this was a surprisingly hard day 1 puzzle, took me 30-40 minutes to get it done. i think the approach i chose was good though, since i didn't get hung up on the "overlapping numbers" issue that apparently tripped some other people up.

just for fun, i refactored it down to be a little "tighter" - although honestly, this refactor is optimizing for cleverness over readability, and it's entirely unnecessary - especially DRYing the "part" function.

I think I could get it down even further - could basically define everything in line, but it would start requiring me to delete tests, so I'm going to leave it here. It might also be possible to do some regex voodoo that would eliminate the need for reversing the string, which could further condense the need for "first" and "last" functions, and let me just pass regexes, but that's getting severely stupid at that point.