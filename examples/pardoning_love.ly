\version "2.19.2"
\include "../shapenote.ly"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                   Setup                                   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

title = "Pardoning Love. C.M."
poet = ""
composer = "William Walker."
pitch = c % The written pitch; Set to relative major if song is in minor
isMajor = ##t
timeSignature = 3/4


globalOverride = {
  \aikenHeads
  % \sacredHarpHeads
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 Music                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\include "italiano.ly" % do re mi fa sol la si

trebleMusic = \relative do' {
  \repeat volta 2 {
    r2 do'4 | mi2 mi8[ re] | mi2 mi4 | re2 re4 | do2 sol4 | la2 sol4 | do8( re4.) mi4 | mi2.
  }
  r1 r4 do | do2 do4 re2 mi4 | fa4.( re8 mi4 re2) do4 | sol'2 sol4 sol( mi) do | re1. |
}

altoMusic = \relative do
{
  \repeat volta 2 {
    r2 mi'4 | sol2 sol4 | sol2 sol4 | si2 si4 | la2 sol4 | mi2 sol4 | do8( si4.) la4 | sol2. 
  }
  r1 r4 sol | la2 la4 sol2 sol4 | la2( do4 si2) sol4 | si2 si4 sol( la) do | si1. |
}

tenorMusic = \relative do'
{
  \tempo 4 = 90
  \bar ".;"
  \repeat volta 2 {
    r2 sol'4 | do2 mi8[ re] | do2 la4 | sol2 sol8[ fa] | mi2 sol4 | la8( do4.) re4 | do8( sol4.) la4 | do2.
    \fine
  }
  \time 6/4
  \tempo 4 = 180
  r1 r4 do | mi2 mi4 re2 do4 | fa4.( sol8 la4 sol2) sol8[ mi] | re2 re4 re( mi) fa | sol1. |
  \bar "|." \dc
}

bassMusic = \relative do
{
  \clef bass
  \repeat volta 2 {
    r2 sol'4 | do,2 do4 | do2 mi4 | sol2 sol8[ fa] | mi2 re4 | do2 re4 | mi8( sol4.) mi4 | do2.
  }
  r1 r4 mi | mi2 mi4 sol2 sol4 | do4.( si8 la4 sol2) do,4 | re2 re4 sol( mi) do | sol'1. |
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 Verses                                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
verseTreble = \lyricmode { }

verseAlto = \lyricmode <<
  \new Lyrics {
    In ev -- il long I took de -- light, Un -- awed by shame or fear,
  }
  \new Lyrics {
    Till a new ob -- oject struck my sight, And stopped my wild ca -- reer.
    And stopped my wild ca -- reer, And stopped my wild ca -- reer.
  }
  \new Lyrics {
    \stanzaDC
    Till a new ob -- oject struck my sight, And stopped my wild ca -- reer.
  }
>>


verseTenor = \lyricmode { }

verseBass = \lyricmode { }


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 Score                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\include "../shapenote_layout.ily"
