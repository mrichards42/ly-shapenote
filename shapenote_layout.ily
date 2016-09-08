\version "2.19.2"

global = {
  \key \pitch #(if isMajor #{ \major #} #{ \minor #})
  \time \timeSignature
  \numericTimeSignature
  \autoBeamOff
  \aikenHeads
  \override NoteHead #'font-size = #1.125
  \override Staff.StaffSymbol #'thickness = #1
  \set Staff.midiInstrument = #"synth voice"
  \set Staff.midiMaximumVolume = #0.75
  #(if sn:solo #{ \set Staff.midiMaximumVolume = #0 #})
  \set Score.tempoHideNote = ##t
  #(if (defined? 'globalOverride) #{ \globalOverride #} )
}

\header {
  title = \markup { \caps \title }
  poet = \markup { \markupKey \poet }
  composer = \markup { \composer }
  tagline = ##f %Turns off annoying Lilypond version stamp on bottom of page
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 Header                                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% not-last-page for the header
#(define (not-last-page layout props arg) 
   (if (and (chain-assoc-get 'page:is-bookpart-last-page props #f) 
            (chain-assoc-get 'page:is-last-bookpart props #f)) 
       empty-stencil 
       (interpret-markup layout props arg)))

% Header markup
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
}

\paper {
  system-count = #(if (defined? 'systemCount) systemCount) %Suggests to Lilypond how many braces to use for this piece.
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
  }
}


% Shift verses if we are missing parts
#(if (or (not (defined? 'trebleMusic)) (is-empty trebleMusic))
     (begin
       (set! verseTenor #{ \lyricmode { \verseAlto \verseTenor } #})
       (set! verseAlto #{ \lyricmode { \verseTreble \verseAlto } #})))

#(if (or (not (defined? 'altoMusic)) (is-empty altoMusic))
     (set! verseTenor #{ \lyricmode { \verseAlto \verseTenor } #}))

% Score for print -- to exclude a part, just delete it
\score 
{
  \new StaffGroup <<
    #(if (defined? 'trebleMusic) #{
      \new Staff = "treble" { \global \transpose do \pitch \trebleMusic }
      \addlyrics { \verseTreble }
         #})

    #(if (defined? 'altoMusic)
         #{
      \new Staff = "alto" { \global \transpose do \pitch \altoMusic }
      \addlyrics { \verseAlto }
         #})

    #(if (defined? 'tenorMusic) #{
      \new Staff = "tenor" { \global \transpose do \pitch \tenorMusic }
      \addlyrics { \verseTenor }
         #})

    #(if (defined? 'bassMusic) #{
      \new Staff = "bass" { \global \transpose do \pitch \bassMusic }
      \addlyrics { \verseBass }
         #})
  >>
}

% Score for MIDI
\score {
  <<
    % Tenor first so we can use the repeats and DC's from the tenor line
    #(if (defined? 'tenorMusic) #{
      \new Staff = "tenorM" \shapeNoteAccent {
        \global
        \transpose re \pitch
        \unfoldRepeats
        \tenorMusic
      }
      \new Staff = "tenorF" \shapeNoteAccent {
        \global
        \transpose re, \pitch % up an octave, plus transposition
        \unfoldRepeats
        \tenorMusic
      }
         #})

    #(if (defined? 'trebleMusic) #{
      \new Staff = "trebleM" \shapeNoteAccent {
        \global
        \transpose re \pitch
        \unfoldRepeats
        \trebleMusic
      }
      \new Staff = "trebleF" \shapeNoteAccent {
        \global
        \transpose re, \pitch % up an octave, plus transposition
        \unfoldRepeats
        \trebleMusic
      }
         #})

    #(if (defined? 'altoMusic) #{
      \new Staff = "alto" \shapeNoteAccent {
        \global
        % Bump up the alto volume a hair
        #(if (not sn:solo) #{ \set Staff.midiMaximumVolume = #0.8 #})
        \transpose re \pitch
        \unfoldRepeats
        \altoMusic
      }
         #})

    #(if (defined? 'bassMusic) #{
      \new Staff = "bass" \shapeNoteAccent {
        \global
        % Bump up the bass volume a hair
        #(if (not sn:solo) #{ \set Staff.midiMaximumVolume = #0.8 #})
        \transpose re \pitch
        \unfoldRepeats
        \bassMusic
      }
         #})
  >>
  % \layout {} %Uncomment to debug midi
  \midi {
    \tempo 4 = 160 % Reasonable default midi tempo
  }
}
