# notes

## day 25
we've got it!

this was a pretty cool if straightforward problem. i expected to have to get clever, nice surprise that it could be easily bruteforced. the surprise for part 2 was also nice :)

one neat thing is i got to use the idiom for an 'infinite loop' - running Enum.reduce_while with Stream.iterate as the input.

## day 23
almost there.

i probably should have guessed that this one would do some kinda thing to make my fairly naive part 1 solution obsolete. i wrote the functions for performing each cycle in a bit of a brutish way, just rotating the list around so that the current and destination cups were at the front. this made insertion logic easier at the cost of being completely untenable for a million element list - quick math estimated a 2 week runtime for the 10 million cycles. obviously not gonna work.

the sorta first thing that came to mind is a circular linked list, but that only solves the problem of the case where you're trying to pull and add elements at the end of the list. doesn't really solve the access time problem. i had to dig around on reddit to get the hint i needed - use a map where each key points to it's next neighbor. this makes both removal of the three cups and the reinsertion logic actually really simple.

another thing - dont print the entire list on every cycle. slows things down.

## day 24
pretty happy with this one, [this article](https://www.redblobgames.com/grids/hexagons/) from redblob games made the whole thing fairly straightforward. i opted to go with the cubic coordinates approach which seems to be the easiest to manage with a map. o ran into an issue early on with an extra line in the input that was causing an extra flip. in part 2, due to the update rules, you potentially need to simulate cells which are not yet in the map. my first approach to this was just to expand the grid outward in all directions. however this runs into problems due to exponential growth. the trick was to realize that only black cells and their neighbors could potentially update, which allowed me to eschew the grid expansion logic and just work through the comparatively much shorter list of black cells. this version of the alg runs in a reasonable time.

## day 21
well that wasn't nearly as bad as I thought it would be, pretty straightforward process of elimination kinda problem. once i had the code necessary to solve part 1, all that was left was to tweak the process of elimination function from day 16.

## day 22
after the amount of time day 20 took i wanted to get a quick win in today (HA!). this one looked a bit easier than day 21.

for the most part this was fairly easy - the conditions of the recursive function were laid out well enough in the puzzle. there was one minor detail which took some digging to find - where i was slicing the deck for the subgames, i was initially doing 0..card_num. you need to do 0..card_num-1 if you want card_num cards. that's a pretty picky little detail so i don't feel bad for getting hung up on it. apart from that i think it's fair to say i've gotten better at writing recursion, both these functions were pretty simple enough to write.

## day 20
well, i feel pretty proud to have figured this out but damn was this a huge problem. how people can code something like this within an hour or two after the puzzle is released is beyond me. this thing just had a way of spawning off sub problems. I wrote almost 1000 lines of code between test and implementation to figure this out.

it's one of those problems where the statement of what you have to do is easy. find the tiles that have matching edges, lay them out into an image, then scan them for a pattern. but man there's a lot of pieces involved in that seemingly straightforward task.

i'm well beyond worry about whether the code is good. and after tackling this one i _hope_ the last 5 will feel a little less daunting. 5 more to go.


## day 19
didn't feel like writing a bunch of parsing code after yesterday so I just transformed the rules in the input into proper elixir code with Vim. Brutish maybe, but hey.

ugh. what a mess. thank god for recursive regex. that was the main trick, not even sure how i'd have tried to handle it if i hadn't seen some folks on reddit talking about recursive regex. thank god that elixir uses PCRE. thank god named captures are supported. thank god this puzzle is over. some of the ugliest code i've written thus far in this one.

## day 18
Choosing to do this with leex and yecc probably didn't save me any effort, but it feels pretty cool. Couldn't have done it without these posts:

https://andrealeopardi.com/posts/tokenizing-and-parsing-in-elixir-using-leex-and-yecc/
https://pl-rants.net/posts/leex-yecc-in-elixir/

I initially took an approach where I used the parser to transform the input into a valid elixir list. this was kinda a neat way to go for the first section, writing a recursive evaluator was pretty straightforward. But the approach broke down for the second half, i didn't have a good way to change precedence.

the approach outlined in the second article results in a tree structure, which looked scary at first but turns out to be really easy to write recursion for, especially with pattern matching. the evaluate_tree function is much simpler imo than the evaluate function (although they really work about the same way). the nicest thing about the tree structure is that the same interpreter function works for the output of two different parsers. this was overall a pretty cool and educational problem.

## day 17
i liked this one, and i'm pretty happy with my code. two things that were nice here: using a map instead of trying to construct a 4d array, and having elixir's super powerful for comprehension for generating the 4d coordinates (and the 3d in the first part). because of these two things changing the code from 3d to 4d took all of 10 minutes.

## day 16
this one was kinda a drag. i got to the point where I could do the process of elimination manually. i think writing the code would be straightforward enough but idk, may not bother. got the right answer, anyway.

next day edit: went back and wrote the process of elimination code, suprisingly straightforward. the top level algorithm for part_2 is pretty simple. determine_field_names contains some complexity too, but really pretty reasonable. made easier by the fact that at each stage of the process there is only one possibility. i had initially thought i might have to do some sort of recursive backtracking by guessing at points where things were ambiguous. apart from that though the majority of the code i wrote was for parsing the input and then extracting data from the resulting object. I wonder if better organization of that object could be done, getting the data I wanted out of it never felt as easy as it could have. overall though now that i did this programmatically i feel pretty good about it.

## day 15
bit of a pain, this one. the major optimization trick is that you only need to store the last time that the number was said. i don't love this code, probably be utterly incomprehensible to me a few days from now. the algorithm in part2 runs substantially faster than the part1 one, and the major time sink is the part where we generate a map with all 30000000 indices, because we need some default value ...

as I wrote that I realized we didn't need to initialize all the indices since we started writing the turn that _last_ was spoken at the end of the loop. taking that initialization out got me to around 20 seconds. For the brute force solution, i'm happy with this. there's probably some math bullshit i could have done but close enough.

## day 14
not too bad, and i have to say i think the recursive solution for finding the different memory locations is a pretty good one. feel like maybe i'm getting a hair better at recursion so that's nice. maybe some slop in the code, but whatever, onward and upward

## day 13
holy shit goddamn that was a rough one, extremely happy to be able to call it done. i think there's some weirdness in the code but if i look at it any longer my brain will melt. i hope day 14 is a straightforward one. woof.

## day 12
pretty straightforward one, probably could have dried it a bit but oh well. good enough!

## day 11
this one took more effort than i thought it would from reading the description, but it turns out that there are some nice things about using a map instead of a 2d array. one neat thing was no writing bounds checking code, just check if the tuple key is in the map. curious about efficiency of something like that though. anyway i'm happy with this overall, it's a bit verbose and there are definitely some optimizations to be made but hey, it works.


## day 10
this one was tough. spent a lot more time than was necessary on the first part. it's funny because looking back i was so close to realizing that i could just sort the input.

i'm not sure i would have gotten the second part if not for a math tip from a friend - the key phrase of which was "you only have options when there's a difference of one". this was the key realization - anywhere in the chain of differences where there's a 3, there was only one choice to make there. likewise there was only one choice if [ 1 ]. But if you have a few 1 differences in a row you have more options, and these multiplicatively affect the total possible orderings.

## day 9
pretty happy that I could reuse day 1 code for the first part. Enum module and some nice pattern matching made the rest easy.

Part 2 is a little trickier, gonna try to brute force it. One observation - I will not need to chunk_every any higher than 617, because that's the line where the target number occurs, and everything after it appears to be larger (though they are not necessarily in ascending order).

welp, brute force worked. took a few seconds to run but ah well, good enough.

## day 8
not sure if this code is _good_ but by god it works and that's something. I'm happy to have come up with a solution for part 2 which didn't require me to trace any assembly! fun little problem to kinda brute force that out.

## day 7
having a good graph lib saved me here. friggin' recursion, man. at the end of writing it it makes such perfect sense but figuring out how to express it can be rough. took 2 or 3 runs at it before i figured out what i needed for part 2. overall happy with the code though at the end, the majority of code that had to be written was the string processing code and elixir makes that kind of stuff so easy.

## day 6
once again elixir made life easy, there was basically nothing i needed to do here that wasn't part of the standard library. whole thing is like 20 lines of code, feel great about this one.

## day 5
man elixir made this one easy, really happy with this solution.

## day 4
this seems reasonably good, except maybe in one place, which is the hgt_valid? function. not sure of a prettier way to handle that mess of a requirement though.

## day 3
reasonably happy with this one. figuring out how to translate the sorta typical 2d array reading and writing into elixir was interesting. Ultimately I think I chose a good approach that avoided having to do anything too weird.

I feel good also about how I handled the sled path stuff, it's cool to define it lazily with a stream and then use take_while to get the relevant pieces.

https://elixirforum.com/t/how-to-make-proper-two-dimensional-data-structures-in-elixir/872
https://blog.danielberkompas.com/2016/04/23/multidimensional-arrays-in-elixir/



## day 2
bit happier with this code. Elixir's pattern matching and good string library made this a lot less painful than it might be in other languages. probably a cleverer way to do the xor stuff at the end of the function for the second part.

## day 1

i think this code is kinda awful but oh well, that's the point of this exercise. found another solution in elixir and picked up a few ideas.

Enum.find_value is interesting, it takes a function. it returns the _value_ of the first time the function was invoked and that value was truthy. whereas find just returns the first element of the list for which _f_ was truthy.

Enum.reduce_while is also interesting, it has a mechanism for breaking out of the execution - it goes until _fun_ returns {:halt, term}.

Lastly a cool pattern matching trick - if you are writing a recursive function for chewing through a list, one of the signatures can be like this:
```elixir
def do_thing([front | rest], etc) do
```
this handles pulling the front element off the list, and then you can just pass `rest` to the recursive call to keep working through the list.