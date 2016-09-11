Lilypond templates for shape-note music

Write music and lyrics; the heavy lifting is done for you.

# Score output

The layout template takes care of some shape-note standards:

* Repeats with four dots
* Removing brackets over alternate endings
* Forcing hyphens to appear in lyrics
* Multi-page headings ("Continued" and "Concluded")
* Adjustments to the default note, lyric, and staff size and weights.


### Repeats and D.C.

A repeat mark can be placed at the beginning of the piece by adding an explicit `\bar`.

D.C. can be indicated using two markup commands: `\dc` and `\fine`.

```lilypond
% examples/pardoning_love.ly
tenorMusic = \relative do' {
  \bar ".;"                 % Explicit beginning repeat mark
  \repeat volta 2 {
    % [music]
    \fine                   % "Fine." markup
  }
  \time 6/4
  % [music]
  \bar "|."                 % Explicit ending bar
  \dc                       % "D.C." markup
}
```

D.C. can be indicated in the lyrics using `\stanzaDC`.


# Midi output

A separate (hidden) score is created for midi output, which does the following:

* Lowers the pitch a whole step, to approximate the key the music would be sung in.
* Unfolds repeats and D.C. (as long as you used `\dc` and `\fine`).
* Attempts to accent the music in sacred harp style with primary and secondary accents, according to the time signature.
    * This works by attaching dynamics to each note based on where it falls in the measure
    * The amount of accent can be adjusted:
        ```lilypond
        % These are the default settings
        \setAccentDynamics "ff" "f" "mp"   % primary, secondary, unaccented
        ```


Parts can be muted:
```lilypond
trebleMusic = \relative do' {
  \mute
  sol'2 sol4 mi mi4 sol do do do2
}
```

Or a single part can solo:
```lilypond
trebleMusic = \relative do' {
  \solo
  sol'2 sol4 mi mi4 sol do do do2
}
```