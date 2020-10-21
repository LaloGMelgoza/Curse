/*   consult('/Users/lalogonzalez/repos/Curse/curse.pl').   */

:- dynamic i_am_at/1, at/2, holding/1, talked/1, examined/1, time/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).
:- discontiguous talkable/1.
:- discontiguous in/2.
:- discontiguous requires/2.

/* Starting position */
 
i_am_at(church_plaza).


/* Definition of world map */

path(church_plaza, s, main_plaza).
path(main_plaza, n, church_plaza).

path(church_plaza, n, church_altar_room).
path(church_altar_room, s, church_plaza).

path(church_altar_room, w, church_study).
path(church_study, e, church_altar_room).

path(church_altar_room, e, church_basement).
path(church_basement, w, church_altar_room).

path(church_plaza, w, your_house).
path(your_house, e, church_plaza).

path(main_plaza, e, inn).
path(inn, w, main_plaza).

path(main_plaza, s, swamp).
path(swamp, n, main_plaza).

path(swamp, e, witch_cabin).
path(witch_cabin, w, swamp).

path(swamp, w, bald_cypress_tree_family).
path(bald_cypress_tree_family, e, swamp).


/* Definition of objects starting position */

at(beggar, main_plaza).
at(bartender, inn).
at(witch, witch_cabin).
at(bark_piece, bald_cypress_tree_family).
at(house_key, church_study).
at(prayer_book, your_house).
at(vampire, church_basement).


/* Definition of people objects and objects revealed by them with talk() */

talkable(beggar).
in(beggar, compass).
requires(compass, beer_tankard).

talkable(bartender).
in(bartender, beer_tankard).

talkable(witch).
in(witch, tonic).
requires(tonic, bark_piece).


/* Different scenarios that can happen when taking something */

take(X) :-
        holding(X),
        write('You are already holding that'),
        !, nl.

take(X) :-
        requires(X,Y), \+ holding(Y),
        write('You can''t take the '), write(X), write(' yet. You need to find '), write(Y), write(' first.'),
        !, nl.

take(X) :-
        talkable(X),
        write('Umm... you cannot take people. Remember what happened to the last priest who tried to do that...'), !, nl.

take(compass) :-
        i_am_at(Place),
        at(compass, Place),
        retract(at(compass, Place)),
        assert(holding(compass)),
        drop(beer_tankard),
        write('Exchanged the beer tankard for the compass'),
        !, nl.

take(tonic) :-
        i_am_at(Place),
        at(tonic, Place),
        retract(at(tonic, Place)),
        assert(holding(tonic)),
        drop(bark_piece),
        write('Added the bald cypress tree bark into the mix to complete the tonic'),
        !, nl.

take(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(holding(X)),
        write('Took the '), write(X),
        !, nl.

take(_) :-
        write('I don''t see it here.'),
        nl.


drop(X) :-
        holding(X),
        i_am_at(Place),
        retract(holding(X)),
        assert(at(X, Place)),
        write('Dropped the '), write(X),
        !, nl.

drop(_) :-
        write('You aren''t holding it!'),
        nl.


i :- write('Inventory:'), nl,
     holding(X),
     write(X), nl,
     fail.

i :- \+ holding(_), write('Your inventory is empty.'), !, nl.

i.


/* Defines start of game */

start :-
        controls,
        introduction,
        look.


controls :-
        nl,
        write('-------------------------------------'), nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.             -- to start the game.'), nl,
        write('n.  s.  e.  w.     -- to move in given direction.'), nl,
        write('take(Object).      -- to pick up an object.'), nl,
        /*write('drop(Object).      -- to put down an object.'), nl,
        write('i.                 -- to check your inventory.'), nl,*/
        write('talk(Person)    -- to talk to people.'), nl,
        write('look.              -- to look around you again.'), nl,
        write('controls.      -- to show controls again.'), nl,
        write('halt.              -- to end game and quit.'), nl,
        write('-------------------------------------'), nl,
        nl.

introduction :-
        nl,
        write('The year is 1310. You are the town of Eadburgh''s local priest.'), nl, %sleep(2),
        write('Lately, people have been disappearing, there have been rumors of a'), nl, %sleep(2),
        write('vampiric curse menacing the town. You can trust no one.'), nl, nl, %sleep(4),

        write('The time is late at night when you hear someone knocking at your door...'), nl, %sleep(2),
        write('asking for help. As the priest, you cannot deny help to townspeople.'), nl, %sleep(2),
        write('You open the door to find a cloacked figure who suddenly attacks you,'), nl, %sleep(2),
        write('too fast to even try to defend yourself!'), nl, nl, %sleep(4),

        write('You black out...'), nl, nl, %sleep(5),

        write('You wake, lying on the floor before your church. You feel an acute pain'), nl, %sleep(2),
        write('to the neck. You touch it with your fingers to discover you have been'), nl, %sleep(2),
        write('bitten! "I''ve been cursed with vampirism", you figure, "I''ve got to'), nl, %sleep(2),
        write('find a way to revert the curse, and kill whatever thing cursed me." '), nl, %sleep(2),
        write('-------------------------------------'), nl, %%sleep(5),
        nl.


/* Predicate that reveals desctiption of current position and people/objects found there. */

look :-
        i_am_at(Place),
        describe(Place),
        nl,
        print_objects_found_in(Place),
        nl,
        possible_ways(Place).


print_objects_found_in(Place) :-
        at(X, Place),
        write('There is a '), write(X), write(' here.'), nl,
        fail.
        
print_objects_found_in(_).


/* Talked to people drop other objects. Without conversation, objects dont show up upon look */

talk(beggar) :-
        talkable(beggar),
        assert(talked(beggar)),
        in(beggar, Y),
        write('Beggar: What''s the matter Reverend? Can''t go inside your church?'), nl, %sleep(2),
        write('I''ll tell you what. I heard an old hag lives in the swamp south to Eadburgh.'), nl, %sleep(2),
        write('They call her Old Jezabelle. She might be able to help you with your... situation. '), nl, %sleep(2),
        write('Oh but you won''t get there so easily. You will need a compass to traverse those wetlands.'), nl, %sleep(2),
        write('Luckily for you, I''ve got one right here. Sure you can have it...'), nl, %sleep(2),
        write('What? You thought I would give it away so easily? Gwahaha'), nl, %sleep(2),
        write('FOOD? CLOTHES? Do I look like a charity case to you?'), nl, %sleep(2),
        write('BEER IS WHAT I WANT! Go get me some delicious beer from the Inn and I''ll give you my compass.'), nl, nl, %sleep(2),
        write('The beggar offered a '), write(Y), write(' for you to take in exchange for some beer.'), nl,
        i_am_at(Place),
        assert(at(Y,Place)),
        !, nl.

talk(witch) :-
        talkable(witch),
        assert(talked(witch)),
        in(witch, Y),
        write('Old Jezabel: I''m a witch, but that you might have already figured, old cabin in the swamp and all heheh.'), nl, %sleep(2),
        write('Cursed, huh? Heheheh, how careless of you!. So you want to know how to get rid of that curse, yes?'), nl, %sleep(2),
        write('Heheheh...'), nl, %sleep(2),
        write('Every now and then, some pesky traveler comes to Old Jezabelle, looking for something great she can do for them.'), nl, %sleep(2),
        write('Some come searching for unnatural love, a treacherous bond if you ask me.'), nl, %sleep(2),
        write('Some others come seeking revenge on their most hated ones.'), nl, nl, %sleep(2),
        write('What now? A priest, coming to such an godless being, to recover his hollyness...'), nl, %sleep(2),
        write('Heheheh, listen. Old Jezabelle will help you, but just because she enjoys the irony of the situation.'), nl, %sleep(2),
        write('Old Jezabelle cannot lift the curse, but she can prepare a tonic that will...'), nl, %sleep(2),
        write('shall we say, camouflage your current state from the eyes of your God.'), nl, %sleep(2),
        write('By drinking the tonic, you should be able to go inside the church and slay the thing that laid that curse upon you.'), nl, %sleep(2),
        write('Yes, doing this should revert the curse permanently.'), nl, nl, %sleep(2),
        write('Funny coincidence heheheh, Old Jezabelle was just finishing a tonic like the one she''s telling you about.'), nl, %sleep(2),
        write('The only ingredient missing is a piece of bald cypress tree bark. Get me some of that to complete the tonic, and you are free to take it.'), nl, nl, %sleep(2),
        write('Old Jezabelle dropped the '), write(Y), write(' for you to take once you get the missing ingredient.'), nl,
        i_am_at(Place),
        assert(at(Y,Place)),
        !, nl.

talk(bartender) :-
        talkable(bartender),
        assert(talked(bartender)),
        in(bartender, Y),
        write('Bartender: Evenin'' Reverend! Woah, you''re lookin'' a wee bit under the weather tonight.'), nl, %sleep(2),
        write('Will you be having the usual? Red wine and the body of the Lord?'), nl, %sleep(2),
        write('Beer? Didn''t even know you liked it!'), nl, %sleep(2),
        write('Anyway, this one''s on the house! Sure hope it makes you feel better! Or at least look better...'), nl, %sleep(2),
        write('Bartender placed a '), write(Y), write(' on the counter for you to take.'), nl,
        i_am_at(Place),
        assert(at(Y,Place)),
        !, nl.

talk(X) :-
        talkable(X),
        assert(talked(X)),
        in(X, Y),
        write('The '), write(X), write(' dropped a '), write(Y), write(' for you to take!'), nl,
        i_am_at(Place),
        assert(at(Y,Place)),
        !, nl.

talk(X) :-
        talkable(X),
        assert(talked(X)),
        write('There''s nothing special about '), write(X), write('.'), !, nl.

talk(_) :-
        write('You can''t talk to inanimate objects.'), nl.


/* These rules define the direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).


/* This rule tells how to move in a given direction. */

go(Direction) :-
        i_am_at(Here), nl,
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        !, look.

go(_) :-
        write('You cannot go that way.').


/* These rules print descriptions about the rooms that make up the world. ***** STILL NEED TO WRITE MORE INTERESTING DESCRIPTIONS*/

describe(church_plaza) :-
        write('You are in the church plaza.'), nl,
        write('You can hear violent noises coming from inside the church.'), nl,
        write('Could the thing that attacked you be hiding inside?'), nl.

describe(main_plaza) :-
        write('You are in the main plaza'), nl.
        

describe(your_house) :-
        write('You are home.'), nl.
        

describe(inn) :-
        write('You are at the inn.'), nl.

describe(swamp) :- 
        write('You are at the swamp.'), nl.

describe(witch_cabin) :-
        write('You are inside the cabin.'), nl.

describe(bald_cypress_tree_family) :-
        write('You are surrounded by Bald Cypress trees.'), nl.

describe(church_altar_room) :-
        write('You are in the church''s altar room.'), nl.

describe(church_study) :-
        write('You are in your study.'), nl.

describe(church_basement) :-
        write('You are in the church basement.'), nl.


/* Defines the possible paths to take from each location */


possible_ways(church_plaza) :-
        write('To the north is the church.'), nl,
        write('To the south is the main plaza.'), nl,
        write('To the west is your house.'), nl,
        write('-------------------------------------').

possible_ways(main_plaza) :-
        write('To the north is the church plaza.'), nl,
        write('To the south is the town''s exit. Outside there is a path that leads to the swamp'), nl,
        write('To the east is the inn.'), nl,
        write('-------------------------------------').

possible_ways(your_house) :-
        write('To the east is the exit to church plaza.'), nl,
        write('-------------------------------------').

possible_ways(inn) :-
        write('To the west is the exit to main plaza.'), nl,
        write('-------------------------------------').

possible_ways(swamp) :-
        write('To the north is the path back to Eadburgh''s main plaza.'), nl,
        write('To the east you see an old cabin, almost consumed by the swamp''s vegetation.'), nl,
        write('To the west is a Bald Cypress tree family.'), nl,
        write('-------------------------------------').        

possible_ways(witch_cabin) :-
        write('To the west is the exit back to the swamp.'), nl,
        write('-------------------------------------').        

possible_ways(bald_cypress_tree_family) :-
        write('To the east is the exit back to the swamp.'), nl,
        write('-------------------------------------').

possible_ways(church_altar_room) :-
        write('To the south is the exit to church plaza.'), nl,
        write('To the east are the stair to descend to the basement.'), nl,
        write('To the west is your study.'), nl,
        write('-------------------------------------').

possible_ways(church_study) :-
        write('To the east is the exit to the altar room.'), nl,
        write('-------------------------------------').

possible_ways(church_basement) :-
        write('To the east are the stairs to exit back to the altar room.'), nl,
        write('-------------------------------------').        



