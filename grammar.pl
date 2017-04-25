s --> decl.
s --> inter.

%% declarative sentences
decl --> np, vp.
decl --> np, vp, period.

%% noun phrases
np --> n.
np --> det, n.
np --> n, pp.
np --> det, n, pp.

%% prepositional phrases
pp --> p, np.

%% verb phrases
vp --> v.
vp --> v, ap.
vp --> v, np.

%% adjectival phrases
ap --> adj.
ap --> adv, adj.

%% interrogative sentences
inter --> [what], vp, question.