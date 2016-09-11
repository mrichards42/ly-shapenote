% Utility functions for shapenote.ly

#(define (is-empty music)
   "Does this music have no duration?"
   (= 0 (ly:moment-main-numerator (ly:music-length music))))


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


% not-last-page for the header (for symmetry with not-first-page)
#(define (not-last-page layout props arg)
   (if (and (chain-assoc-get 'page:is-bookpart-last-page props #f)
            (chain-assoc-get 'page:is-last-bookpart props #f))
       empty-stencil
       (interpret-markup layout props arg)))

