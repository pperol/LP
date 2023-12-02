\version "2.25.10"
\include "../../../0 tools/myTools25.ily"
\include "../../../0 tools/myComposers.ily"
\clefGScore
#(set-global-staff-size 18)
%\pointAndClickOff

voixUn = {
  \set fingeringOrientations = #'(left)
  \set strokeFingerOrientations = #'(up)
  \override StrokeFinger.add-stem-support = ##t
  \set stringNumberOrientations = #'(right)
  | % mes.1
    r4 r8 <g-1\5 cis'-3-\tweak extra-offset #'(0 . .3)\4 a'-2\2\ap\ai\aa>4.
  | % mes.2
    \set fingeringOrientations = #'(up)
    \override Fingering.add-stem-support = ##f
    \override Fingering.X-offset = #-.5
    r4 r8 
    \stringNumberSpanner #UP #2 
    <a'-2>\startTextSpan <b'-\tweak extra-offset #'(0 . -.3)-4\ai> <a'\glissFour\am>\stopTextSpan
  | % mes.3
    \slashedGrace fis8 \glissando a4. 8 b a
  | % mes.4
    a4. 8 b cis'
  | % mes.5
    d'4. 8 e' d'
  | % mes.6
    d'4. 8 e' fis'
  | % mes.7
    g'4. fis'8 e' g'
  | % mes.8
    fis'4. b8 cis' d'
  | % mes.9
    e'4. 8 fis' d' \glissando
  | % mes.10
    \slashedGrace e'8 8 b d' cis' b a\harmonic
  | % mes.11
    \slashedGrace fis8 \glissando a4. 8 b a
  | % mes.12
    a4. 8 b cis'
  | % mes.13
    d'4. 8 e' d'
  | % mes.14
    b'4. e'8 fis' g'\glissando
  | % mes.15
    \slashedGrace a'8 4.  b'8 cis'' d'' 
  | % mes.16
    a'4. b'8 cis'' d'' \glissando
  | % mes.17
    \slashedGrace a'8 \once\dotsDown 4. 4.
    \mark\markup\fontsize #2 \coda \bar "||"
| % mes.18
    <fis d' a'>4. a'8 b' a'
  | % mes.19
    <fis d' a'>4. cis'
  | % mes.20
    d'4. <a cis'>
  \tempo \markup\normal-text\italic "ritmico"
  \repeat volta 2 {
      | % mes.21
        fis4 b8 g4 b8
      | % mes.22
        fis4 b8 g4 b8
      | % mes.23
        fis4 b8 e a g
      | % mes.24
        fis8 g_( e) fis ais cis'
      | % mes.25
        fis'4 8 d' fis' d'
      | % mes.26
        e'4 8 cis' e' cis' \glissando
      | % mes.27
        d'4 8 b b'\harmonic g'\harmonic
      | % mes.28
        <b e'>4 r8 b8 e'\glissando g'
      | % mes.29
        g'4. fis'8 e' g'
      | % mes.30
        fis'4. b8 cis' d'
    }
    \alternative {
      {
          | % mes.31
            e'4. cis'
          | % mes.32
            cis'8 ais fis fis4.
      }
      {
          | % mes.33
            e'4. fis'
          | % mes.34
            <fis d'>4. r4 r8
      }
    }
    | % mes.35
      a'8\rest e' a'~ a'4 e''8
    | % mes.36
      d''8 cis''_( b') a' g' fis'
    | % mes.37
      g'16 fis' e'8 b \appoggiatura { cis'16 d' } cis'8 b a
    | % mes.38
      b4. 8 cis' a
    | % mes.39
      b4. 8 cis' \glissando a
    | % mes.40
      fis4. eis
    | % mes.41
      fis4. eis8 fis gis
    | % mes.42
      a4 fis'8 eis'4.
    | % mes.43
      fis'4. eis'8 fis' gis' \glissando
    | % mes.44
      fis'4. eis'
    | % mes.45
      r4 r8 e'! fis' g' \glissando
    | % mes.46
      d'4. r4 r8
    | % mes.47
      r4 r8 e' f' \glissando d'
    | % mes.48
      c'4. 8 e' a'~  
    | % mes.49
      a'8 a' b' \appoggiatura { a'16 b' } <f' a'>8 f' b
    | % mes.50
      r4 r8 c' e' a'~ 
    | % mes.51
      a'8 a' b' \appoggiatura { a'16 b' } <f' a'>8 f' b
    | % mes.52
      \mergeDifferentlyDottedOn
      a, e a c' e' a'
    | % mes.53
      g,8 e a cis'! e' a'\harmonic
    | % mes.54
      fis,8 ees a c' ees' a'\harmonic
    | % mes.5
      f,8 d g b d' a'\harmonic
    | % mes.56
      e,8 cis! g b \glissando cis' a'\fermata \harmonic 
    \bar "||"
    \tweak direction #DOWN
    \tweak self-alignment-X #RIGHT
    \mark\markup\fontsize #-3 { "D.C. al" \lower #.3 \large\coda "y Final." } 
}

voixDeux = {
  \set strokeFingerOrientations = #'(down)
  \override StrokeFinger.add-stem-support = ##t
  | % mes.1
    <d,-\ap>4. r4 r8
  | % mes.2
    <d,-\ap>4. r4 b,8\rest
  | % mes.3
    d,4. r4 r8
  | % mes.4
    d,4. r4 r8
  | % mes.5
    fis,4. r4 r8
  | % mes.6
    g,4. r4 r8
  | % mes.7
    b,4. r4 r8
  | % mes.8
    b,4. r4 r8
  | % mes.9
    b,4. r4 r8
  | % mes.10
    a,4. g!
  | % mes.11
    d,4. r4 r8
  | % mes.12
    d,4. r4 r8
  | % mes.13
    fis,4. r4 r8
  | % mes.14
    g,4. r4 r8
  | % mes.15
    fis4. <e d' g'>
  | % mes.16
    fis4. <g b>
  | % mes.17
    <a, fis>4. g
  | % mes.18
    \once\override NoteColumn.force-hshift = #.3
    d,4. r4 r8
  | % mes.19
    \once\override NoteColumn.force-hshift = #.3
    d,4. g
  | % mes.20
    fis4. fis8 g fis
  \repeat volta 2 {
      | % mes.21
        d8( b,) r e( cis) r
      | % mes.22
        d8( b,) r e( cis) r
      | % mes.23
        d8( b,) r cis4.
      | % mes.24
        d4. cis
      | % mes.25
        d,4. r4 r8
      | % mes.26
        e,4. r4 r8
      | % mes.27
        d,4. r4 r8
      | % mes.28
        cis8 e \glissando g r4 r8
      | % mes.29
        g,4. r4 r8
      | % mes.30
        a,4. fis4 e8\rest
    }
    \alternative {
      {
          | % mes.31
            e,4. g,
          | % mes.32
            fis,4. ais,8 b, cis
      }
      {
          | % mes.33
            e,4. a,
          | % mes.34
            \once\override NoteColumn.force-hshift = #.3
            d,4. fis,8 a, d
      }
    }
    | % mes.35
      fis4.cis4.
    | % mes.36
      d4. <dis c'>
    | % mes.37
      e4 a,8\rest a,4 r8
    | % mes.38
      d,4. g4.
    | % mes.39
      d,4. eis4 r8
    | % mes.40
      fis,8 a, cis d4.
    | % mes.41
      fis,8 a, cis d4.
    | % mes.42
      fis,4. r4 r8
    | % mes.43
      fis,4. r4 r8
    | % mes.44
      d8 gis bis cis gis cis'
    | % mes.45
      ais,8 g! cis' r4 r8
    | % mes.46
      b,8 fis b! a,! f b
    | % mes.47
      \slashedGrace f,8 g,4.~ 4 a,8\rest
    | % mes.48
      a,4. r4 r8
    | % mes.49
      d,4. r4 r8
    | % mes.50
      a,4. r4 r8
    | % mes.51
      d,4. r4 r8
    | % mes.52
      a,4. r4 r8
    | % mes.53
      g,4. r4 r8
    | % mes.54
      fis,4. r4 r8
    | % mes.55
      f,4. r4 r8
    | % mes.56
      e,4. r4 r8
    \bar "||"
}

voixTrois = {
  \set strokeFingerOrientations = #'(down)
  \override StrokeFinger.add-stem-support = ##t
  \set fingeringOrientations = #'(down)
  \override Fingering.add-stem-support = ##f
  \override Fingering.X-offset = #.5
  | % mes.1
    g8\rest <a,\ap> <fis-1\ap> s4.
  | % mes.2
    g8\rest <a,\ap> <fis-1\ap> -\markup\italic\small "poco rall."
    \once\set fingeringOrientations = #'(right)
    <g-1 cis'-3>4.
  | % mes.3
    e8\rest a, fis g4.
  | % mes.4
    e8\rest a, fis g4.
  | % mes.5
    g8\rest d a ais4.
  | % mes.6
    g8\rest d b cis'4.
  | % mes.7
    g8\rest g d' d'4.
  | % mes.8
    g8\rest fis d' s4.
  | % mes.9
    g8\rest fis d' gis4.
  | % mes.10
    s2.
  | % mes.11
    c8\rest a, fis g4.
  | % mes.12
    c8\rest a, fis g4.
  | % mes.13
    g8\rest d a cis'4.
  | % mes.14
    g8\rest d g cis'4.
  | % mes.15
    c'8\rest cis' e' s4.
  | % mes.16
    \stemUp cis'8 d' cis' s4.
  | % mes.17
    e'8 d' b \appoggiatura { cis'16 d' } cis'8 b cis'
  | % mes.18
    \once\override NoteColumn.force-hshift = #.3
    d,8 a, fis \once\stemDown <g cis'>4.
  | % mes.19
    \once\override NoteColumn.force-hshift = #.3
    d,8 a, fis \stemUp a b a
  | % mes.20
    a8 b a s4.
  \repeat volta 2 {
      | % mes.21-24
        s2.*4
      | % mes.25
        \stemDown
        g8\rest  fis4~ <fis b>4.
      | % mes.26
        g8\rest g4 b4.
      | % mes.27
        g8\rest fis d' s4.
      | % mes.28
        s2.
      | % mes.29
        g8\rest d bes s4.
      | % mes.30
        g8\rest d8 e s4.
    }
    \alternative {
      {
          | % mes.31
            g8\rest g b e\rest e b
          | % mes.32
            s2.
      }
      {
          | % mes.33
            g8\rest gis d' g\rest g cis'
          | % mes.34
            \once\override NoteColumn.force-hshift = #.3
            \stemUp
            d,8 a, b, s4.
      }
    }
    | % mes.35
      \stemDown
      c'8\rest cis' g' b\rest a g'
    | % mes.36
      b8\rest fis'4 s4.
    | % mes.37
      b4 e8\rest g e8\rest s
    | % mes.38
      e8\rest a, fis s4.
    | % mes.39
      e8\rest a, fis s4.
    | % mes.40
      s2.
    | % mes.41
      s2.
    | % mes.42
      e8\rest cis a b4.
    | % mes.43
      g8\rest cis a b4.
    | % mes.44
      s2.
    | % mes.45
      s2.
    | % mes.46
      s2.
    | % mes.47
      g8\rest e b g4\rest g8\rest
    | % mes.48
      e8\rest e a s4.
    | % mes.49
      b4\rest b8\rest b4 s8
    | % mes.50
      g8\rest e a s4.
    | % mes.51
      b4\rest b8\rest b4 s8
    | % mes.52-56
      s2.* 5
    \bar "||"
}

codaVoixUn = {
    | % mes.57
      <fis d' a'>4. a'8 b' a'
    | % mes.58
      a'4. r4 r8
    | % mes.59
      \stemNeutral
      \har d'8 \har fis' \har a' \har d'' \har fis'' \har a''
    | % mes.60
      \har <d'''>4.\p \har<fis' a' d''>\pp
    | % mes.61
      \har <d d'>2.\fermata\ppp
    \bar "|."  
}

codaVoixDeux = {
    | % mes.57
      d,4. r4 r8
    | % mes.58
      d,8 fis, a, d fis \har a 
    | % mes.59-61
      s2.*3
    \bar "|."  
}

codaVoixTrois = {
    | % mes.57
      c8\rest a, fis <g cis'>4.
    | % mes.58-61
      s2. *4
    \bar "|."  
}

global = { 
  \clef "G_8"
  \time 6/8
  \key d\major
  \tempo Cantabile %\markup\small\normal-text { \concat { 6 \fontsize #-3 \raise #.7 a } em Ré }
  s2.*20 \bar ".|:-||" \break
}

\paper {
  page-count = 2
  ragged-last-bottom = ##f
  %score-system-spacing.basic-distance = 0
  score-markup-spacing.basic-distance = 2
}

\layout {
  indent = 8
  \context {
    \Score
    \override BarNumber.font-shape = #'italic
    \override BarNumber.font-size = #-3
    \override BarNumber.X-offset = #-.5
  }
}

\header {
  title = "Julia Florida"
  composer = \Barrios
  subsubtitle = "Barcarola"
  piece = \markup\column {
    \line\italic\fontsize #-1 { La \concat { 6 \teeny\raise #.6 a } corda en Ré. }
    \vspace #-10
  }
  dedication = \markup
    \override #'(baseline-skip . 2)
    \center-column \italic \fontsize #-2 {
      "A mi inteligente y muy estimada discípula," 
      "la distinguida señorita Julia Florida Martínez"
      \vspace #.5
    }
  tagline = ""
}

\score {
  \new Staff <<
    \new Voice \global
    \new Voice { \voiceOne  \voixUn }
    \new Voice { \voiceTwo  \voixDeux }
    \new Voice { \voiceFour \voixTrois }
  >>
  \layout {
    system-count = 13
  }
  \midi {}
}

globalCoda = { 
  \clef "G_8"
  \time 6/8
  \key d\major
  \set Score.currentBarNumber = 57 \bar ""
  \omit Staff.TimeSignature
}

\score {
  \new Staff <<
    \new Voice { \voiceOne  \globalCoda \codaVoixUn }
    \new Voice { \voiceTwo  \globalCoda \codaVoixDeux }
    \new Voice { \voiceFour \globalCoda \codaVoixTrois }
  >>
  \layout {
    system-count = 1
    ragged-right = ##f
  }
  \header {
    piece = "Final"
  }
}