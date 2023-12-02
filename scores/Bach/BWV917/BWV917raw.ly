\version "2.25.10"
\include "../../../0 tools/myTools25.ily"
\include "../../../0 tools/myComposers.ily"
%\clefGScore
#(set-global-staff-size 18)
%\pointAndClickOff
%% => https://www.youtube.com/watch?v=FQVcWygRBV8

canevas = {
  | % mes.1
    s1
  | % mes.2
    s1
  | % mes.3
    s1
  | % mes.4
    s1
  | % mes.5
    s1
  | % mes.6
    s1
  | % mes.7
    s1
  | % mes.8
    s1
  | % mes.9
    s1
  | % mes.10
    s1
  | % mes.11
    s1
  | % mes.12
    s1
  | % mes.13
    s1
  | % mes.14
    s1
  | % mes.15
    s1
  | % mes.16
    s1
  | % mes.17
    s1
  | % mes.18
    s1
  | % mes.19
    s1
  | % mes.20
    s1
  | % mes.21
    s1
  | % mes.22
    s1
  | % mes.23
    s1
  | % mes.24
    s1
  | % mes.25
    s1
  | % mes.26
    s1
  | % mes.27
    s1
  | % mes.28
    s1
  | % mes.29
    s1
  | % mes.30
    s1
  | % mes.31
    s1
  | % mes.32
    s1
  | % mes.33
    s1
  | % mes.34
    s1
  | % mes.35
    s1
  | % mes.36
    s1
  | % mes.37
    s1
  | % mes.38
    s1
  | % mes.39
    s1
  | % mes.40
    s1
  | % mes.41
    s1
  | % mes.42
    s1
  | % mes.43
    s1
  | % mes.44
    s1
  | % mes.45
    s1
  | % mes.46
    s1
  | % mes.47
    s1
  | % mes.48
    s1
  | % mes.49
    s1
  | % mes.50
    s1
  | % mes.51
    s1
  | % mes.52
    s1
  | % mes.53
    s1
  | % mes.54
    s1
  | % mes.55
    s1
  | % mes.56
    s1
  | % mes.57
    s1
  | % mes.58
    s1
  | % mes.59
    s1
  | % mes.60
    s1
  | % mes.61
    s1  
}

voixUn = {
  \set fingeringOrientations = #'(left)
  \set strokeFingerOrientations = #'(up)
  \override StrokeFinger.add-stem-support = ##t
  \set stringNumberOrientations = #'(right)
  | % mes.1
    \stemNeutral
    \slurNeutral
    r8 d''\mordent r16 ees''32( d'') c'' bes' a' g' fis'( g') a' d' g'16\noBeam r16 d'8\rest r16 r32 g'
  | % mes.2
    f'!32( ees') d' c' bes a g( fis) g a bes( d) g r r16 r32 g f( ees) d c bes,( a,) g, b\rest b16\rest g8\rest
  | % mes.3
    \stemUp\slurDown
    r2 g
  | % mes.4
    r2 r8 a' f' d'
  | % mes.5
    g'8 f' g' a' g' a' e' g'
  | % mes.6
    f'8 e' f' g' f' g' d' f'
  | % mes.7
    ees'!1
  | % mes.8
    d'2~ 8 c' d' bes
  | % mes.9
    c'2~ 8 bes c' a
  | % mes.10
    bes4 g8 a <bes d>4 <g bes,>
  | % mes.11
    <a d'>4 a d'2~ 
  | % mes.12
    2 cis'
  | % mes.13
    <f d'>4 r bes2~ 
  | % mes.14
    bes a~ 
  | % mes.15
    a4 g'8( fis') g'2~ 
  | % mes.16
    g'2 fis'
  | % mes.17
    g'2 r8 f'! g' a'
  | % mes.18
    bes'8 a' g' f' e' f' g' e'
  | % mes.19
    r4 d'8 e' fis'4 d'
  | % mes.20
    g'4 d' g'2
  | % mes.21
    r2 fis'
  | % mes.22
    r8 g' d' f! ees!2
  | % mes.23
    s1
  | % mes.24
    s1
  | % mes.25
    s1
  | % mes.26
    s1
  | % mes.27
    s1
  | % mes.28
    s1
  | % mes.29
    s1
  | % mes.30
    s1
  | % mes.31
    s1
  | % mes.32
    s1
  | % mes.33
    s1
  | % mes.34
    s1
  | % mes.35
    s1
  | % mes.36
    s1
  | % mes.37
    s1
  | % mes.38
    s1
  | % mes.39
    s1
  | % mes.40
    s1
  | % mes.41
    s1
  | % mes.42
    s1
  | % mes.43
    s1
  | % mes.44
    s1
  | % mes.45
    s1
  | % mes.46
    s1
  | % mes.47
    s1
  | % mes.48
    s1
  | % mes.49
    s1
  | % mes.50
    s1
  | % mes.51
    s1
  | % mes.52
    s1
  | % mes.53
    s1
  | % mes.54
    s1
  | % mes.55
    s1
  | % mes.56
    s1
  | % mes.57
    s1
  | % mes.58
    s1
  | % mes.59
    s1
  | % mes.60
    s1
  | % mes.61
    s1  
}

voixDeux = {
  | % mes.1
    s1
  | % mes.2
    s1
  | % mes.3
    s1
  | % mes.4
    s1
  | % mes.5
    s1
  | % mes.6
    s1
  | % mes.7
    s1
  | % mes.8
    s1
  | % mes.9
    s1
  | % mes.10
    s1
  | % mes.11
    s1
  | % mes.12
    s1
  | % mes.13
    s1
  | % mes.14
    s1
  | % mes.15
    s1
  | % mes.16
    s1
  | % mes.17
    s1
  | % mes.18
    s1
  | % mes.19
    s1
  | % mes.20
    s1
  | % mes.21
    s1
  | % mes.22
    s1
  | % mes.23
    s1
  | % mes.24
    s1
  | % mes.25
    s1
  | % mes.26
    s1
  | % mes.27
    s1
  | % mes.28
    s1
  | % mes.29
    s1
  | % mes.30
    s1
  | % mes.31
    s1
  | % mes.32
    s1
  | % mes.33
    s1
  | % mes.34
    s1
  | % mes.35
    s1
  | % mes.36
    s1
  | % mes.37
    s1
  | % mes.38
    s1
  | % mes.39
    s1
  | % mes.40
    s1
  | % mes.41
    s1
  | % mes.42
    s1
  | % mes.43
    s1
  | % mes.44
    s1
  | % mes.45
    s1
  | % mes.46
    s1
  | % mes.47
    s1
  | % mes.48
    s1
  | % mes.49
    s1
  | % mes.50
    s1
  | % mes.51
    s1
  | % mes.52
    s1
  | % mes.53
    s1
  | % mes.54
    s1
  | % mes.55
    s1
  | % mes.56
    s1
  | % mes.57
    s1
  | % mes.58
    s1
  | % mes.59
    s1
  | % mes.60
    s1
  | % mes.61
    s1  
}

voixTrois = {
  | % mes.1
    s1
  | % mes.2
    s1
  | % mes.3
    s1
  | % mes.4
    s1
  | % mes.5
    s1
  | % mes.6
    s1
  | % mes.7
    s1
  | % mes.8
    s1
  | % mes.9
    s1
  | % mes.10
    s1
  | % mes.11
    s1
  | % mes.12
    s1
  | % mes.13
    s1
  | % mes.14
    s1
  | % mes.15
    s1
  | % mes.16
    s1
  | % mes.17
    s1
  | % mes.18
    s1
  | % mes.19
    s1
  | % mes.20
    s1
  | % mes.21
    s1
  | % mes.22
    s1
  | % mes.23
    s1
  | % mes.24
    s1
  | % mes.25
    s1
  | % mes.26
    s1
  | % mes.27
    s1
  | % mes.28
    s1
  | % mes.29
    s1
  | % mes.30
    s1
  | % mes.31
    s1
  | % mes.32
    s1
  | % mes.33
    s1
  | % mes.34
    s1
  | % mes.35
    s1
  | % mes.36
    s1
  | % mes.37
    s1
  | % mes.38
    s1
  | % mes.39
    s1
  | % mes.40
    s1
  | % mes.41
    s1
  | % mes.42
    s1
  | % mes.43
    s1
  | % mes.44
    s1
  | % mes.45
    s1
  | % mes.46
    s1
  | % mes.47
    s1
  | % mes.48
    s1
  | % mes.49
    s1
  | % mes.50
    s1
  | % mes.51
    s1
  | % mes.52
    s1
  | % mes.53
    s1
  | % mes.54
    s1
  | % mes.55
    s1
  | % mes.56
    s1
  | % mes.57
    s1
  | % mes.58
    s1
  | % mes.59
    s1
  | % mes.60
    s1
  | % mes.61
    s1  
}

voixQuatre = {
  | % mes.1
    s1
  | % mes.2
    s1
  | % mes.3
    s1
  | % mes.4
    s1
  | % mes.5
    s1
  | % mes.6
    s1
  | % mes.7
    s1
  | % mes.8
    s1
  | % mes.9
    s1
  | % mes.10
    s1
  | % mes.11
    s1
  | % mes.12
    s1
  | % mes.13
    s1
  | % mes.14
    s1
  | % mes.15
    s1
  | % mes.16
    s1
  | % mes.17
    s1
  | % mes.18
    s1
  | % mes.19
    s1
  | % mes.20
    s1
  | % mes.21
    s1
  | % mes.22
    s1
  | % mes.23
    s1
  | % mes.24
    s1
  | % mes.25
    s1
  | % mes.26
    s1
  | % mes.27
    s1
  | % mes.28
    s1
  | % mes.29
    s1
  | % mes.30
    s1
  | % mes.31
    s1
  | % mes.32
    s1
  | % mes.33
    s1
  | % mes.34
    s1
  | % mes.35
    s1
  | % mes.36
    s1
  | % mes.37
    s1
  | % mes.38
    s1
  | % mes.39
    s1
  | % mes.40
    s1
  | % mes.41
    s1
  | % mes.42
    s1
  | % mes.43
    s1
  | % mes.44
    s1
  | % mes.45
    s1
  | % mes.46
    s1
  | % mes.47
    s1
  | % mes.48
    s1
  | % mes.49
    s1
  | % mes.50
    s1
  | % mes.51
    s1
  | % mes.52
    s1
  | % mes.53
    s1
  | % mes.54
    s1
  | % mes.55
    s1
  | % mes.56
    s1
  | % mes.57
    s1
  | % mes.58
    s1
  | % mes.59
    s1
  | % mes.60
    s1
  | % mes.61
    s1  
}

global = { 
  \clef "G_8"
  \key g\minor
  s1*61 
  \bar "|."
}

\paper {
  page-count = 2
  ragged-last-bottom = ##f
  %score-system-spacing.basic-distance = 0
  score-markup-spacing.basic-distance = 3
}

\layout {
  indent = 8
}

\header {
  title = "Fantasia in G-moll"
  subsubtitle = "(Fantasia duobus subjectis)"
  opus = \markup { "BWV 917" \smaller\italic "(1708)" }
  composer = \Bach
  piece = \markup\italic\fontsize #-1 { \smaller\circle\number 6 en Ré. }
  tagline = ""
  %opus = "(1938)"
}

\score {
  \new Staff <<
    \new Voice \global
    \new Voice { \voiceOne  \voixUn }
    \new Voice { \voiceTwo  \voixDeux }
    \new Voice { \voiceThree \voixTrois }
    \new Voice { \voiceFour \voixQuatre }
  >>
  \layout {
    system-count = 15
  }
  \midi {}
}