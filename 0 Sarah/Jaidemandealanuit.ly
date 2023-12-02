\version "2.24.0"
\include "myTools23.ily"
\clefGBaeren

accords = \chordmode {
  \frenchChords
  \partial 8 s8 
  e1:m a2:m b:7+ b1:7+ e:m a2:m e:m a:m d s g4 a:m b1:7+
  e1:m a2:m b:7+ b1:7+ e:m a2:m e:m a:m d g b:7+ 
  
  e1:m
  \mark\markup\fontsize #3 \segno 
  e1:m
}

voixUn = \fixed c' {
  \key e\minor
  \stemUp
  \partial 8 b,8 \mark\markup\fontsize #3 \segno 
  \repeat volta 3 {
  e fis g e~ e4 fis8 g
    a8 b a fis~ fis4 b,8 b, fis8 g a b~ b a g fis g2~ 4 e8 e e' d' c' b~ b4 e8 e
    c'8 b a d'8~ 4 c'8 b c' b a g b a g a fis2~ 4 r8 b, e8 fis g e8~ 4 fis8 g a b 
    a fis8~ 4 b,8 b, fis g a b~ b a g fis b2~ 4 e8 e e' d' c' b8~ 4 e8 8 c' b a 
    d'8~ 4 c'8 b c'8 b a g b a cis dis
  }
  \alternative {
    { e2. r8 b }
    { e1 }
  }
  \bar "|."
}

paroles = \lyricmode {
  J'ai dit à la nuit de dor -- mi a -- vec moi __ 
  D'ef -- fa -- cer  les cou -- leurs de l'arc en ciel
  Et de pren -- dre ma main __ jus -- qu'aux ri -- ves du rêve
  Où du vent souf -- fle sans trê -- ve les cla -- meurs
  J'ai pri -- é la nuit __ de m'of -- frir des pa -- lais 
  D'a -- bri -- ter mon cœur frê __ "- le" dans leur cœur
  De ber -- cer mon ex -- il par des chan -- sons se -- crètes __ 
  qui cap -- ti -- vent sen -- ti -- nel -- les et vo -- leurs 
  J'ai " - leil."
}

voixDeux = \fixed c' {
  \key e\minor
  \partial 8 r8 
  \repeat volta 3 {
    b2~ 4 a8 b c'2 a2~ 8 fis b a b4 e e' d' c'2 b
    b c'2 a r4 
    \shape #'((-.7 . 0.5) (-.7 . 0.5) (0 . -1) (0 . -1)) PhrasingSlur
    fis\( g c' b2~ 4\) r 
    \shape #'((0 . -1) (0 . 0) (0 . 0) (0 . -1)) PhrasingSlur
    b2\( ~ 4 a8 b c'2 b\) 
    \shape #'(
               ((0 . -.5) (0 . -0.5) (0 . -0.5) (0 . -1))
               ((-.5 . -2.5) (-.5 . -2.5) (.5 . -2.5) (.5 . -2.5))
               ) PhrasingSlur
    a2~_\( 8 fis b a b4\) \tweak extra-offset #'(-3 . 0) \tweak font-size #3 \breathe 
    e4\( e' d'\) c'2\( b c' a2~ \) 4 \tweak extra-offset #'(-6 . 0) \tweak font-size #3 \breathe 
   \shape #'((0 . 0) (0 . 0) (21 . 0) (21 . 0)) PhrasingSlur
    b4\( g fis\) 
  }
  \alternative {
    { e2. r4 } { e1 }
  }
}

\pointAndClickOff
#(set-global-staff-size 15)
\paper {
  page-count = 1
  system-count = 6
  ragged-last-bottom = ##f
}

\header {
  title = "J'ai dit à la nuit"
  subtitle =  \markup\normal-text { "Extrait de la Comédie musicale"  \italic "l'Iliade" "(1986)" }
  poet = \markup \override #'(baseline-skip . 3 )\center-column {
    \italic "Paroles" "Anne Plassard"
  }
  composer = \markup \override #'(baseline-skip . 3 )\center-column {
    \italic "Musique" "Thierry Cerisier" \vspace #1
  }
  tagline = ""
}

\score {
  <<
    \new ChordNames \accords
    \new StaffGroup <<
      \new Voice \voixUn
      \addlyrics \paroles
      \new Staff \voixDeux
    >>
  >>
  \layout {
    \revert Slur.after-line-breaking
    \revert PhrasingSlur.after-line-breaking
    \revert Tie.after-line-breaking
  }
}
\markup\raise #5 \fill-line \fontsize #1 {
  \hspace #1
  \center-column {
    \bold 2. 
    \line { J'ai dit aux forêts de dormir avec moi }
    \line { D'inviter les oiseaux des sources vives } 
    \line { À chanter les minuits sur la cîme des chênes } 
    \line { À rejoindre par leurs cris les cris du ciel. } 
    \line { J'ai dit aux forêts de rêver avec moi } 
    \line { D'oublier les lisières et les prairies } 
    \line { Les forêts ont dit oui, m'ont livré leur poème } 
    \line { Sur leur peau de mousse et d'ombre j'ai dormi. }
    \vspace #2
  }
  \hspace #7
  \center-column {
    \bold 3. 
    \line { J'ai dit à la mer de dormir avec moi }
    \line { De partir avec moi chercher le rêve} 
    \line { D'abandonner les grèves, de déserter les îles} 
    \line { De laisser son flot d'épaves aux naufrageurs.} 
    \line { J'ai dit à la mer de venir avec moi } 
    \line { De noyer son mystère à l'horizon } 
    \line { Et la mer m'a dit oui en dessinant sur elle } 
    \line { Un sourire, deux lèvres bleues sans soleil. }
  }
  \hspace #1
}