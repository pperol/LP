\version "2.18.2"

% preliminary LilyJAZZ version for testing purposes

\paper { 
  indent = #0 
  %{
      #(define fonts
        (make-pango-font-tree ""LilyJAZZText"
                          "Nimbus Sans"
                          "Luxi Mono"
                           (/ staff-height pt 20)))
  %}
  bookTitleMarkup = 
  \markup {
    \column {
        \line {
          \fill-line {
          \override #'(font-name . "LilyJAZZText") 
          \fontsize #7 \fromproperty #'header:title
          }
        }
        \line {
          \fill-line {
            \override #'(font-name . "LilyJAZZText") 
            \fontsize #4 \fromproperty #'header:subtitle
          }
        }
        \line {
          \fill-line {
            \override #'(font-name . "LilyJAZZText") 
            \fontsize #0 \fromproperty #'header:subsubtitle
          }
        }
        \line {
          \fill-line {
            \null
            \override #'(font-name . "LilyJAZZText") 
            \fontsize #4 \fromproperty #'header:composer
          }
        }
        \line {
          \fill-line {
            \override #'(font-name . "LilyJAZZText") 
            \fontsize #4 \fromproperty #'header:poet
            \override #'(font-name . "LilyJAZZText") 
            \fontsize #4 \fromproperty #'header:arranger
          }
        }
    }
  }
  scoreTitleMarkup = \markup { 
    \override #'(font-name . "LilyJAZZText") 
    \fontsize #4
    \scoreTitleMarkup 
  }
}

%***********************************************************************
% MAPPING ALISTS / LOOKUP TABLES
%***********************************************************************

% MAPPING ALIST: GLYPH NAME TO UNICODE CHAR NUMBER =====================
#(define jazz-map '(
    ("noteheads.s0jazz" . #xe191) 
    ("noteheads.s1jazz" . #xe192)
    ("noteheads.s2jazz" . #xe193)
    ("noteheads.s0slashjazz" . #xe19c)
    ("noteheads.s1slashjazz" . #xe19d)
    ("noteheads.s2slashjazz" . #xe19e)
    ("noteheads.s2crossjazz" . #xe1a1)
    ("flags.u3jazz" . #xe21c)
    ("flags.u4jazz" . #xe21d)
    ("flags.u5jazz" . #xe21e)
    ("flags.u6jazz" . #xe21f)
    ("flags.u7jazz" . #xe220)
    ("flags.d3jazz" . #xe221)
    ("flags.d4jazz" . #xe222)
    ("flags.d5jazz" . #xe223)
    ("flags.d6jazz" . #xe224)
    ("flags.d7jazz" . #xe225)
    ("flags.ugracejazz" . #xe226)
    ("flags.dgracejazz" . #xe227)
    ("dots.dot" . #xe131)
    ("accidentals.doublesharpjaz" . #xe126)
    ("accidentals.sharpjazz" . #xe10f)
    ("accidentals.naturaljazz" . #xe117)
    ("accidentals.flatjazz" . #xe11b)
    ("accidentals.flatflatjazz" . #xe124)
    ("accidentals.rightparenjaz" . #xe127)
    ("accidentals.leftparenjazz" . #xe128)
    ("rests.mmendjazz" . #xe0f8)
    ("rests.0jazz" . #xe100)
    ("rests.1jazz" . #xe101)
    ("rests.0ojazz" . #xe102)
    ("rests.1ojazz" . #xe103)
    ("rests.2jazz" . #xe108)
    ("rests.3jazz" . #xe10a)
    ("rests.4jazz" . #xe10b)
    ("rests.5jazz" . #xe10c)
    ("rests.6jazz" . #xe10d)
    ("rests.7jazz" . #xe10e)
    ("clefs.Fjazz" . #xe170)
    ("scripts.ufermatajazz" . #xe132)
    ("scripts.dfermatajazz" . #xe133)
    ("scripts.asteriskjazz" . #xe138)
    ("scripts.sforzatojazz" . #xe13b)
    ("scripts.esprjazz" . #xe13c)
    ("scripts.staccatojazz" . #xe13d)
    ("scripts.tenutojazz" . #xe140)
    ("scripts.uportatojazz" . #xe141)
    ("scripts.dportatojazz" . #xe142)
    ("scripts.umarcatojazz" . #xe143)
    ("scripts.dmarcatojazz" . #xe144)
    ("scripts.openjazz" . #xe145)
    ("scripts.stoppedjazz" . #xe148)
    ("scripts.trilljazz" . #xe14d)
    ("scripts.segnojazz" . #xe153)
    ("scripts.varsegnojazz" . #xe154)
    ("scripts.codajazz" . #xe155)
    ("scripts.varcodajazz" . #xe156)
    ("scripts.trill_elementjazz" . #xe15c)
    ("scripts.trilelementjazz" . #xe15f)
    ("scripts.pralljazz" . #xe160)
    ("scripts.prallpralljazz" . #xe162)
    ("clefs.F_changejazz" . #xe171)
    ("clefs.Gjazz" . #xe172)
    ("clefs.G_changejazz" . #xe173)
    ("timesig.C44jazz" . #xe178)
    ("timesig.C22jazz" . #xe179)
    ("zerojazz" . #x0030)
    ("onejazz" . #x0031)
    ("twojazz" . #x0032)
    ("threejazz" . #x0033)
    ("fourjazz" . #x0034)
    ("fivejazz" . #x0035)
    ("sixjazz" . #x0036)
    ("sevenjazz" . #x0037)
    ("eightjazz" . #x0038)
    ("ninejazz" . #x0039)
    ("Fjazz" . #x0046)
    ("fjazz" . #x0066)
    ("mjazz" . #x006d)
    ("pjazz" . #x0070)
    ("rjazz" . #x0072)
    ("sjazz" . #x0073)
    ("zjazz" . #x007a)))                            

#(define jazz-alteration-glyph-name-alist
  '((0 . "accidentals.naturaljazz")
    (-1/2 . "accidentals.flatjazz")
    (1/2 . "accidentals.sharpjazz")
    (1 . "accidentals.doublesharpjaz")
    (-1 . "accidentals.flatflatjazz")))


%***********************************************************************
%  JAZZ GLYPH ACCESS
%***********************************************************************

#(define-markup-command (jazzchar layout props charnum) (number?)
  "char for jazz characters"
    (interpret-markup layout props
      (markup (#:fontsize 5 #:override '(font-name . "LilyJAZZ") #:char charnum))))

% JAZZGLYPH: REPLACEMENT FOR MUSICGLYPH ================================
#(define-markup-command (jazzglyph layout props glyphname) (string?)
  "musicglyph replacemet for jazz (i. e. non-Feta) characters"
    (let* ((charnum (cdr (assoc glyphname  jazz-map))))
    (interpret-markup layout props
      (markup (#:fontsize 5 #:override '(font-name . "LilyJAZZ") #:char charnum)))))


%***********************************************************************
%  JAZZ CLEFS
%***********************************************************************

#(define (jazz-clef grob)
  "jazz clef stencil"
  (let* ((glyphname (string-append (ly:grob-property grob 'glyph-name) "jazz")))    
    (if (pair? (assoc glyphname jazz-map))
        (grob-interpret-markup grob (markup #:jazzglyph glyphname))
        (ly:clef::print grob))))


%***********************************************************************
% KEY SIGNATURES
%***********************************************************************

#(define (jazz-keysig grob)
  "stencil: jazz key signature (including cancellation)"
  (let* ((altlist (ly:grob-property grob 'alteration-alist))
    (c0pos (ly:grob-property grob 'c0-position))
    (keysig-stencil '()))
    (for-each (lambda (alt)
         (let* ((alteration (if (grob::has-interface grob 'key-cancellation-interface) 0 (cdr alt)))
         (glyphname (assoc-get alteration jazz-alteration-glyph-name-alist
""))
         (padding (cond
           ((< alteration 0) 0.25)  ; any kind of flat
           ((= alteration 0) 0.05)  ;  natural
           ((< alteration 1) 0.1)   ; sharp (less than double sharp)
           (else -0.4)))            ; double sharp
         (ypos (key-signature-interface::alteration-positions alt c0pos grob))
         (acc-stencil (fold (lambda (y s)
                              (ly:stencil-add
                                (grob-interpret-markup grob
                                  (markup #:raise (/ y 2) #:jazzglyph
glyphname))
                                s))
                            empty-stencil
                            ypos)))
         (set! keysig-stencil (ly:stencil-combine-at-edge acc-stencil X
RIGHT keysig-stencil padding)))) altlist)
    keysig-stencil))



%***********************************************************************
% TIME SIGNATURE
%***********************************************************************

#(define (jazz-timesig grob)
  (let* ((style (ly:grob-property grob 'style))
         (fraction (ly:grob-property grob 'fraction))
         (glyphname (if (equal? style 'C) 
                (cond 
                   ((equal? fraction '(4 . 4)) "timesig.C44jazz")
                   ((equal? fraction '(2 . 2)) "timesig.C22jazz")
                   (else "")) "")))
    (if (equal? glyphname "")
        (ly:time-signature::print grob)
        (grob-interpret-markup grob (markup #:fontsize -5 #:jazzglyph glyphname)))))


%***********************************************************************
% NOTE HEADS
%***********************************************************************
%=> http://lists.gnu.org/archive/html/lilypond-user/2013-10/msg00071.html

#(define (jazz-notehead grob)
  "stencil: jazz noteheads"
  (let* ((log (ly:grob-property grob 'duration-log))
         (style (ly:grob-property grob 'style))
         (n-c (ly:grob-parent grob Y))
         (stem (ly:grob-object n-c 'stem))
         (stem-dir (ly:grob-property stem 'direction))
         (note-head-glyph (format #f "noteheads.s~a~ajazz"
                                           (cond ((<= log 0) 0)
                                                 ((<= log 1) 1)
                                                 (else 2))
                                           (if (not (null? style)) style ""))))

     (set! (ly:grob-property grob 'stem-attachment)
           (if (eq? style 'slash)
               (if (= stem-dir -1)
                   (if (<= log 1)
                       '(1.28 . 0.95)
                       '(1.12 . 0.725))
                   (if (<= log 1)
                       '(1.6 . 0.9)
                       '(1.227 . 0.72)))
               '(1.0 . 0.35)))
     (grob-interpret-markup grob (markup #:jazzglyph note-head-glyph))))

%***********************************************************************
% FLAGS
%***********************************************************************

#(define (jazz-flag grob)
  "stencil: jazz flags"
   (let* ((stem-grob (ly:grob-parent grob X))
          (log (ly:grob-property stem-grob 'duration-log))
          (dir (ly:grob-property stem-grob 'direction))
          (stem-width (* (ly:staff-symbol-line-thickness grob) (ly:grob-property stem-grob 'thickness)))
          (glyphname (string-append "flags." (if (> dir 0) "u" "d") (number->string log) "jazz"))
          (flag-stencil (grob-interpret-markup grob (markup #:jazzglyph glyphname)))
          (flag-pos (cons (* stem-width 0) 0))
          (stroke-style (ly:grob-property grob 'stroke-style))
          (stroke-stencil (if (equal? stroke-style "grace")
                              (if (equal? dir UP) 
                                  (make-line-stencil 0.15 -0.5 -1.6 0.75 -0.6)
                                  (make-line-stencil 0.15 -0.4 1.6 0.85 0.6))
     ;                             (grob-interpret-markup grob (markup #:jazzglyph "flags.ugracejazz"))
     ;                             (grob-interpret-markup grob (markup #:jazzglyph "flags.dgracejazz")))
                              empty-stencil)))
          (ly:stencil-translate (ly:stencil-add flag-stencil stroke-stencil) flag-pos)))


%***********************************************************************
% DOTS (DURATION)
%***********************************************************************

#(define (jazz-dots grob)
  "stencil: jazz duration dots"
  (let* ((dot-count (ly:grob-property grob 'dot-count)))
     (grob-interpret-markup grob (markup
         (if (>= dot-count 1) (markup #:translate '(0.4 . 0) #:jazzglyph "dots.dot") (markup #:null))
         (if (>= dot-count 2) (markup #:translate '(0.25 . 0) #:jazzglyph "dots.dot") (markup #:null))
         (if (>= dot-count 3) (markup #:translate '(0.25 . 0) #:jazzglyph "dots.dot") (markup #:null))
         (if (>= dot-count 4) (markup #:translate '(0.25 . 0) #:jazzglyph "dots.dot") (markup #:null))
         (if (>= dot-count 5) (markup #:translate '(0.25 . 0) #:jazzglyph "dots.dot") (markup #:null))))))         


%***********************************************************************
% ACCIDENTALS
%***********************************************************************

% ACCIDENTALS (MUSICAL CONTEXT) ========================================
#(define (jazz-accidental grob)
   "stencil: jazz accidentals in front of notes or used as suggestions"
  (let* ((alt (ly:grob-property grob 'alteration))
         (show (if (null? (ly:grob-property grob 'forced)) (if (null? (ly:grob-object grob 'tie)) #t #f ) #t )))
    (if (equal? show #t)
      (grob-interpret-markup grob (markup #:jazzglyph (assoc-get alt jazz-alteration-glyph-name-alist "")))
      (ly:accidental-interface::print grob))))

% CAUTIONARY ACCIDENTALS (MUSICAL CONTEXT) =============================
#(define (jazz-accidental-cautionary grob)
   "stencil: jazz cautionary accidentals in front of notes"
  (let* ((alt (ly:grob-property grob 'alteration)))
    (grob-interpret-markup grob
      (case alt 
         ((1) (markup #:concat (
                     #:translate '(0 . -0.05) #:jazzglyph "accidentals.leftparenjazz" 
                     #:jazzglyph "accidentals.doublesharpjaz"                         
                     #:translate '(0 . 0.05) #:jazzglyph "accidentals.rightparenjaz" )))
         ((1/2) (markup #:concat (
                     #:translate '(0 . -0.1) #:jazzglyph "accidentals.leftparenjazz" 
                     #:jazzglyph "accidentals.sharpjazz"                       
                     #:translate '(0 . 0.3) #:jazzglyph "accidentals.rightparenjaz" )))
         ((0) (markup #:concat (
                     #:translate '(0.1 . 0) #:rotate 5 #:jazzglyph "accidentals.leftparenjazz" 
                     #:jazzglyph "accidentals.naturaljazz"                          
                     #:translate '(0.05 . 0.3) #:rotate 5 #:jazzglyph "accidentals.rightparenjaz" )))
         ((-1/2) (markup #:concat (
                     #:translate '(-0.15 . 0.3) #:jazzglyph "accidentals.leftparenjazz" 
                     #:jazzglyph "accidentals.flatjazz"                                   
                     #:translate '(0 . 0.2) #:jazzglyph "accidentals.rightparenjaz" )))   ;   
         ((-1) (markup #:concat (
                     #:translate '(-0.15 . 0.5) #:jazzglyph "accidentals.leftparenjazz" 
                     #:jazzglyph "accidentals.flatflatjazz"                                  
                     #:translate '(-0.1 . 0.4) #:jazzglyph "accidentals.rightparenjaz" )))))))


%***********************************************************************
% RESTS
%***********************************************************************

#(define (jazz-rest grob)
  (let* ((duration (ly:grob-property grob 'duration-log))
         (glyphname (string-append "rests." (number->string duration) "jazz")))
      (grob-interpret-markup grob (markup #:jazzglyph glyphname))))


%***********************************************************************
% DYNAMICS
%***********************************************************************

  sfpp = #(make-dynamic-script  "sfpp" )
% re-defined because of spefilal f with horizontal bar for ligatures/grouping:
  ff = #(make-dynamic-script  "FF" )
  fff = #(make-dynamic-script  "FFF" )
  ffff = #(make-dynamic-script  "FFFF" )
  fffff = #(make-dynamic-script  "FFFFF" )

% to do: make reversible for \jazzOff
#(define-markup-command (dynamic layout props arg)
  (markup?)
  #:category font
  "Use jazz instead of feta for dynamic markup font."
  (interpret-markup layout props (markup #:fontsize 5 #:override '(font-name . "LilyJAZZ") arg)))



%***********************************************************************
% ACCENTS
%***********************************************************************

#(define (jazz-articulation grob)
  (let* ((dir (ly:grob-property grob 'direction))
           (var (ly:grob-property grob 'script-stencil))
           (glyphname (if (= dir DOWN) (car (cdr var)) (cdr (cdr var))))
           (jazzchar (assoc-get (string-append "scripts." glyphname "jazz") jazz-map 0 )))
     (if (> jazzchar 0) 
         (grob-interpret-markup grob (markup #:jazzchar jazzchar))
         (ly:script-interface::print grob))))


fermataMarkup =
#(make-music 'MultiMeasureTextEvent
             'tweaks (list
                      ;; Set the 'text based on the 'direction
                      (cons 'text (lambda (grob)
                                    (if (eq? (ly:grob-property grob 'direction) DOWN)
                                        (markup #:concat (" " #:jazzglyph "scripts.dfermatajazz"))
                                        (markup #:concat (" " #:jazzglyph "scripts.ufermatajazz")))))
                      (cons 'outside-staff-priority 40)
                      (cons 'outside-staff-padding 0)))


makeUnpurePureContainer =
        #(ly:make-unpure-pure-container
       ly:grob::stencil-height
       (lambda (grob start end) (ly:grob::stencil-height grob)))  

%***********************************************************************
% JAZZ TEMPO
%***********************************************************************

%=> http://lists.gnu.org/archive/html/lilypond-user/2013-08/msg00675.html

jazzTempoMarkup = 
#(define-scheme-function (parser location name music bpm) (string? ly:music? string?)
  #{ \markup\concat\magnify #0.9 {
       \line {
         #name
         "(" \hspace #-.5
         \score {
           \new Staff \with {
             fontSize = #-4
             \override StaffSymbol.staff-space = #(magstep -4)
             \override StaffSymbol.line-count = #0
             \override VerticalAxisGroup.Y-extent = #'(0 . 0)
           }
           \relative c'' { \jazzOn \stemUp $music }
           \layout {
             ragged-right= ##t
             indent = 0
             \context {
               \Staff
               \remove "Clef_engraver"
               \remove "Time_signature_engraver"
             }
           }
         }
         "="
         #bpm
         ")"
       }
     }
   #})

%**************************************************************************
% DEFAULT TEMPO
%**************************************************************************

%=>http://lists.gnu.org/archive/html/lilypond-user/2014-02/msg00237.html

#(define*-public
  ((styled-metronome-markup
     #:optional (glyph-font 'default)(note-head-flag '(default . default)))
     event context)
   (let ((hide-note (ly:context-property context 'tempoHideNote #f))
         (text (ly:event-property event 'text))
         (dur (ly:event-property event 'tempo-unit))
         (count (ly:event-property event 'metronome-count)))

   (metronome-markup glyph-font note-head-flag text dur count hide-note)))

#(define (metronome-markup glyph-font note-head-flag text dur count hide-note)
  (let* ((note-mark
            (if (and (not hide-note) (ly:duration? dur))
                (make-smaller-markup
                   ;; We insert the (default)-font for flag-glyphs and
                   ;; note-head-glyphs to prepare the possibility to use
                   ;; other fonts and to make possible using
                   ;; \override MetronomeMark #'font-name = #<font-name>
                   ;; without affecting the note/flag-glyphs.
                   (make-override-markup (cons 'font-name glyph-font)
                   ;; The following 2 lines were inserted,
                   ;; Also, 'note-head-flag' was made available as an argument
                   ;; in 'metronome-markup' and 'styled-metronome-markup'
                    (make-override-markup `(style . ,(car note-head-flag))
                     (make-override-markup `(flag-style . ,(cdr note-head-flag))
                       (make-note-by-number-markup
                           (ly:duration-log dur)
                           (ly:duration-dot-count dur)
                           UP)))))
                         #f))
         (count-markup (cond ((number? count)
                              (if (> count 0)
                                  (make-simple-markup
                                          (number->string count))
                                  #f))
                             ((pair? count)
                              (make-concat-markup
                               (list
                                (make-simple-markup
                                        (number->string (car count)))
                                (make-simple-markup " ")
                                (make-simple-markup "–")
                                (make-simple-markup " ")
                                (make-simple-markup
                                        (number->string (cdr count))))))
                             (else #f)))
         (note-markup (if (and (not hide-note) count-markup)
                          (make-concat-markup
                           (list
                            (make-general-align-markup Y DOWN note-mark)
                            (make-simple-markup " ")
                            (make-simple-markup "=")
                            (make-simple-markup " ")
                            count-markup))
                          #f))
         (text-markup (if (not (null? text))
                          (make-bold-markup text)
                          #f)))
    (if text-markup
        (if (and note-markup (not hide-note))
            (make-line-markup (list text-markup
                                    (make-concat-markup
                                     (list (make-simple-markup "(")
                                           note-markup
                                           (make-simple-markup ")")))))
            (make-line-markup (list text-markup)))
        (if note-markup
            (make-line-markup (list note-markup))
            (make-null-markup)))))

%% default:
#(define-public format-metronome-markup
  (styled-metronome-markup))

#(define-public jazz-metronome-markup
  (styled-metronome-markup 'default '(jazz . jazz)))

#(define-public my-format-metronome-markup
  (styled-metronome-markup 'default '(diamond . old-straight-flag)))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% markup-command: note-by-number
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=> http://lists.gnu.org/archive/html/lilypond-user/2014-02/txtyB40b0cFCg.txt

% #(use-modules (ice-9 pretty-print))
%% 'note-by-number' is now able to deal with the LillyJAZZ-glyphs.

%% needed c/p from lily-library
#(define (sign x)
  (if (= x 0)
      0
      (if (< x 0) -1 1)))
 
#(define-markup-command (note-by-number layout props log dot-count dir)
  (number? number? number?)
  #:category music
  #:properties ((font-size 0)
                (flag-style '())
                (style '()))
  "
@cindex notes within text by log and dot-count

Construct a note symbol, with stem and flag.  By using fractional values for
@var{dir}, longer or shorter stems can be obtained.
Supports all note-head-styles.
Supported flag-styles are @code{default}, @code{old-straight-flag},
@code{modern-straight-flag} and @code{flat-flag}.

@lilypond[verbatim,quote]
\\markup {
  \\note-by-number #3 #0 #DOWN
  \\hspace #2
  \\note-by-number #1 #2 #0.8
}
@end lilypond"

  (define (get-glyph-name-candidates dir log style)
    (map (lambda (dir-name)
           (format #f "noteheads.~a~a" dir-name
                   (if (and (symbol? style)
                            (not (equal? 'default style)))
                       (select-head-glyph style (min log 2))
                       (min log 2))))
         (list (if (= dir UP) "u" "d")
               "s")))

  (define (get-glyph-name font cands)
    (if (null? cands)
        ""
        (if (ly:stencil-empty? (ly:font-get-glyph font (car cands)))
            (get-glyph-name font (cdr cands))
            (car cands))))
            
  (define (get-jazz-glyph-name jazz-font cands)
    (if (null? cands)
        ""
        (if (assoc (car cands) jazz-font)
            (car (assoc (car cands) jazz-font))
            (get-jazz-glyph-name jazz-font (cdr cands)))))

  (define (buildflags flag-stencil remain curr-stencil spacing)
    ;; Function to recursively create a stencil with @code{remain} flags
    ;; from the single-flag stencil @code{curr-stencil}, which is already
    ;; translated to the position of the previous flag position.
    ;;
    ;; Copy and paste from /scm/flag-styles.scm
    (if (> remain 0)
        (let* ((translated-stencil
                (ly:stencil-translate-axis curr-stencil spacing Y))
               (new-stencil (ly:stencil-add flag-stencil translated-stencil)))
          (buildflags new-stencil (- remain 1) translated-stencil spacing))
        flag-stencil))

  (define (straight-flag-mrkp flag-thickness flag-spacing
                              upflag-angle upflag-length
                              downflag-angle downflag-length
                              dir)
    ;; Create a stencil for a straight flag.  @var{flag-thickness} and
    ;; @var{flag-spacing} are given in staff spaces, @var{upflag-angle} and
    ;; @var{downflag-angle} are given in degrees, and @var{upflag-length} and
    ;; @var{downflag-length} are given in staff spaces.
    ;;
    ;; All lengths are scaled according to the font size of the note.
    ;;
    ;; From /scm/flag-styles.scm, modified to fit here.

    (let* ((stem-up (> dir 0))
           ;; scale with the note size
           (factor (magstep font-size))
           (stem-thickness (* factor 0.1))
           (line-thickness (ly:output-def-lookup layout 'line-thickness))
           (half-stem-thickness (/ (* stem-thickness line-thickness) 2))
           (raw-length (if stem-up upflag-length downflag-length))
           (angle (if stem-up upflag-angle downflag-angle))
           (flag-length (+ (* raw-length factor) half-stem-thickness))
           (flag-end (if (= angle 0)
                         (cons flag-length (* half-stem-thickness dir))
                         (polar->rectangular flag-length angle)))
           (thickness (* flag-thickness factor))
           (thickness-offset (cons 0 (* -1 thickness dir)))
           (spacing (* -1 flag-spacing factor dir))
           (start (cons (- half-stem-thickness) (* half-stem-thickness dir)))
           ;; The points of a round-filled-polygon need to be given in
           ;; clockwise order, otherwise the polygon will be enlarged by
           ;; blot-size*2!
           (points (if stem-up (list start flag-end
                                     (offset-add flag-end thickness-offset)
                                     (offset-add start thickness-offset))
                       (list start
                             (offset-add start thickness-offset)
                             (offset-add flag-end thickness-offset)
                             flag-end)))
           (stencil (ly:round-filled-polygon points half-stem-thickness))
           ;; Log for 1/8 is 3, so we need to subtract 3
           (flag-stencil (buildflags stencil (- log 3) stencil spacing)))
      flag-stencil))
      


  (let* ((font (ly:paper-get-font layout (cons '((font-encoding . fetaMusic))
                                               props)))
         (size-factor (magstep font-size))
         (blot (ly:output-def-lookup layout 'blot-diameter))
         (head-glyph-name
          (let ((result (if (eq? style 'jazz)                     
                            (if (not (defined? 'jazz-map))
                                (ly:error (_ "Cannot find \"jazz-map\""))
                                (get-jazz-glyph-name jazz-map 
                                            (get-glyph-name-candidates
                                             (sign dir) log style)))
                            (get-glyph-name font
                                        (get-glyph-name-candidates
                                         (sign dir) log style))))) 
            (if (string-null? result)
                ;; If no glyph name can be found, select default heads.
                ;; Though this usually means an unsupported style has been
                ;; chosen, it also prevents unrelated 'style settings from
                ;; other grobs (e.g., TextSpanner and TimeSignature) leaking
                ;; into markup.
                (get-glyph-name font
                                (get-glyph-name-candidates
                                 (sign dir) log 'default))
                result)))
         (head-glyph (if (eq? style 'jazz)
                         (interpret-markup layout props 
                            (markup #:jazzglyph head-glyph-name))
                         (ly:font-get-glyph font head-glyph-name)))
         (ancient-flags? (or (eq? style 'mensural) (eq? style 'neomensural)))
         (attach-indices 
           (if (eq? style 'jazz)
               ;; Ugh, hardcoded. How to do it better?
               '(0.987 . 0.32)
               (ly:note-head::stem-attachment font head-glyph-name)))
         (stem-length (* size-factor (max 3 (- log 1))))
         ;; With ancient-flags we want a tighter stem
         (stem-thickness (* size-factor (if ancient-flags? 0.1 0.13)))
         (stemy (* dir stem-length))
         (attach-off (cons (interval-index
                            (ly:stencil-extent head-glyph X)
                            (* (sign dir) (car attach-indices)))
                           ;; fixme, this is inconsistent between X & Y.
                           (* (sign dir)
                              (interval-index
                               (ly:stencil-extent head-glyph Y)
                               (cdr attach-indices)))))
         ;; For a tighter stem (with ancient-flags) the stem-width has to be
         ;; adjusted.
         (stem-X-corr (if ancient-flags? (* 0.5 dir stem-thickness) 0))
         (stem-glyph (and (> log 0)
                          (ly:round-filled-box
                           (ordered-cons (+ stem-X-corr (car attach-off))
                                         (+ stem-X-corr (car attach-off)
                                            (* (- (sign dir)) stem-thickness)))
                           (cons (min stemy (cdr attach-off))
                                 (max stemy (cdr attach-off)))
                           (/ stem-thickness 3))))
         (dot (if (eq? style 'jazz)
                  (interpret-markup layout props 
                     (markup #:jazzglyph "dots.dot"))
                  (ly:font-get-glyph font "dots.dot")))
         (dotwid (interval-length (ly:stencil-extent dot X)))
         (dots (and (> dot-count 0)
                    (apply ly:stencil-add
                           (map (lambda (x)
                                  (ly:stencil-translate-axis
                                   dot (* 2 x dotwid) X))
                                (iota dot-count)))))
         ;; Straight-flags. Values taken from /scm/flag-style.scm
         (modern-straight-flag (straight-flag-mrkp 0.55 1 -18 1.1 22 1.2 dir))
         (old-straight-flag (straight-flag-mrkp 0.55 1 -45 1.2 45 1.4 dir))
         (flat-flag (straight-flag-mrkp 0.55 1.0 0 1.0 0 1.0 dir))
         ;; Calculate a corrective to avoid a gap between
         ;; straight-flags and the stem.
         (flag-style-Y-corr (if (or (eq? flag-style 'modern-straight-flag)
                                    (eq? flag-style 'old-straight-flag)
                                    (eq? flag-style 'flat-flag))
                                (/ blot 10 (* -1 dir))
                                0))
         (flaggl (and (> log 2)
                      (ly:stencil-translate
                       (cond ((eq? flag-style 'modern-straight-flag)
                              modern-straight-flag)
                             ((eq? flag-style 'old-straight-flag)
                              old-straight-flag)
                             ((eq? flag-style 'flat-flag)
                              flat-flag)
                             ((eq? flag-style 'jazz)
                              (interpret-markup layout props
                                (markup #:jazzglyph
                                        (format #f 
                                                "flags.~a~ajazz"
                                                (if (> dir 0) "u" "d")
                                                log))))
                             (else
                              (ly:font-get-glyph 
                                  font (format #f 
                                               (if ancient-flags?
                                                   "flags.mensural~a2~a"
                                                   "flags.~a~a")
                                               (if (> dir 0) "u" "d")
                                               log))))
                       (cons (+ (car attach-off)
                                ;; For tighter stems (with ancient-flags) the
                                ;; flag has to be adjusted different.
                                (if (and (not ancient-flags?) (< dir 0))
                                    stem-thickness
                                    0))
                             (+ stemy flag-style-Y-corr)))))) 

    ;; If there is a flag on an upstem and the stem is short, move the dots
    ;; to avoid the flag.  16th notes get a special case because their flags
    ;; hang lower than any other flags.
    ;; Not with ancient flags or straight-flags.
    (if (and dots (> dir 0) (> log 2)
             (or (eq? flag-style 'jazz) 
                 (eq? flag-style 'default) 
                 (null? flag-style))
             (not ancient-flags?)
             (or (< dir 1.15) (and (= log 4) (< dir 1.3))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO: patch note-by-number with
;; inserted size-factor !!!
;; otherwise \note-by-number will work badly with \fontsize
        (set! dots (ly:stencil-translate-axis dots (* size-factor 0.5) X)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (if flaggl
        (set! stem-glyph (ly:stencil-add flaggl stem-glyph)))
    (if (ly:stencil? stem-glyph)
        (set! stem-glyph (ly:stencil-add stem-glyph head-glyph))
        (set! stem-glyph head-glyph))
    (if (ly:stencil? dots)
        (set! stem-glyph
              (ly:stencil-add
               (ly:stencil-translate-axis
                dots
                (+ (cdr (ly:stencil-extent head-glyph X)) dotwid)
                X)
               stem-glyph)))
    stem-glyph))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating jazz-style repeats
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=> http://lsr.di.unimi.it/LSR/Item?id=753
#(define (white-under grob) (grob-interpret-markup grob 
  (markup #:vcenter #:whiteout #:pad-x 1 (ly:grob-property grob 'text))))

inlineMMRN = {
  \once \override MultiMeasureRest.layer = #-2
  \once \override MultiMeasureRestNumber.layer = #-1
  \once \override MultiMeasureRestNumber.Y-offset = #0
  \once \override MultiMeasureRestNumber.stencil = #white-under
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start with a repeat Barline
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

showStartRepeatBar = { 
  \once \override Score.BreakAlignment.break-align-orders =
        #(make-vector 3 '(instrument-name
                          left-edge
                          ambitus
                          breathing-sign
                          clef
                          key-signature
                          time-signature
                          staff-bar
                          custos))
      \once \override Staff.TimeSignature.space-alist =
        #'((first-note . (fixed-space . 2.0))
           (right-edge . (extra-space . 0.5))
           ;; free up some space between time signature
           ;; and repeat bar line
           (staff-bar . (extra-space . 1)))
}
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% jazz overrides
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
jazzOn = {
  \override Staff.Clef.stencil = #jazz-clef
  \override Score.Clef.break-visibility = #'#(#f #f #f)		
  
  %=> http://lilypondblog.org/2013/09/lilypond-and-lilyjazz/
  \override Score.BarNumber.stencil = ##f
  
  \override Staff.KeySignature.stencil = #jazz-keysig
  \override Staff.KeyCancellation.stencil = #jazz-keysig
  \override Score.KeySignature.break-visibility = #'#(#f #f #f)

  \override Staff.TimeSignature.stencil = #jazz-timesig
  
  \override Staff.NoteHead.stencil = #jazz-notehead  
  \override Staff.NoteHead.Y-extent = \makeUnpurePureContainer
  
  %=> http://lists.gnu.org/archive/html/lilypond-user/2013-08/msg00690.html
  \override Staff.Dots.X-extent = \makeUnpurePureContainer
  
  \override Staff.Stem.thickness = #2
  \override Staff.Beam.beam-thickness = #0.55
  \override Staff.Flag.stencil = #jazz-flag
  \override Staff.Flag.Y-extent = \makeUnpurePureContainer

  \override Staff.Dots.stencil = #jazz-dots
  \override Staff.Accidental.stencil = #jazz-accidental
  \override Staff.Accidental.Y-extent = \makeUnpurePureContainer
  
  \override Staff.AccidentalCautionary.stencil = #jazz-accidental-cautionary
  \override Staff.AccidentalCautionary.Y-extent = \makeUnpurePureContainer

  \override Staff.AccidentalSuggestion.stencil = #jazz-accidental
  \override Staff.AccidentalSuggestion.Y-extent = \makeUnpurePureContainer
        
  \override Staff.Script.stencil = #jazz-articulation        
  
  \override Staff.Rest.stencil = #jazz-rest
  %\override Staff.Slur.thickness = #2.5
  \override Staff.Slur.line-thickness = #2.5
  %\override Staff.Tie.thickness = #2.5
  \override Staff.Tie.line-thickness = #2.5
  \override Staff.RepeatTie.line-thickness = #2.5
  
  \override Staff.BarLine.hair-thickness = #3  
  \override Score.BarNumber.font-name = #"LilyJAZZText"

  \override Staff.TimeSignature.font-name = #"LilyJAZZ"
  \override Staff.TimeSignature.font-size = #5
  
  \override Staff.DynamicText.font-name = #"LilyJAZZ"
  \override Staff.DynamicText.font-size = #6

  \override Score.RehearsalMark.font-name = #"LilyJAZZText"
  \override Score.MetronomeMark.font-name = #"LilyJAZZText"

  \override Staff.TextScript.font-name = #"LilyJAZZText"   
  \override Staff.TextScript.font-size = #1

  \override Score.InstrumentName.font-name = #"LilyJAZZText"   
  
  \override Staff.TupletNumber.font-name = "LilyJAZZText"
  \override Staff.TupletBracket.thickness = #3
  
  \override Score.VoltaBracket.font-name = #"LilyJAZZText"
  \override Score.VoltaBracket.font-size = #0
  \override Score.VoltaBracket.thickness = #3
  
  %=> http://lilypond-french-users.1298960.n2.nabble.com/Repetition-de-mesure-avec-LilyJAZZ-td7581186.html
  \override Score.PercentRepeatCounter.font-size = #2
  \override Score.PercentRepeatCounter.font-name = "LilyJAZZText"
  \override Score.DoublePercentRepeatCounter.font-size = #2
  \override Score.DoublePercentRepeatCounter.font-name = "LilyJAZZText"
  \override Score.MultiMeasureRestNumber.font-size = #2
  \override Score.MultiMeasureRestNumber.font-name = "LilyJAZZText"
  \override Score.MultiMeasureRestText.font-name = "LilyJAZZText"
  
  \override Score.OttavaBracket.thickness = #3
  \override Score.OttavaBracket.dash-period = #1.5
  
  \override Score.Fingering.font-name = "LilyJAZZ"
  \override Score.Fingering.font-size = #0 
  
  \override Staff.ClefModifier.font-name = "LilyJAZZText"
  \override Staff.ClefModifier.font-size = #1
  
  \override Staff.StringNumber.font-name = "LilyJAZZText"
  \override Staff.StringNumber.font-size = #-2
  \override Staff.StringNumber.thickness = #3
  
  \override Score.MetronomeMark.font-name = "LilyJAZZText"
  
  \override Hairpin.thickness = #'3
  
  \override Score.SystemStartBar.thickness = #3  
  \override Score.SystemStartBracket.padding = #.3 
      
}

jazzOff = {
  \revert Staff.Clef.stencil
  \revert Score.Clef.break-visibility
  \revert Staff.KeySignature.stencil
  %=> http://lilypond.1069038.n5.nabble.com/RE-Problems-with-LilyJAZZ-ily-tt152000.html#a161802
  \revert Score.KeySignature.break-visibility
  \revert Staff.KeyCancellation.stencil
  \revert Staff.TimeSignature.stencil
  \revert Staff.NoteHead.stencil
  \revert Staff.NoteHead.Y-extent
  \revert Staff.Stem.thickness
  \revert Staff.Beam.beam-thickness
  \revert Staff.Flag.stencil
  \revert Staff.Dots.stencil
  \revert Staff.Accidental.stencil
  \revert Staff.AccidentalCautionary.stencil
  \revert Staff.AccidentalSuggestion.stencil
  \revert Staff.Script.stencil 
  \revert Staff.Rest.stencil
  %\revert Staff.Slur.thickness
  \revert Staff.Slur.line-thickness
  %\revert Staff.Tie.thickness
  \revert Staff.Tie.line-thickness
  \revert Staff.RepeatTie.line-thickness
  \revert Staff.BarLine.hair-thickness
  \revert Score.BarNumber.font-name
  \revert Score.BarNumber.stencil
  \revert Staff.TimeSignature.font-name
  \revert Staff.TimeSignature.font-size
  \revert Staff.DynamicText.font-name
  \revert Staff.DynamicText.font-size
  \revert Score.RehearsalMark.font-name
  \revert Score.MetronomeMark.font-name
  \revert Staff.TextScript.font-name  
  \revert Staff.TextScript.font-size
  \revert Score.InstrumentName.font-name   
  \revert Staff.TupletNumber.font-name
  \revert Staff.TupletBracket.thickness
  \revert Score.VoltaBracket.font-name
  \revert Score.VoltaBracket.font-size
  \revert Score.VoltaBracket.thickness
  \revert Score.PercentRepeatCounter.font-size
  \revert Score.PercentRepeatCounter.font-name
  \revert Score.DoublePercentRepeatCounter.font-size
  \revert Score.DoublePercentRepeatCounter.font-name
  \revert Score.MultiMeasureRestNumber.font-size
  \revert Score.MultiMeasureRestNumber.font-name
  \revert Score.MultiMeasureRestText.font-name
  \revert Score.OttavaBracket.thickness
  \revert Score.OttavaBracket.dash-period
  \revert Score.Fingering.font-name
  \revert Score.Fingering.font-size
  \revert Staff.ClefModifier.font-name
  \revert Staff.ClefModifier.font-size
  \revert Staff.StringNumber.font-name
  \revert Staff.StringNumber.font-size
  \revert Staff.StringNumber.thickness
  \revert Score.MetronomeMark.font-name
  \revert Hairpin.thickness
  \revert Score.SystemStartBar.thickness
  \revert Score.SystemStartBracket.padding 
}
