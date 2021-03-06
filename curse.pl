
/*  
*	Copyright (C) 2020  Eduardo Gonzalez Melgoza
*
*   This program is free software: you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation, either version 3 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

%   consult('/Users/lalogonzalez/repos/Curse/curse.pl').

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                            %
%    %%%%%  %    %  %%%%%    %%%%%  %%%%%%   %
%   %       %    %  %    %  %       %        %
%   %       %    %  %%%%%   %%%%%   %%%%%%   %
%   %       %    %  %  %         %  %        %
%    %%%%%   %%%%   %   %   %%%%%   %%%%%%   %
%                                            %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 



:- dynamic actual_position/1, at/2, holding/1, talked/1, examined/1, time/1.
:- retractall(at(_, _)), retractall(actual_position(_)).
:- discontiguous isNPC/1, in/2, requires/2.

/* Starting position */
 
actual_position(church_plaza).


/* Definition of world map. Some rooms are restricted until certain condition is met */

path(church_plaza, s, main_plaza).
path(main_plaza, n, church_plaza).

path(church_plaza, n, church_altar_room) :- holding(doll).
path(church_plaza, n, church_altar_room) :-
        write('Are you crazy? Attempting to enter a holy place with a vampiric curse laid upon yourself.'), nl,
        write('You would burn whole!'), nl,
        !, fail.
path(church_altar_room, s, church_plaza).

path(church_altar_room, w, church_study).
path(church_study, e, church_altar_room).

path(church_altar_room, e, church_basement) :- holding(prayer_book), holding(cross).
path(church_altar_room, e, church_basement) :- holding(prayer_book),
	write("''The prayer book alone will do no good, I need my cross too.''"), nl,
	!, fail.
path(church_altar_room, e, church_basement) :- holding(cross),
	write("''The cross alone will do no good, I need my prayer book too.''"), nl,
	!, fail.
path(church_altar_room, e, church_basement) :-
        write("''I can't just go kill a vampire empty-handed. I should get both my cross and prayer book from home.'' "), nl,
        !, fail.

path(church_plaza, w, your_house) :-
        holding(house_key),
        write('Used your house key to unlock the door.'), nl.
path(church_plaza, w, your_house) :-
        write('"It''s locked. I left the key in my study in the left wing of the church.'), nl,
        write('I need to find a way to get inside..."'), nl,
        !, fail.
path(your_house, e, church_plaza).

path(main_plaza, e, inn).
path(inn, w, main_plaza).

path(main_plaza, s, swamp) :-
        holding(compass),
        write('Used the compass to move through the swamp.'), nl.
path(main_plaza, s, swamp) :-
        write("''The swamp is a dangerous area to navigate without something or someone to guide me through it.'' "), nl,
        !, fail.
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
at(cross, your_house).
at(vampire, church_basement).


/* Definition of people objects and objects revealed by them with talk() */

isNPC(beggar).
in(beggar, compass).
requires(compass, beer_tankard).

isNPC(bartender).
in(bartender, beer_tankard).

isNPC(witch).
in(witch, doll).
requires(doll, bark_piece).

isNPC(vampire).


/* Different scenarios that can happen when taking something */

take(X) :-
        holding(X),
        write('You are already holding that'),
        !, nl.

take(X) :-
        requires(X,Y), \+ holding(Y),
        write('You can''t take the '), write(X), write(' yet. You need to find a '), write(Y), write(' first.'),
        !, nl.

take(X) :-
        isNPC(X),
        write('Umm... you cannot take people. Remember what happened to the last priest who tried to do that...'), !, nl.

take(compass) :-
        actual_position(Place),
        at(compass, Place),
        retract(at(compass, Place)),
        assert(holding(compass)),
        trade(beer_tankard),
        !, nl.

take(doll) :-
        actual_position(Place),
        at(doll, Place),
        retract(at(doll, Place)),
        assert(holding(doll)),
        trade(bark_piece),
        !, nl.

take(X) :-
        actual_position(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(holding(X)),
        write('Took the '), write(X),
        !, nl.

take(_) :-
        write('I don''t see it here.'),
        nl.


/* Definition of different drop() scenarios */

drop(X) :-
        holding(X),
        actual_position(Place),
        retract(holding(X)),
        assert(at(X, Place)),
        write('Dropped the '), write(X),
        !, nl.

drop(_) :-
        write('You aren''t holding it!'),
        nl.

trade(beer_tankard) :-
        holding(beer_tankard),
        %actual_position(Place),
        retract(holding(beer_tankard)),
        assert(at(beer_tankard, limbo)),
        write('Beggar: Took you long enough. Yes yes take it, just give me my beer.'), nl, nl, sleep(2),

        write('Handed the beer_tankard to the beggar.'), nl,
        write('Took the compass.'),
        !, nl.

trade(bark_piece) :-
        holding(bark_piece),
        %actual_position(Place),
        retract(holding(bark_piece)),
        assert(at(bark_piece, limbo)),
        assert(at(witch, limbo)),
        write('Old Jezabelle: You found it! Hand me the doll so I can cover it with the bark to have it done.'), nl,
        write('You are free to take it. Good luck with your intent Old Jezabelle wishes to you, heheh...'), nl, nl, sleep(2),

        write('The doll is complete and working now.'), nl,
        write('Took the doll.'),
        !, nl.


inventory :- write('Inventory:'), nl,
     holding(X),
     write(X), nl,
     fail.

inventory :- \+ holding(_), write('Your inventory is empty.'), !, nl.

inventory.


/* Defines start of game */

start :-
        controls, sleep(2),
        introduction,
        look.


controls :-
        nl,
        write('-------------------------------------'), nl,
        write('Enter commands using standard Prolog syntax.'), nl, nl,
        write('start.                    to start the game.'), nl,
        write('n.  s.  e.  w.          to move in given direction.'), nl,
        write('take(Object).        to pick up an object.'), nl,
        write('talk(Character).    to talk to other characters.'), nl,
        %write('drop(Object).        to put down an object.'), nl,
        write('inventory.            to check your inventory.'), nl,
        write('look.                    to look around you again.'), nl,
        write('controls.              to show controls again.'), nl,
        write('halt.                     to end game and quit.'), nl,
        write('-------------------------------------'), nl,
        nl.

introduction :-
        nl,
        write('The year is 1310. You are the town of Eadburgh''s local priest.'), nl, sleep(2),
        write('Lately, people have been disappearing, there have been rumors of a'), nl, sleep(2),
        write('vampiric curse menacing the town. You can trust no one.'), nl, nl, sleep(4),

        write('The time is late at night when you hear someone knocking at your door...'), nl, sleep(2),
        write('asking for help. As the priest, you cannot deny help to townspeople.'), nl, sleep(2),
        write('You open the door to find a cloaked figure who suddenly attacks you,'), nl, sleep(2),
        write('too fast to even try to defend yourself!'), nl, nl, sleep(4),

        write('While lying on the floor, you notice the cloaked figure stepping inside the church'), nl, sleep(2),
        write('closing the doors behind it.'), nl, nl, sleep(2),

        write('You black out...'), nl, nl, sleep(5),

        write('You wake, lying on the floor before your church. You feel an acute pain'), nl, sleep(2),
        write('to the neck. You touch it with your fingers to discover you have been'), nl, sleep(2),
        write('bitten! "I''ve been cursed with vampirism", you figure, "I''ve got to'), nl, sleep(2),
        write('find a way to revert the curse, and kill whatever thing cursed me." '), nl, sleep(2),
        write('-------------------------------------'), nl, sleep(6),
        nl.


/* Predicate that reveals desctiption of current position and people/objects found there */

look :-
        actual_position(Place),
        describe(Place),
        nl,
        print_objects_found_in(Place),
        nl,
        possible_ways(Place).

print_objects_found_in(Place) :-
        at(X, Place),
        nl,
        write('There is a '), write(X), write(' here.'), nl,
        fail.
        
print_objects_found_in(_).


/* Talked to people drop other objects. Without conversation, objects dont show up upon look */

talk(beggar) :-
        isNPC(beggar),
        assert(talked(beggar)),
        in(beggar, Y),
        write('Beggar: What''s the matter Reverend? Can''t go inside your church?'), nl, sleep(2),
        write('I''ll tell you what. I heard an old hag lives in the swamp south to Eadburgh.'), nl, sleep(2),
        write('They call her Old Jezabelle. She might be able to help you with your... situation. '), nl, sleep(2),
        write('Oh but you won''t get there so easily. You will need a compass to traverse those wetlands.'), nl, sleep(2),
        write('Luckily for you, I''ve got one right here. Sure you can have it...'), nl, sleep(2),
        write('What? You thought I would give it away so easily? Gwahaha'), nl, sleep(2),
        write('FOOD? CLOTHES? Do I look like a charity case to you?'), nl, sleep(2),
        write('BEER IS WHAT I WANT! Go get me some delicious beer from the Inn and I''ll give you my compass.'), nl, nl, sleep(2),
        write('The beggar offered a '), write(Y), write(' for you to take in exchange for some beer.'), nl,
        actual_position(Place),
        assert(at(Y,Place)),
        !, nl.

talk(witch) :-
        isNPC(witch),
        assert(talked(witch)),
        in(witch, Y),
        write('Old Jezabelle: I''m a witch, but that you might have already figured, old cabin in the swamp and all heheh.'), nl, sleep(2),
        write('Cursed, huh? Heheheh, how careless of you! So you want to know how to get rid of that curse, yes?'), nl, sleep(2),
        write('Heheheh...'), nl, sleep(2),
        write('Every now and then, some pesky traveler comes to Old Jezabelle, looking for something great she can do for them.'), nl, sleep(2),
        write('Some come seeking revenge on their most hated ones.'), nl, sleep(2),
        write('Some others come searching for unnatural love, a treacherous bond if you ask me.'), nl, nl, sleep(2),
        write('What now? A priest, coming to such a godless being, to recover his holiness...'), nl, sleep(2),
        write('Heheheh, listen. Old Jezabelle will help you, but just because she enjoys the irony of the situation.'), nl, sleep(2),
        write('Old Jezabelle cannot lift the curse, but she can make a doll that will...'), nl, sleep(2),
        write('shall we say, camouflage your current state from the eyes of your God.'), nl, sleep(2),
        write('While holding the doll, you should be able to go inside the church and slay the thing that laid that curse upon you.'), nl, sleep(2),
        write('Yes, doing that should revert the curse permanently.'), nl, nl, sleep(2),
        write('Funny coincidence heheheh, Old Jezabelle was just finishing a doll like the one she''s telling you about.'), nl, sleep(2),
        write('The only thing missing is a piece of bald cypress tree bark. Get me some of that to complete the doll, and you are free to take it.'), nl, nl, sleep(2),
        write('Old Jezabelle dropped the '), write(Y), write(' for you to take once you get the missing piece.'), nl,
        actual_position(Place),
        assert(at(Y,Place)),
        !, nl.

talk(bartender) :-
        isNPC(bartender),
        assert(talked(bartender)),
        in(bartender, Y),
        write('Bartender: Evenin'' Reverend! Woah, you''re lookin'' a wee bit under the weather tonight.'), nl, sleep(2),
        write('Will you be having the usual? Red wine and the body of the Lord?'), nl, sleep(3),
        write('Beer? Didn''t even know you liked that!'), nl, sleep(2),
        write('Anyway, this one''s on the house! Sure hope it makes you feel better!'), nl, sleep(2),
        write('Or at least look better...'), nl, nl, sleep(2),
        write('Bartender placed a '), write(Y), write(' on the counter for you to take.'), nl,
        actual_position(Place),
        assert(at(Y,Place)),
        !, nl.

talk(vampire) :-
        isNPC(vampire),
        assert(talked(vampire)),
        write('Vampire: Ahh, you found your way into my hideout.'), nl, sleep(2),
        write('I see you are holding a doll just like mine.'), nl, sleep(2),
        write('To be honest, I thought I killed you during our first encounter.'), nl, sleep(2),
        write('No worries, since the oportunity presented itself to me, this time I shall kill you right.'), nl, nl, sleep(2),
        write('* As you take out your cross and your holy book, the vampire flinches against the wall. *'), nl, sleep(2),
        write('* You pronounce some lines from the book, making the vampire twitch in pain. *'), nl, sleep(2),
        write('* You raise the cross and point it directly in the creature''s direction. *'), nl, sleep(2),
        write('* The vampire''s life force slowly drains until it is completely gone. *'), nl, sleep(2),
        write('* It finally receds into colorless dust, falling onto the cold, stone floor of Eadburgh''s Church *'), nl, sleep(2),
        write('* You got rid of the creature that has been terrorizing Eadburgh. *'), nl, sleep(2),
        write('* You can feel the curse leave your body, as if something got off your shoulders. *'), nl, sleep(5),
        game_over,
        !, nl.

talk(X) :-
        isNPC(X),
        assert(talked(X)),
        in(X, Y),
        write('The '), write(X), write(' dropped a '), write(Y), write(' for you to take!'), nl,
        actual_position(Place),
        assert(at(Y,Place)),
        !, nl.

% This shows up when theres no dialogue given to a isNPC character yet.
talk(X) :-
        isNPC(X),
        assert(talked(X)),
        write('There''s nothing special about '), write(X), write('.'), !, nl.

talk(_) :-
        write('You do realize what you are trying to do right?'), nl.

game_over :-
        nl,
        write('GAME OVER. THANKS FOR PLAYING.'), nl,
        write('please enter the halt command.').


/* Definition of directions for movement */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).


/* Definition of how movement works */

go(Direction) :-
        actual_position(Here), nl,
        path(Here, Direction, There),
        retract(actual_position(Here)),
        assert(actual_position(There)),
        !, look.

go(_) :-
        write('You cannot go that way.').


/* These rules print descriptions about the rooms that make up the world. */

describe(church_plaza) :-
        write('You are in the church plaza.'), nl,
        write('You can hear violent noises coming from inside the church.').

describe(main_plaza) :-
        write('You are in the main plaza,'), nl,
        write('Everything is quiet.').

describe(your_house) :-
        write('You are home.'), nl,
        write('You wish you could just stay and get some rest,'), nl,
        write('but you have to keep going.').

describe(inn) :-
        write('You are at the Inn.'), nl,
        write('You love the welcoming atmosphere this place always has.').

describe(swamp) :- 
        write('You are at the swamp.'), nl,
        write('The moist air is thick here, you find it hard to breathe.').

describe(witch_cabin) :-
        write('You are inside the cabin.'), nl,
        write('The walls are covered with shelves,'), nl,
        write('topped with all sorts of weird stuff like plants and critters.').

describe(bald_cypress_tree_family) :-
        write('You are surrounded by enormous Bald Cypress trees.'), nl,
        write('One of the trees seems to have been struck by lightning,'), nl,
        write('breaking down its trunk into small pieces of bark.').

describe(church_altar_room) :-
        holding(cross),
        holding(prayer_book),
        write('You are in the church''s altar room.'), nl,
        write('The effects of the doll allow you to stay here without burning to death.'), nl,
        write('The violent noises coming from the basement have gone silent...'),
        !.

describe(church_altar_room) :-
        holding(doll),
        write('You are in the church''s altar room.'), nl,
        write('The effects of the doll allow you to stay here without burning to death.'), nl,
        write('You perceive that the violent noises are coming from the church''s basement.'),
        !.

describe(church_altar_room) :-
        write('You are in the church''s altar room.'), nl,
        write('You perceive that the violent noises are coming from the church''s basement.').

describe(church_study) :-
        write('You are in your study.'), nl,
        write('Everything is still the way you left it before being attacked.'), nl,
        write('Lucky that thing did not go into this room.').

describe(church_basement) :-
        write('You are in the church basement.'), nl,
        write('It is freezing in here. You can feel a dense shiver traveling through your body.').


/* Defines the possible paths to take from each location */


possible_ways(church_plaza) :-
        write('- To the north is the church.'), nl,
        write('- To the south is the main plaza.'), nl,
        write('- To the west is your house.'), nl,
        write('-------------------------------------').

possible_ways(main_plaza) :-
        write('- To the north is the church plaza.'), nl,
        write('- To the south is the town''s exit. Following the path leads to the swamp'), nl,
        write('- To the east is the inn.'), nl,
        write('-------------------------------------').

possible_ways(your_house) :-
        write('- To the east is the exit to church plaza.'), nl,
        write('-------------------------------------').

possible_ways(inn) :-
        write('- To the west is the exit to main plaza.'), nl,
        write('-------------------------------------').

possible_ways(swamp) :-
        write('- To the north is the path back to Eadburgh''s main plaza.'), nl,
        write('- To the east you see an old cabin, almost consumed by the swamp''s vegetation.'), nl,
        write('- To the west is a Bald Cypress tree family.'), nl,
        write('-------------------------------------').        

possible_ways(witch_cabin) :-
        write('- To the west is the exit back to the swamp.'), nl,
        write('-------------------------------------').        

possible_ways(bald_cypress_tree_family) :-
        write('- To the east is the exit back to the swamp.'), nl,
        write('-------------------------------------').

possible_ways(church_altar_room) :-
        write('- To the south is the exit to church plaza.'), nl,
        write('- To the east are the stairs to descend to the basement.'), nl,
        write('- To the west is your study.'), nl,
        write('-------------------------------------').

possible_ways(church_study) :-
        write('- To the east is the exit to the altar room.'), nl,
        write('-------------------------------------').



