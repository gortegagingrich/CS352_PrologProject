%% simple grammar definition
pp --> p, det.
p --> [of].
det --> [the].
verb --> [is].
what --> [what].
any --> [_].
any --> [_,_].

preInter --> what, verb, det.

%% declarative sentence
decl --> det, any, pp, any, verb, any.
%% interogative sentence
inter --> preInter, any, pp, any.

%% predicate used for general bindings
%% if the color of the car is blue, ternaryBind(color,car,[blue])
%% if the length of the rod is 20 inches, ternaryBind(length,rod,[20,inches])
:- dynamic ternaryBind/3.

%% required predicate that takes a sample sentence as a list
%% and a string matched to some sort of output message
:- dynamic execute/2.
execute(Sentence,Out) :-
    %%receives declarative sentence
    %make sure Sentence is declarative
    decl(Sentence,[]),

    %get individual parts of sentence
    det(Sentence,[Attr|T1]),
    pp(T1,[Subj|T2]),
    verb(T2,Val),
    (
        %given sentence matches preexisting rule
        ternaryBind(Attr,Subj,Val),
        swritef(Out,'I know.') |

        %a different value is already bound to the subject
        %for the same attribute
        ternaryBind(Attr,Subj,Prop),
        Prop \== Val,
        (
            length(Prop,1), %Property is one word
            swritef(Out,'No, it\'s %w.', Prop)|
            length(Prop,2), %Property is two words
            swritef(Out,'No, it\'s %w %w.', Prop)
        )|

        %add new binding if there is not a preexisting one
        not(ternaryBind(Attr,Subj,_)),
        swritef(Out,'OK.'),
        assert(ternaryBind(Attr,Subj,Val))
    ),!|

    %%receives question
    inter(Sentence,[]),
    preInter(Sentence,[Attr|T1]),
    pp(T1,[Subj|_]),
    (
    	%% there is a mathing ternaryBind
    	ternaryBind(Attr,Subj,Val),
    	(
    		length(Val,1),
    		swritef(Out,'It\'s %w.',Val)|
			length(Val,2),
			swritef(Out,'It\'s %w %w.', Val)
		) |
		not(ternaryBind(Attr,Subj,_)),
		swritef(Out,'I don\'t know.')
	),!|

    %% does not receive well-formed sentence
    not(decl(Sentence,[])),
    not(inter(Sentence,[])),
    swritef(Out,'I couldn\'t understand that.'),!.

%% tests various cases to make sure execute/2 works
:- dynamic test/0.
test() :-
	%% make sure current knowledge base doesn't change results
	retractall(ternaryBind(color,car,_)),
	retractall(ternaryBind(color,boat,_)),

	%% test with given examples on project page
	execute([what,is,the,color,of,the,car],"I don't know."),
	execute([the,color,of,the,car,is,blue],"OK."),
	execute([the,color,of,the,car,is,red],"No, it's blue."),
	execute([the,color,of,the,car,is,blue],"I know."),
	execute([what,is,the,color,of,the,car],"It's blue."),

	%% test with 2 word property
	execute([the,color,of,the,car,is,dark,blue],"No, it's blue."),
	execute([the,color,of,the,boat,is,dark,blue],"OK."),
	execute([the,color,of,the,boat,is,green],"No, it's dark blue."),
	execute([the,color,of,the,boat,is,dark,green],"No, it's dark blue."),
	execute([the,color,of,the,boat,is,light,blue],"No, it's dark blue."),
	execute([the,color,of,the,boat,is,dark,blue],"I know."),
	execute([what,is,the,color,of,the,boat],"It's dark blue."),!.
