\include "shapenote_accent.ly"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                Markup                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
textFlat = \markup { \hspace #0.2 \raise #0.3 \smaller \smaller \flat }
textSharp = \markup { \hspace #0.2 \raise #0.7 \smaller \smaller \smaller \sharp }
textcodaysym = \markup { \hspace #1 \raise #1.1 \musicglyph #"scripts-coda"}

dc = {
  \once \override Score.RehearsalMark.break-visibility = #begin-of-line-invisible
  \once \override Score.RehearsalMark.self-alignment-X = #RIGHT
  \mark \markup { \small \italic "D.C." }
}

fine = {
  \once \override Score.RehearsalMark.break-visibility = #begin-of-line-invisible
  \once \override Score.RehearsalMark.self-alignment-X = #RIGHT
  \mark \markup { \small \italic "Fine."}
}

stanzaDC = {
  \override LyricText.font-shape = #'italic
  \set stanza = \markup { \italic "D.C." }
}

% Print the key signature markup
#(define-markup-command (markupKey layout props ) ()
   (let* ((notes "CDEFGAB")
          (idx (ly:pitch-notename pitch))
          (accidental (cond
                       ((= -1/2 (ly:pitch-alteration pitch)) #{ \textFlat #})
                       ((= 1/2 (ly:pitch-alteration pitch)) #{ \textSharp #})
                       (else "")))
          (major-minor (if isMajor "Major" "Minor")))
     (interpret-markup layout props
       #{
         \markup {
           \concat { #(string (string-ref notes idx)) #accidental }
           \concat { #major-minor "." }
       } #})))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                Midi                                       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mute = #(define-music-function (parser location music) (ly:music?)
          #{
            \set Staff.midiMaximumVolume = #0
            #music
          #})

#(define sn:solo #f)

solo = #(define-music-function (parser location music) (ly:music?)
          (set! sn:solo #t)
          #{
            \set Staff.midiMaximumVolume = #0.8
            #music
          #})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                Repeats                                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Repeats with four dots (";") instead of two (":")
% The standard lilypond repeats
#(define-bar-line ";|.;" ";|." ".|;"  " |.")
#(define-bar-line ";..;" ";|." ".|;" " ..")
#(define-bar-line ";|.|;" ";|." ".|;" " |.|")
#(define-bar-line ";.|.;" ";|." ".|;" " .|.")
#(define-bar-line ";|." ";|." #f " |.")
#(define-bar-line ".|;" "|" ".|;" ".|")
#(define-bar-line "[|;" "|" "[|;" " |")
#(define-bar-line ";|]" ";|]" #f " |")
#(define-bar-line ";|][|;" ";|]" "[|;" " |  |")
#(define-bar-line ".|;-||" "||" ".|;" ".|")

% A thick bar line, with no thin barline (the normal sacred harp repeat)
#(define-bar-line ".;" "." ";" "|")  % start
#(define-bar-line ";." ";." "" "")   % end
#(define-bar-line ";.;" ";.;" "" "") % double middle


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                Utils                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#(define (is-empty music)
   (= 0 (ly:moment-main-numerator (ly:music-length music))))