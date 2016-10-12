\version "2.19.2"
% Heavily modified from Robert Stoddard's lilypond templates: <http://www.bostonsing.org/music>

global = {
  \key \pitch #(if isMajor #{ \major #} #{ \minor #})
  \time \timeSignature
  \numericTimeSignature
  \autoBeamOff
  #(if (defined? 'shapes) #{ \shapes #} #{ \sacredHarpHeads #})
  \override NoteHead #'font-size = #1.125
  \override Staff.StaffSymbol #'thickness = #1
  \set Staff.midiInstrument = #(if (defined? 'midiInstrument) midiInstrument "synth voice")
  \set Staff.midiMaximumVolume = #0.75
  #(if sn:solo #{ \set Staff.midiMaximumVolume = #0 #})
  \set Score.tempoHideNote = ##t
  #(if (defined? 'globalOverride) #{ \globalOverride #} )
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 Header                                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the header
\header {
  title = \markup { #(string-upcase title) }
  poet = \markup { \markupKey \poet }
  composer = \markup { \composer }
  tagline = ##f % Remove lilypond version
}

% Header layout on the page
\paper {
  #(set-paper-size "letter" 'landscape)
  evenHeaderMarkup = \markup {
    \column {
      \fill-line {
        \bold \fontsize #4
        \concat {
          \on-the-fly #not-first-page \fromproperty #'header:title
          \on-the-fly #not-first-page \on-the-fly #not-last-page "  Continued."
          \on-the-fly #not-first-page \on-the-fly #last-page "  Concluded."
        }
      }
      \large \on-the-fly #print-page-number-check-first \fromproperty #'page:page-number-string
      " "
    }
  }
  oddHeaderMarkup = \evenHeaderMarkup
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                             Score Layout                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\paper {
  % line-width = 10\in
  %horizontal-shift = 0.175\in
  top-margin = 0.3\in
  % bottom-margin = 0.5\in
  ragged-last = ##f
  ragged-bottom = ##t
  % Increase the gap between systems (default=12)
  system-system-spacing.basic-distance = #15
  % Force this may braces if systemCount is defined
  system-count = #(if (defined? 'systemCount) systemCount)
}

#(if (not (defined? 'staffSize)) (define staffSize 20))

\layout {
  #(layout-set-staff-size staffSize)
  indent = #0
  \context {
    \Score
    \remove "Bar_number_engraver" % Get rid of measure numbers at the beginning of each brace
    \override SpanBar #'transparent = ##t % Turn off staff lines between staves
    % Lyrics
    \override LyricText #'font-size = #-1
    \override StanzaNumber #'font-size = #-1
    \override StanzaNumber #'font-series = #'medium
    % Repeats
    \override VoltaBracket #'stencil = ##f
    startRepeatType = #".;"
    endRepeatType = #";."
    doubleRepeatType = #";.;"
    % Spacing tweaks
    %\override SpacingSpanner #'base-shortest-duration = #(ly:make-moment 1/1)
    %\override SpacingSpanner #'common-shortest-duration = #(ly:make-moment 1/1)
    %\override SpacingSpanner #'shortest-duration-space = 0.5
    %\override SpacingSpanner #'spacing-increment = 0.5
    %\override NonMusicalPaperColumn.full-measure-extra-space = #0
  }
  \context {
    \Staff
    \override TimeSignature.break-visibility = #end-of-line-invisible
  }
  \context {
    \Lyrics
    % Reduce space between lyric lines
    \override VerticalAxisGroup.nonstaff-nonstaff-spacing.minimum-distance = #0
    % Force hypens to appear
    \override LyricHyphen.minimum-distance = #1
    % Spacing tweaks
    %\override LyricHyphen.minimum-length = #0.3
    %\override LyricHyphen.padding = #0.0
    %\override LyricSpace.minimum-distance = #0.3
    %\override LyricText #'word-space = #0.5
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                              Score                                        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Allow hiding lyrics
#(if (and (defined? 'hideLyrics) hideLyrics)
     (begin
      (set! verseTreble #{ \lyricmode { } #})
      (set! verseAlto #{ \lyricmode { } #})
      (set! verseTenor #{ \lyricmode { } #})
      (set! verseBass #{ \lyricmode { } #})))

% Shift verses if we are missing parts
#(if (or (not (defined? 'trebleMusic)) (is-empty trebleMusic))
     (begin
       (set! verseTenor #{ \lyricmode { \verseAlto \verseTenor } #})
       (set! verseAlto #{ \lyricmode { \verseTreble \verseAlto } #})))

#(if (or (not (defined? 'altoMusic)) (is-empty altoMusic))
     (set! verseTenor #{ \lyricmode { \verseAlto \verseTenor } #}))

% Common music operations
fixMusic = #(define-music-function (parser location music) (ly:music?)
   #{
     \global \transpose do \pitch \fixStems #music
   #})

% Score for print -- to exclude a part, just delete it
\score 
{
  \new ChoirStaff <<
    #(if (defined? 'trebleMusic) #{
      \new Staff = "treble" { \fixMusic \trebleMusic }
      \addlyrics { \verseTreble }
         #})

    #(if (defined? 'altoMusic)
         #{
      \new Staff = "alto" { \fixMusic \altoMusic }
      \addlyrics { \verseAlto }
         #})

    #(if (defined? 'tenorMusic) #{
      \new Staff = "tenor" { \fixMusic \tenorMusic }
      \addlyrics { \verseTenor }
         #})

    #(if (defined? 'bassMusic) #{
      \new Staff = "bass" { \fixMusic \bassMusic }
      \addlyrics { \verseBass }
         #})
  >>
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 MIDI                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Common midi operations
fixMidi = #(define-music-function (parser location music) (ly:music?)
   #{
     % Add articulations
     \shapeNoteArticulate {
       % Transpose one step down
       \transpose re do {
         % same as fixMusic
         \global \transpose do \pitch { \unfoldRepeats #music }
       }
     }
   #})

\score {
  <<
    % Tenor first so we can use the repeats and DC's from the tenor line
    #(if (defined? 'tenorMusic) #{
      \new StaffGroup <<
      \new Staff \with { instrumentName = #"Low Tenor" }
      { \fixMidi \tenorMusic }

      \new Staff \with { instrumentName = #"High Tenor" }
      {
        \transpose do, do % up an octave
        \fixMidi \tenorMusic
      }
      >>
         #})

    #(if (defined? 'trebleMusic) #{
      \new StaffGroup <<
      \new Staff \with { instrumentName = #"Low Treble" }
      { \fixMidi \trebleMusic }

      \new Staff \with { instrumentName = #"High Treble" }
      {
        \transpose do, do % up an octave
        \fixMidi
        \trebleMusic
      }
      >>
         #})

    #(if (defined? 'altoMusic) #{
      \new Staff \with { instrumentName = #"Alto" }
      {
        \fixMidi {
          % Bump up the alto volume a hair
          #(if (not sn:solo) #{ \set Staff.midiMaximumVolume = #0.8 #})
          \altoMusic
        }
      }
         #})

    #(if (defined? 'bassMusic) #{
      \new Staff \with { instrumentName = #"Bass" }
      {
        \fixMidi {
          % Bump up the bass volume a hair
          #(if (not sn:solo) #{ \set Staff.midiMaximumVolume = #0.8 #})
          \bassMusic
        }
      }
         #})
  >>
  %\layout { indent = #20 } %Uncomment to debug midi
  \midi {
    \tempo 4 = 160 % Reasonable default midi tempo
  }
}
