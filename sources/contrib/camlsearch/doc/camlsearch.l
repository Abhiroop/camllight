.TH CAMLSEARCH 1 "29 November 1994"

.SH NAME
camlsearch \- Search Caml libraries using types as search keys

.SH SYNOPSIS
.B camlsearch
[
.BI \-x
]
[
.BI \-s
]
[
.BI \-nounit 
]
[
.BI \-e \ type
]
[
.I .zi files or directories ...
]

.B camlsearch
[
.BI \-x
]
[
.BI \-s
]
[
.BI \-nounit 
]
[
.BI \-d \ depth
]
[
.BI \-l \ type
]
[
.I .zi files or directories ...
]

.B camlsearch
[
.BI \-x
]
[
.BI \-s
]
[
.BI \-nounit 
]
[
.BI \-d \ depth
]
[
.BI \-m \ type
]
[
.I .zi files or directories ...
]


.SH DESCRIPTION

The
.B camlsearch
program is a library search tool that allows to search for functions or
values inside CamlLight modules, using the type as a search key.

For example, if you are looking for a function that computes the length of a string,
you probably think of something with type
.I string -> int
; the following command will search for such functions in the standard library:

.B \ camlsearch 
-e "string -> int" /usr/local/lib/caml-light

This gives as a result:

\ string__string_length : string -> int
 fstring__string_length : string -> int
 int__int_of_string : string -> int

That is, the function string_length in module 
.B string 
and module 
.B fstring, 
and the function int_of_string in module 
.B int.

The
.B camlsearch
program does not limit itself to a pure syntactical comparison of types as it may
seem from the example above: it can retrieve any function in the library that has a type 
.B isomorphic
to the query (as detailed in the [Rit90], [Rit91], [Rit93] and [RDC]).

Typical isomorphisms are curryfication and argument swap, as is apparent from
the following query:

.B \ camlsearch 
-e "'a list * ('a -> 'b) -> 'b list" /usr/local/lib/caml-light
 list__map : ('b -> 'a) -> 'b list -> 'a list

A less typical isomorphism identifies a type of the shape 
.B A -> unit 
with the type
.B unit
like in the following example:

.B \ camlsearch 
-e "unit" /usr/local/lib/caml-light/set.zi
 set__iter : ('a -> 'b) -> 'a set__t -> unit

Since this isomorphism usually identifies too many types, it is possible to
disable it in the search using the
.B -nounit 
command line option.
 
The 
.B \-s
option suppresses the module name information from the output.

The 
.B \-x 
options gives more detailed information about the retrieved functions.

.SH SEARCHES BY TYPE MATCHING

Besides searching using equality modulo isomorphisms (the
.B \-e
option), it is also possible to retrieve functions whose type is, up to isomorphisms,
.B more general
than the query using the 
.B \-m
option, and functions whose type is less general than the query using the
.B \-l 
option.

For example, 

.B \ camlsearch 
-m "int list * (int -> int) -> int list" /usr/local/lib/caml-light

retrieves the following functions with more general types:

\ list__map : ('b -> 'a) -> 'b list -> 'a list
 pair__fst : 'a * 'b -> 'a
 pair__snd : 'b * 'a -> 'a

On the other hand, when searching functions with less general type 
variables prefixed with an underscore can be instantiated to whatever type.
This can be very useful to find out how to build values of a specific type:

.B \ camlsearch 
-l "_x -> char" /usr/local/lib/caml-light
 lexing__get_lexeme_char : lexing__lexbuf -> int -> char
 lexing__get_next_char : lexing__lexbuf -> char
 io__input_char : io__in_channel -> char
 fstring__nth_char : string -> int -> char
 fchar__char_of_int : int -> char
 string__nth_char : string -> int -> char
 char__char_of_int : int -> char

When searching types that are  more general or  less general than the query, the
matching  functions  are ordered by the  complexity  of the substitution that is
used in the process (this is considered an empirically satisfying notion of 
.B distance
on the types), so functions whose types is more similar  to the query type
are printed first.

It is possible to put a bound on the distance from the query with the 
.B \-d
option: usually the functions you are really interested in can be found at a
distance of less than 3, but this is not a general rule.


.SH REFERENCES

[RDC]  Di Cosmo (Roberto). - Isomorphisms of types: from lambda-calculus to
information retrieval and language design. - Birkhauser, 1994.

[Rit90] Mikael Rittri. Retrieving library identifiers by equational matching of
types in 10th Int. Conf. on Automated Deduction. Lecture Notes in Computer
Science, 449, July 1990.

[Rit91]  Mikael Rittri. Using types as search keys in function
libraries. Journal of Functional Programming, 1(1):71-89, 1991.

[Rit93]  Mikael Rittri.   Retrieving library functions by unifying types modulo
linear isomorphism.  RAIRO Theoretical Informatics and Applications, 27(6):523-540,
1993.
