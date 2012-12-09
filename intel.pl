:- dynamic room_time_no/5, busy_student/2, booked/5.
:- dynamic room_conflict_1/5,module_conflict_1/5,lecturer_conflict_1/5,module_taken_1/2.
:- dynamic module_room/2, module_in/1,time_in/1.
doit :-
	tell('database.txt'),
	task1,
	told.
% Author, Mehdi Dana (m3dana at gmail dot com)
% Thanks to Prof. Lee McCluskey

% data are in data.pl file
:- include('data.pl').


/************************************** TASK 1 **********************************	
*** CONSTRAINTS ***/

	% some examples - they work
  	% gary is not avaiable on monday 09:15
	% lecturer_time_no([01,09:15],gary).	\+ lecturer_time_no(TS,LT),
	% room cw203 is reserved for other activities
	% room_time_no([02,10:15],cw203). \+ room_time_no(TS,RM),



% booked(timeslot,room,module,lecturer,student).

%room_conflict_1(ts,rm,_,_,st).  
%module_conflict_1(ts,_,md,_,st).
%lecturer_conflict_1(ts,_,_,lt,st).
module_taken_1(md,st).
busy_student(timeslot,student).

module_room(module,room).
% module_in(md).

task :-
write('timeslot '),tab(6),write('module '),tab(7),write('lecturer '),tab(3), write('student'),nl,
write('---------------------------------------------'),nl,
	mix(
	[
		[01,09:15],[01,10:15],[01,11:15],[01,12:15],
		[02,09:15],[02,10:15],[02,11:15],[02,12:15]
	],		% timeslot
	[maths_lec,maths_tu,java_lec,java_tu,arti_lec,arti_tu,project],		% modules
	[gary,andy,lee],						% lecturers
	[mehdi,sara,ed,mani],					% students
	[cw203,cw301,cw503]						% rooms
	).
	
mix(List1,List2,List3,List4,List5):-
	member(TS,List1),member(MD,List2),member(LT,List3),member(ST,List4),member(RM,List5),
	lecturer_teach(MD,LT),
	student_take(MD,ST),
	
	\+ room_conflict_1(TS,RM,_,_,ST),
%	\+ module_conflict_1(TS,_,MD,_,ST),
%	\+ lecturer_conflict_1(TS,_,_,LT,ST),
	\+ module_taken_1(MD,ST),
	\+ busy_student(TS,ST),
	
	% module_room_ok(TS,MD,RM),
%	module_room(MD,RM),
%	assert(module_room(MD,RM)),
	
	% assert(room_conflict_1(TS,RM,_,_,ST)),
%	assert(module_conflict_1(TS,_,MD,_,ST)),
%	assert(lecturer_conflict_1(TS,_,_,LT,ST)),
	assert(module_taken_1(MD,ST)),
	assert(busy_student(TS,ST)),

	% for information
	assert(booked(TS,RM,MD,LT,ST)),
	assert(lec_timetable(TS,RM,MD,LT)),
	
	write(TS),write(' \t '),
	% write(RM),write(' \t '),
	write(MD),
	write(' \t '),write(LT),write(' \t '),write(ST),nl,
	delete(RM,List2,_).

module_room_ok(TS,MD,RM) :-
		% if its first time, then add it to database, return true
		% \+ module_room(MD,RM),
		\+ module_in(MD), assert(module_in(MD)),!,
		write(MD),nl,
		time_room_ok(TS,RM),
		assert(module_room(MD,RM)).
module_room_ok(_,MD,RM) :-
		% if already in database, check with database, then return room
		 module_room(MD,RM).

time_room_ok(TS,RM) :- 
		\+ time_in(TS), assert(time_in(TS)),
		assert(time_room(TS,RM)).
time_room_ok(TS,RM) :-
		 \+ time_room(TS,RM).
		
	
% print individual timetable for student 
student(ST) :-
	booked(TS,RM,MD,LT,ST),
	write(TS),write('\t'),write(RM),write('\t'),write(MD),
	write('\t'),write(LT),nl,
	retract(booked(TS,RM,MD,LT,ST)),
	student(ST).
student(_):-
	booked(_,_,_,_,_).	
	
% print individual timetable for lecturer 	
lecturer(LT) :-
	lec_timetable(TS,RM,MD,LT),
	write(TS),write('\t'),write(RM),write('\t'),write(MD),nl,
	retractall(lec_timetable(TS,RM,MD,LT)),
	lecturer(LT).
lecturer(_):-
	lec_timetable(_,_,_,_).	


/*************** UTILLITY ****************/
	
member(X,[X|_]).
member(X,[_|Rest]) :-
    member(X,Rest).

delete(Item,[Item|List],List).
delete(Item,[First|List],[First|List1]) :-
	delete(Item,List,List1).

append([],List2,List2).
append([Head|Tail],List2,[Head|Rest]):-
	append(Tail,List2,Rest).

get_list([]).
get_list([Head|Tail]):-
	write(Head),write(' '),
	get_list(Tail).
	
head([],[]).
head([Head|_],Head).

