pp --> p, det.
p --> [of].
det --> [the].
verb --> [is].
what --> [what].
any --> [_].

decl --> det, any, pp, any, verb, any.
inter --> what, verb, det, any, pp, any.

ternaryBind([],[],[]).

:- dynamic execute/2.

execute(Sent,Out) :-
    %%receives declarative sentence
    %make sure Sent is declarative
    decl(Sent,_),

    %get individual parts of sentence
    det(Sent,[Attr|T1]),
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
        assertz(ternaryBind(Attr,Subj,Val)),!
    )|

    %%receives question
    inter(Sent,_)|

    %% does not receive well-formed sentence
    not(decl(Sent,_)),
    not(inter(Sent,_)),
    swritef(Out,'I couldn\'t understand that.'),!.
