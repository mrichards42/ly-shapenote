\version "2.19.2"
\include "../shapenote.ly"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                   Setup                                   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

title = "Wells. L.M."
poet = "Isaac Watts, 1707."
composer = "Israel Holdroyd, 1724."
pitch = g % The written pitch; Set to relative major if song is in minor
isMajor = ##t
timeSignature = 4/4


globalOverride = {
  \tempo 4 = 90
  % \aikenHeads
  \sacredHarpHeads
}

systemCount = 1
staffSize = 19


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 Music                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\include "italiano.ly" % do re mi fa sol la si

trebleMusic = \relative do' {
  mi1 sol4 sol mi2 sol fa4 mi re1 ~ 2
  re2 re4 re mi2 sol2 la4 sol mi1 ~ 2
  sol2 fa4 mi re2 mi sol4 fa sol1 ~ 2
  sol2 do,4 re re2 la'2 la4 sol mi1
  
}

altoMusic = \relative do {
  sol'1 sol4 sol sol2 sol do4 do si1 r2
  si2 re4 re do2 sol la4 si sol1 r2
  do2 si4 do la2 sol do4 do si1 r2
  sol2 sol4 la si2 do do4 si do1
}

tenorMusic = \relative do' {
  do1 mi4 sol do2 si do4 la sol1 r2
  sol2 sol4 sol sol2 mi fa4 re do1 r2
  mi2 fa4 sol la2 si do4 la sol1 r2
  re2 mi4 fa sol2 mi fa4 re do1
  \bar "|."
}

bassMusic = \relative do, {
  \clef bass
  do'1 do4 si do2 mi do4 re sol,1 ~ 2
  sol2 sol4 sol do2 do fa,4 sol do1 ~ 2
  do2 re4 mi re2 sol do,4 re sol,1 ~ 2
  si2 do4 la sol2 la fa4 sol <do do,>1
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 Verses                                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verseTreble = \lyricmode {
  \set stanza = "1."
  Life is the time to serve the Lord,
  The time t'in -- sure the great re -- ward;
  And while the lamp holds out to burn
  The vil -- est sin -- ner may re -- turn.
}

verseAlto = \lyricmode {
  \set stanza = "2."
  Life is the hour that God has giv'n,
  To es -- scape hell and fly to heav'n;
  The day of grace, and mor -- tals may
  Se -- cure the bless -- ing of the day.
}

verseTenor = \lyricmode {
  \set stanza = "3."
  The liv -- ing know that they must die,
  But all the dead for -- got -- ten lie;
  Their mem -- 'ry and their sense is gone,
  A -- like un -- know -- ing and un -- known.
}

verseBass = \lyricmode {
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 Score                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\include "../shapenote_layout.ily"
