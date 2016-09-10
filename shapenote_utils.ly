% Utility functions for shapenote.ly

#(define (sn:chord-map function music)
   "Same as lilypond music-map, but doesn't recurse into chords"
   (let ((es (ly:music-property music 'elements))
         (e (ly:music-property music 'element))
         (name (ly:music-property music 'name)))
     (if (not (eqv? name 'EventChord))
         (begin
          (if (pair? es)
              (set! (ly:music-property music 'elements)
                    (map (lambda (y) (sn:chord-map function y)) es)))
          (if (ly:music? e)
              (set! (ly:music-property music 'element)
                    (sn:chord-map function  e)))))
     (function music)))


fixStems = #(define-music-function (parser location music) (ly:music?)
              "Fix stems on whole notes (always pointing down)"
              (sn:chord-map (lambda (m)
                              (if (and (memq (ly:music-property m 'name) '(EventChord NoteEvent)) ; EventChord or NoteEvent
                                       (not (ly:moment<? (ly:music-length m) (ly:make-moment 1 1)))) ; whole note or longer
                                  ; force stems down
                                  (make-sequential-music (list #{ \once \stemDown #} m))
                                  ; else return music as-is
                                  m))
                music))

