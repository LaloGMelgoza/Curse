/*   /Users/lalogonzalez/Desktop/samples/curse.pl   */

:- dynamic i_am_at/1, at/2, holding/1, examined/1, time/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

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
at(basement_key, church_study).
at(bark_piece, bald_cypress_tree_family).


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
        write('drop(Object).      -- to put down an object.'), nl,
        write('examine(Object)    -- to examine an object.'), nl,
        write('i.                 -- to check your inventory.'), nl,
        write('look.              -- to look around you again.'), nl,
        write('controls.      -- to see this message again.'), nl,
        write('halt.              -- to end the game and quit.'), nl,
        write('-------------------------------------'), nl,
        nl.

introduction :-
        nl,
        write('The year is 1310. You are the town of Eadburgh''s local priest.'), nl,
        write('Lately, people have been disappearing, there have been rumors of a'), nl,
        write('vampiric curse menacing the town. You can trust no one.'), nl, nl,

        write('The time is late at night when you hear someone knocking at your door...'), nl,
        write('asking for help. As the priest, you cannot deny help to townspeople.'), nl,
        write('You open the door to find a cloacked figure who suddenly attacks you,'), nl,
        write('too fast to even try to defend yourself!'), nl, nl,

        write('You black out...'), nl, nl,

        write('You wake, lying on the floor before your church. You feel an acute pain'), nl,
        write('to the neck. You feel it with your fingers to discover you have been'), nl,
        write('bitten! "I have been cursed with vampirism", you figure, "I''ve got to'), nl,
        write('find a way to revert the curse, and kill whatever thing cursed me." '), nl,
        write('-------------------------------------'), nl,
        nl.


look :-
        i_am_at(Place),
        describe(Place),
        nl,
        notice_objects_at(Place),
        nl.


notice_objects_at(Place) :-
        at(X, Place),
        write('There is a '), write(X), write(' here.'), nl,
        fail.
        
notice_objects_at(_).



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



/* These rules describe the rooms that make up the world. */

describe(church_plaza) :-
        write('You are in the church plaza.'), nl,
        write('You can hear violent noises coming from inside the church.'), nl, nl,
        write('To the north is the church.'), nl,
        write('To the south is the main plaza.'), nl,
        write('To the west is your house.'),
        nl.

describe(main_plaza) :-
        write('You are in the main plaza'), nl,
        write('To the north is the church plaza.'), nl,
        write('To the south is the town''s exit. Outside there is a path that leads to the swamp'), nl,
        write('To the east is the inn.'),
        nl.

describe(church_altar_room) :-
        write('You are in the church''s altar room.'), nl,
        write('To the south is the exit to church plaza.'), nl,
        write('To the east are the stair to descend to the basement.'), nl,
        write('To the west is your study.'),
        nl.

describe(church_study) :-
        write('You are in your study.'), nl,
        write('To the east is the exit to the altar room.'),
        nl.

describe(church_basement) :-
        write('You are in the church basement.'), nl,
        write('To the east are the stairs to exit back to the altar room.'),
        nl.

describe(your_house) :-
        write('You are home.'), nl,
        write('To the east is the exit to church plaza.'),
        nl.

describe(inn) :-
        write('You are at the inn.'), nl,
        write('To the west is the exit to main plaza.'),
        nl.

describe(swamp) :-
        write('You are at the swamp.'), nl,
        write('To the north is the path back to Eadburgh''s main plaza.'), nl,
        write('To the east you see an old cabin, almost consumed by the swamp''s vegetation.'), nl,
        write('To the west is a Bald Cypress tree family.'),
        nl.

describe(witch_cabin) :-
        write('You are inside the witch''s cabin. There seems to be no one home.'), nl,
        write('To the west is the exit back to the swamp.'),
        nl.

describe(bald_cypress_tree_family) :-
        write('You are surrounded by Bald Cypress trees.'), nl,
        write('To the east is the exit back to the swamp.'),
        nl.