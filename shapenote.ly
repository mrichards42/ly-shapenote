#(ly:set-option 'relative-includes #t)
\include "shapenote_articulate.ly"
\include "shapenote_utils.ly"
#(ly:set-option 'relative-includes #f)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          Variable Defaults                                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Header
title = ""
meter = ""
poet = ""
composer = ""
pitch = ##f % require this to be defined
isMajor = ##t

% Music display/layout
shapes = \sacredHarpHeads
staffSize = 20
systemCount = 0 % let lilypond decide
globalOverride = {}
midiInstrument = "voice oohs"
wholeNoteStems = ##f % set to \stemDown to override whole note stem direction

% Music
timeSignature = 4/4
trebleMusic = {}
altoMusic = {}
tenorMusic = {}
bassMusic = {}

% Lyrics
verseTreble = {}
verseAlto = {}
verseTenor = {}
verseBass = {}


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
