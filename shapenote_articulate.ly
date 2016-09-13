\version "2.19.2"
\include "articulate.ly"

% Apply shape note articulations

% Globals
#(define sn:debug #f)
#(define sn:beat (ly:make-moment 0))
#(define sn:beatsPerMeasure #f)
#(define sn:accentedBeats #f)
#(define sn:accentHash '(("2/2" . ((0/2 . primary) (1/2 . secondary)))
                         ("2/4" . ((0/4 . primary)))
                         ("4/4" . ((0/4 . primary) (2/4 . secondary)))
                         ("3/2" . ((0/2 . primary) (2/2 . secondary)))
                         ("3/4" . ((0/4 . primary) (2/4 . secondary)))
                         ("6/4" . ((0/4 . primary) (3/4 . secondary)))
                         ("6/8" . ((0/8 . primary) (3/8 . secondary)))))

#(define fermataFactor 2) % How much to scale fermatas? (configurable)
#(define sn:accentDynamics '())
#(define sn:tempoCount #f)
#(define sn:dcMusic (list))
#(define sn:dcStartBeat (ly:make-moment 0)) % The first beat of the DC
#(define sn:dcEndBeat (ly:make-moment 500)) % One beat past the last beat of the DC (default to an absurdly high value
#(define sn:hasDC #f)

#(define (add-to-dc music nextBeat)
   ; Add to DC
   (if (and
        (or (equal? sn:dcStartBeat sn:beat) (ly:moment<? sn:dcStartBeat sn:beat))
        (or (equal? nextBeat sn:dcEndBeat)  (ly:moment<? nextBeat sn:dcEndBeat)))
       (set! sn:dcMusic (append sn:dcMusic (list (ly:music-deep-copy music))))))

% Find markup text
#(define (sn:markupText music)
   (let loop ((label (ly:music-property music 'label)))
     (if (list? label)
         (if (= 1 (length label))
             (loop (car label))  ; Bounce between car and cdr
             (loop (cdr label))) ; until this isn't a list
         label)))

% Find an articulation by type (expects event-chord-wrap!'ed music)
#(define (sn:find-articulation music type)
  (let loop ((elements (ly:music-property music 'elements)))
    (if (pair? elements)
          (let ((e (car elements)))
            (if (equal? (ly:music-property e 'articulation-type) type)
                e
                (loop (cdr elements))))
          #f)))

% Apply articulations on a per-note basis
#(define (sn:articulate music)
   ;(ly:warning (_ "name: ~a, duration: ~a") (ly:music-property music 'name) (ly:music-length music))

   (if sn:debug (ly:warning (_ "name: ~a") (ly:music-property music 'name)))

   (case (ly:music-property music 'name)

     ((TimeSignatureMusic)
      (let* ((numer (ly:music-property music 'numerator))
             (denom (ly:music-property music 'denominator))
             (timeSig (format #f "~a/~a" numer denom)))

        ; Update beats per measure (moment) and accentedBeats (alist)
        (set! sn:beatsPerMeasure (ly:make-moment numer denom))
        (set! sn:accentedBeats (assoc-ref sn:accentHash timeSig))

        (if sn:debug (ly:warning (_ "TIME SIGNATURE: ~a") timeSig))
        (if sn:debug (ly:warning (_ "accents: ~a") sn:accentedBeats))

        ; Make sure this is a valid time signature
        (if (not sn:accentedBeats)
            (ly:error (_ "Unknown shape note time signature: ~a") timeSig))))
     

     ((EventChord)
      (let* ((beat (ly:moment-mod sn:beat sn:beatsPerMeasure))
             (beatFraction (/ (ly:moment-main-numerator beat) (ly:moment-main-denominator beat)))
             (accentType(or (assoc-ref sn:accentedBeats beatFraction) 'none))
             (dynamic (assoc-ref sn:accentDynamics accentType)))

        ; Make sure we have a time signature
        (if (not sn:beatsPerMeasure)
            (ly:error "Music encountered before a time signature.  I don't know how to accent this."))

        (if sn:debug (ly:warning (_ "beat: ~a, ~a: ~a") beatFraction accentType dynamic))
        ; Set the dynamic
        (set! (ly:music-property music 'articulations)
              (cons (make-music 'AbsoluteDynamicEvent 'text dynamic)
                (ly:music-property music 'articulations)))
        ; Next beat
        (let* ((nextBeat (ly:moment-add sn:beat (ly:music-length music))))
          (add-to-dc music nextBeat)
          ; Add this note's duration to the beat counter
          (set! sn:beat nextBeat))

        ; Check for fermata
        (if (sn:find-articulation music "fermata")
            ; Change tempo around the fermata
            (let ((slowTempo (inexact->exact (floor (/ sn:tempoCount fermataFactor))))
                  (normalTempo (inexact->exact (floor sn:tempoCount))))
              (set! music (make-sequential-music (list #{ \tempo 4 = #slowTempo #} music #{ \tempo 4 = #normalTempo #})))))))

     ((TempoChangeEvent)
      (add-to-dc music sn:beat)
      ; tempoCount is scaled assuming tempo-unit is 4
      (let* ((moment (ly:duration-length (ly:music-property music 'tempo-unit)))
             (n (ly:moment-main-numerator moment))
             (d (ly:moment-main-denominator moment)))
        (set! sn:tempoCount (* (ly:music-property music 'metronome-count) (/ (/ d n) 4)))))

     ((ContextSpeccedMusic) (add-to-dc music sn:beat))

     ((MarkEvent)
      (case (string->symbol (sn:markupText music))
        ((Fine.)
         (if (ly:moment<? sn:beat sn:dcEndBeat) (ly:warning (_ "GOT FINE at: ~a") sn:beat))
         (if (ly:moment<? sn:beat sn:dcEndBeat) (set! sn:dcEndBeat sn:beat)))
        ((D.C.) 
         (ly:warning "GOT DC")
         (set! sn:hasDC #t))
        (else (ly:warning (_ "Other Markup: ~s") (sn:markupText music))))))
   
   ; Return updated music
   music)


% \shapeNoteArticulate { music }
shapeNoteArticulate = #(define-music-function (parser location music)
                     (ly:music?)
                     ; Reset globals
                     (set! sn:beat (ly:make-moment 0))
                     (set! sn:tempoCount #f)
                     (set! sn:beatsPerMeasure #f)
                     (set! sn:accentedBeats #f)
                     (set! sn:dcMusic (list))
                     ; Accent
                     (let* ((newMusic (music-map sn:articulate (ac:unfoldMusic (event-chord-wrap! (expand-repeat-notes! music) parser)))))
                       (if sn:hasDC
                           (ly:music-set-property! newMusic 'elements
                             (append (ly:music-property newMusic 'elements)
                               (list (make-sequential-music sn:dcMusic)))))
                       newMusic))


setAccentDynamics = #(define-scheme-function (parser location primary secondary unaccented)
                       (string? string? string?)
                       (set! sn:accentDynamics (assoc-set! sn:accentDynamics 'primary primary))
                       (set! sn:accentDynamics (assoc-set! sn:accentDynamics 'secondary secondary))
                       (set! sn:accentDynamics (assoc-set! sn:accentDynamics 'none unaccented)))

\setAccentDynamics "ff" "f" "mp"

debugAccent = #(define-scheme-function (parser location) () (set! sn:debug #t))