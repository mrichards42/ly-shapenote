\version "2.19.2"
\include "../shapenote.ly"


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                   Setup                                   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

title = "The Finest Flower. C.M.D."
poet = ""
composer = "David Walker."
pitch = bes % The written pitch; Set to relative major if song is in minor
isMajor = ##t
timeSignature = 4/4

globalOverride = {
  \tempo 4 = 100
  \aikenHeads
% \sacredHarpHeads
}

systemCount = 2
staffSize = 19


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 Music                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\include "italiano.ly" % do re mi fa sol la si


trebleMusic = \relative do'
{
  r2
  \repeat unfold 2 {
    mi2
    do4 mi do2
    sol2 do8[ re] mi4
    re2. sol4
    mi4 re do4. re8
  }
  \alternative {
    { mi2 }
    { mi1 }
  }

  \repeat volta 2 {
    mi2 do4 mi
    re2 sol
    mi4 mi sol2
    sol4.( fa8) mi4 re
    do8[ re] mi4 re2
    mi2 do4 mi
    sol2 mi
    mi4 re8[ do] re4 re8[ do]
    mi4 re do4. re8
    mi1
  }
}

altoMusic = \relative do'
{
  r2
  \repeat unfold 2 {
    sol2
    la4 sol sol2
    sol2 la4 la
    si2. si4
    do4 la sol4. la8
  }
  \alternative {
    { sol2 }
    { sol1 }
  }

  \repeat volta 2 {
    sol2 sol4 do
    si2 si
    do4 do sol2
    sol2 sol4 sol
    la4 la si2
    do2 do4 do
    sol2 sol
    la4 la si si
    do4 la sol4. la8
    sol1
  }
}

tenorMusic = \relative do'
{
  r2
  \repeat unfold 2 {
    sol2
    la4 do do2
    do2 mi8[ re] do4
    re2. re8[ do]
    la4 sol8[ la] do4. la8
  }
  \alternative {
    { sol2 }
    { sol1 }
  }

  \repeat volta 2 {
    sol2 do4 mi
    sol2 sol
    la4 sol mi2
    do4.( re8) mi4 sol
    mi8[ re] do4 re2
    sol2 la4 sol
    mi2 do
    mi4 re8[ do] re4 re8[ do]
    la4 sol8[ la] do4. la8
    sol1
  }
  \bar ";|."
}

bassMusic = \relative do,
{
  \clef bass
  r2
  \repeat unfold 2 {
    do2
    mi4 do do2
    do'2 la8[ sol] mi4
    sol2. sol4
    la4 sol8[ la] mi4. re8 \noBreak
  }
  \alternative {
    { do2 }
    { do1 }
  }

  \repeat volta 2 {
    do2 do'4 la
    sol2 sol
    la4 mi sol2
    do4.( si8) la4 sol
    mi4 mi sol2
    sol2 mi4 sol
    do,2 do
    mi4 fa sol sol
    la4 sol8[ la] mi4. re8
    do1
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 Verses                                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
verseTreble = \lyricmode
{
  \set stanza = "1."
  The fin -- est flow'r that e'er was known,
  O -- pened on Cal -- v'ry's tree,
  When Christ the Lord was pierced and torn,
  For love of worth -- less me.
  
  Its deep -- est hue, its rich -- est smell,
  No mor -- tal sense can bear;
  Nor can the tongue of an -- gels tell
  How bright its col -- ors are.
}

verseAlto = \lyricmode
{
  \set stanza = "2."
  Earth could not hold so rich a flow'r,
  Nor half its beau -- ties show;
  Nor could the world and Sa -- tan's pow'r
  Con -- fine it here be -- low.
  
  On Ca -- naan's banks su -- preme -- ly fair,
  This flow'r of won -- der blooms,
  Trans -- plant -- ed to its na -- tive air,
  And all the shores per -- fumes.
}

verseTenor = \lyricmode
{
  \set stanza = "3."
  But not to Ca -- naan's shores con -- fined,
  The seeds which from it blow
  Take root with -- in the hu -- man mind,
  And scent the church be -- low.

  Love is the sweet -- est bud that blows,
  Its beau -- ty nev -- er dies;
  On earth a -- mong the saints it grows,
  And ri -- pens in the skies.
}

verseBass = \lyricmode
{
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 Score                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\include "../shapenote_layout.ily"
