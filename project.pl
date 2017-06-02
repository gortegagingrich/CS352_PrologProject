pp --> p, det.
p --> [of].
det --> [the].
verb --> [is].
what --> [what].

decl --> det, any, pp, any, verb, any.
any --> [_].

ternaryBind([],[],[]).

:- dynamic test/1.

test(Sent) :-
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
        write('Yes.  That is correct') |

        %a different value is already bound to the subject
        %for the same attribute
        ternaryBind(Attr,Subj,Prop),
        Prop \== Val,
        (
            length(Prop,1), %Property is one word
            writef('No, it is %w', Prop)|
            length(Prop,2), %Property is two words
            writef('No, it is %w %w', Prop)
        )|

        %add new binding if there is not a preexisting one
        assertz(ternaryBind(Attr,Subj,Val))
    ).
