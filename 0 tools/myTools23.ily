\version "2.24.0"
makeUnpurePureContainer =
        #(ly:make-unpure-pure-container
       ly:grob::stencil-height
       (lambda (grob start end) (ly:grob::stencil-height grob)))
      

        #(define semi-tie-stencil
  (lambda (grob)
    (let* ((cps (ly:grob-property grob 'control-points))
           (first-cp (car cps))
           (last-cp (last cps))
           (actual-length
             (- (car last-cp) (car first-cp)))
           (thickness (ly:grob-property grob 'thickness 2.2))
           (orientation (ly:grob-property grob 'direction -1))
           (minimum-length
             (ly:grob-property grob 'minimum-length
               (+ (car first-cp) actual-length)))
           (head-dir (ly:grob-property grob 'head-direction))
           (used-length (max actual-length minimum-length))
           (line-thick (ly:staff-symbol-line-thickness grob)))
      (make-tie-stencil
        (if (positive? head-dir)
            (cons (- used-length) (cdr first-cp))
            first-cp)
        (if (positive? head-dir)
            last-cp
            (cons used-length (cdr first-cp)))
        (* thickness line-thick)
        orientation))))
%% Variable thickness:
%% => http://lilypond.1069038.n5.nabble.com/Tie-slur-variable-thickness-vs-shape-td233187.html#a233192
#(define (variable-bow-thickness min-l max-l min-t max-t)
   (lambda (grob)
     (let* (;; get the procedure to calculate the control-points
             (cpf (assoc-get 'control-points (ly:grob-basic-properties grob)))
             (cpt (cond ((list? cpf) cpf)
                        ((procedure? cpf) (cpf grob))
                        ((ly:unpure-pure-container? cpf)
                         (ly:unpure-call cpf grob))))
             (cp0 (car cpt))
             (cp3 (cadddr cpt))
             (dx (- (car cp3) (car cp0)))
             (dy (- (cdr cp3) (cdr cp0)))
             (len (magnitude (make-rectangular dx dy)))
             ;; return a value for thickness
             ;;   below min-l             -> min-l
             ;;   greater than max-l      -> max-l
             ;;   between min-l and max-l -> calculate a nice value
             (thickness
              (cond ((< len min-l) min-t)
                    ((> len max-l) max-t)
                    (else
                     (+ min-t
                        (* (- len min-l)
                           (/ (- max-t min-t)
                              (- max-l min-l))))))))
       thickness)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 		Barrés
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stopBarre = \stopTextSpan
Prefix = \markup {
  %% uncomment/comment these lines for C, C slashed, B or B slashed prefix :
  %\roman C
  %\combine \roman C \translate #'(0.65 . -0.25) \override #'(thickness . 1.2) \draw-line #'(0 . 1.8)
  %\roman B
  \sans B
  %\combine \roman B \translate #'(0.65 . -0.25) \override #'(thickness . 1.2) \draw-line #'(0 . 1.8)
  %%%%%%%%%%%%
  \hspace #0.2
}
barre =
#(define-event-function (str) (string?)
  (let* ((mrkp (markup #:upright #:concat (Prefix str " "))))
    (define (width grob text-string)
      (let* ((layout (ly:grob-layout grob))
             (props (ly:grob-alist-chain
                       grob
                       (ly:output-def-lookup layout 'text-font-defaults))))
      (interval-length
         (ly:stencil-extent
           (interpret-markup layout props (markup text-string))
           X))))
    #{

      \tweak TextSpanner.after-line-breaking
        #(lambda (grob)
          (let* ((mrkp-width (width grob mrkp))
                 (line-thickness (ly:staff-symbol-line-thickness grob)))
           (ly:grob-set-nested-property!
             grob
             '(bound-details left padding)
             (+ (/ mrkp-width -4) (* line-thickness 2)))))
      \tweak TextSpanner.font-size -2
      \tweak TextSpanner.style #'line
      \tweak TextSpanner.bound-details.left.text #mrkp
      \tweak TextSpanner.bound-details.left.padding 0.25
      \tweak TextSpanner.bound-details.left.attach-dir -2
      \tweak TextSpanner.bound-details.left-broken.text ##f
      \tweak TextSpanner.bound-details.left-broken.attach-dir -1
      %% adjust the numeric values to fit your needs:
      \tweak TextSpanner.bound-details.left-broken.padding 1.5
      \tweak TextSpanner.bound-details.right-broken.padding 0
      \tweak TextSpanner.bound-details.right.padding 0.25
      \tweak TextSpanner.bound-details.right.attach-dir 2
      \tweak TextSpanner.bound-details.right-broken.text ##f
      \tweak TextSpanner.bound-details.right.text
        \markup \draw-line #'(0 . -0.65)
      \startTextSpan
    #}))
%%%%%%%%%%%%%%%%% Half Barré function with prefix %%%%%%%%%%%%%%%%%%%%%%%
#(define-markup-command (prefix layout props string-qty) (integer?)
    (interpret-markup layout props
      (case string-qty
            ((2) #{
                    \markup {
                      \override #'(font-family . typewriter)
                      \concat {
                      \fontsize #-4
                        {
                          \raise #.5 "1"
                          \hspace #-.2
                          \raise #.2 "/"
                          \hspace #-.2
                          "3"
                        }
                        \Prefix
                      }
                    }
                 #})
            ((3) #{
                    \markup {
                      \override #'(font-family . typewriter)
                      \concat {
                      \fontsize #-4
                        {
                          \raise #.5 "1"
                          \hspace #-.2
                          \raise #.2 "/"
                          \hspace #-.2
                          "2"
                        }
                        \Prefix
                      }
                    }
                 #})
            ((4) #{
                    \markup {
                      \override #'(font-family . typewriter)
                      \concat {
                      \fontsize #-4
                        {
                          \raise #.5 "2"
                          \hspace #-.2
                          \raise #.2 "/"
                          \hspace #-.2
                          "3"
                        }
                        \Prefix
                      }
                    }
                 #})
            ((5) #{
                    \markup {
                      \override #'(font-family . typewriter)
                      \concat {
                      \fontsize #-4
                        {
                          \raise #.5 "5"
                          \hspace #-.2
                          \raise #.2 "/"
                          \hspace #-.2
                          "6"
                        }
                        \Prefix
                      }
                    }
                 #})
            (else
             #{ \markup\Prefix #}))))
hbarre =
#(define-event-function (arg-string-qty fret-nbr) (integer? markup?)
   (let* ((string-qty arg-string-qty)
            (mrkp
             (markup #:upright #:concat (#:prefix string-qty fret-nbr #:hspace 0.3))))
   (define (width grob text-string)
      (let* ((layout (ly:grob-layout grob))
             (props (ly:grob-alist-chain
                       grob
                       (ly:output-def-lookup layout 'text-font-defaults))))
      (interval-length
         (ly:stencil-extent
           (interpret-markup layout props (markup text-string))
           X))))
    #{

      \tweak TextSpanner.after-line-breaking
        #(lambda (grob)
          (let* ((mrkp-width (width grob mrkp))
                 (line-thickness (ly:staff-symbol-line-thickness grob)))
           (ly:grob-set-nested-property!
             grob
             '(bound-details left padding)
             (+ (/ mrkp-width -4) (* line-thickness 2)))))
      \tweak TextSpanner.font-size -2
      \tweak TextSpanner.style #'line
      \tweak TextSpanner.bound-details.left.text #mrkp
      \tweak TextSpanner.bound-details.left.padding 0.25
      \tweak TextSpanner.bound-details.left.attach-dir -2
      \tweak TextSpanner.bound-details.left-broken.text ##f
      \tweak TextSpanner.bound-details.left-broken.attach-dir -1
      %% adjust the numeric values to fit your needs:
      \tweak TextSpanner.bound-details.left-broken.padding 1.5
      \tweak TextSpanner.bound-details.right-broken.padding 0
      \tweak TextSpanner.bound-details.right.padding 0.25
      \tweak TextSpanner.bound-details.right.attach-dir 2
      \tweak TextSpanner.bound-details.right-broken.text ##f
      \tweak TextSpanner.bound-details.right.text
        \markup
        \with-dimensions #'(0 . 0) #'(-.3 . 0)
        \draw-line #'(0 . -1)
      \startTextSpan
    #}))

alterBarre =
#(define-event-function (str) (string?)
  (let* ((mrkp (markup #:upright #:concat ( str " "))))
    (define (width grob text-string)
      (let* ((layout (ly:grob-layout grob))
             (props (ly:grob-alist-chain
                       grob
                       (ly:output-def-lookup layout 'text-font-defaults))))
      (interval-length
         (ly:stencil-extent
           (interpret-markup layout props (markup text-string))
           X))))
    #{

      \tweak TextSpanner.after-line-breaking
        #(lambda (grob)
          (let* ((mrkp-width (width grob mrkp))
                 (line-thickness (ly:staff-symbol-line-thickness grob)))
           (ly:grob-set-nested-property!
             grob
             '(bound-details left padding)
             (+ (/ mrkp-width -4) (* line-thickness 2)))))
      \tweak TextSpanner.font-size -2
      \tweak TextSpanner.style #'line
      \tweak TextSpanner.bound-details.left.text #mrkp
      \tweak TextSpanner.bound-details.left.padding 0.25
      \tweak TextSpanner.bound-details.left.attach-dir -2
      \tweak TextSpanner.bound-details.left-broken.text ##f
      \tweak TextSpanner.bound-details.left-broken.attach-dir -1
      %% adjust the numeric values to fit your needs:
      \tweak TextSpanner.bound-details.left-broken.padding 1.5
      \tweak TextSpanner.bound-details.right-broken.padding 0
      \tweak TextSpanner.bound-details.right.padding 0.25
      \tweak TextSpanner.bound-details.right.attach-dir 2
      \tweak TextSpanner.bound-details.right-broken.text ##f
      \tweak TextSpanner.bound-details.right.text
        \markup \draw-line #'(0 . -0.65)
      \startTextSpan
    #}))
PrefixUnTiers = \markup \concat {
  \override #'(font-family . typewriter)
  \override #'(word-space . -0.25)
  \line {
    \magnify #.5 { \raise #.5 "1" }
    \magnify #.5 { \raise #.2 "/" }
    \magnify #.5 { "3" }  

    \hspace #0.2
    \sans B
  }
}
barreUnTiers =
#(define-event-function (str) (string?)
  (let* ((mrkp (markup #:upright #:concat (PrefixUnTiers str " "))))
    (define (width grob text-string)
      (let* ((layout (ly:grob-layout grob))
             (props (ly:grob-alist-chain
                       grob
                       (ly:output-def-lookup layout 'text-font-defaults))))
      (interval-length
         (ly:stencil-extent
           (interpret-markup layout props (markup text-string))
           X))))
    #{

      \tweak TextSpanner.after-line-breaking
        #(lambda (grob)
          (let* ((mrkp-width (width grob mrkp))
                 (line-thickness (ly:staff-symbol-line-thickness grob)))
           (ly:grob-set-nested-property!
             grob
             '(bound-details left padding)
             (+ (/ mrkp-width -4) (* line-thickness 2)))))
      \tweak TextSpanner.font-size -2
      \tweak TextSpanner.style #'line
      \tweak TextSpanner.bound-details.left.text #mrkp
      \tweak TextSpanner.bound-details.left.padding 0.25
      \tweak TextSpanner.bound-details.left.attach-dir -4
      \tweak TextSpanner.bound-details.left-broken.text ##f
      \tweak TextSpanner.bound-details.left-broken.attach-dir -1
      %% adjust the numeric values to fit your needs:
      \tweak TextSpanner.bound-details.left-broken.padding 1.5
      \tweak TextSpanner.bound-details.right-broken.padding 0
      \tweak TextSpanner.bound-details.right.padding 0.25
      \tweak TextSpanner.bound-details.right.attach-dir 2
      \tweak TextSpanner.bound-details.right-broken.text ##f
      \tweak TextSpanner.bound-details.right.text
        \markup \draw-line #'(0 . -0.65)
      \startTextSpan
    #}))

PrefixUnDemi = \markup \concat {
  \override #'(font-family . typewriter)
  \override #'(word-space . -0.25)
  \line {
    \magnify #.5 { \raise #.5 "1" }
    \magnify #.5 { \raise #.2 "/" }
    \magnify #.5 { "2" }  

    \hspace #0.2
    \sans B
  }
}

barreUnDemi =
#(define-event-function (str) (string?)
  (let* ((mrkp (markup #:upright #:concat (PrefixUnDemi str " "))))
    (define (width grob text-string)
      (let* ((layout (ly:grob-layout grob))
             (props (ly:grob-alist-chain
                       grob
                       (ly:output-def-lookup layout 'text-font-defaults))))
      (interval-length
         (ly:stencil-extent
           (interpret-markup layout props (markup text-string))
           X))))
    #{

      \tweak TextSpanner.after-line-breaking
        #(lambda (grob)
          (let* ((mrkp-width (width grob mrkp))
                 (line-thickness (ly:staff-symbol-line-thickness grob)))
           (ly:grob-set-nested-property!
             grob
             '(bound-details left padding)
             (+ (/ mrkp-width -4) (* line-thickness 2)))))
      \tweak TextSpanner.font-size -2
      \tweak TextSpanner.style #'line
      \tweak TextSpanner.bound-details.left.text #mrkp
      \tweak TextSpanner.bound-details.left.padding 0.25
      \tweak TextSpanner.bound-details.left.attach-dir -4
      \tweak TextSpanner.bound-details.left-broken.text ##f
      \tweak TextSpanner.bound-details.left-broken.attach-dir -1
      %% adjust the numeric values to fit your needs:
      \tweak TextSpanner.bound-details.left-broken.padding 1.5
      \tweak TextSpanner.bound-details.right-broken.padding 0
      \tweak TextSpanner.bound-details.right.padding 0.25
      \tweak TextSpanner.bound-details.right.attach-dir 2
      \tweak TextSpanner.bound-details.right-broken.text ##f
      \tweak TextSpanner.bound-details.right.text
        \markup \draw-line #'(0 . -0.65)
      \startTextSpan
    #}))

PrefixDeuxTiers = \markup \concat {
  \override #'(font-family . typewriter)
  \override #'(word-space . -0.25)
  \line {
    \magnify #.5 { \raise #.5 "2" }
    \magnify #.5 { \raise #.2 "/" }
    \magnify #.5 { "3" }  

    \hspace #0.2
    \sans B
  }
}

barreDeuxTiers =
#(define-event-function (str) (string?)
  (let* ((mrkp (markup #:upright #:concat (PrefixDeuxTiers str " "))))
    (define (width grob text-string)
      (let* ((layout (ly:grob-layout grob))
             (props (ly:grob-alist-chain
                       grob
                       (ly:output-def-lookup layout 'text-font-defaults))))
      (interval-length
         (ly:stencil-extent
           (interpret-markup layout props (markup text-string))
           X))))
    #{

      \tweak TextSpanner.after-line-breaking
        #(lambda (grob)
          (let* ((mrkp-width (width grob mrkp))
                 (line-thickness (ly:staff-symbol-line-thickness grob)))
           (ly:grob-set-nested-property!
             grob
             '(bound-details left padding)
             (+ (/ mrkp-width -4) (* line-thickness 2)))))
      \tweak TextSpanner.font-size -2
      \tweak TextSpanner.style #'line
      \tweak TextSpanner.bound-details.left.text #mrkp
      \tweak TextSpanner.bound-details.left.padding 0.25
      \tweak TextSpanner.bound-details.left.attach-dir -4
      \tweak TextSpanner.bound-details.left-broken.text ##f
      \tweak TextSpanner.bound-details.left-broken.attach-dir -1
      %% adjust the numeric values to fit your needs:
      \tweak TextSpanner.bound-details.left-broken.padding 1.5
      \tweak TextSpanner.bound-details.right-broken.padding 0
      \tweak TextSpanner.bound-details.right.padding 0.25
      \tweak TextSpanner.bound-details.right.attach-dir 2
      \tweak TextSpanner.bound-details.right-broken.text ##f
      \tweak TextSpanner.bound-details.right.text
        \markup \draw-line #'(0 . -0.65)
      \startTextSpan
    #}))

PrefixCinqSix = \markup \concat {
  \override #'(font-family . typewriter)
  \override #'(word-space . -0.25)
  \line {
    \magnify #.5 { \raise #.5 "5" }
    \magnify #.5 { \raise #.2 "/" }
    \magnify #.5 { "6" }  

    \hspace #0.2
    \sans B
  }
}

barreCinqSix =
#(define-event-function (str) (string?)
  (let* ((mrkp (markup #:upright #:concat (PrefixCinqSix str " "))))
    (define (width grob text-string)
      (let* ((layout (ly:grob-layout grob))
             (props (ly:grob-alist-chain
                       grob
                       (ly:output-def-lookup layout 'text-font-defaults))))
      (interval-length
         (ly:stencil-extent
           (interpret-markup layout props (markup text-string))
           X))))
    #{

      \tweak TextSpanner.after-line-breaking
        #(lambda (grob)
          (let* ((mrkp-width (width grob mrkp))
                 (line-thickness (ly:staff-symbol-line-thickness grob)))
           (ly:grob-set-nested-property!
             grob
             '(bound-details left padding)
             (+ (/ mrkp-width -4) (* line-thickness 2)))))
      \tweak TextSpanner.font-size -2
      \tweak TextSpanner.style #'line
      \tweak TextSpanner.bound-details.left.text #mrkp
      \tweak TextSpanner.bound-details.left.padding 0.25
      \tweak TextSpanner.bound-details.left.attach-dir -4
      \tweak TextSpanner.bound-details.left-broken.text ##f
      \tweak TextSpanner.bound-details.left-broken.attach-dir -1
      %% adjust the numeric values to fit your needs:
      \tweak TextSpanner.bound-details.left-broken.padding 1.5
      \tweak TextSpanner.bound-details.right-broken.padding 0
      \tweak TextSpanner.bound-details.right.padding 0.25
      \tweak TextSpanner.bound-details.right.attach-dir 2
      \tweak TextSpanner.bound-details.right-broken.text ##f
      \tweak TextSpanner.bound-details.right.text
        \markup \draw-line #'(0 . -0.65)
      \startTextSpan
    #}))

%%%%%% modern barre
mBarr =
#(define-event-function (fretnum partial)
   (number? number?)
    #{
      \tweak bound-details.left.text
        \markup
          \small \bold \concat {
          %\Prefix
          #(format #f "~@r" fretnum)
          \hspace #.2
          \lower #.3 \fontsize #-2 #(number->string partial)
          \hspace #.5
        }
      \tweak font-size -1
      \tweak font-shape #'upright
      \tweak style #'dashed-line
      \tweak dash-fraction #0.3
      \tweak dash-period #1
      \tweak bound-details.left.stencil-align-dir-y #0.35
      \tweak bound-details.left.padding -1
      %\tweak bound-details.left.attach-dir -2
      \tweak bound-details.left-broken.text ##f
      \tweak bound-details.left-broken.attach-dir -1
      %% adjust the numeric values to fit your needs:
      \tweak bound-details.left-broken.padding 1.5
      \tweak bound-details.right-broken.padding 0
      \tweak bound-details.right.padding -1.5
      %\tweak bound-details.right.attach-dir -2
      \tweak bound-details.right-broken.text ##f
      \tweak bound-details.right.text
        \markup
          \with-dimensions #'(0 . 0) #'(-.3 . 0)
          \draw-line #'(0 . -1)
      \startTextSpan
   #})

mBar = #(define-event-function (fretnum partial)
     (number? number?)
      #{
        \tweak bound-details.left.text
          \markup\concat {
            #(format #f "~@r" fretnum) \hspace #.2 \lower #.3
            \override #'(thickness . 1)
            \override #'(circle-padding . 0.1)
            \circle\finger\fontsize #-2
            #(number->string partial)
            \hspace #.5
          }
        \tweak font-size -1
        \tweak font-shape #'upright
        \tweak style #'straight-line
        %\tweak dash-fraction #0.3
        %\tweak dash-period #1
        \tweak bound-details.left.stencil-align-dir-y #0.35
        \tweak bound-details.left.padding -1
        %\tweak bound-details.left.attach-dir -2
        \tweak bound-details.left-broken.text ##f
        \tweak bound-details.left-broken.attach-dir -1
        %% adjust the numeric values to fit your needs:
        \tweak bound-details.left-broken.padding 1.5
        %\tweak bound-details.right-broken.padding 0
        \tweak bound-details.right.padding #-1.5
        %\tweak bound-details.right.attach-dir -2
        \tweak bound-details.right-broken.text ##f
        \tweak bound-details.right-broken.padding 0
        \tweak bound-details.right.text
          \markup
            %\with-dimensions-from \null
            \draw-line #'(0 . -1)
        \startTextSpan
     #})

sBar = \stopTextSpan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
unTiers = \markup\concat {
   \override #'(font-family . typewriter)
   \override #'(word-space . -0.25)
   \line {
      \magnify #.5 { \raise #.5 "1" }
      \magnify #.5 { \raise #.2 "/" }
      \magnify #.5 { "3" }
      \hspace #0.2
      \sans B
   }
}

unDemi = \markup\concat {
   \override #'(font-family . typewriter)
   \override #'(word-space . -0.25)
   \line {
      \magnify #.5 { \raise #.5 "1" }
      \magnify #.5 { \raise #.2 "/" }
      \magnify #.5 { "2" }
      \hspace #0.2
      \sans B
   }
}

deuxTiers = \markup\concat {
   \override #'(font-family . typewriter)
   \override #'(word-space . -0.25)
   \line {
      \magnify #.5 { \raise #.5 "2" }
      \magnify #.5 { \raise #.2 "/" }
      \magnify #.5 { "3" }
      \hspace #0.2
      \sans B
   }
}
cinqSix = \markup\concat {
   \override #'(font-family . typewriter)
   \override #'(word-space . -0.25)
   \line {
      \magnify #.5 { \raise #.5 "5" }
      \magnify #.5 { \raise #.2 "/" }
      \magnify #.5 { "6" }
      \hspace #0.2
      \sans B
   }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 		Doigtés
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% shortcuts right hand fingering must be use in
%% chord notation < > (space before > is included in shortcut)
ap = \rightHandFinger #1
ai = \rightHandFinger #2
am = \rightHandFinger #3
aa = \rightHandFinger #4
ax = \rightHandFinger #5

%% flamenco notation :
strokeUp =
  \markup
  \combine
  \override #'(thickness . 1.3)
  \draw-line #'(0 . 2)
  \raise #2
  \arrow-head #Y #UP ##f
  
strokeDown =
  \markup
  \combine
  \arrow-head #Y #DOWN ##f
  \override #'(thickness . 1.3)
  \draw-line #'(0 . 2)
% Golpe symbol :
golpe = \markup {
  \filled-box #'(0 . 1) #'(0 . 1) #0
  \hspace #-1.6
  \with-color #white
  \filled-box #'(0.15 . 0.85) #'(0.15 . 0.85) #0
}

% Strokesand golpe command :
au = \rightHandFinger \strokeUp
ad = \rightHandFinger \strokeDown
ag = \rightHandFinger \golpe
GOneDown 	= \markup \concat { \hspace #-1 \raise #.4 \rotate #-15 "–" \finger "1" }
GTwoDown 	= \markup \concat { \hspace #-1 \raise #.4 \rotate #-15 "–" \finger "2" }
GThreeDown = \markup \concat { \hspace #-1 \raise #.4 \rotate #-15 "–" \finger "3" }
GFourDown = \markup \concat { \hspace #-1 \raise #.4 \rotate #-15 "–" \finger "4" }
GOneUp = \markup \concat { \hspace #-1 \raise #-0.5  \rotate #15 "–" \finger "1" }
GTwoUp = \markup \concat { \hspace #-1 \raise #-0.5  \rotate #15 "–" \finger "2" }
GThreeUp = \markup \concat { \hspace #-1 \raise #-0.5  \rotate #15 "–" \finger "3" }
GFourUp = \markup \concat { \hspace #-1 \raise #-0.5  \rotate #15 "–" \finger "4" }
GOne 	= \markup \concat { \hspace #-1 \raise #-0.3 "–" \finger "1" }
GTwo 	= \markup \concat { \hspace #-1 \raise #-0.3 "–" \finger "2" }
GThree = \markup \concat { \hspace #-1 \raise #-0.3 "–" \finger "3" }
GFour	= \markup \concat { \hspace #-1 \raise #-0.3 "–" \finger "4" }
glissOne =
#(let ((finger (make-music 'FingeringEvent)))
   (set! (ly:music-property finger 'tweaks)
         (acons 'text (markup GOne)
                (ly:music-property finger 'tweaks)))
   finger)
 

glissTwo =
#(let ((finger (make-music 'FingeringEvent)))
   (set! (ly:music-property finger 'tweaks)
         (acons 'text (markup GTwo)
                (ly:music-property finger 'tweaks)))
   finger)
 

glissThree =
#(let ((finger (make-music 'FingeringEvent)))
   (set! (ly:music-property finger 'tweaks)
         (acons 'text (markup GThree)
                (ly:music-property finger 'tweaks)))
   finger)
 

glissFour =
#(let ((finger (make-music 'FingeringEvent)))
   (set! (ly:music-property finger 'tweaks)
         (acons 'text (markup GFour)
                (ly:music-property finger 'tweaks)))
   finger)
glissOneUp =
#(let ((finger (make-music 'FingeringEvent)))
   (set! (ly:music-property finger 'tweaks)
         (acons 'text (markup GOneUp)
                (ly:music-property finger 'tweaks)))
   finger)
 

glissTwoUp =
#(let ((finger (make-music 'FingeringEvent)))
   (set! (ly:music-property finger 'tweaks)
         (acons 'text (markup GTwoUp)
                (ly:music-property finger 'tweaks)))
   finger)
 

glissThreeUp =
#(let ((finger (make-music 'FingeringEvent)))
   (set! (ly:music-property finger 'tweaks)
         (acons 'text (markup GThreeUp)
                (ly:music-property finger 'tweaks)))
   finger)
 

glissFourUp =
#(let ((finger (make-music 'FingeringEvent)))
   (set! (ly:music-property finger 'tweaks)
         (acons 'text (markup GFourUp)
                (ly:music-property finger 'tweaks)))
   finger)
glissOneDown =
#(let ((finger (make-music 'FingeringEvent)))
   (set! (ly:music-property finger 'tweaks)
         (acons 'text (markup GOneDown)
                (ly:music-property finger 'tweaks)))
   finger)
 

glissTwoDown =
#(let ((finger (make-music 'FingeringEvent)))
   (set! (ly:music-property finger 'tweaks)
         (acons 'text (markup GTwoDown)
                (ly:music-property finger 'tweaks)))
   finger)
 

glissThreeDown =
#(let ((finger (make-music 'FingeringEvent)))
   (set! (ly:music-property finger 'tweaks)
         (acons 'text (markup GThreeDown)
                (ly:music-property finger 'tweaks)))
   finger)
 

glissFourDown =
#(let ((finger (make-music 'FingeringEvent)))
   (set! (ly:music-property finger 'tweaks)
         (acons 'text (markup GFourDown)
                (ly:music-property finger 'tweaks)))
   finger)
NoFin =
\markup {
  \with-dimensions #'(-.4 . .6) #'(-.5 . .5)
  %\with-dimensions-from \null % { \finger "4" }
  %\translate #'(-.1 . .4)
  \concat {
    \combine
    \draw-circle #0.51 #0.1 ##t
    \with-color #white \draw-circle #0.33 #0.1 ##t
  }
}
nf =
#(let ((finger (make-music 'FingeringEvent)))
   (set! (ly:music-property finger 'tweaks)
         (acons 'text (markup NoFin)
                (ly:music-property finger 'tweaks)))
   finger) 

o = \finger
  \markup\concat {
    \combine
    \draw-circle #0.51 #0.1 ##t
    \with-color #white \draw-circle #0.33 #0.1 ##t
  }
  
gl = #(define-event-function (n) (index?)
  #{ 
    \finger 
    \markup\concat { 
      \text \fontsize #2 \bold "–" %\bold "—"
      #(format "~d" n) 
  } #})

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
       \bar ".|:"
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Position
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use: position #position #padding
position =
#(define-music-function (pos padding)
   (string? number?)
    #{
      \once\override Voice.TextSpanner.padding = #padding
      \once\override Voice.TextSpanner.style = #'dashed-line
      \once\override Voice.TextSpanner.dash-period = #1.2
      \once\override Voice.TextSpanner.bound-details.left.padding = #-.1
      \once\override Voice.TextSpanner.bound-details.right.padding = #-.8
      \once \override Voice.TextSpanner.bound-details.left.text =
        \markup\lower #.2 \concat\small\italic { $pos \hspace #.5 }
      \once \override Voice.TextSpanner.bound-details.left-broken.text = \markup { \null }
      \once \override Voice.TextSpanner.bound-details.left-broken.padding = #-3
      \once \override Voice.TextSpanner.bound-details.right-broken.text = \markup { \null }
      \once \override Voice.TextSpanner.bound-details.right-broken.padding = #0.5
      \once\override Voice.TextSpanner.bound-details.right.text =
        \markup\column { " " \vspace #.3 }
    #})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	String number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use: stringNumberSpanner #direction (UP/DOWN) #stringnumber
stringNumberSpanner =
#(define-music-function (direction string)
   (number? number?)
    #{
      \once \override Voice.TextSpanner.style = #'dashed-line
      \once \override Voice.TextSpanner.dash-period = #.8
      \once \override Voice.TextSpanner.bound-details.left.padding = #.3
      \once \override Voice.TextSpanner.bound-details.right.padding = #-.8
      \once \override Voice.TextSpanner.bound-details.left.stencil-align-dir-y = #CENTER
      \once \override Voice.TextSpanner.font-encoding = #'latin1
      \once \override Voice.TextSpanner.font-series = #'bold
      \once \override Voice.TextSpanner.font-size = #-2.5
      \once \override Voice.TextSpanner.bound-details.left.text =
        \markup\circle \upright $(number->string string)
      \once \override Voice.TextSpanner.bound-details.left-broken.text = \markup { \null }
      \once \override Voice.TextSpanner.bound-details.left-broken.padding = #-3
      \once \override Voice.TextSpanner.bound-details.right-broken.text = \markup { \null }
      \once \override Voice.TextSpanner.bound-details.right-broken.padding = #0.5
      \once \override Voice.TextSpanner.direction = #direction
      \once \override Voice.TextSpanner.bound-details.right.text =
        \markup\draw-line $(cons 0 ( * -0.45 direction ))
    #})
% use: stringNumberSpanner #direction (UP/DOWN) #stringnumber #padding
doubleStringNumberSpanner =
#(define-music-function (direction string1 string2 padding)
   (number? number? number? number?)
    #{
      \once \override Voice.TextSpanner.padding = #padding
      \once \override Voice.TextSpanner.style = #'dashed-line
      \once \override Voice.TextSpanner.dash-period = #.8
      \once \override Voice.TextSpanner.bound-details.left.padding = #-.1
      \once \override Voice.TextSpanner.bound-details.right.padding = #-.8
      \once \override Voice.TextSpanner.bound-details.left.stencil-align-dir-y = #CENTER
      \once \override Voice.TextSpanner.font-encoding = #'latin1
      \once \override Voice.TextSpanner.font-series = #'bold
      \once \override Voice.TextSpanner.font-size = #-2.5
      \once \override Voice.TextSpanner.bound-details.left.text =
        \markup\center-column {
          \raise #-1 \circle\upright $(number->string string1)
          \raise #1 \circle\upright $(number->string string2)
        }
      \once \override Voice.TextSpanner.bound-details.left-broken.text = \markup { \null }
      \once \override Voice.TextSpanner.bound-details.left-broken.padding = #-3
      \once \override Voice.TextSpanner.bound-details.right-broken.text = \markup { \null }
      \once \override Voice.TextSpanner.bound-details.right-broken.padding = #0.5
      \once \override Voice.TextSpanner.direction = #direction
      \once \override Voice.TextSpanner.bound-details.right.text =
        \markup\draw-line $(cons 0 ( * -0.45 direction ))
    #})


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RitSpannerUp =
#(define-music-function (Text) (string?)
  #{
    \textSpannerUp
    \once \override TextSpanner.padding = #3
    \once \override TextSpanner.style = #'dashed-line
    \once \override TextSpanner.dash-period = #2
    \once \override TextSpanner.to-barline = ##f
    \once \override TextSpanner.bound-details =
            #`((left
                (text . ,#{ \markup\raise #-.1 { \small \italic $Text } #})
                (Y . 0)
                (padding . 0.25)
                (attach-dir . -2))
               (right
                (Y . 0)
                (padding . 0.25)
                (attach-dir . 1)))
    \once \override TextSpanner.bound-details.left-broken.attach-dir = #0
    \once \override TextSpanner.bound-details.left-broken.text = ##f
    \once \override TextSpanner.bound-details.right-broken.text = ##f
  #})
RitSpannerDown =
#(define-music-function (Text) (string?)
  #{
    \textSpannerDown
    \once \override TextSpanner.padding = #3
    \once \override TextSpanner.style = #'dashed-line
    \once \override TextSpanner.dash-period = #2
    \once \override TextSpanner.to-barline = ##f
    \once \override TextSpanner.bound-details =
            #`((left
                (text . ,#{ \markup\raise #-.2 { \small \italic $Text } #})
                (Y . 0)
                (padding . 0.25)
                (attach-dir . -2))
               (right
                (Y . 0)
                (padding . 0.25)
                (attach-dir . 1)))
    \once \override TextSpanner.bound-details.left-broken.attach-dir = #0
    \once \override TextSpanner.bound-details.left-broken.text = ##f
    \once \override TextSpanner.bound-details.right-broken.text = ##f
  #})


RitAtempoSpannerUp =
#(define-music-function (Text) (string?)
  #{
    \textSpannerUp
    \once \override TextSpanner.padding = #3
    \once \override TextSpanner.style = #'dashed-line
    \once \override TextSpanner.dash-period = #1.3
    \once \override TextSpanner.to-barline = ##f
    \once \override TextSpanner.bound-details =
            #`((left
                (text . ,#{ \markup { \small \italic $Text } #})
                (Y . 0)
                (padding . 0.25)
                (attach-dir . -2))
               (right
                (text . ,#{ \markup { \small\italic "  a tempo" } #})
                (Y . 0)
                (padding . 0.25)
                (attach-dir . -3)))
    \once \override TextSpanner.bound-details.left-broken.attach-dir = #0
    \once \override TextSpanner.bound-details.left-broken.text = ##f
    \once \override TextSpanner.bound-details.right-broken.text = ##f
  #})


RitAtempoSpannerDown =
#(define-music-function (Text) (string?)
  #{
    \textSpannerDown
    \once \override TextSpanner.padding = #3
    \once \override TextSpanner.style = #'dashed-line
    \once \override TextSpanner.dash-period = #1.3
    \once \override TextSpanner.to-barline = ##f
    \once \override TextSpanner.bound-details =
            #`((left
                (text . ,#{ \markup { \small \italic $Text } #})
                (Y . 0)
                (padding . 0.25)
                (attach-dir . -2))
               (right
                (text . ,#{ \markup { \small\italic "  a tempo" } #})
                (Y . 0)
                (padding . 0.25)
                (attach-dir . -3)))
    \once \override TextSpanner.bound-details.left-broken.attach-dir = #0
    \once \override TextSpanner.bound-details.left-broken.text = ##f
    \once \override TextSpanner.bound-details.right-broken.text = ##f
  #})


CaseNumberSpannerUp =
#(define-music-function (Case) (string?)
  #{
    \textSpannerUp
  

    \once \override TextSpanner.style = #'dashed-line
    \once \override TextSpanner.dash-period = #0.8
    \once \override TextSpanner.to-barline = ##f
    \once \override TextSpanner.bound-details =
            #`((left
                (text . ,#{ \markup { \tiny $Case } #})
                (Y . 0)
                (padding . 0.25)
                (attach-dir . -2))
               (right
                (text . ,#{ \markup { \draw-line #'( 0 . -.5) } #})
                (Y . 0)
                (padding . 0.25)
                (attach-dir . 2)))
    \once \override TextSpanner.bound-details.left-broken.attach-dir = #0
    \once \override TextSpanner.bound-details.left-broken.text = ##f
    \once \override TextSpanner.bound-details.right-broken.text = ##f
  #})


CaseNumberSpannerDown =
#(define-music-function (Case) (string?)
  #{
    \textSpannerDown
  

    \once \override TextSpanner.style = #'dashed-line
    \once \override TextSpanner.dash-period = #0.8
    \once \override TextSpanner.to-barline = ##f
    \once \override TextSpanner.bound-details =
            #`((left
                (text . ,#{ \markup { \tiny $Case } #})
                (Y . 0)
                (padding . 0.25)
                (attach-dir . -2))
               (right
                (text . ,#{ \markup { \draw-line #'( 0 . 0.5) } #})
                (Y . 0)
                (padding . 0.25)
                (attach-dir . 2)))
    \once \override TextSpanner.bound-details.left-broken.attach-dir = #0
    \once \override TextSpanner.bound-details.left-broken.text = ##f
    \once \override TextSpanner.bound-details.right-broken.text = ##f
  #})
%%%%%%%%%%%%%%%
% copyleft
%%%%%%%%%%%%%%%
copyLeft = \markup \epsfile #X #1.6 #"Copyleft.eps"
%%%%%%%%%%%%%%%
% midpartial
%%%%%%%%%%%%%%%
midPartial =
#(define-music-function (music)
   (ly:music?)
   #{
     \once\omit Score.BarNumber
     \cadenzaOn
     #music \bar "|"
     \cadenzaOff
   #})

%%%% Variable Slurs and ties %%%%%%%%
#(define (bezier-curve control-points t)
"Given a Bezier curve of arbitrary degree specified by @var{control-points},
compute the point at the specified position @var{t}."
  (if (< 1 (length control-points))
      (let ((q0 (bezier-curve (drop-right control-points 1) t))
            (q1 (bezier-curve (drop control-points 1) t)))
        (cons
          (+ (* (car q0) (- 1 t)) (* (car q1) t))
          (+ (* (cdr q0) (- 1 t)) (* (cdr q1) t))))
      (car control-points)))

#(define (bezier-approx-length control-points from to)
"Given a Bezier curve of arbitrary degree specified by @var{control-points},
compute its approximate arc length between the positions @var{from} and @var{to}."
  (let* ((steps 10)
         (params (iota steps from (/ (- to from) (1- steps))))
         (points (map (lambda (x) (bezier-curve control-points x)) params))
         (length 
           (fold 
             (lambda (a b prev) 
               (+ prev (ly:length (- (car a) (car b)) (- (cdr a) (cdr b)))))
             0 
             (drop points 1) 
             (drop-right points 1))))
    ; Need to support negative length when the range is inverted.
    (if (< from to) length (- length))))
          
#(define (variable-bow-thickness min-l max-l min-t max-t) 
  (lambda (grob)
      (let* ((cpf (ly:grob-property-data grob 'control-points))
             (cpt (ly:grob-property grob 'control-points))
             ;(cp0 (car cpt)) 
             ;(cp3 (cadddr cpt))
             ;(dx (- (car cp3) (car cp0)))
             ;(dy (- (cdr cp3) (cdr cp0)))
             ;(len (ly:length dx dy))
             (len (bezier-approx-length cpt 0 1))
             (thickness
               (cond ((< len min-l) min-t)
                     ((> len max-l) max-t)
                     (else 
                       (+ min-t 
                         (* (- len min-l)
                            (/ (- max-t min-t) 
                               (- max-l min-l))))))))
        (ly:grob-set-property! grob 'thickness thickness)
        (ly:grob-set-property! grob 'control-points (ly:unpure-call cpf grob)))))


%%%%%%%%%%%%%%%
% Clefs G
%%%%%%%%%%%%%%%
#(define-markup-command (G-mauri layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup
    (#:stencil
     (make-path-stencil
       '(M 0.00  0.50
         C 0.00  2.17  2.22  2.50  2.22  3.75
         C 2.22  3.75  2.22  4.24  2.01  4.24
         C 1.90  4.24  1.15  4.00  1.51  1.95
         L 2.06 -1.70
         C 2.13 -2.10  2.00 -2.78  1.20 -2.78
         C 0.70 -2.77  0.50 -2.45  0.50 -2.10
         C 0.50 -1.85  0.72 -1.60  0.95 -1.60
         C 1.21 -1.60  1.36 -1.75  1.36 -2.00
         C 1.36 -2.13  1.22 -2.35  0.95 -2.36
         C 0.90 -2.36  0.80 -2.38  0.80 -2.42
         C 0.80 -2.52  1.00 -2.63  1.20 -2.63
         C 1.50 -2.63  2.05 -2.48  1.91 -1.60
         L 1.30  2.45
         C 0.92  4.45  1.90  4.76  1.96  4.76
         C 2.20  4.76  2.36  4.05  2.36  3.60
         C 2.36  1.67  0.28  1.83  0.28  0.20
         C 0.28 -1.22  2.50 -1.29  2.50  0.00
         C 2.50  0.81  1.07  0.87  1.07  0.10
         C 1.07 -0.20  1.10 -0.29  1.44 -0.56
         C 1.54 -0.63  1.47 -0.63  1.45 -0.63
         C 1.24 -0.63  0.83 -0.29  0.83  0.19
         C 0.83  0.65  1.20  1.10  1.70  1.10
         C 2.40  1.10  2.70  0.45  2.70  0.10
         C 2.70 -0.55  2.28 -1.06  1.40 -1.06
         C 0.70 -1.06  0.00 -0.45  0.00  0.50
         Z)
       thk mlt mlt #t)))))
mauri = \layout {
  \context {
    \Score
    \override Clef.stencil =
              #(lambda (grob)
                 (let* ((sz (ly:grob-property grob 'font-size 0.00))
                        (mlt (magstep sz))
                        (glyph (ly:grob-property grob 'glyph-name)))
                       (cond
                        ((equal? glyph "clefs.G")
                         (grob-interpret-markup grob
                          (markup #:scale(cons mlt mlt)#:G-mauri 0 1)))
                        ((equal? glyph "clefs.G_change")
                         (grob-interpret-markup grob
                          (markup #:scale(cons mlt mlt)#:G-mauri .01 .8)))
                        (else (ly:clef::print grob)))))
      %\override Clef.X-extent = #'(0 . 2.9)
      \override ClefModifier.extra-offset = #'(0.3 . 0)
      \override ClefModifier.stencil = #(lambda (grob) (grob-interpret-markup grob
                              #{ \markup\fontsize #1.1 \bold "8" #}))
      \override Beam.beam-thickness = #0.58
      \override StrokeFinger.avoid-slur = #'inside
      \override StrokeFinger.add-stem-support = ##t
  }
}
#(define-markup-command (G_trasatti layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup
    (#:stencil
     (make-path-stencil
      '(M  1.125 -2.524
        C  0.969 -2.548  0.645 -2.481 0.520 -2.317
        C  0.363 -2.110  0.316 -1.919 0.359 -1.720
        C  0.418 -1.450  0.680 -1.270 0.957 -1.380
        C  1.199 -1.474  1.266 -1.915 1.129 -2.044
        C  1.000 -2.161  0.727 -2.345 1.074 -2.364
        C  1.785 -2.407  1.770 -1.559 1.711 -1.020
        C  0.504 -1.302 -0.219 -0.184 0.051  0.761
        C  0.281  1.585  0.973  2.034 1.340  2.319
        C  1.281  2.843  1.184  3.515 1.418  3.933
        C  1.520  4.140  1.664  4.339 1.832  4.515
        C  2.180  4.886  2.297  4.245 2.352  4.003
        C  2.453  3.530  2.441  3.144 2.324  2.773
        C  2.180  2.323  1.695  1.831 1.559  1.741
        C  1.590  1.452  1.602  1.355 1.629  1.105
        C  2.871  1.077  2.801 -0.766 1.867 -0.981
        C  1.945 -1.673  1.934 -2.474 1.125 -2.524
        M  1.691 -0.864
        C  1.637 -0.302  1.582  0.116 1.535  0.546
        C  1.125  0.526  0.777  0.179 0.992 -0.352
        C  1.078 -0.563  1.355 -0.638 1.199 -0.645
        C  1.086 -0.649  0.922 -0.505 0.824 -0.333
        C  0.469  0.280  0.957  1.007 1.484  1.089
        C  1.465  1.253  1.449  1.366 1.414  1.640
        C  0.734  1.171  0.539  0.898 0.398  0.640
        C -0.027 -0.138  0.734 -1.091 1.691 -0.864
        M  1.695  0.546
        C  1.746  0.073  1.805 -0.477 1.848 -0.837
        C  2.395 -0.704  2.586  0.530 1.695  0.546
        M  2.238  3.941
        C  2.160  4.214  1.707  3.675 1.652  3.585
        C  1.379  3.155  1.426  2.933 1.480  2.429
        C  2.039  2.847  2.457  3.151 2.238  3.941
        Z)
       thk mlt mlt #t)))))
trasatti = \layout {
  \context {
    \Score
    \override Clef.stencil =
      #(lambda (grob)
         (let* ((sz (ly:grob-property grob 'font-size 0.00))
                (mlt (magstep sz))
                (glyph (ly:grob-property grob 'glyph-name)))
               (cond
                ((equal? glyph "clefs.G")
                 (grob-interpret-markup grob
                  (markup #:scale(cons mlt mlt)#:G_trasatti 0 1)))
                ((equal? glyph "clefs.G_change")
                 (grob-interpret-markup grob
                  (markup #:scale(cons mlt mlt)#:G_trasatti .01 .8)))
                (else (ly:clef::print grob)))))
    \override ClefModifier.extra-offset = #'(.2 . 0)
  }
}
#(define-markup-command (G_Mokba layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup
    (#:stencil
     (make-path-stencil
      '(M 1.113 -2.403
        C 0.355 -2.345 0.23 -1.54 0.629 -1.282
        C 0.867 -1.134 1.227 -1.255 1.32 -1.536
        C 1.406 -1.794 1.23 -2.048 1.027 -2.161
        C 1.367 -2.263 1.637 -2.153 1.723 -1.872
        C 1.832 -1.493 1.809 -1.259 1.762 -0.981
        C 1.301 -1.181 0.395 -0.747 0.184 -0.282
        C -0.309 0.862 0.238 1.558 1.215 2.319
        C 0.949 3.585 1.18 3.804 1.426 4.269
        C 1.512 4.429 1.906 5.015 2.043 4.62
        C 2.27 3.968 2.742 2.96 1.516 1.788
        C 1.551 1.558 1.57 1.413 1.605 1.226
        C 2.074 1.316 2.551 0.8 2.617 0.276
        C 2.711 -0.462 2.188 -0.809 1.953 -0.899
        C 2 -1.184 2.016 -1.634 1.953 -1.872
        C 1.871 -2.208 1.629 -2.446 1.113 -2.403
        M 1.723 -0.778
        C 1.637 -0.212 1.574 0.144 1.5 0.585
        C 1.113 0.581 1.008 -0.063 1.16 -0.302
        C 1.246 -0.427 1.582 -0.61 1.328 -0.595
        C 1.023 -0.575 0.797 -0.118 0.766 0.124
        C 0.699 0.667 0.949 1.073 1.398 1.175
        C 1.379 1.327 1.363 1.444 1.332 1.616
        C 0.82 1.128 0.313 0.737 0.371 0.132
        C 0.434 -0.587 1.336 -0.938 1.723 -0.778
        M 1.914 -0.7
        C 2.262 -0.52 2.328 -0.208 2.293 0.109
        C 2.262 0.374 2.102 0.585 1.707 0.585
        C 1.77 0.214 1.824 -0.239 1.914 -0.7
        M 1.398 2.476
        C 1.754 2.851 2.09 3.234 2.141 3.78
        C 2.16 3.991 2.113 4.253 1.781 3.972
        C 1.168 3.444 1.332 2.87 1.398 2.476
        Z)
      thk mlt mlt #t)))))
#(define-markup-command (F_Mokba layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup
    (#:stencil
     (make-path-stencil
      '(M 0.258 -1.755
        C 0.582 -1.681 0.957 -1.462 1.188 -1.188
        C 1.531 -0.77 1.813 0.175 1.242 0.757
        C 1.008 1.003 0.605 0.925 0.391 0.569
        C 0.273 0.37 0.453 0.448 0.648 0.456
        C 0.773 0.46 0.914 0.362 0.98 0.253
        C 1.078 0.105 1.07 -0.118 0.969 -0.251
        C 0.813 -0.458 0.66 -0.481 0.387 -0.431
        C 0.281 -0.411 0.164 -0.313 0.105 -0.22
        C -0.082 0.089 -0.008 0.566 0.246 0.769
        C 0.867 1.261 1.484 1.093 1.855 0.593
        C 2.016 0.378 2.137 0.038 2.094 -0.384
        C 2.004 -1.208 1.098 -1.938 0.313 -1.934
        C 0.102 -1.942 -0.227 -1.86 0.258 -1.751
        M 2.223 -0.645
        C 2.141 -0.552 2.168 -0.423 2.23 -0.345
        C 2.289 -0.266 2.438 -0.231 2.523 -0.286
        C 2.641 -0.356 2.652 -0.434 2.652 -0.516
        C 2.648 -0.567 2.609 -0.681 2.516 -0.716
        C 2.363 -0.778 2.262 -0.692 2.223 -0.645
        M 2.211 0.362
        C 2.145 0.472 2.18 0.581 2.23 0.64
        C 2.262 0.671 2.332 0.734 2.438 0.722
        C 2.52 0.71 2.613 0.663 2.648 0.53
        C 2.668 0.456 2.637 0.366 2.574 0.308
        C 2.477 0.218 2.297 0.218 2.211 0.362
        Z)
      thk mlt mlt #t)))))
mokba = \layout {
  \context {
    \Score
    \override Clef.stencil =
        #(lambda (grob)
           (let* ((sz (ly:grob-property grob 'font-size 0))
                  (mlt (magstep sz))
                  (glyph (ly:grob-property grob 'glyph-name)))
                 (cond
                  ((equal? glyph "clefs.G")
                   (grob-interpret-markup grob
                    (markup #:scale(cons mlt mlt)#:G_Mokba 0 1)))
                  ((equal? glyph "clefs.G_change")
                   (grob-interpret-markup grob
                    (markup #:scale(cons mlt mlt)#:G_Mokba .01 .8)))
                  ((equal? glyph "clefs.F")
                   (grob-interpret-markup grob
                    (markup #:scale(cons mlt mlt)#:F_Mokba 0 1)))
                  ((equal? glyph "clefs.F_change")
                   (grob-interpret-markup grob
                    (markup #:scale(cons mlt mlt)#:F_Mokba .01 .8)))
                  (else (ly:clef::print grob)))))
        \override ClefModifier.extra-offset = #'(.4 . 0)
        \override ClefModifier.font-series = #'bold
  }
}
#(define-markup-command (G_django layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup
    (#:stencil
     (make-path-stencil
      '(M 0.699 -1.556
        C 0.707 -1.399 0.82 -1.251 1.055 -1.251
        C 1.289 -1.255 1.352 -1.77 0.973 -1.665
        C 0.855 -1.665 0.832 -1.876 1.02 -1.977
        C 1.797 -2.407 2.406 -1.446 2.063 -0.778
        C 1.277 -1.263 0.246 -1.005 0.008 -0.095
        C -0.102 0.515 0.32 1.019 0.637 1.155
        C 0.004 1.737 0.188 2.558 0.734 2.886
        C 1.277 3.21 1.809 3.026 2.105 2.644
        C 2.402 2.261 2.398 1.71 2.105 1.347
        C 1.813 0.984 1.371 1.198 1.145 1.386
        C 1.066 1.226 1.145 0.956 1.207 0.804
        C 2.543 1.87 3.258 -0.024 2.191 -0.681
        C 2.805 -2.349 0.656 -2.712 0.699 -1.559
        M 1.992 -0.626
        C 1.754 -0.204 1.633 0.015 1.23 0.452
        C 1.156 0.226 1.313 -0.204 1.211 -0.216
        C 1.02 -0.208 0.914 -0.337 0.758 -0.45
        C 1.184 -0.845 1.625 -0.985 1.992 -0.626
        M 2.074 -0.477
        C 2.559 0.249 1.715 1.034 1.223 0.694
        C 1.621 0.249 1.863 -0.032 2.074 -0.477
        M 0.727 -0.376
        C 0.84 -0.282 0.773 0.702 0.711 1.03
        C 0.355 0.441 0.57 -0.216 0.727 -0.376
        M 1.254 1.87
        C 1.363 2.05 1.273 2.077 1.809 1.675
        C 2.348 1.269 2.289 2.792 1.395 2.851
        C 0.5 2.913 0.055 1.921 0.777 1.234
        C 0.902 1.569 1.086 1.484 1.254 1.87
        Z)
       thk mlt mlt #t)))))
django = \layout {
  \context {
    \Score
    \override Clef.stencil =
        #(lambda (grob)
           (let* ((sz (ly:grob-property grob 'font-size 0.00))
                  (mlt (magstep sz))
                  (glyph (ly:grob-property grob 'glyph-name)))
                 (cond
                  ((equal? glyph "clefs.G")
                   (grob-interpret-markup grob
                    (markup #:scale(cons mlt mlt)#:G_django 0 1)))
                  ((equal? glyph "clefs.G_change")
                   (grob-interpret-markup grob
                    (markup #:scale(cons mlt mlt)#:G_django .01 .8)))
                  (else (ly:clef::print grob)))))
    \override ClefModifier.extra-offset = #'(.4 . 0)
    \override ClefModifier.font-series = #'bold
  }
}
#(define-markup-command (G_abAeterno layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup
    (#:stencil
     (make-path-stencil
      '(M 1.867 4.699
        C 1.898 4.699 1.938 4.695 1.965 4.676
        C 2.324 4.414 2.348 3.535 2.266 2.965
        C 2.16 1.77 0.246 1.313 0.336 0.23
        C 0.379 -0.449 0.844 -0.875 1.348 -0.891
        C 1.895 -0.887 2.227 -0.645 2.227 -0.117
        C 2.23 0.852 0.934 0.742 0.945 0.082
        C 0.961 -0.082 0.98 -0.195 1.141 -0.379
        C 1.156 -0.398 1.191 -0.406 1.188 -0.43
        C 1.188 -0.445 1.172 -0.461 1.156 -0.465
        C 1.102 -0.484 1.027 -0.457 0.98 -0.426
        C 0.871 -0.352 0.648 -0.129 0.68 0.227
        C 0.754 1.395 2.5 1.27 2.504 0.008
        C 2.465 -0.41 2.328 -0.586 2.102 -0.77
        C 1.887 -0.941 1.645 -1.012 1.301 -0.992
        C 0.473 -0.941 -0.035 -0.309 -0.02 0.508
        C -0.008 1.793 1.902 2.086 2.098 3.598
        C 2.113 3.938 2.07 3.98 2.066 4.008
        C 2.047 4.074 1.668 3.887 1.492 3.383
        C 1.395 3.113 1.344 2.871 1.391 2.426
        C 1.453 1.855 1.617 0.23 1.746 -1.258
        C 1.75 -1.332 1.75 -1.516 1.738 -1.633
        C 1.688 -2.211 1.297 -2.445 0.941 -2.457
        C 0.508 -2.469 0.254 -2.133 0.324 -1.746
        C 0.355 -1.574 0.555 -1.363 0.816 -1.426
        C 1.008 -1.473 1.055 -1.613 1.063 -1.75
        C 1.07 -1.891 1.035 -2.035 0.844 -2.109
        C 0.68 -2.172 0.555 -2.051 0.555 -2.051
        C 0.57 -2.184 0.75 -2.316 0.98 -2.293
        C 1.434 -2.254 1.563 -1.855 1.586 -1.551
        C 1.598 -1.441 1.59 -1.273 1.59 -1.273
        C 1.484 0.359 1.23 1.805 1.176 3.156
        C 1.164 3.461 1.18 3.695 1.266 3.98
        C 1.383 4.367 1.613 4.578 1.777 4.676
        C 1.793 4.688 1.836 4.699 1.867 4.699
        Z)
       thk mlt mlt #t)))))
abAeterno = \layout {
  \context {
    \Score
    \override Clef.stencil =
        #(lambda (grob)
           (let* ((sz (ly:grob-property grob 'font-size 0.00))
                  (mlt (magstep sz))
                  (glyph (ly:grob-property grob 'glyph-name)))
                 (cond
                  ((equal? glyph "clefs.G")
                   (grob-interpret-markup grob
                    (markup #:scale(cons mlt mlt)#:G_abAeterno 0 1)))
                  ((equal? glyph "clefs.G_change")
                   (grob-interpret-markup grob
                    (markup #:scale(cons mlt mlt)#:G_abAeterno .01 .8)))
                  (else (ly:clef::print grob)))))
    \override ClefModifier.font-series = #'bold
  }
}
#(define-markup-command (G_smith layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup
    (#:stencil
     (make-path-stencil
      '(M 0.012 0.288
        C -0.023 1.058 0.559 1.694 1.109 1.956
        C 1.66 2.214 2.258 2.8 2.379 3.148
        C 2.5 3.495 2.277 4.042 2.156 4.019
        C 2.039 3.999 1.41 3.241 1.41 2.659
        C 1.41 2.073 1.398 2.237 1.438 1.89
        C 1.477 1.534 1.777 -0.602 1.813 -0.942
        C 1.848 -1.278 1.859 -1.606 1.793 -1.891
        C 1.727 -2.181 1.594 -2.368 1.355 -2.446
        C 0.879 -2.602 0.598 -2.497 0.43 -2.391
        C 0.262 -2.286 0.086 -2.013 0.117 -1.79
        C 0.145 -1.571 0.273 -1.317 0.594 -1.313
        C 0.914 -1.309 1.051 -1.645 0.98 -1.864
        C 0.906 -2.083 0.668 -2.102 0.586 -2.102
        C 0.508 -2.102 0.559 -2.294 0.68 -2.329
        C 0.801 -2.36 1.016 -2.423 1.332 -2.298
        C 1.492 -2.235 1.605 -2.075 1.66 -1.813
        C 1.715 -1.552 1.719 -1.306 1.68 -0.95
        C 1.637 -0.595 1.367 1.421 1.316 1.831
        C 1.262 2.237 1.352 1.569 1.215 2.718
        C 1.078 3.866 1.828 4.444 2.109 4.491
        C 2.387 4.538 2.609 3.737 2.598 3.194
        C 2.582 2.651 2.133 1.933 1.574 1.632
        C 1.012 1.335 0.398 0.894 0.367 0.284
        C 0.336 -0.325 0.656 -0.747 1.148 -0.891
        C 1.641 -1.032 2.363 -0.809 2.34 -0.192
        C 2.32 0.421 1.93 0.569 1.586 0.554
        C 1.246 0.538 1.023 0.366 1.004 0.026
        C 0.98 -0.317 1.309 -0.599 1.273 -0.661
        C 1.234 -0.727 0.75 -0.321 0.758 0.191
        C 0.766 0.702 1.273 1.042 1.625 1.054
        C 1.98 1.058 2.621 0.749 2.621 0.101
        C 2.621 -0.552 2.168 -1.036 1.465 -1.044
        C 0.758 -1.052 0.051 -0.481 0.012 0.288
        Z)
       thk mlt mlt #t)))))
smith = \layout {
  \context {
    \Score
    \override Clef.stencil =
        #(lambda (grob)
           (let* ((sz (ly:grob-property grob 'font-size 0.00))
                  (mlt (magstep sz))
                  (glyph (ly:grob-property grob 'glyph-name)))
                 (cond
                  ((equal? glyph "clefs.G")
                   (grob-interpret-markup grob
                    (markup #:scale(cons mlt mlt)#:G_smith 0 1)))
                  ((equal? glyph "clefs.G_change")
                   (grob-interpret-markup grob
                    (markup #:scale(cons mlt mlt)#:G_smith .01 .8)))
                  (else (ly:clef::print grob)))))
    \override ClefModifier.extra-offset = #'(.1 . 0)
    \override ClefModifier.font-series = #'bold
  }
}
#(define-markup-command (G_dorico layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup
    (#:stencil
     (make-path-stencil
      '(M  0.516 -2.024
        C  0.488 -1.669 0.793 -1.462 1.078 -1.563
        C  1.379 -1.657 1.445 -2.200 1.086 -2.313
        C  0.895 -2.376 0.910 -2.388 0.973 -2.446
        C  1.020 -2.489 1.148 -2.509 1.230 -2.505
        C  1.699 -2.497 1.824 -2.286 1.883 -2.001
        C  1.910 -1.856 1.852 -1.470 1.785 -1.044
        C  1.777 -0.989 1.781 -0.985 1.711 -0.993
        C  0.395 -1.157 0.055 -0.263 0.008  0.101
        C -0.086  0.784 0.195  1.405 1.176  2.191
        C  1.219  2.222 1.219  2.222 1.207  2.304
        C  1.059  3.288 1.277  3.780 1.391  3.972
        C  1.492  4.148 1.719  4.382 1.805  4.378
        C  1.871  4.378 2.000  4.222 2.090  4.058
        C  2.297  3.675 2.539  2.694 1.570  1.773
        C  1.484  1.691 1.484  1.691 1.488  1.663
        C  1.523  1.409 1.551  1.331 1.594  1.038
        C  1.598  1.015 1.594  0.995 1.656  0.999
        C  2.082  1.026 2.410  0.765 2.555  0.491
        C  2.785  0.054 2.680 -0.544 2.172 -0.845
        C  1.953 -0.970 1.930 -0.903 1.945 -1.013
        C  2.070 -1.743 2.121 -1.923 1.992 -2.231
        C  1.871 -2.509 1.605 -2.649 1.285 -2.653
        C  0.891 -2.661 0.551 -2.501 0.516 -2.024
        M  1.723 -0.856
        C  1.742 -0.852 1.746 -0.837 1.742 -0.817
        C  1.719 -0.677 1.574  0.206 1.551  0.347
        C  1.543  0.390 1.539  0.437 1.500  0.429
        C  0.992  0.316 0.965 -0.169 1.191 -0.356
        C  1.273 -0.423 1.324 -0.466 1.375 -0.493
        C  1.457 -0.536 1.387 -0.587 1.301 -0.567
        C  1.156 -0.528 0.941 -0.419 0.852 -0.181
        C  0.668  0.304 0.906  0.753 1.359  0.933
        C  1.430  0.960 1.445  0.933 1.422  1.073
        C  1.410  1.140 1.367  1.386 1.348  1.503
        C  1.332  1.605 1.332  1.589 1.285  1.562
        C  0.965  1.308 0.457  0.862 0.355  0.444
        C  0.082 -0.661 1.035 -0.985 1.723 -0.856
        M  1.703  0.413
        C  1.777 -0.028 1.773 -0.001 1.902 -0.751
        C  1.906 -0.790 1.914 -0.798 1.992 -0.759
        C  2.578 -0.434 2.367  0.276 1.887  0.425
        C  1.859  0.433 1.688  0.495 1.703  0.409
        M  1.652  2.577
        C  2.367  3.249 2.129 3.952 1.715  3.710
        C  1.359  3.499 1.281 2.862 1.363  2.382
        C  1.379  2.292 1.375 2.312 1.652  2.577
        Z)
       thk mlt mlt #t)))))
dorico = \layout {
  \context {
    \Score
    \override Clef.stencil =
      #(lambda (grob)
         (let* ((sz (ly:grob-property grob 'font-size 0.00))
                (mlt (magstep sz))
                (glyph (ly:grob-property grob 'glyph-name)))
               (cond
                ((equal? glyph "clefs.G")
                 (grob-interpret-markup grob
                  (markup #:scale(cons mlt mlt)#:G_dorico 0 1)))
                ((equal? glyph "clefs.G_change")
                 (grob-interpret-markup grob
                  (markup #:scale(cons mlt mlt)#:G_dorico .01 .8)))
                (else (ly:clef::print grob)))))
    \override ClefModifier.extra-offset = #'(.3 . 0)
    \override ClefModifier.font-series = #'bold
    \override Beam.beam-thickness = #0.54
  }
}
#(define-markup-command (G_UME layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup
    (#:stencil
     (make-path-stencil
      '(M 0.469 -2.079
        C 0.441 -1.778 0.758 -1.501 1.027 -1.606
        C 1.305 -1.735 1.363 -2.009 1.223 -2.235
        C 1.16 -2.376 0.961 -2.446 0.871 -2.477
        C 1.074 -2.684 1.543 -2.583 1.688 -2.349
        C 1.914 -2.048 1.816 -1.563 1.727 -1.052
        C 0.578 -1.161 0.012 -0.415 0 0.421
        C -0.008 0.851 0.207 1.55 1.188 2.269
        C 1.02 3.202 1.188 3.909 1.637 4.444
        C 1.965 4.839 2.105 4.226 2.156 4.03
        C 2.223 3.769 2.254 3.546 2.238 3.284
        C 2.246 2.691 1.891 2.062 1.453 1.726
        C 1.484 1.523 1.512 1.331 1.563 1.058
        C 2.75 1.042 2.996 -0.622 1.902 -1.016
        C 2 -1.677 2.164 -1.946 1.836 -2.477
        C 1.719 -2.669 1.359 -2.821 1.109 -2.763
        C 0.711 -2.677 0.504 -2.368 0.469 -2.079
        M 1.707 -0.915
        C 1.609 -0.341 1.605 -0.313 1.48 0.444
        C 0.996 0.39 0.938 -0.196 1.273 -0.45
        C 1.383 -0.52 1.371 -0.638 1.246 -0.563
        C 0.504 -0.141 0.773 0.804 1.387 1.015
        C 1.348 1.187 1.355 1.378 1.297 1.624
        C 0.809 1.347 0.305 0.671 0.316 0.304
        C 0.355 -0.778 1.031 -1.005 1.707 -0.915
        M 1.656 0.464
        C 1.656 0.464 1.816 -0.485 1.883 -0.876
        C 2.559 -0.524 2.434 0.562 1.656 0.464
        M 1.383 2.409
        C 1.762 2.694 2.234 3.437 2.098 3.823
        C 1.969 4.191 1.699 3.987 1.57 3.788
        C 1.313 3.398 1.344 2.73 1.383 2.409
        Z)
       thk mlt mlt #t)))))
UME = \layout {
        \context {
          \Score
          \override Clef.stencil =
            #(lambda (grob)
               (let* ((sz (ly:grob-property grob 'font-size 0.00))
                      (mlt (magstep sz))
                      (glyph (ly:grob-property grob 'glyph-name)))
                     (cond
                      ((equal? glyph "clefs.G")
                       (grob-interpret-markup grob
                        (markup #:scale(cons mlt mlt)#:G_UME 0 1)))
                      ((equal? glyph "clefs.G_change")
                       (grob-interpret-markup grob
                        (markup #:scale(cons mlt mlt)#:G_UME .01 .8)))
                      (else (ly:clef::print grob)))))
           \override ClefModifier.extra-offset = #'(.3 . 0)
           \override ClefModifier.font-series = #'bold
           \override Beam.beam-thickness = #0.54
        }
      }
    

#(define-markup-command (G_Score layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup #:translate (cons 0 .05)
    (#:stencil
     (make-path-stencil
      '(M  1.117 -2.778
        C  0.730 -2.782  0.363 -2.364 0.484 -1.981
        C  0.566 -1.641  1.043 -1.540 1.285 -1.786
        C  1.504 -1.997  1.418 -2.395 1.141 -2.513
        C  0.996 -2.567  0.836 -2.583 1.090 -2.614
        C  1.379 -2.673  1.703 -2.559 1.828 -2.278
        C  1.969 -1.911  1.820 -1.395 1.766 -1.024
        C  1.031 -1.169  0.277 -0.903 0.031 -0.196
        C -0.129  0.323 -0.043  0.917 0.250  1.366
        C  0.492  1.737  0.832  1.999 1.152  2.300
        C  1.070  2.886  1.000  3.468 1.203  4.034
        C  1.297  4.292  1.484  4.503 1.680  4.687
        C  1.898  4.886  2.117  4.335 2.211  4.062
        C  2.398  3.601  2.227  2.839 1.934  2.323
        C  1.816  2.105  1.637  1.929 1.457  1.757
        C  1.500  1.523  1.539  1.288 1.586  1.054
        C  2.117  1.077  2.477  0.792 2.602  0.359
        C  2.766 -0.134  2.516 -0.766 1.953 -0.977
        C  2.004 -1.423  2.160 -1.927 2.004 -2.313
        C  1.902 -2.567  1.656 -2.766 1.379 -2.778
        C  1.293 -2.798  1.203 -2.790 1.117 -2.782
        M  1.734 -0.919
        C  1.621 -0.306  1.574  0.026 1.500  0.464
        C  1.164  0.433  0.973  0.066 1.090 -0.220
        C  1.141 -0.345  1.223 -0.407 1.359 -0.485
        C  1.492 -0.563  1.387 -0.657 1.297 -0.618
        C  1.031 -0.509  0.664 -0.188 0.758  0.269
        C  0.816  0.569  1.059  0.917 1.398  1.023
        C  1.359  1.261  1.332  1.378 1.297  1.612
        C  0.887  1.234  0.332  0.753 0.348  0.155
        C  0.363 -0.532  0.746 -1.071 1.734 -0.919
        M  1.688  0.480
        C  1.762  0.105  1.844 -0.509 1.926 -0.880
        C  2.656 -0.462  2.438  0.534 1.688  0.480
        M  2.016  3.776
        C  1.984  4.378  1.691  4.058 1.500  3.706
        C  1.313  3.366  1.273  2.894 1.352  2.468
        C  1.945  3.066  2.031  3.409 2.016  3.776
        Z)
       thk mlt mlt #t)))))
clefGScore = \layout {
        \context {
          \Score
          \override Clef.stencil =
            #(lambda (grob)
               (let* ((sz (ly:grob-property grob 'font-size 0.00))
                      (mlt (magstep sz))
                      (glyph (ly:grob-property grob 'glyph-name)))
                     (cond
                      ((equal? glyph "clefs.G")
                       (grob-interpret-markup grob
                        (markup #:scale(cons mlt mlt)#:G_Score 0 1.08)))
                      ((equal? glyph "clefs.G_change")
                       (grob-interpret-markup grob
                        (markup #:scale(cons mlt mlt)#:G_Score .01 .8)))
                      (else (ly:clef::print grob)))))
           \override ClefModifier.clef-alignments = #'((G 0 . .4))
           \override ClefModifier.font-series = #'bold
           \override ClefModifier.font-size = #-3
           \override Beam.beam-thickness = #0.56
           \override Parentheses.font-size = #0
           %\override Slur.thickness = #2.5
           %\override Tie.thickness = #2.5
           %\override LaissezVibrerTie.thickness = #2.5
           \override LedgerLineSpanner.length-fraction = #.2
           \override LedgerLineSpanner.minimum-length-fraction = #.2
           \override StrokeFinger.font-size = #-2
           % \appoggiatura { \once\offset positions #'(-.5 . -.5) Beam g16 a }
        }
      }
    

#(define-markup-command (G_Octo layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup #:translate (cons 0 -2.95)
    (#:stencil
     (make-path-stencil
      '(M 2.363 6.773
        C 2.359 6.824 2.355 6.875 2.352 6.93
        C 2.34 6.984 2.313 7.027 2.266 7.059
        C 1.953 6.824 1.746 6.652 1.641 6.535
        C 1.422 6.301 1.316 6.063 1.316 5.813
        C 1.316 5.738 1.324 5.668 1.34 5.598
        C 1.57 5.711 1.781 5.875 1.973 6.09
        C 2.164 6.305 2.297 6.535 2.363 6.773 Z
        M 1.91 1.828
        C 1.902 1.832 1.898 1.832 1.895 1.832
        C 1.855 1.832 1.836 1.711 1.836 1.465
        C 1.828 1.129 1.813 0.902 1.793 0.789
        C 1.691 0.48 1.559 0.254 1.395 0.113
        C 1.305 0.086 1.219 0.066 1.133 0.047
        C 1.016 0.016 0.91 0 0.824 0
        C 0.68 0 0.559 0.039 0.457 0.113
        C 0.23 0.285 0.117 0.539 0.117 0.871
        C 0.117 0.938 0.121 1.008 0.129 1.082
        C 0.18 1.219 0.289 1.285 0.453 1.285
        C 0.477 1.285 0.535 1.281 0.633 1.273
        C 0.707 1.27 0.766 1.27 0.805 1.273
        C 0.934 1.18 0.996 1.043 0.996 0.867
        C 0.996 0.789 0.98 0.715 0.945 0.648
        C 0.914 0.582 0.84 0.516 0.723 0.453
        C 0.609 0.391 0.539 0.324 0.512 0.254
        C 0.594 0.152 0.727 0.098 0.906 0.098
        C 1.016 0.098 1.145 0.121 1.293 0.16
        C 1.602 0.375 1.754 0.723 1.754 1.203
        C 1.754 1.395 1.727 1.598 1.68 1.82
        C 1.641 1.828 1.484 1.848 1.203 1.883
        C 1 1.902 0.785 1.961 0.566 2.066
        C 0.188 2.438 0 2.859 0 3.332
        C 0 3.504 0.027 3.68 0.078 3.855
        C 0.164 4.152 0.313 4.438 0.527 4.719
        C 0.695 4.93 0.93 5.176 1.238 5.457
        C 1.223 5.574 1.215 5.688 1.215 5.805
        C 1.215 6.18 1.309 6.523 1.492 6.832
        C 1.676 7.137 1.934 7.391 2.266 7.594
        C 2.273 7.598 2.281 7.598 2.289 7.598
        C 2.309 7.598 2.332 7.586 2.355 7.559
        C 2.383 7.52 2.398 7.504 2.402 7.504
        C 2.453 7.289 2.477 7.078 2.477 6.871
        C 2.477 6.48 2.391 6.113 2.219 5.773
        C 2.039 5.422 1.773 5.117 1.43 4.867
        C 1.438 4.711 1.441 4.555 1.445 4.398
        C 1.473 4.227 1.547 4.105 1.676 4.047
        C 1.727 4.059 1.777 4.063 1.828 4.063
        C 2.094 4.063 2.32 3.895 2.508 3.559
        C 2.609 3.371 2.664 3.18 2.664 2.988
        C 2.664 2.734 2.57 2.496 2.391 2.273
        C 2.277 2.133 2.152 2.023 2.023 1.941 Z
        M 2.266 2.488
        C 2.309 2.629 2.328 2.766 2.328 2.895
        C 2.328 3.055 2.289 3.18 2.211 3.27
        C 2.156 3.332 2.102 3.398 2.051 3.465
        C 1.977 3.539 1.898 3.582 1.82 3.582
        C 1.789 3.582 1.758 3.574 1.727 3.559
        C 1.727 3.496 1.723 3.43 1.723 3.359
        C 1.723 3.191 1.734 2.973 1.762 2.707
        C 1.805 2.273 1.828 2.055 1.828 2.055
        C 1.922 2.074 2.008 2.129 2.094 2.215
        C 2.176 2.301 2.234 2.395 2.266 2.488 Z
        M 1.305 3.98
        C 1.332 4.035 1.348 4.113 1.348 4.207
        C 1.348 4.273 1.336 4.367 1.32 4.488
        C 1.301 4.609 1.293 4.691 1.293 4.73
        C 1.094 4.516 0.895 4.305 0.695 4.094
        C 0.465 3.844 0.332 3.609 0.289 3.395
        C 0.273 3.32 0.27 3.246 0.27 3.168
        C 0.27 2.77 0.395 2.43 0.641 2.145
        C 0.93 2.023 1.164 1.961 1.344 1.961
        C 1.441 1.961 1.551 1.973 1.676 2
        C 1.645 2.273 1.602 2.629 1.535 3.074
        C 1.527 3.09 1.508 3.18 1.48 3.348
        C 1.457 3.473 1.414 3.535  1.352 3.535
        C 1.313 3.535 1.258 3.512 1.188 3.461
        C 0.973 3.359 0.867 3.18  0.867 2.922
        C 0.867 2.801 0.895 2.641 0.945 2.434
        C 0.863 2.477 0.805 2.539  0.773 2.621
        C 0.738 2.703 0.711 2.781 0.684 2.863
        C 0.695 3.113 0.711 3.273  0.723 3.344
        C 0.754 3.504 0.816 3.645 0.91 3.766
        C 1 3.84 1.082 3.891 1.152 3.918
        C 1.203 3.941 1.254 3.961 1.305 3.98 Z)
       thk mlt mlt #t)))))
clefGOcto = \layout {
        \context {
          \Score
          \override Clef.stencil =
            #(lambda (grob)
               (let* ((sz (ly:grob-property grob 'font-size 0.00))
                      (mlt (magstep sz))
                      (glyph (ly:grob-property grob 'glyph-name)))
                     (cond
                      ((equal? glyph "clefs.G")
                       (grob-interpret-markup grob
                        (markup #:scale(cons mlt mlt)#:G_Octo 0 1)))
                      ((equal? glyph "clefs.G_change")
                       (grob-interpret-markup grob
                        (markup #:scale(cons mlt mlt)#:G_Octo .01 .8)))
                      (else (ly:clef::print grob)))))
           \override ClefModifier.clef-alignments = #'((G -.2 . .4))
           \override ClefModifier.font-series = #'bold
           \override Beam.beam-thickness = #0.54
           \override Parentheses.font-size = #0
           \override Slur.thickness = #2.5
           \override Tie.thickness = #2.5
        }
      }
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	    Clefs PostScript
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myClefG = #"
0 setgray
7.395 20.574 moveto
7.449 20.59 7.52 20.41 7.41 20.289 curveto
7.242 20.039 6.969 19.895 6.941 19.668 curveto
6.871 19.055 7.684 19.109 7.641 19.605 curveto
7.609 19.965 7.141 19.844 7.152 19.563 curveto
7.152 19.418 7.262 19.391 7.262 19.395 curveto
7.238 19.418 7.176 19.473 7.207 19.578 curveto
7.254 19.727 7.555 19.785 7.57 19.551 curveto
7.582 19.148 6.996 19.109 7.027 19.574 curveto
7.047 19.859 7.371 19.91 7.477 20.277 curveto
7.543 20.527 7.434 20.742 7.41 20.715 curveto
7.336 20.699 7.168 20.492 7.215 20.297 curveto
7.215 20.297 7.375 19.578 7.445 19.254 curveto
7.457 19.203 7.473 19.121 7.453 19.035 curveto
7.438 18.949 7.426 18.941 7.41 18.91 curveto
7.313 18.777 7.16 18.828 7.191 18.84 curveto
7.219 18.879 7.223 19.02 7.121 19.023 curveto
6.953 19.027 6.965 18.742 7.188 18.746 curveto
7.301 18.754 7.395 18.813 7.453 18.945 curveto
7.465 18.969 7.484 19.055 7.484 19.109 curveto
7.484 19.172 7.477 19.219 7.469 19.262 curveto
7.25 20.242 lineto
7.23 20.363 7.34 20.563 7.395 20.574 curveto
closepath
fill
"
myClef = \markup {
  \with-dimensions #'(0 . 2) #'(0 . 3)
  \translate #'(-25 . -70.2)
  \scale #'(3.6 . 3.6)
  \postscript #myClefG
}
myNewClef = \markup {
  \with-dimensions #'(0 . 3) #'(0 . 4)
  \translate #'(-25 . -70.2)
  \scale #'(3.6 . 3.6)
  \postscript #myClefG
}
CleAbAeterno = \markup \raise #1.13 \override #'(baseline-skip . 2) {
          \general-align #Y #CENTER {
             \epsfile #X #2.6 #"CleVI65.eps"
          }
        }
%{
myClefChangeSmall = \markup {
  \with-dimensions #'(0 . 2) #'(0 . 3)
  \translate #'(0 . -2.05)
  \scale #'(.85 . .85)
  \postscript #myClefG
}
myClefChangeTiny = \markup {
  \with-dimensions #'(0 . 1.5) #'(0 . 3)
  \translate #'(0 . -1.7)
  \scale #'(.7 . .7)
  \postscript #myClefG
}
%}
%%%%%%%%%%%%%%%
% Divers
%%%%%%%%%%%%%%%
showStg = \once\revert StringNumber.stencil
triplet = \tuplet 3/2 \etc
abso = \transpose c \etc
segno = \markup { \musicglyph "scripts.segno" }
coda = \markup { \musicglyph "scripts.coda" }
#(define-markup-command (dbSegno layout props mlt) (number?)
  (interpret-markup layout props
   (markup
    (#:stencil
     (make-path-stencil
       '(M -0.793 -0.192
         C -0.793 -0.126 -0.742 -0.075 -0.676 -0.075
         C -0.605 -0.075 -0.555 -0.126 -0.555 -0.192
         C -0.555 -0.263 -0.605 -0.313 -0.676 -0.313
         C -0.742 -0.313 -0.793 -0.263 -0.793 -0.192
         M  0.574  0.206
         C  0.574  0.273  0.629  0.323  0.695  0.323
         C  0.762  0.323  0.816  0.273  0.816  0.206
         C  0.816  0.136  0.762  0.085  0.695  0.085
         C  0.629  0.085  0.574  0.136  0.574  0.206
         M -0.129 -0.899
         C -0.129 -0.763 -0.063 -0.665  0.086 -0.665
         C  0.242 -0.665  0.316 -0.786  0.316 -0.911
         C  0.316 -1.020  0.258 -1.130  0.156 -1.165
         C  0.191 -1.282  0.301 -1.368  0.434 -1.368
         C  0.586 -1.368  0.695 -1.231  0.695 -1.071
         C  0.695 -0.677  0.363 -0.399  0.012 -0.196
         L -0.746 -1.489
         L -0.984 -1.489
         L -0.172 -0.099
         C -0.586  0.132 -0.984  0.429 -0.984  0.878
         C -0.984  1.222 -0.738  1.499 -0.414  1.499
         C -0.098  1.499  0.148  1.230  0.148  0.909
         C  0.148  0.776  0.082  0.675 -0.066  0.675
         C -0.223  0.675 -0.297  0.800 -0.297  0.921
         C -0.297  1.030 -0.238  1.140 -0.137  1.179
         C -0.168  1.292 -0.281  1.382 -0.414  1.382
         C -0.563  1.382 -0.676  1.241 -0.676  1.081
         C -0.676  0.687 -0.344  0.413  0.012  0.210
         L  0.766  1.499
         L  1.008  1.499
         L  0.195  0.109
         C  0.609 -0.122  1.008 -0.415  1.008 -0.868
         C  1.008 -1.208  0.758 -1.489  0.434 -1.489
         C  0.117 -1.489 -0.129 -1.220 -0.129 -0.899
         M  0.289  1.651
         C  0.289  1.718  0.340  1.773  0.410  1.773
         C  0.477  1.773  0.527  1.718  0.527  1.651
         C  0.527  1.585  0.477  1.530  0.410  1.530
         C  0.340  1.530  0.289  1.585  0.289  1.651
         M  1.660  2.050
         C  1.660  2.116  1.711  2.171  1.781  2.171
         C  1.848  2.171  1.898  2.116  1.898  2.050
         C  1.898  1.984  1.848  1.929  1.781  1.929
         C  1.711  1.929  1.660  1.984  1.660  2.050
         M  0.953  0.944
         C  0.953  1.081  1.023  1.183  1.172  1.183
         C  1.324  1.183  1.402  1.058  1.402  0.933
         C  1.402  0.827  1.340  0.714  1.242  0.679
         C  1.273  0.562  1.387  0.476  1.516  0.476
         C  1.668  0.476  1.781  0.616  1.781  0.776
         C  1.781  1.171  1.449  1.444  1.094  1.648

         L  0.336  0.355
         L  0.098  0.355
         L  0.910  1.745
         C  0.496  1.980  0.098  2.273  0.098  2.722
         C  0.098  3.066  0.344  3.347  0.672  3.347
         C  0.988  3.347  1.234  3.073  1.234  2.757
         C  1.234  2.620  1.168  2.519  1.020  2.519
         C  0.863  2.519  0.789  2.644  0.789  2.769
         C  0.789  2.874  0.848  2.987  0.945  3.023
         C  0.914  3.140  0.805  3.226  0.672  3.226
         C  0.520  3.226  0.410  3.085  0.410  2.925
         C  0.410  2.530  0.738  2.257  1.094  2.054
         L  1.852  3.347
         L  2.090  3.347
         L  1.277  1.956
         C  1.691  1.722  2.090  1.429  2.090  0.980
         C  2.090  0.636  1.844  0.355  1.516  0.355
         C  1.203  0.355  0.953  0.628  0.953  0.944
         Z)
       0 (+ (* mlt 0.1) 1) (+ (* mlt 0.1) 1) #t)))))
%{
Baeren old:
1.168 0 C 0.879 -0.008 0.586 0.266 0.516 0.543 C 0.484 0.762 0.535 0.949
0.691 1.098 C 0.883 1.215 1.125 1.234 1.277 1.055 C 1.445 0.855 1.426 0.57
1.258 0.395 C 1.148 0.328 0.82 0.352 1.059 0.215 C 1.27 0.094 1.605 0.234
1.738 0.426 C 1.902 0.625 1.93 1.055 1.875 1.355 C 1.816 1.699 1.77 1.574
1.348 1.582 C 0.906 1.59 0.527 1.844 0.316 2.102 C 0.141 2.313 0.039 2.684
0.012 2.895 C -0.098 3.719 0.539 4.262 1.148 4.754 C 0.813 6.188 1.125
6.438 1.598 7.027 C 1.863 7.324 1.984 7.105 2.117 6.828 C 2.5 5.734 2.309
5.016 1.613 4.5 C 1.367 4.316 1.434 4.195 1.477 4.008 C 1.57 3.582 1.66
3.668 1.977 3.637 C 2.398 3.594 2.758 3.363 2.848 2.77 C 2.891 2.469 2.586
1.879 2.207 1.75 C 2.094 1.707 2.02 1.684 2.027 1.543 C 2.043 1.297 2.086
0.984 2.039 0.738 C 1.988 0.488 1.91 0.281 1.688 0.145 C 1.5 0.039 1.344
0.008 1.168 0 Z M
1.492 1.734 C 1.883 1.77 1.785 1.867 1.746 2.094 C 1.715 2.254 1.629 2.613
1.59 2.785 C 1.523 3.102 1.375 3.117 1.215 2.918 C 1.055 2.711 1.063 2.48
1.117 2.316 C 1.16 2.176 1.473 1.875 1.188 1.988 C 0.875 2.113 0.762 2.496
0.754 2.691 C 0.742 2.977 0.984 3.395 1.168 3.516 C 1.449 3.703 1.344 3.813
1.332 3.93 C 1.293 4.238 0.973 4.094 0.563 3.355 C 0.379 3.031 0.348 2.477
0.563 2.18 C 0.73 1.945 1.148 1.707 1.492 1.734 Z M
2.363 2.238 C 2.516 2.477 2.395 2.758 2.328 2.84 C 2.188 3.02 1.66 3.258
1.719 2.969 C 1.742 2.84 1.855 2.305 1.918 2.043 C 2.016 1.625 2.297 2.133
2.363 2.238 Z M
1.305 4.871 C 1.641 5.227 1.914 5.582 2.043 5.922 C 2.141 6.18 2.078 6.547
1.941 6.691 C 1.402 6.414 1.168 5.609 1.305 4.871
"1.168 0 C 0.883 -0.008 0.586 0.266 0.52 0.543 C 0.484 0.762 0.535 0.949
0.695 1.102 C 0.883 1.219 1.125 1.238 1.277 1.055 C 1.445 0.859 1.426 0.57
1.258 0.395 C 1.148 0.328 0.82 0.352 1.059 0.215 C 1.273 0.094 1.609 0.234
1.742 0.426 C 1.906 0.625 1.934 1.059 1.879 1.355 C 1.816 1.703 1.773 1.613
1.352 1.586 C 0.902 1.555 0.574 1.816 0.316 2.105 C 0.133 2.309 0.039 2.691
0.012 2.898 C -0.098 3.727 0.543 4.27 1.152 4.766 C 0.813 6.199 1.125 6.449
1.602 7.039 C 1.867 7.34 1.988 7.121 2.121 6.84 C 2.504 5.746 2.313 5.023
1.617 4.508 C 1.371 4.324 1.434 4.203 1.477 4.016 C 1.574 3.59 1.684 3.695
2 3.664 C 2.426 3.621 2.762 3.371 2.852 2.773 C 2.898 2.473 2.59 1.879
2.219 1.727 C 2.105 1.68 2.023 1.688 2.031 1.547 C 2.047 1.301 2.09 0.984
2.043 0.738 C 1.992 0.488 1.914 0.281 1.691 0.145 C 1.5 0.039 1.344 0.008
1.168 0 Z M
1.484 1.766 C 1.871 1.82 1.789 1.871 1.746 2.098 C 1.719 2.258 1.629 2.617
1.594 2.793 C 1.523 3.105 1.379 3.129 1.23 2.902 C 1.086 2.684 1.086 2.488
1.137 2.32 C 1.184 2.18 1.488 1.977 1.184 1.961 C 0.922 2.16 0.762 2.5
0.754 2.699 C 0.742 2.984 0.988 3.398 1.172 3.523 C 1.453 3.711 1.348 3.82
1.332 3.938 C 1.297 4.246 0.977 4.102 0.563 3.363 C 0.379 3.035 0.332 2.461
0.582 2.188 C 0.91 1.82 1.141 1.715 1.484 1.766 Z M
2.367 2.242 C 2.52 2.484 2.398 2.762 2.332 2.848 C 2.191 3.023 1.664 3.262
1.719 2.973 C 1.746 2.848 1.859 2.309 1.922 2.047 C 2.02 1.625 2.301 2.137
2.367 2.242 Z M
1.309 4.879 C 1.645 5.234 1.918 5.594 2.047 5.934 C 2.145 6.191 2.082 6.563
1.945 6.703 C 1.402 6.426 1.172 5.617 1.309 4.879"
1.18 -0.168 C 0.879 -0.176 0.57 0.117 0.5 0.414 C 0.465 0.648 0.516 0.852
 0.684 1.012 C 0.883 1.137 1.137 1.16 1.293 0.961 C 1.473 0.75 1.453 0.441
 1.273 0.25 C 1.164 0.18 0.816 0.207 1.066 0.063 C 1.289 -0.07 1.645 0.086
 1.785 0.289 C 1.953 0.5 1.98 0.965 1.926 1.289 C 1.859 1.656 1.816 1.527
 1.371 1.531 C 0.906 1.539 0.512 1.813 0.289 2.09 C 0.102 2.316 -0.004 2.719
 -0.031 2.941 C -0.145 3.828 0.52 4.414 1.164 4.941 C 0.809 6.516 1.133
6.777 1.633 7.414 C 1.91 7.73 2.039 7.469 2.184 7.168 C 2.582 5.992 2.383
 5.223 1.652 4.668 C 1.391 4.473 1.461 4.34 1.504 4.137 C 1.605 3.684 1.699
 3.773 2.031 3.738 C 2.477 3.695 2.852 3.449 2.949 2.805 C 2.996 2.488 2.676
 1.852 2.277 1.711 C 2.156 1.668 2.074 1.641 2.086 1.492 C 2.102 1.223 2.148
 0.887 2.098 0.621 C 2.047 0.355 1.961 0.133 1.73 -0.016 C 1.531 -0.129
1.363 -0.16 1.18 -0.168 Z M
1.523 1.695 C 1.934 1.734 1.836 1.836 1.789 2.082 C 1.762 2.254 1.668 2.641
 1.629 2.824 C 1.555 3.164 1.402 3.18 1.23 2.969 C 1.063 2.75 1.074 2.5
1.129 2.32 C 1.176 2.168 1.5 1.844 1.203 1.969 C 0.875 2.102 0.754 2.516
 0.746 2.727 C 0.734 3.031 0.992 3.48 1.184 3.609 C 1.477 3.813 1.367 3.934
 1.352 4.055 C 1.313 4.383 0.98 4.23 0.547 3.441 C 0.352 3.086 0.336 2.5
 0.563 2.176 C 0.738 1.926 1.164 1.664 1.523 1.695 Z M
2.441 2.238 C 2.598 2.496 2.469 2.793 2.402 2.883 C 2.254 3.074 1.703 3.332
 1.762 3.02 C 1.789 2.883 1.906 2.309 1.969 2.027 C 2.07 1.578 2.371 2.121
 2.441 2.238 Z M
1.328 5.063 C 1.68 5.449 1.992 5.793 2.129 6.156 C 2.234 6.434 2.141 6.871
 1.996 7.02 C 1.465 6.648 1.234 5.887 1.328 5.063
1.672 4.309 C 1.746 3.949 1.73 4.195 2.199 3.992 C 2.664 3.789 2.875 3.453
          2.828 2.871 C 2.805 2.551 2.352 2.07 2.121 1.941 C 2.012 1.879 1.977 1.871
          2.039 1.586 C 2.074 1.441 2.094 1.152 2.109 1.004 C 2.156 0.543 1.988 0.023
          1.305 0 C 0.711 -0.02 0.422 0.43 0.449 0.863 C 0.465 1.105 0.688 1.367
          0.957 1.352 C 1.316 1.332 1.461 1.039 1.445 0.832 C 1.43 0.621 1.184 0.336
          0.938 0.438 C 0.734 0.523 0.77 0.219 1.344 0.168 C 1.844 0.125 2.039 0.695
          1.957 1.113 C 1.934 1.242 1.918 1.422 1.891 1.566 C 1.84 1.84 1.809 1.836
          1.664 1.828 C 0.813 1.766 0.016 2.352 0 3.176 C -0.02 4.156 0.688 4.676
          1.051 4.973 C 1.371 5.234 1.285 5.008 1.184 5.793 C 1.16 6 1.168 6.348
          1.215 6.582 C 1.289 6.941 1.633 7.496 1.969 7.68 C 1.996 7.695 2.039 7.699
          2.059 7.68 C 2.395 7.125 2.438 6.914 2.449 6.434 C 2.469 5.754 1.953 5.023
          1.684 4.832 C 1.574 4.754 1.637 4.461 1.672 4.309 Z M
          1.898 2.402 C 1.945 2.012 2.023 2.086 2.137 2.188 C 2.684 2.699 2.438 3.359
          2.121 3.531 C 1.875 3.66 1.672 3.676 1.707 3.457 C 1.781 3.035 1.844 2.902
          1.898 2.402 Z M
          0.344 3.109 C 0.391 2.523 0.758 1.965 1.48 2.008 C 1.859 2.031 1.809 2.051
          1.773 2.32 C 1.75 2.512 1.703 3.012 1.668 3.191 C 1.605 3.531 1.582 3.668
          1.445 3.582 C 1.164 3.406 1.18 3.328 1.125 3.191 C 1.012 2.91 1.191 2.617
          1.289 2.512 C 1.402 2.391 1.355 2.359 1.305 2.379 C 1.012 2.488 0.809 2.879
          0.809 3.109 C 0.805 3.48 0.973 3.766 1.285 4 C 1.402 4.086 1.582 4.121
          1.551 4.223 C 1.512 4.367 1.52 4.324 1.48 4.438 C 1.43 4.578 1.383 4.633
          1.242 4.512 C 0.934 4.242 0.305 3.648 0.344 3.109 Z M
          2.07 7.18 C 1.699 7.008 1.398 6.414 1.387 6.039 C 1.379 5.727 1.461 5.449
          1.469 5.355 C 1.496 5.113 2.188 5.984 2.254 6.5 C 2.281 6.719 2.262 7.055
          2.07 7.18
%}
#(define-markup-command (G_Baeren layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup #:translate (cons 0 -2.85)
    (#:stencil
     (make-path-stencil
      '(M 1.699 4.324 C 1.777 3.949 1.762 4.207 2.25 3.996 C 2.734 3.785 2.957 3.391
          2.906 2.785 C 2.879 2.453 2.418 2.008 2.086 1.859 C 1.969 1.805 2.012 1.738
          2.047 1.402 C 2.066 1.25 2.066 1.039 2.074 0.883 C 2.109 0.328 1.598 0.004
          1.277 0 C 0.594 -0.008 0.305 0.438 0.387 0.898 C 0.43 1.148 0.633 1.383
          0.914 1.367 C 1.289 1.344 1.438 1.043 1.426 0.824 C 1.41 0.605 1.258 0.383
          0.992 0.379 C 0.855 0.379 0.988 0.172 1.32 0.219 C 1.512 0.246 1.934 0.426
          1.891 1.02 C 1.883 1.152 1.875 1.316 1.848 1.465 C 1.797 1.754 1.762 1.75
          1.613 1.738 C 0.727 1.676 0.016 2.367 0 3.223 C -0.02 4.25 0.758 4.828
          1.137 5.137 C 1.469 5.41 1.418 5.176 1.316 5.992 C 1.289 6.211 1.258 6.57
          1.305 6.813 C 1.383 7.188 1.742 7.766 2.09 7.957 C 2.121 7.973 2.164 7.977
          2.188 7.957 C 2.543 7.277 2.582 7.16 2.594 6.656 C 2.609 5.953 2.078 5.191
          1.793 4.988 C 1.684 4.91 1.664 4.48 1.699 4.324 Z M
          1.938 2.297 C 1.984 1.895 2.109 2.051 2.223 2.156 C 2.797 2.688 2.496 3.297
          2.168 3.473 C 1.914 3.609 1.789 3.586 1.82 3.355 C 1.883 2.895 1.879 2.82
          1.938 2.297 Z M
          0.398 3.195 C 0.348 2.641 0.676 2.102 1.055 1.969 C 1.293 1.891 1.844 1.813
          1.809 2.094 C 1.781 2.293 1.711 2.93 1.695 3.121 C 1.668 3.5 1.629 3.527
          1.465 3.484 C 1.238 3.426 1.148 3.262 1.09 3.121 C 0.973 2.828 1.199 2.523
          1.301 2.414 C 1.422 2.285 1.371 2.254 1.32 2.273 C 1.012 2.387 0.801 2.793
          0.801 3.031 C 0.797 3.418 0.973 3.723 1.297 3.922 C 1.426 4 1.605 4.047
          1.574 4.156 C 1.531 4.305 1.543 4.34 1.5 4.457 C 1.449 4.605 1.398 4.664
          1.254 4.535 C 0.934 4.258 0.453 3.758 0.398 3.195 Z M
          2.195 7.355 C 1.809 7.004 1.68 6.73 1.566 6.25 C 1.492 5.934 1.559 5.715
          1.57 5.617 C 1.602 5.363 2.316 6.191 2.387 6.727 C 2.414 6.957 2.395 7.223
          2.195 7.355 Z)
       thk mlt mlt #t)))))
clefGBaeren = \layout {
        \context {
          \Score
          \override Clef.stencil =
            #(lambda (grob)
               (let* ((sz (ly:grob-property grob 'font-size 0.00))
                      (mlt (magstep sz))
                      (glyph (ly:grob-property grob 'glyph-name)))
                     (cond
                      ((equal? glyph "clefs.G")
                       (grob-interpret-markup grob
                        (markup #:scale(cons mlt mlt)#:G_Baeren 0 1)))
                      ((equal? glyph "clefs.G_change")
                       (grob-interpret-markup grob
                        (markup #:scale(cons mlt mlt)#:G_Baeren .01 .8)))
                      (else (ly:clef::print grob)))))
           \override ClefModifier.stencil =
              #(lambda (grob) (grob-interpret-markup grob
                                #{
                                  \markup \override #'(font-name . "LilyFont")
                                  \fontsize #-1 "8"
                                #}))
           \override ClefModifier.Y-extent = \makeUnpurePureContainer
           \override LedgerLineSpanner.length-fraction = #.2
           \override LedgerLineSpanner.minimum-length-fraction = #.2
           %\override BarNumber.self-alignment-X = #LEFT % <= ???
           % \override Clef.break-align-anchor-alignment = #3 <= ???
           rehearsalMarkFormatter = #format-mark-box-letters
           \override BarNumber.font-shape = #'italic
           \override BarNumber.font-size = #-1
           \override BarNumber.X-offset= #.3
           \override BarNumber.Y-offset = #4
           %\override BarNumber.self-alignment-X = #LEFT
        }
        \context {
          \PianoStaff
          \override SystemStartBrace.stencil =
            #(lambda (grob)
               (let* ((scale-amount 0.97)
                      (stil (ly:system-start-delimiter::print grob))
                      (scaled-stil (ly:stencil-scale stil scale-amount scale-amount))
                      (extent (ly:stencil-extent stil Y))
                      (height (- (cdr extent) (car extent))))
                 (ly:stencil-translate-axis
                   scaled-stil
                     (* -0.5 (- 1 scale-amount) (+ height 8))
                   Y)))
        }
        \context {
          \GrandStaff
          \override SystemStartBrace.stencil =
            #(lambda (grob)
               (let* ((scale-amount 0.97)
                      (stil (ly:system-start-delimiter::print grob))
                      (scaled-stil (ly:stencil-scale stil scale-amount scale-amount))
                      (extent (ly:stencil-extent stil Y))
                      (height (- (cdr extent) (car extent))))
                 (ly:stencil-translate-axis
                   scaled-stil
                     (* -0.5 (- 1 scale-amount) (+ height 8))
                   Y)))
        }
        \context {
           \Voice
           \override Beam.beam-thickness = #0.56
           \override Parentheses.font-size = #0
           %\override Slur.thickness = #2.2
           %\override Tie.thickness = #2.2
           \override PhrasingSlur.after-line-breaking = #(variable-bow-thickness 6 25 1 3)
           \override Slur.after-line-breaking = #(variable-bow-thickness 6 25 1 3)
           \override Tie.after-line-breaking = #(variable-bow-thickness 6 18 1 2)
           \override Tie.details.min-length = 4
           \override LaissezVibrerTie.thickness = #2.2
           \override RepeatTie.thickness = #2.2
           \override StrokeFinger.font-size = #-2.5
           %\override TupletNumber.font-name = #"LilyFont"
           \override TupletNumber.font-size = #-3
           \override TupletNumber.Y-extent = \makeUnpurePureContainer
           \override LaissezVibrerTie.stencil = #semi-tie-stencil
           \override RepeatTie.stencil = #semi-tie-stencil
         

           % \appoggiatura { \once\offset positions #'(-.5 . -.5) Beam g16 a }
        }
      }
 

#(set! paper-alist (cons '("Baerenreiter" . (cons (* 243.1 mm) (* 309.7 mm))) paper-alist))

%%%% PETERS :
#(define-markup-command (G_Peters layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup #:translate (cons 0 -2.85)
    (#:stencil
     (make-path-stencil
      '(M 1.168 0.313 C 0.887 0.316 0.625 0.586 0.629 0.867 C 0.59 1.199 0.984 1.512
        1.293 1.34 C 1.563 1.219 1.695 0.773 1.418 0.594 C 1.25 0.543 1.215 0.383
        1.43 0.453 C 1.77 0.496 1.973 0.82 1.969 1.145 C 1.926 1.379 2 1.836 1.629
        1.758 C 1.305 1.781 1.164 1.773 0.746 2.008 C 0.5 2.188 0.27 2.43 0.148
        2.707 C -0.152 3.324 0.145 4.203 0.469 4.602 C 0.648 4.781 0.922 5.07 1.113
        5.254 C 1.305 5.434 1.16 5.73 1.117 6.113 C 1.082 6.5 1.113 6.641 1.164
        6.93 C 1.238 7.176 1.359 7.449 1.535 7.641 C 1.707 7.828 1.797 8.109 2.02
        7.652 C 2.242 7.191 2.234 7.043 2.281 6.375 C 2.324 5.715 1.496 4.73 1.523
        4.609 C 1.574 4.348 1.496 4.02 1.934 3.996 C 2.371 3.969 2.746 3.605 2.801
        3.133 C 2.863 2.66 2.695 2.332 2.242 1.992 C 2.055 1.844 2.063 1.746 2.113
        1.191 C 2.102 0.906 2.027 0.563 1.746 0.418 C 1.586 0.301 1.363 0.281 1.168
        0.316 Z M
        1.559 1.922 C 1.93 1.914 1.785 2.266 1.77 2.48 C 1.727 2.707 1.699 2.801
        1.668 2.996 C 1.633 3.195 1.555 3.59 1.289 3.254 C 1.02 2.914 1.059 2.66
        1.402 2.195 C 0.871 2.32 0.766 3.223 0.941 3.469 C 1.113 3.715 1.035 3.707
        1.348 3.918 C 1.555 3.934 1.465 4.707 1.227 4.5 C 0.969 4.227 0.504 3.699
        0.516 3.535 C 0.379 3.078 0.391 2.617 0.715 2.262 C 0.945 2.086 1.086 1.945
        1.559 1.922 Z M
        2.086 2.098 C 2.773 2.375 2.473 3.469 1.848 3.395 C 1.621 3.523 1.859 2.563
        1.945 2.184 C 1.941 2.086 2.004 2.055 2.086 2.098 Z M
        1.551 5.633 C 1.98 6.047 1.914 6.027 2.066 6.441 C 2.219 6.852 2.121 7.5
        1.738 7.102 C 1.359 6.711 1.297 6.445 1.293 6.203 C 1.277 5.957 1.289 6.035
        1.336 5.586 C 1.367 5.418 1.445 5.52 1.551 5.637 Z)
      thk mlt mlt #t)))))
#(define-markup-command (F_Peters layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup #:translate (cons 0 -2.85)
    (#:stencil
     (make-path-stencil
      '(M 0.156 0.605 C -0.086 0.66 -0.012 0.738 0.309 0.797 C 0.809 0.969 1.148
        1.227 1.418 1.555 C 1.848 2.117 1.832 2.465 1.84 2.988 C 1.848 3.277 1.648
        3.66 1.34 3.719 C 1.086 3.77 0.793 3.652 0.672 3.418 C 0.484 3.102 0.801
        3.18 0.938 3.215 C 1.293 3.086 1.305 2.734 1.156 2.52 C 1.051 2.395 0.898
        2.293 0.727 2.32 C 0.559 2.332 0.387 2.441 0.34 2.609 C 0.063 3.313 0.75
        3.902 1.141 3.922 C 1.77 3.961 2.07 3.773 2.371 3.23 C 2.563 2.832 2.48
        2.641 2.395 2.266 C 2.203 1.801 2.031 1.602 1.676 1.301 C 1.09 0.848 0.797
        0.672 0.152 0.605 Z M
        2.785 2.227 C 2.574 2.211 2.508 2.578 2.719 2.625 C 2.906 2.719 3.113 2.434
        2.965 2.285 C 2.93 2.23 2.848 2.176 2.785 2.227 Z M
        2.641 3.148 C 2.449 3.266 2.594 3.586 2.801 3.539 C 3.008 3.512 3.016 3.152
        2.801 3.145 C 2.746 3.145 2.695 3.152 2.641 3.148 Z)
      thk mlt mlt #t)))))

clefGPeters =
\markup\G_Peters #0 #1

clefFPeters =
\markup\F_Peters #0 #1

clefPeters = \layout {
          \context {
            \Score
            \override Clef.stencil =
              #(lambda (grob)
                 (let* ((sz (ly:grob-property grob 'font-size 0.00))
                        (mlt (magstep sz))
                        (glyph (ly:grob-property grob 'glyph-name)))
                       (cond
                        ((equal? glyph "clefs.G")
                         (grob-interpret-markup grob
                          (markup #:scale(cons mlt mlt)#:G_Peters 0 1)))
                        ((equal? glyph "clefs.G_change")
                         (grob-interpret-markup grob
                          (markup #:scale(cons mlt mlt)#:G_Peters .01 .8)))
                        ((equal? glyph "clefs.F")
                         (grob-interpret-markup grob
                          (markup #:scale(cons mlt mlt)#:F_Peters 0 1)))
                        ((equal? glyph "clefs.F_change")
                         (grob-interpret-markup grob
                          (markup #:scale(cons mlt mlt)#:F_Peters .01 .8)))
                        (else (ly:clef::print grob)))))
           \override ClefModifier.stencil =
              #(lambda (grob) (grob-interpret-markup grob
                                #{
                                  \markup \override #'(font-name . "LilyFont")
                                  \fontsize #-1 "8"
                                #}))
           \override ClefModifier.stencil =
              #(lambda (grob) (grob-interpret-markup grob
                                #{
                                  \markup \override #'(font-name . "LilyFont")
                                  \fontsize #-1 "8"
                                #}))
           \override ClefModifier.Y-extent = \makeUnpurePureContainer
           \override LedgerLineSpanner.length-fraction = #.2
           \override LedgerLineSpanner.minimum-length-fraction = #.2
           \override BarNumber.self-alignment-X = #LEFT
           % \override Clef.break-align-anchor-alignment = #3 <= ???
           rehearsalMarkFormatter = #format-mark-box-letters
           \override BarNumber.font-size = #-1
           %\override BarNumber.X-offset= #.3
           \override BarNumber.Y-offset = #5
           %\override BarNumber.stencil = #(make-stencil-boxer 0.13 0.25 ly:text-interface::print)
           \override BarNumber.before-line-breaking =
              #(lambda (grob)
                (let* ((stl (ly:text-interface::print grob))
                       (txt (ly:grob-property grob 'text))
                       (nbr (string->number (
(lambda* (m #:optional headers)
  (if headers
      (markup->string m #:props (headers-property-alist-chain headers))
      (markup->string m)))
 txt))))
                (if (< nbr 10)
                    (ly:grob-set-property! grob 'text
                      #{
                        \markup
                        \override #'(thickness . 1.3)
                        \override #'(line-width . 2.15)
                        \box \fill-line { #txt }
                      #})
                    (ly:grob-set-property! grob 'text
                      #{ \markup\override #'(thickness . 1.3)\box #txt #}))
                stl))
        }
        \context {
          \PianoStaff
          \override SystemStartBrace.stencil =
            #(lambda (grob)
               (let* ((scale-amount 0.97)
                      (stil (ly:system-start-delimiter::print grob))
                      (scaled-stil (ly:stencil-scale stil scale-amount scale-amount))
                      (extent (ly:stencil-extent stil Y))
                      (height (- (cdr extent) (car extent))))
                 (ly:stencil-translate-axis
                   scaled-stil
                     (* -0.5 (- 1 scale-amount) (+ height 8))
                   Y)))
        }
        \context {
          \GrandStaff
          \override SystemStartBrace.stencil =
            #(lambda (grob)
               (let* ((scale-amount 0.97)
                      (stil (ly:system-start-delimiter::print grob))
                      (scaled-stil (ly:stencil-scale stil scale-amount scale-amount))
                      (extent (ly:stencil-extent stil Y))
                      (height (- (cdr extent) (car extent))))
                 (ly:stencil-translate-axis
                   scaled-stil
                     (* -0.5 (- 1 scale-amount) (+ height 8))
                   Y)))
        }
        \context {
           \Voice
           \override Beam.beam-thickness = #0.56
           \override Parentheses.font-size = #0
           %\override Slur.thickness = #2.2
           %\override Tie.thickness = #2.2
           \override PhrasingSlur.after-line-breaking = #(variable-bow-thickness 6 25 1 3)
           \override Slur.after-line-breaking = #(variable-bow-thickness 6 25 1 3)
           \override Tie.after-line-breaking = #(variable-bow-thickness 6 18 1 2)
           \override Tie.details.min-length = 4
           \override LaissezVibrerTie.thickness = #2.2
           \override RepeatTie.thickness = #2.2
           \override StrokeFinger.font-size = #-2.5
           \override TupletNumber.font-name = #"LilyFont"
           \override TupletNumber.font-size = #-3
           \override TupletNumber.Y-extent = \makeUnpurePureContainer
           \override LaissezVibrerTie.stencil = #semi-tie-stencil
           \override RepeatTie.stencil = #semi-tie-stencil
           \override NoteHead.stencil = #(lambda (grob)
              (let* ((log (ly:grob-property grob 'duration-log)))
                     (grob-interpret-markup grob
                      (cond
                       ((< log 1)
                         #{
                           \markup
                           \musicglyph "noteheads.s0"
                         #})
                        ((= log 1)
                         #{
                           \markup
                           \rotate #-15
                           \scale #'(.9 . 1.15)
                           \musicglyph "noteheads.s1"
                         #})
                        ((>= log 2)
                         #{
                           \markup
                           \rotate #-9
                           \scale #'(.9 . 1.1)
                           \musicglyph "noteheads.s2"
                         #})
               (else (ly:note-head::print grob))))))
         \override NoteHead.stem-attachment = #'(.922 . .28)
        }
      }
 

#(set! paper-alist (cons '("Peters" . (cons (* 243.1 mm) (* 309.7 mm))) paper-alist))
%% HENLE :
#(define-markup-command (G_Henle layout props thk mlt) (number? number?)
  (interpret-markup layout props
   (markup #:translate (cons 0 -2.75)
    (#:stencil
     (make-path-stencil
      '(M 0.953 0.012 C 0.723 0.07 0.527 0.25 0.484 0.488 C 0.426 0.781 0.715 1.074
        1.012 1.008 C 1.238 0.988 1.402 0.734 1.324 0.516 C 1.293 0.363 1.219 0.23
        1.066 0.168 C 1.25 0.047 1.531 0.195 1.621 0.379 C 1.723 0.586 1.73 0.828
        1.66 1.047 C 1.602 1.445 1.535 1.426 1.238 1.383 C 1.055 1.367 0.855 1.367
        0.684 1.438 C 0.492 1.516 0.336 1.629 0.227 1.801 C 0.082 2.02 -0.027 2.277
        0.004 2.547 C -0.008 2.813 0.043 3.086 0.215 3.297 C 0.371 3.527 0.566
        3.734 0.762 3.938 C 0.797 4.18 0.602 4.414 0.574 4.664 C 0.523 5.027 0.559
        5.414 0.715 5.75 C 0.816 5.961 0.984 6.168 1.176 6.305 C 1.332 6.371 1.496
        5.973 1.551 5.832 C 1.691 5.457 1.75 5.039 1.645 4.652 C 1.563 4.383 1.445
        4.117 1.23 3.93 C 0.934 3.738 1.102 3.496 1.172 3.273 C 1.328 3.082 1.469
        3.281 1.871 3.012 C 2.156 2.844 2.289 2.492 2.234 2.172 C 2.223 1.879 2.016
        1.633 1.773 1.484 C 1.637 1.406 1.758 1.234 1.816 0.871 C 1.863 0.613 1.813
        0.32 1.598 0.152 C 1.414 0 1.18 -0.016 0.953 0.012 M
        1.313 1.5 C 1.648 1.516 1.465 1.836 1.402 1.992 C 1.371 2.234 1.254 2.453
        1.219 2.695 C 0.965 2.844 0.773 2.348 0.871 2.133 C 0.867 1.988 1.16 1.859
        1.074 1.773 C 0.871 1.832 0.734 2.023 0.645 2.207 C 0.539 2.52 0.691 2.863
        0.949 3.055 C 1.172 3.129 0.965 3.711 0.777 3.418 C 0.621 3.277 0.48 3.117
        0.391 2.922 C 0.246 2.684 0.277 2.375 0.309 2.105 C 0.43 1.906 0.535 1.676
        0.758 1.57 C 0.922 1.469 1.125 1.48 1.313 1.5 M
        1.719 1.605 C 2.113 1.793 2.148 2.441 1.777 2.672 C 1.535 2.836 1.219 2.902
        1.367 2.547 C 1.422 2.352 1.488 2.148 1.535 1.945 C 1.582 1.863 1.57 1.539
        1.719 1.605 M
        0.953 4.121 C 1.109 4.266 1.242 4.449 1.34 4.637 C 1.438 4.816 1.504 5.012
        1.512 5.219 C 1.551 5.465 1.492 5.738 1.352 5.945 C 1.117 5.969 0.98 5.672
        0.887 5.488 C 0.699 5.074 0.715 4.59 0.879 4.172 C 0.891 4.145 0.922 4.117
        0.953 4.121 Z)
       thk mlt mlt #t)))))
clefGHenle = \layout {
        \context {
          \Score
          \override Clef.stencil =
            #(lambda (grob)
               (let* ((sz (ly:grob-property grob 'font-size 0.00))
                      (mlt (magstep sz))
                      (glyph (ly:grob-property grob 'glyph-name)))
                     (cond
                      ((equal? glyph "clefs.G")
                       (grob-interpret-markup grob
                        (markup #:scale(cons mlt mlt)#:G_Henle 0 1.2)))
                      ((equal? glyph "clefs.G_change")
                       (grob-interpret-markup grob
                        (markup #:scale(cons mlt mlt)#:G_Henle .01 .96)))
                      (else (ly:clef::print grob)))))
           \override ClefModifier.stencil =
              #(lambda (grob) (grob-interpret-markup grob
                                #{
                                  \markup \override #'(font-name . "LilyFont")
                                  \fontsize #-1 "8"
                                #}))
           \override ClefModifier.Y-extent = \makeUnpurePureContainer
           \override ClefModifier.extra-offset = #'(.3 . 0)
           \override LedgerLineSpanner.length-fraction = #.2
           \override LedgerLineSpanner.minimum-length-fraction = #.2
           %\override BarNumber.self-alignment-X = #LEFT % <= ???
           % \override Clef.break-align-anchor-alignment = #3 <= ???
           rehearsalMarkFormatter = #format-mark-box-letters
           %\override BarNumber.font-shape = #'italic
           \override BarNumber.font-size = #-4
           \override BarNumber.self-alignment-X = #LEFT
           \override BarNumber.Y-offset= #4.2
           \override VoltaBracket.font-size = #-2.5
        }
        \context {
          \PianoStaff
          \override SystemStartBrace.stencil =
            #(lambda (grob)
               (let* ((scale-amount 0.97)
                      (stil (ly:system-start-delimiter::print grob))
                      (scaled-stil (ly:stencil-scale stil scale-amount scale-amount))
                      (extent (ly:stencil-extent stil Y))
                      (height (- (cdr extent) (car extent))))
                 (ly:stencil-translate-axis
                   scaled-stil
                     (* -0.5 (- 1 scale-amount) (+ height 7))
                   Y)))
        }
        \context {
          \GrandStaff
          \override SystemStartBrace.stencil =
            #(lambda (grob)
               (let* ((scale-amount 0.98)
                      (stil (ly:system-start-delimiter::print grob))
                      (scaled-stil (ly:stencil-scale stil scale-amount scale-amount))
                      (extent (ly:stencil-extent stil Y))
                      (height (- (cdr extent) (car extent))))
                 (ly:stencil-translate-axis
                   scaled-stil
                     (* -0.5 (- 1 scale-amount) (+ height 8))
                   Y)))
        }
        \context {
           \Voice
           \override Beam.beam-thickness = #0.56
           \override Parentheses.font-size = #0
           %\override Slur.thickness = #2.2
           %\override Tie.thickness = #2.2
           \override PhrasingSlur.after-line-breaking = #(variable-bow-thickness 6 25 1 3)
           \override Slur.after-line-breaking = #(variable-bow-thickness 6 25 1 3)
           \override Tie.after-line-breaking = #(variable-bow-thickness 6 18 1 2)
           \override Tie.details.min-length = 4
           \override LaissezVibrerTie.thickness = #2.2
           \override RepeatTie.thickness = #2.2
           \override StrokeFinger.font-size = #-2.5
           \override TupletNumber.font-name = #"LilyFont"
           \override TupletNumber.font-size = #-3
           %\override TupletNumber.Y-extent = \makeUnpurePureContainer
           \override LaissezVibrerTie.stencil = #semi-tie-stencil
           \override RepeatTie.stencil = #semi-tie-stencil
         

           % \appoggiatura { \once\offset positions #'(-.5 . -.5) Beam g16 a }
        }
      }
%% Lolgo HENLE
#(define-markup-command (LogoHenle layout props) ()
  (interpret-markup layout props
   (markup
    (#:stencil
     (make-path-stencil
       '( M 5.871 0.742
          C 2.449 1.965 -0.629 4.504 0.109 5.703
          C 0.695 6.648 6.727 9.984 7.914 9.984
          C 8.344 9.984 8.43 9.027 8.43 8.18
          C 8.43 6.012 10.426 2.406 12.137 1.488
          C 14.785 0.074 18.852 0.57 20.836 2.559
          L 22.68 4.398
          L 22.68 68.93
          L 24.742 69.988
          C 25.875 70.574 28.023 71.559 29.52 72.18
          L 33.758 74.387
          L 31.598 70.578
          C 31.25 69.074 30.949 54.848 30.934 38.969
          C 30.902 10.508 31.48 10.117 29.832 7.16
          C 27.328 2.68 21.066 -0.043 14.105 0
          C 11.188 0.016 7.484 0.168 5.871 0.742 Z
          M 5.164 15.309
          L 2.895 18.188
          L 2.988 33.766
          L 2.988 50.008
          L 7.656 52.457
          C 12.934 55.121 13.793 55.836 12.773 53.93
          C 12.309 53.063 11.43 45.578 11.43 36.359
          C 11.43 20.945 11.434 20.895 13.27 19.059
          C 14.281 18.047 17.289 17.402 18.238 17.379
          C 19.527 17.348 17.629 16.68 14.852 15.305
          C 10.172 12.984 7.668 12.984 5.164 15.305 Z
          M 42.09 15.555
          C 43.301 17.816 43.207 46.258 41.98 48.656
          C 41.469 49.652 39.898 50.855 38.484 51.328
          L 34.863 51.418
          L 40.465 54.406
          C 45.27 56.355 47.457 55.496 49.691 52.656
          C 51.07 50.902 51.176 49.586 51.176 34.465
          L 51.176 18.168
          L 47.238 16.5
          C 45.074 15.586 42.84 14.645 42.277 14.414
          C 41.457 14.074 41.418 14.301 42.09 15.555 Z
          )
       0 .13 .13 #t)))))
%#(ly:font-config-add-font "Bauer Bodoni Roman.otf")
%#(ly:font-config-add-font "Bauer Bodoni Italic.otf")
%#(ly:font-config-add-font "Bauer Bodoni Bold.otf")
#(set! paper-alist (cons '("Henle" . (cons (* 235 mm) (* 310.1 mm))) paper-alist))
%%%%%%%%%%%
% Tabs Magasine GC
%%%%%%%%%%%%%
equal-tab-staff-stems =
#(define-music-function (val)(number?)
#{
  \override Stem.direction =
    #(lambda (grob)
      (if (negative? val)
          DOWN
          UP))
  \override Stem.after-line-breaking =
    #(lambda (grob)
      (let* ((stem-begin-position (ly:grob-property grob 'stem-begin-position)))
        ;; the override for Beam.positions counts from staff-position 0
        ;; thus we need to go there for the (unbeamed) stem-length as well
      ;; beam-thickness is taken from engraver-init.ly:
      (ly:grob-set-property! grob
        'length
        (+ (if (negative? val)
               stem-begin-position
               (- stem-begin-position))
           (* (abs val) 2)
           ;; beam-thickness:
           0.32))))
  \override Beam.positions = #(cons val val)
#})


%%%%%%%%%%%%%%%%%%%%%%

#(define-public (format-time-sig-note grob)
   (let* ((frac (ly:grob-property grob 'fraction))
          (num (if (pair? frac) (car frac) 4))
          (den (if (pair? frac) (cdr frac) 4))
          (m (markup #:raise .6
                     #:override '(baseline-skip . 3)
                     #:center-column (#:number (number->string num)
                                     (#:number (number->string den))))))
     (grob-interpret-markup grob m)))


#(set! paper-alist (cons '("GuitarClassic" . (cons (* 205 mm) (* 290 mm))) paper-alist))
%%% EllipSize :
#(define-markup-command
  (ellipSize layout props size thick) (number-pair? number?)
    (let ((width (car size))
          (height (cdr size)))
      "Draw an ellipse with specific width, height and thickness (optional)."
      (interpret-markup layout props
        (markup
          #:translate (cons (+ (* (/ -3 2) width) .5) (- (* (/ -3 2) height) .5))
          #:with-dimensions (cons 0 0) (cons 0 0)
          #:override `(thickness . ,thick)
          #:override `(x-padding . 0)
          #:override `(y-padding . 0)
          #:ellipse
          #:combine 

            (#:vspace height)
            (#:hspace (* 3 width))))))
%% test :
%{
  c'8-\markup
  \with-color #red
  \ellipSize #'(1 . 3) #2
%}
#(define-markup-command (super layout props arg)
  (markup?)
  #:category font
  #:properties ((font-size 0))
  "
    @cindex superscript text
  

    Set @var{arg} in superscript.
  

    @lilypond[verbatim,quote]
    \\markup {
      E =
      \\concat {
        mc
        \\super
        2
      }
    }
    @end lilypond"
  (ly:stencil-translate-axis
   (interpret-markup
    layout
    (cons `((font-size . ,(- font-size 3))) props)
    arg)
   (* .6 (magstep font-size)) ; original font-size
   Y))
#(define-markup-command (sub layout props arg)
  (markup?)
  #:category font
  #:properties ((font-size 0))
  "
@cindex subscript text
Set @var{arg} in subscript.
@lilypond[verbatim,quote]
\\markup {
  \\concat {
    H
    \\sub {
      2
    }
    O
  }
}
@end lilypond"
  (ly:stencil-translate-axis
   (interpret-markup
    layout
    (cons `((font-size . ,(- font-size 3))) props)
    arg)
   (* -0.4 (magstep font-size)) ; original font-size
   Y))
%% COUNTERS :
%% => http://lilypond.1069038.n5.nabble.com/Toc-with-counter-td214472.html
#(define counter-alist '())
#(define-markup-command (counter layout props name) (string?)
  "Increases and prints out the value of the given counter named @var{name}.
  If the counter does not yet exist, it is initialized with 1."
  (let* ((oldval (assoc-ref counter-alist name))
         (newval (if (number? oldval) (+ oldval 1) 1)))
  (set! counter-alist (assoc-set! counter-alist name newval))
  (interpret-markup layout props
    ;; => here it goes :
    (markup (number->string newval)))))
#(define-markup-command (setcounter layout props name value) (string? number?)
  "Set the given counter named @var{name} to the given @var{value} and prints
  out the value. The counter does not yet have to exist."
  (set! counter-alist (assoc-set! counter-alist name (- value 1)))
  (interpret-markup layout props (make-counter-markup name)))
%% => http://lsr.di.unimi.it/LSR/Item?id=1068
#(define-markup-command
  (circled-pattern layout props radius angle num arg)
  (number? number? number? markup?)
  (interpret-markup layout props
   (let ((rep (abs num)))
    (cond
     ((= num 0) (markup ""))
     ((= num 1) arg)
     (#t (do ((i 0 (1+ i))
              (res (markup (#:null))
                   (markup
                    (#:combine
                     (#:rotate
                      (* i (/ angle rep))
                      (#:concat (#:null #:hspace radius arg)))
                     res))))
             ((= i (1+ rep)) res)))))))
%% test: \markup\circled-pattern #'radius #'angle #'repeat 'sign (or letter, or glyph)
%% Hairpin lengths:
#(define broken-right-neighbor
   (lambda (grob)
     (let* ((pieces (ly:spanner-broken-into (ly:grob-original grob)))
            (me-list (member grob pieces)))
       (if (> (length me-list) 1)
           (cadr me-list)
           '()))))
#(define (interval-dir-set i val dir)
   (cond ((= dir LEFT) (set-car! i val))
     ((= dir RIGHT) (set-cdr! i val))
     (else (ly:error "dir must be LEFT or RIGHT"))))
#(define (other-dir dir) (- dir))
#(define hairpin::print-scheme
   (lambda (grob)
     (let ((grow-dir (ly:grob-property grob 'grow-direction)))
       (if (not (ly:dir? grow-dir))
           (begin
            (ly:grob-suicide! grob)
            '())
           (let* ((padding (ly:grob-property grob 'bound-padding 0.5))
                  (bounds (cons (ly:spanner-bound grob LEFT)
                            (ly:spanner-bound grob RIGHT)))
                  (broken (cons
                           (not (= (ly:item-break-dir (car bounds)) CENTER))
                           (not (= (ly:item-break-dir (cdr bounds)) CENTER))))
                  (broken (if (cdr broken)
                              (let ((next (broken-right-neighbor grob)))
                                (if (ly:spanner? next)
                                    (begin
                                     (ly:grob-property next 'after-line-breaking) ; call for side-effect
                                     (cons (car broken) (grob::is-live? next)))
                                    (cons (car broken) #f)))
                              broken))
                  (common (ly:grob-common-refpoint (car bounds) (cdr bounds) X))
                  (x-points (cons 0 0))
                  (circled-tip (ly:grob-property grob 'circled-tip))
                  (height (* (ly:grob-property grob 'height 0.2)
                            (ly:staff-symbol-staff-space grob)))
                  (rad (* 0.525 height))
                  (thick (* (ly:grob-property grob 'thickness 1.0)
                           (ly:staff-symbol-line-thickness grob)))
                  (shorten-pair (ly:grob-property grob 'shorten-pair '(0.0 . 0.0)))) ; enhancement
             (define (set-x-points dir)
               (let* ((b (interval-bound bounds dir))
                      (e (ly:generic-bound-extent b common))) ; X-AXIS assumed
                 (interval-dir-set
                  x-points (ly:grob-relative-coordinate b common X) dir)
                 (if (interval-bound broken dir)
                     ;; If broken ...
                     ;; starting a line
                     (if (= dir LEFT)
                         (interval-dir-set
                          ;x-points (interval-bound e (other-dir dir)) dir)
                          x-points (interval-bound e RIGHT) LEFT)
                         ;; ending a line
                         (let* ((broken-bound-padding
                                 (ly:grob-property grob 'broken-bound-padding 0.0))
                                (chp (ly:grob-object grob 'concurrent-hairpins)))
                           ; make sure that concurrent broken hairpins end at the same time at line break
                           (let loop ((i 0))
                             (if (and (ly:grob-array? chp) ; hmm...why no test in C++ needed?
                                      (< i (ly:grob-array-length chp)))
                                 (let ((span-elt (ly:grob-array-ref chp i)))
                                   (if (= (ly:item-break-dir (ly:spanner-bound span-elt RIGHT))
                                          LEFT)
                                       (set! broken-bound-padding
                                             (max broken-bound-padding
                                               (ly:grob-property span-elt 'broken-bound-padding 0.0))))
                                   (loop (1+ i)))))
                           (interval-dir-set
                            x-points
                            (- (interval-bound x-points dir)
                              (* dir broken-bound-padding))
                            dir)))
                     ;; Not broken ...
                     ;; If a dynamic is present at bound
                     (if (grob::has-interface b 'text-interface)
                         (if (not (interval-empty? e))
                             (interval-dir-set x-points
                               (- (interval-bound e (other-dir dir))
                                 (* dir padding))
                               dir))
                         ;; If no dynamic, we consider adjacent spanners
                         (let* ((neighbor-found #f)
                                (adjacent '()) ; spanner
                                (neighbors (ly:grob-object grob 'adjacent-spanners))
                                (neighbors-len (if (ly:grob-array? neighbors)
                                                   (ly:grob-array-length neighbors)
                                                   0))) ; this shouldn't be necessary -- see comment above
                           ;; is there a spanner sharing bound?
                           (let find-neighbor ((i 0))
                             (if (and (< i neighbors-len)
                                      (not neighbor-found))
                                 (begin
                                  (set! adjacent (ly:grob-array-ref neighbors i))
                                  (if (and (ly:spanner? adjacent)
                                           (eq? (ly:item-get-column (ly:spanner-bound adjacent (other-dir dir)))
                                                (ly:item-get-column b)))
                                      (set! neighbor-found #t))
                                  (find-neighbor (1+ i)))))
                           (if neighbor-found
                               (if (grob::has-interface adjacent 'hairpin-interface)
                                   (if (and circled-tip (not (eq? grow-dir dir)))
                                       (interval-dir-set x-points
                                         (+ (interval-center e)
                                           (* dir
                                             (- rad (/ thick 2.0))))
                                         dir)
                                       (interval-dir-set x-points
                                         (- (interval-center e)
                                           (/ (* dir padding) 3.0))
                                         dir))
                                   (if (= dir RIGHT)
                                       (interval-dir-set x-points
                                         (- (interval-bound e (other-dir dir))
                                           (* dir padding))
                                         dir)))
                               (begin
                                (if (and (= dir RIGHT)
                                         (grob::has-interface b 'note-column-interface)
                                         (ly:grob-array? (ly:grob-object b 'rest)))
                                    (interval-dir-set x-points
                                      (interval-bound e (other-dir dir))
                                      dir)
                                    (interval-dir-set x-points
                                      (interval-bound e dir)
                                      dir))
                                (if (eq? (ly:grob-property b 'non-musical) #t)
                                    (interval-dir-set x-points
                                      (- (interval-bound x-points dir)
                                        (* dir padding))
                                      dir)))))))
                 (interval-dir-set x-points
                   (- (interval-bound x-points dir) (* dir (interval-bound shorten-pair dir)))
                   dir)))
             (set-x-points LEFT)
             (set-x-points RIGHT)
             (let* ((width (- (interval-bound x-points RIGHT)
                             (interval-bound x-points LEFT)))
                    (width (if (< width 0)
                               (begin
                                (ly:warning
                                 (if (< grow-dir 0)
                                     "decrescendo too small"
                                     "crescendo too small"))
                                0)
                               width))
                    (continued (interval-bound broken (other-dir grow-dir)))
                    (continuing (interval-bound broken grow-dir))
                    (starth (if (< grow-dir 0)
                                (if continuing
                                    (* 2 (/ height 3))
                                    height)
                                (if continued
                                    (/ height 3)
                                    0.0)))
                    (endh (if (< grow-dir 0)
                              (if continued
                                  (/ height 3)
                                  0.0)
                              (if continuing
                                  (* 2 (/ height 3))
                                  height)))
                    (mol empty-stencil)
                    (x 0.0)
                    (tip-dir (other-dir grow-dir)))
               (if (and circled-tip
                        (not (interval-bound broken tip-dir)))
                   (if (> grow-dir 0)
                       (set! x (* rad 2.0))
                       (if (< grow-dir 0)
                           (set! width (- width (* rad 2.0))))))
               ;(set! mol (make-line-stencil thick x starth width endh))
               (set! mol (ly:line-interface::line grob x starth width endh))
               (set! mol
                     (ly:stencil-add
                      mol
                      ;(make-line-stencil thick x (- starth) width (- endh))))
                      (ly:line-interface::line grob x (- starth) width (- endh))))
               ;; Support al/del niente notation by putting a circle at the
               ;; tip of the (de)crescendo.
               (if circled-tip
                   (let ((circle (make-circle-stencil rad thick #f)))
                     ;;  don't add another circle if the hairpin is broken
                     (if (not (interval-bound broken tip-dir))
                         (set! mol
                               (ly:stencil-combine-at-edge mol X tip-dir circle 0)))))
               (set! mol
                     (ly:stencil-translate-axis mol
                       (- (interval-bound x-points LEFT)
                         (ly:grob-relative-coordinate (interval-bound bounds LEFT) common X))
                       X))
               mol))))))
%% test: { \override Hairpin.shorten-pair = #'(0 . 4) c'1~\< 1 ~ 2\! }
#(define (suppress message x)
  (let loop ((c x))
    (if (> c 0)
       (begin
        (ly:expect-warning message)
        (loop (1- c))))))
% test: #(suppress "barcheck failed at: -1/4" 8)
rinfz = #(make-dynamic-script #{
             \markup\concat {
                "r" \hspace #.2
                \normal-text\italic\bold \scale #'(.9 . 1.1) "in"
                \hspace #-.3 "fz"
              }
           #})
%%% Barlines
\defineBarLine ".|;" #'(".|;" ".|;" ".| ")
\defineBarLine ";|." #'(";|." ";|." " |.")
#(define-bar-line "!!" "!!" #f "!")
%%% cres -- cen -- do:
%% CUSTOM GROB PROPERTIES
% Taken from http://www.mail-archive.com/lilypond-user%40gnu.org/msg97663.html
% (Paul Morris)
% function from "scm/define-grob-properties.scm" (modified)
#(define (cn-define-grob-property symbol type?)
   (set-object-property! symbol 'backend-type? type?)
   (set-object-property! symbol 'backend-doc "custom grob property")
   symbol)
% For internal use.
#(cn-define-grob-property 'text-spanner-stencils list?)
% user interface
#(cn-define-grob-property 'text-spanner-line-count number-list?)
% List of booleans describing connections between text items regardless
% of line breaks.
#(cn-define-grob-property 'connectors list?)
% How much space between line and object to left and right?
% Default is '(0.0 . 0.0).
#(cn-define-grob-property 'line-X-offset number-pair?)
% Vertical shift of connector line, independenf of texts.
#(cn-define-grob-property 'line-Y-offset number?)
#(define (get-text-distribution text-list line-extents)
   ;; Given a list of texts and a list of line extents, attempt to
   ;; find a decent line distribution.  The goal is to put more texts
   ;; on longer lines, while ensuring that first and last lines are texted.
   ;; TODO: ideally, we should consider extents of text, rather than
   ;; simply their number.
   (let* ((line-count (length line-extents))
          (text-count (length text-list))
          (line-lengths
           (map (lambda (line) (interval-length line))
             line-extents))
          (total-line-len (apply + line-lengths))
          (exact-per-line
           (map (lambda (line-len)
                  (* text-count (/ line-len total-line-len)))
             line-lengths))
          ;; First and last lines can't be untexted.
          (adjusted
           (let loop ((epl exact-per-line) (idx 0) (result '()))
             (if (null? epl)
                 result
                 (if (and (or (= idx 0)
                              (= idx (1- line-count)))
                          (< (car epl) 1))
                     (loop (cdr epl) (1+ idx)
                       (append result (list 1.0)))
                     (loop (cdr epl) (1+ idx)
                       (append result (list (car epl)))))))))
     ;; The idea is to raise the "most roundable" line's count, then the
     ;; "next most roundable," and so forth, until we account for all texts.
     ;; Everything else is rounded down (except those lines which need to be
     ;; bumped up to get the minimum of one text), so we shouldn't exceed our
     ;; total number of texts.
     ;; TODO: Need a promote-demote-until-flush to be safe, unless this is
     ;; mathematically sound!
     (define (promote-until-flush result)
       (let* ((floored (map floor result))
              (total (apply + floored)))
         (if (>= total text-count)
             (begin
              ;(format #t "guess: ~a~%~%~%" result)
              floored)
             (let* ((decimal-amount
                     (map (lambda (x) (- x (floor x))) result))
                    (maximum (apply max decimal-amount))
                    (max-location
                     (list-index
                      (lambda (x) (= x maximum))
                      decimal-amount))
                    (item-to-bump (list-ref result max-location)))
               ;(format #t "guess: ~a~%" result)
               (list-set! result max-location (1+ (floor item-to-bump)))
               (promote-until-flush result)))))
     (let ((result (map inexact->exact
                     (promote-until-flush adjusted))))
       (if (not (= (apply + result) text-count))
           ;; If this doesn't work, discard, triggering crude
           ;; distribution elsewhere.
           '()
           result))))
#(define (get-connectors grob text-distribution)
   "Modify @var{text-distribution} to reflect line breaks.  Return a list
    of lists of booleans representing whether to draw a connecting line
    between successive texts."
   ;; The property TextSpanner.connectors holds a list of booleans representing
   ;; whether a line will be drawn between two texts.  (Thus, there will be
   ;; one fewer boolean than texts.)  This does NOT include spacers: "".
   ;; This function transforms the list of booleans into a list of lists
   ;; of booleans which reflects line breaks and the additional lines
   ;; which must be drawn.
   ;;
   ;; Given an input of '(#t #t #f)
   ;;
   ;;    '((#t        #t            #f))
   ;; one_ _ _ _two_ _ _ _ _three        four  (one line)
   ;;
   ;;     '((#t       #t)
   ;; one_ _ _ _two_ _ _ _ _                   (two lines)
   ;;   (#t         #f))
   ;; _ _ _ _three     four
   ;;
   ;;     '((#t)
   ;; one_ _ _ _                               (four lines/blank)
   ;; (#t       #t)
   ;; _ _ _two_ _ _
   ;;      (#t)
   ;; _ _ _ _ _ _ _
   ;; (#t      #f))
   ;; _ _three    four
   (let* ((connectors? (ly:grob-property grob 'connectors))
          (text-distribution (vector->list text-distribution)))
     (if (pair? connectors?)
         (let loop ((td text-distribution)
                    (c? connectors?)
                    (result '()))
           (if (null? td)
               result
               (let inner ((texts (car td))
                           (bools c?)
                           (inner-result '()))
                 (cond
                  ((null? (cdr texts))
                   (loop (cdr td) bools
                     (append result (list inner-result))))
                  ((null? bools)
                   (ly:warning
                    "too few connections specified.  Reverting to default.")
                   '())
                  ;; Ignore spacers since they don't represent a new line.
                  ((equal? "" (cadr texts))
                   (inner (cdr texts) bools inner-result))
                  ((equal? (cadr texts) #{ \markup \null #})
                   (inner (cdr texts) bools
                     (append inner-result (list (car bools)))))
                  (else
                   (inner (cdr texts) (cdr bools)
                     (append inner-result (list (car bools)))))))))
         '())))
#(define (get-line-arrangement siblings extents texts)
   "Given a list of spanner extents and texts, return a vector of lists
    of the texts to be used for each line.  Using @code{'()} for @var{siblings}
    returns a vector for an unbroken spanner."
   (let ((sib-len (length siblings)))
     (if (= sib-len 0)
         ;; only one line...
         (make-vector 1 texts)
         (let* ((texts-len (length texts))
                (text-counts
                 (ly:grob-property
                  (car siblings) 'text-spanner-line-count))
                (text-counts
                 (cond
                  ((pair? text-counts) text-counts) ; manual override
                  ((null? siblings) '())
                  (else (get-text-distribution texts extents))))
                (text-counts
                 (if (and (pair? text-counts)
                          (not (= (apply + text-counts) texts-len)))
                     (begin
                      (ly:warning "Count doesn't match number of texts.")
                      '())
                     text-counts))
                (text-lines (make-vector sib-len 0))
                ;; If user hasn't specified a count elsewhere, or the result
                ;; from 'get-text-distribution' failed, we have this method.
                ;; Populate vector in a simple way: with two lines,
                ;; give one text to the first line, one to the second,
                ;; a second for the first, and second for the second--
                ;; and so forth, until all texts have been exhausted.  So
                ;; for 3 lines and 7 texts we would get this arrangement:
                ;; 3, 2, 2.
                (text-counts
                 (cond
                  ((null? text-counts)
                   (let loop ((txts texts) (idx 0))
                     (cond
                      ((null? txts) text-lines)
                      ;; We need to ensure that the last line has text.
                      ;; This may require skipping lines.
                      ((and (null? (cdr txts))
                            (< idx (1- sib-len))
                            (= 0 (vector-ref text-lines (1- sib-len))))
                       (vector-set! text-lines (1- sib-len) 1)
                       text-lines)
                      (else
                       (vector-set! text-lines idx
                         (1+ (vector-ref text-lines idx)))
                       (loop (cdr txts)
                         (if (= idx (1- sib-len)) 0 (1+ idx)))))))
                  (else (set! text-lines (list->vector text-counts)))))
                ;; read texts into vector
                (texts-by-line
                 (let loop ((idx 0) (texts texts))
                   (if (= idx sib-len)
                       text-lines
                       (let ((num (vector-ref text-lines idx)))
                         (vector-set! text-lines idx
                           (list-head texts num))
                         (loop (1+ idx)
                           (list-tail texts num)))))))
           text-lines))))
#(define (add-markers text-lines)
   ;; Markers are added to the broken edges of spanners to serve as anchors
   ;; for connector lines beginning and ending systems.
   ;; Add null-markup at the beginning of lines 2...n.
   ;; Add null-markup at the end of lines 1...(n-1).
   ;; Note: this modifies the vector 'text-lines'.
   (let loop ((idx 0))
     (if (= idx (vector-length text-lines))
         text-lines
         (begin
          (if (> idx 0)
              (vector-set! text-lines idx
                (cons #{ \markup \null #}
                  (vector-ref text-lines idx))))
          (if (< idx (1- (vector-length text-lines)))
              (vector-set! text-lines idx
                (append (vector-ref text-lines idx)
                  (list #{ \markup \null #}))))
          (loop (1+ idx))))))
%% Adapted from 'justify-line-helper' in scm/define-markup-commands.scm.
#(define (markup-list->stencils-and-extents-for-line grob texts extent padding)
   "Given a list of markups @var{texts}, return a list of stencils and extents
    spread along an extent @var{extent}, such that the intervening spaces are
    equal."
   (let* ((orig-stencils
           (map (lambda (a) (grob-interpret-markup grob a)) texts))
          (stencils
           (map (lambda (stc)
                  (if (ly:stencil-empty? stc X)
                      (ly:make-stencil (ly:stencil-expr stc)
                        '(0 . 0) (ly:stencil-extent stc Y))
                      stc))
             orig-stencils))
          (line-contents
           (if (= (length stencils) 1)
               (list point-stencil (car stencils) point-stencil)
               stencils))
          (text-extents
           (map (lambda (stc) (ly:stencil-extent stc X))
             line-contents))
          (te1 text-extents)
          ;; How much shift is necessary to align left edge of first
          ;; stencil with extent?  Apply this shift to all stencils.
          (text-extents
           (map (lambda (stc)
                  (coord-translate
                   stc
                   (- (car extent) (caar text-extents))))
             text-extents))
          ;; how much does the last stencil need to be translated for
          ;; its right edge to touch the end of the spanner?
          (last-shift (- (cdr extent) (cdr (last text-extents))))
          (word-count (length line-contents))
          ;; Make a list of stencils and their extents, scaling the
          ;; extents across extent. The right edge of the last stencil
          ;; is now aligned with the right edge of the spanner.  The
          ;; first stencil will be moved 0.0, the last stencil the
          ;; amount given by last-shift.
          (stencils-shifted-extents-list
           (let loop ((contents line-contents) (exts text-extents)
                       (idx 0) (result '()))
             (if (null? contents)
                 result
                 (loop
                  (cdr contents) (cdr exts) (1+ idx)
                  (append result
                    (list
                     (cons (car contents)
                       (coord-translate
                        (car exts)
                        (* idx
                          (/ last-shift (1- word-count)))))))))))
          ;; Remove non-marker spacers from list of extents.  This is done
          ;; so that a single line is drawn to cover the total gap rather
          ;; than several. (A single line is needed since successive dashed
          ;; lines will not connect properly.)
          (stencils-extents-list-no-spacers
           (let loop ((orig stencils-shifted-extents-list) (idx 0) (result '()))
             (cond
              ((= idx (length stencils-shifted-extents-list)) result)
              ;; Ignore first and last stencils, which--if point stencil--
              ;; will be markers.
              ((or (= idx 0)
                   (= idx (1- (length stencils-shifted-extents-list))))
               (loop (cdr orig) (1+ idx)
                 (append result (list (car orig)))))
              ;; Remove spacers.  Better way to identify them than comparing
              ;; left and right extents?
              ((= (cadar orig) (cddar orig))
               (loop (cdr orig) (1+ idx) result))
              ;; Keep any visible stencil.
              (else (loop (cdr orig) (1+ idx)
                      (append result (list (car orig)))))))))
     stencils-extents-list-no-spacers))
#(define (check-for-overlaps stil-extent-list)
   (let* ((collision
           (lambda (line)
             (let loop ((exts line) (result '()))
               (if (null? (cdr exts))
                   result
                   (loop (cdr exts)
                     (append result
                       (list
                        (not (interval-empty?
                              (interval-intersection
                               (cdar exts) (cdadr exts)))))))))))
          ;; List of lists of booleans comparing first element to second,
          ;; second to third, etc., for each line.  #f = no collision
          (all-successive-collisions
           (map (lambda (line) (collision line))
             stil-extent-list)))
     ;; For now, just print a warning and return #t if any collision anywhere.
     (let loop ((lines all-successive-collisions) (idx 0) (collisions? #f))
       (cond
        ((null? lines) collisions?)
        ((any (lambda (p) (eq? p #t)) (car lines))
         (ly:warning
          "overlap(s) found on line ~a; redistribute manually"
          (1+ idx))
         (loop (cdr lines) (1+ idx) #t))
        (else
         (loop (cdr lines) (1+ idx) collisions?))))))
#(define (make-distributed-line-stencil grob stil-stil-extent-list connectors)
   "Take a list of stencils and arbitrary extents and return a combined
stencil conforming to the given extents.  Lines separate the stencils.
TODO: lines should be suppressed if not enough space."
   (let* ((padding (ly:grob-property grob 'line-X-offset (cons 0.0 0.0)))
          (padding-L (car padding))
          (padding-R (cdr padding))
          (padded-stencils-extents-list
           (let loop ((orig stil-stil-extent-list) (idx 0) (result '()))
             (cond
              ((= idx (length stil-stil-extent-list)) result)
              ;; don't widen line markers
              ((= (cadar orig) (cddar orig))
               (loop (cdr orig) (1+ idx)
                 (append result (list (car orig)))))
              ;; right padding only if object starts line
              ((= idx 0)
               (loop (cdr orig) (1+ idx)
                 (append
                  result
                  (list (cons (caar orig)
                          (coord-translate
                           (cdar orig) (cons 0 padding-R)))))))
              ;; left padding only if object ends a line
              ((= idx (1- (length stil-stil-extent-list)))
               (loop (cdr orig) (1+ idx)
                 (append
                  result
                  (list (cons (caar orig)
                          (coord-translate
                           (cdar orig) (cons (- padding-L) 0.0)))))))
              ;; otherwise right- and left-padding
              (else
               (loop (cdr orig) (1+ idx)
                 (append
                  result
                  (list (cons (caar orig)
                          (coord-translate
                           (cdar orig)
                           (cons (- padding-L)
                             padding-R))))))))))
          ;; Spaces between the text stencils will be filled with lines.
          (spaces
           (if (> (length padded-stencils-extents-list) 1)
               (let loop ((orig padded-stencils-extents-list)
                          (result '()))
                 (if (null? (cdr orig))
                     result
                     (loop
                      (cdr orig)
                      (append
                       result
                       (list (cons (cdr (cdr (first orig)))
                               (car (cdr (second orig)))))))))
               '()))
          (line-contents
           (let loop ((contents stil-stil-extent-list)
                      (stil empty-stencil))
             (if (null? contents)
                 stil
                 (loop
                  (cdr contents)
                  (ly:stencil-add stil
                    (ly:stencil-translate-axis
                     (caar contents)
                     (- (car (cdr (car contents)))
                       (car (ly:stencil-extent (car (car contents)) X)))
                     X))))))
          ;; By default, lines are drawn between all texts
          (join-all (null? connectors))
          (offset-Y (ly:grob-property grob 'line-Y-offset 0.0))
          (line-contents
           (let loop ((exts spaces)
                      (result line-contents)
                      (join connectors))
             (if (null? exts)
                 result
                 (loop
                  (cdr exts)
                  (if (and
                       ;; space too short for line
                       (not (interval-empty? (car exts)))
                       (or join-all
                           (car join)))
                      (ly:stencil-add
                       result
                       ;(make-line-stencil 0.1
                       ;; For versions < 2.19.27, replace line below with
                       ;; commented line.  No dashed lines!
                       (ly:line-interface::line grob
                         (caar exts) offset-Y
                         (cdar exts) offset-Y))
                      result)
                  (if join-all join (cdr join)))))))
     line-contents))
#(define (make-stencils grob siblings stil-extent-list connectors)
   ;; entry point for stencil construction
   (if (null? siblings)
       (list (make-distributed-line-stencil grob
               (car stil-extent-list)
               (if (pair? connectors)
                   (car connectors)
                   connectors)))
       (map (lambda (sib)
              (make-distributed-line-stencil sib
                (list-ref
                 stil-extent-list
                 (list-index
                  (lambda (x) (eq? x sib))
                  siblings))
                (if (pair? connectors)
                    (list-ref
                     connectors
                     (list-index
                      (lambda (x) (eq? x sib))
                      siblings))
                    '())))
         siblings)))
%% Based on addTextSpannerText, by Thomas Morley.  See
%% http://www.mail-archive.com/lilypond-user%40gnu.org/msg81685.html
addTextSpannerText =
#(define-music-function (texts) (list?)
   (if (< (length texts) 2)
       (begin
        (ly:warning "At least two texts required for `addTextSpannerText'.")
        (make-music 'Music))
       #{
         % The following overrides of 'bound-details are needed to give the
         % correct length to the default spanner we replace.
         \once \override TextSpanner.bound-details.left.text = #(car texts)
         \once \override TextSpanner.bound-details.left-broken.text = ##f
         \once \override TextSpanner.bound-details.right.text = #(last texts)
         \once \override TextSpanner.bound-details.right-broken.text = ##f
         \once \override TextSpanner.stencil =
         #(lambda (grob)
            (let* (;; have we been split?
                    (orig (ly:grob-original grob))
                    ;; if yes, get the split pieces (our siblings)
                    (siblings (if (ly:grob? orig)
                                  (ly:spanner-broken-into orig)
                                  '()))
                    (stils (ly:grob-property grob 'text-spanner-stencils)))
              ;; If stencils haven't been calculated, calculate them.  Once
              ;; we have results prompted by one sibling, no need to go
              ;; through elaborate calculation (stencils, collisions, ideal
              ;; line contents...) for remaining pieces.
              (if (null? stils)
                  (let* (;; pieces and their default stencils
                          (grobs-and-stils
                           (if (null? siblings) ; unbroken
                               (list (cons grob (ly:line-spanner::print grob)))
                               (map
                                (lambda (sib)
                                  (cons sib (ly:line-spanner::print sib)))
                                siblings)))
                          (line-stils
                           (map (lambda (gs) (cdr gs)) grobs-and-stils))
                          (line-extents
                           (map (lambda (s) (ly:stencil-extent s X))
                             line-stils))
                          (our-stil
                           (cdr (find (lambda (x) (eq? (car x) grob))
                                  grobs-and-stils)))
                          (padding (ly:grob-property grob 'padding 0.0)))
                    (define (get-stil-extent-list text-distrib)
                      (if (null? siblings)
                          (list
                           (markup-list->stencils-and-extents-for-line
                            grob
                            (vector-ref text-distrib 0)
                            (ly:stencil-extent our-stil X)
                            padding))
                          (map
                           (lambda (sib)
                             (markup-list->stencils-and-extents-for-line
                              sib
                              (vector-ref text-distrib
                                (list-index
                                 (lambda (y) (eq? y sib)) siblings))
                              (ly:stencil-extent
                               (cdr (find
                                     (lambda (z) (eq? (car z) sib))
                                     grobs-and-stils))
                               X)
                              padding))
                           siblings)))
                    (let*
                     (;; vector which gives the text for unbroken spanner
                       ;; or for siblings.  This is a preliminary
                       ;; arrangement, to be tweaked below.
                       (text-distribution
                        (get-line-arrangement siblings line-extents texts))
                       (text-distribution (add-markers text-distribution))
                       (connectors (get-connectors grob text-distribution))
                       (all-stils-and-extents
                        (get-stil-extent-list text-distribution))
                       ;; warning printed
                       (overlaps (check-for-overlaps all-stils-and-extents))
                       ;; convert stencil/extent list into finished stencil
                       (line-stils
                        (make-stencils
                         grob siblings all-stils-and-extents connectors)))
                     (if (null? siblings)
                         (set! (ly:grob-property grob 'text-spanner-stencils)
                               line-stils)
                         (for-each
                          (lambda (sib)
                            (set!
                             (ly:grob-property sib 'text-spanner-stencils)
                             line-stils))
                          siblings))
                     (set! stils line-stils))))
              ;; Return our stencil
              (if (null? siblings)
                  (car stils)
                  (list-ref stils
                    (list-index (lambda (x) (eq? x grob)) siblings)))))
       #}))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXAMPLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
  \override TextSpanner.line-X-offset = #'(0.5 . 0.5)
  \override TextSpanner.line-Y-offset = 0.5
  \addTextSpannerText #'("ral" "len" "tan" "do")
  c'1\startTextSpan
  d'1\stopTextSpan
%}
%{
%% Score counter => \markup { #nextCount }
#(define nextCount
      (let ((counter 0))
       (lambda ()
        (set! counter (1+ counter))
        (number->string counter))))
%}
%%% Bug
F = -\tweak X-offset #-.3 \f

%% Dashed spanBar => \layout { \dashedStart } :
#(define (make-round-filled-box x1 x2 y1 y2 blot-diameter)
  (ly:make-stencil (list 'round-filled-box (- x1) x2 (- y1) y2 blot-diameter)
                   (cons x1 x2)
                   (cons y1 y2)))
#(define-public (make-dashed-system-start-bar grob extent thickness)
  (let* ((blot (ly:output-def-lookup (ly:grob-layout grob) 'blot-diameter))
         (line-thickness (ly:staff-symbol-line-thickness grob))
         (staff-space (ly:staff-symbol-staff-space grob))
         (height (interval-length extent))
         (gap (ly:grob-property grob 'gap 0.5))
         (dash-size (- 1.0 gap))
         ;(num (ceiling (/ (* 1.5 height) (+ dash-size staff-space))))
         (num (ceiling height))
         (factors
           (map
             (lambda (x) (* x dash-size))
             (iota (* 2 (- num 2)))))
         (scaling (/ (- (+ height line-thickness) (* 3.0 dash-size))
                     (car (reverse factors))))
         (stencil
           (ly:stencil-add
             (ly:stencil-translate-axis
               (make-round-filled-box 0 thickness
                                      (/ dash-size -2) 0 blot)
               (+ (interval-end extent)(* 0.5 line-thickness))
               Y)
             (ly:stencil-translate-axis
               (make-round-filled-box 0 thickness 0
                                      (/ dash-size 2) blot)
               (- (interval-start extent) (* 0.5 line-thickness))
               Y))))
    (define (helper args)
      (set! stencil
            (ly:stencil-add
              stencil
              (ly:stencil-translate-axis
                (make-round-filled-box 0 thickness
                                       (car args) (cadr args) blot)
                (+ (* 1.5 dash-size) (- (interval-start extent) (* 0.5 line-thickness)))
                Y)))
      (if (null? (cddr args))
          stencil
          (helper (cddr args))))
    (set! factors (map (lambda (x) (* scaling x)) factors))
    (if (zero? num)
        empty-stencil
        (helper factors))))
dashedStart =
\override Score.SystemStartBar.stencil =
   #(lambda (grob)
   (let*((stencil (ly:system-start-delimiter::print grob))
         (stencil-y-extent (ly:stencil-extent stencil Y))
         (line-thickness (ly:staff-symbol-line-thickness grob))
         (new-stencil-extent (interval-widen stencil-y-extent (* -0.5
  line-thickness)))
         (thickness (ly:grob-property grob 'thickness))
         (grob-thickness (* line-thickness thickness)))
   (make-dashed-system-start-bar grob new-stencil-extent grob-thickness)))
 

% Sanz vibrato:

vib = \markup
  \scale #'(1 . .9)
  \rotate #2
  \path #0.25 
    #'((moveto -1 -1)(lineto .8 1)(moveto -1 .8)(lineto .6 -1)
       (moveto -.5 -1)(lineto 1.3 1)(moveto -.6 1)(lineto 1.2 -1))
 

%% http://lsr.di.unimi.it/LSR/Item?id=771
% this snippet is useful to put a hairpin between to markups i.e. parentheses or slash
% or any other text
% este fragmento sirve para poner un regulador de angulo entre dos markups, p.e.
% parentesis, corchetes, barras o cualquier otro texto
% leftText y rightText serán los textos a la izquierda y a la derecha respectivamente
% leftText and rightText will be the markup texts on each side of the hairpin
hairpinBetweenText =
#(define-music-function (leftText rightText) (markup? markup?)
   #{
     \once \override Hairpin.stencil =
     #(lambda (grob)
        (ly:stencil-combine-at-edge
         (ly:stencil-combine-at-edge
          (ly:stencil-aligned-to (grob-interpret-markup grob leftText) Y CENTER)
          X RIGHT
          (ly:stencil-aligned-to (ly:hairpin::print grob) Y CENTER)
          0.3)
         X RIGHT
         (ly:stencil-aligned-to (grob-interpret-markup grob rightText) Y CENTER)
         0.3))
   #})
%cambiando el contenido de los \markup cambiamos el objeto de texto (elemento
%de marcado y aceptara cualquier cosa que se pueda incluir en estos.
%you can change de content of the \markup to show diferent texts
%or any other thing you can put in a \markup
parenthesizedHairpin = \hairpinBetweenText \markup "(" \markup ")"
%{ the music
\score {
  \relative c' {
    \time 3/4  

    \parenthesizedHairpin
    c16\< d e f g a b c d e f g a\!
  }
%}
% => http://lilypond.1069038.n5.nabble.com/magnifyStaff-and-key-signature-padding-td222389.html
% => https://notat.io/viewtopic.php?f=2&t=470
scaleStaff = #(define-music-function (scaleFac) (number?)
                 #{
                   \magnifyStaff #scaleFac
                   \override KeySignature.padding = #(* 2/3 (- 1 scaleFac))
                 #})

parC = #(define-event-function () ()
    #{

      \tweak bound-details.left.text \markup\concat { \lower #.1 "(" "cresc." }
      \tweak bound-details.left.attach-dir #-2
      \tweak bound-details.right-broken.text ##f
      \tweak bound-details.left-broken.text ##f
      \tweak bound-details.right.text \markup\lower #.5 " )"
      \tweak bound-details.right.attach-dir # .5
      \cresc
    #})
parD = #(define-event-function () ()
    #{

      \tweak bound-details.left.text \markup\concat { \lower #.1 "(" "decresc." }
      \tweak bound-details.left.attach-dir #-2
      \tweak bound-details.right-broken.text ##f
      \tweak bound-details.left-broken.text ##f
      \tweak bound-details.right.text \markup\lower #.5 " )"
      \tweak bound-details.right.attach-dir #.5
      \decresc
    #})
%% Test:
% { c'1*10 \parC \break s1*5 c'1\! c'1*5 \parD \break s1*10 c'1\! \bar "." }

deleteDynamics = #(define-music-function (music) (ly:music?)
 (music-filter
  (lambda (evt)
   (not
    (memq (ly:music-property evt 'name) (list
       'AbsoluteDynamicEvent
       'CrescendoEvent
       'DecrescendoEvent))))
     music))
%\deleteDynamics { a'4\f\< b'\ff\> c''\p }
startModernBarre =
  #(define-event-function (fretnum partial)
     (number? number?)
      #{
        \tweak bound-details.left.text
          \markup\concat {
            #(format #f "~@r" fretnum) \hspace #.2 \lower #.3
            \override #'(thickness . 1)
            \override #'(circle-padding . 0.1)
            \circle\finger\fontsize #-2
            #(number->string partial)
            \hspace #.5
          }
        \tweak font-size -1
        \tweak font-shape #'upright
        \tweak style #'dashed-line
        \tweak dash-fraction #0.3
        \tweak dash-period #1
        \tweak bound-details.left.stencil-align-dir-y #0.35
        \tweak bound-details.left.padding -1
        \tweak bound-details.left.attach-dir -1
        \tweak bound-details.left-broken.text ##f
        \tweak bound-details.left-broken.attach-dir -1
        %% adjust the numeric values to fit your needs:
        \tweak bound-details.left-broken.padding 1.5
        \tweak bound-details.right-broken.padding 0
        \tweak bound-details.right.padding 0.25
        \tweak bound-details.right.attach-dir 2
        \tweak bound-details.right-broken.text ##f
        \tweak bound-details.right.text
          \markup
            \with-dimensions #'(0 . 0) #'(-.5 . 0)
            \override #'(on . 0.3)
            \override #'(off . 0.1)
            \draw-dashed-line #'(0 . -1)
        \startTextSpan
     #})


startDbleBarre =
  #(define-event-function (fnOne ptlOne fnTwo ptlTwo)
     (number? number? number? number?)
      #{
        \tweak bound-details.left.text
          \markup
          \override #'(baseline-skip . 0)
          \left-column {
            \concat {
              #(format #f "~@r" fnOne) \hspace #.2 \lower #.3
              \override #'(thickness . 1)
              \override #'(circle-padding . 0.1)
              \circle\finger\fontsize #-2
              #(number->string ptlOne)
              \hspace #.5
            }
            \vspace #-.1
            \concat {
              #(format #f "~@r" fnTwo) \hspace #.2 \lower #.3
              \override #'(thickness . 1)
              \override #'(circle-padding . 0.1)
              \circle\finger\fontsize #-2
              #(number->string ptlTwo)
              \hspace #.5
            }
          }
        \tweak font-size -1
        \tweak font-shape #'upright
        \tweak style #'dashed-line
        \tweak dash-fraction #0.3
        \tweak dash-period #1
        \tweak bound-details.left.stencil-align-dir-y #0.7
        \tweak bound-details.left.padding -1
        \tweak bound-details.left.attach-dir -1
        \tweak bound-details.left-broken.text ##f
        \tweak bound-details.left-broken.attach-dir -1
        %% adjust the numeric values to fit your needs:
        \tweak bound-details.left-broken.padding 1.5
        \tweak bound-details.right-broken.padding 0
        \tweak bound-details.right.padding 0.25
        \tweak bound-details.right.attach-dir 2
        \tweak bound-details.right-broken.text ##f
        \tweak bound-details.right.text
          \markup
            \with-dimensions #'(0 . 0) #'(-.5 . 0)
            \override #'(on . 0.3)
            \override #'(off . 0.1)
            \draw-dashed-line #'(0 . -1)
        \startTextSpan
     #})


glissLen = #(define-event-function (arg) (number?)
    #{

      \tweak minimum-length #arg
      \tweak springs-and-rods #ly:spanner::set-spacing-rods
      \glissando
    #})
%\fixed c'' { d8 \glissLen10 cis }

withMinLength = -\tweak springs-and-rods #ly:spanner::set-spacing-rods
                -\tweak minimum-length \etc
%\fixed c'' { d8 \withMinLength #5 \glissando cis }
#(define-markup-command (m-p layout props) ()
  (interpret-markup layout props
   (markup #:translate (cons 0 -.6)
    (#:stencil
     (make-path-stencil
      '(M 2.953 2.195
        C 2.461 1.988 2.406 1.648 2.348 1.41
        C 2.27 1.012 2.199 0.875 2.129 0.867
        C 2.105 0.867 2.094 0.883 2.094 0.906
        C 2.094 0.91 2.098 0.922 2.098 0.934
        L 2.273 1.676 C 2.277 1.699 2.281 1.727 2.281 1.754
        C 2.281 1.926 2.156 2.098 1.988 2.098
        C 1.844 2.098 1.695 2.004 1.59 1.867
        C 1.559 1.996 1.48 2.098 1.367 2.098
        C 1.215 2.098 1.07 2.004 0.961 1.875
        C 0.934 2 0.863 2.098 0.758 2.098
        C 0.422 2.098 0.141 1.715 0.008 1.332
        C 0.004 1.32 0 1.313 0 1.305
        C 0 1.266 0.027 1.246 0.059 1.246
        C 0.102 1.246 0.152 1.273 0.176 1.332
        C 0.238 1.504 0.359 1.766 0.504 1.766
        C 0.555 1.766 0.57 1.734 0.57 1.684
        C 0.57 1.66 0.57 1.629 0.563 1.605
        L 0.246 0.691 C 0.23 0.645 0.258 0.602 0.305 0.602
        L 0.508 0.602 C 0.563 0.602 0.617 0.645 0.633 0.691
        L 0.945 1.605 C 0.973 1.691 1.066 1.766 1.145 1.766
        C 1.191 1.766 1.211 1.734 1.211 1.688
        C 1.211 1.664 1.207 1.637 1.195 1.605
        L 0.934 0.691 C 0.922 0.645 0.949 0.602 1 0.602
        L 1.207 0.602 C 1.258 0.602 1.305 0.645 1.316 0.691
        L 1.582 1.605 C 1.613 1.688 1.695 1.766 1.777 1.766
        C 1.828  1.766 1.848 1.727 1.848 1.676
        C 1.848 1.652 1.844 1.629 1.836 1.605
        L 1.641 0.785 C 1.637 0.762 1.637 0.746 1.637 0.727
        C 1.637 0.629 1.695 0.57 1.797  0.57
        C 2.027 0.57 2.266 0.547 2.406 1.09
        C 2.43 1.16 2.438 1.234 2.453 1.285
        C 2.543 1.734 2.703 1.945 2.871 1.945
        C 2.91 1.945 2.926 1.918 2.926  1.875
        C 2.926 1.848 2.91 1.813 2.902 1.777
        L 2.391 0.277 C 2.359 0.176 2.234 0.156 2.121 0.152
        C 2.035 0.145 1.883 0.16 1.883 0.07
        C 1.883 0.039  1.906 0 1.953 0
        C 2.141 0 2.332 0.023 2.527 0.023
        C 2.719 0.023 2.918 0 3.109 0
        C 3.156 0 3.172 0.039 3.172 0.07
        C 3.172 0.098 3.156 0.137 3.109 0.141
        C 2.992 0.152 2.887 0.184 2.887 0.281
        C 2.887 0.289 2.887 0.305 2.895 0.313
        L 3.039 0.75 C 3.047 0.777 3.086 0.793 3.117 0.793
        C 3.137 0.793 3.156 0.785 3.172 0.777
        C 3.277 0.715 3.402 0.691 3.539 0.691
        C 3.82 0.691 4.176 0.996 4.277 1.285
        C 4.313 1.402 4.332 1.516 4.332 1.625
        C 4.332 1.945 4.145 2.195 3.801 2.195
        C 3.617 2.195 3.426 2.09 3.281 1.934
        C 3.25 2.09 3.125 2.227 2.953 2.195 Z
        M 3.715 1.945 C 3.805 1.945 3.836 1.871 3.836 1.781
        C 3.836 1.52 3.672 0.891 3.352 0.891
        C 3.242 0.891 3.207 0.973 3.207 1.082
        C 3.207 1.414 3.434 1.945 3.715 1.945 Z)
       0 .82 .82 #t)))))
mp = #(make-dynamic-script (markup #:m-p))
mf = #(make-dynamic-script (markup #:concat (#:dynamic "m" #:hspace -0.2 #:dynamic "f" )))
replace-stencil = #(define-music-function (grob text) (grob-list?
markup?)
   (define (stencil grob) (grob-interpret-markup grob text))
   #{ \override $grob . stencil = $stencil #})
%{
   \once \replace-stencil Staff.TimeSignature
     \markup \override #'(baseline-skip . 1)
       \center-column { \musicglyph "four" \musicglyph "noteheads.sM1" }
   \time 8/1 c'\breve c' c' c'
%}
#(define-markup-command (underln layout props arg)
  (markup?)
  #:category font
  #:properties ((thickness 1) (offset 2) (gap 2) (amount 1))
  (let* ((thick (ly:output-def-lookup layout 'line-thickness))
         (underline-thick (* thickness thick))
         (m (interpret-markup layout props arg))
         (stil-x-ext (ly:stencil-extent m X))
         (x1 (car stil-x-ext))
         (x2 (cdr stil-x-ext))
         (y (* thick (- offset)))
         (y-off (* thick (- gap)))
         (lines
           (map
             (lambda (i)
               (let ((y-dist (+ y (* i y-off))))
                 (make-line-stencil underline-thick x1 y-dist x2 y-dist)))
             (iota amount 0 1))))
    (apply ly:stencil-add m lines)))
%{
\markup
  \underline "underlined"
\markup
  \override #'(amount . 2)
  \underline "underlined"
\markup
  \override #'(amount . 3)
  \underline "underlined"
\markup
  \override #'(offset . 4)
  \override #'(amount . 3)
  \underline "underlined"
\markup
  \override #'(offset . 4)
  \override #'(amount . 3)
  \override #'(gap . 3)
  \underline "underlined"
%}
overlay-stencil = #(define-music-function (grob align text)
   (grob-list? (number-pair? '(0 . 0)) markup?)
   (define stencil (grob-transformer 'stencil (lambda (grob orig)
     (let ((x (interval-index (ly:stencil-extent orig X) (car align)))
           (y (interval-index (ly:stencil-extent orig Y) (cdr align)))
           (new (grob-interpret-markup grob text)))
       (ly:stencil-add orig (ly:stencil-translate new (cons x y)))))))
   #{
     \override $grob . layer  = 10
     \override $grob . stencil = $stencil #})
red-x = \markup \with-dimensions-from \null
   \vcenter \center-align \with-color #red \fontsize #5 "×"
 

corr = \once \overlay-stencil NoteHead \red-x
%{
   \overlay-stencil Staff.Clef #'(-1 . 1) "Clef"
   b'8 c''
   \temporary \overlay-stencil NoteHead \red-x
   g' a'
   \revert NoteHead.stencil
   b'4 << { \corr <b> } \\ { \stemUp b' } >>
%}
%%%%%%%%%%%%%%%%%%%%%
#(define-markup-command (medium layout props text) (markup?)
  "Medium bold text"
  (interpret-markup layout props
    #{
      \markup
      \combine #text
      \translate #'(.01 . 0)
      \combine #text
      \translate #'(.02 . 0) #text #}))
extendLV =
#(define-music-function (further) (number?)
#{
  \once \override LaissezVibrerTie.X-extent = #'(0 . 0)
  \once \override LaissezVibrerTie.details.note-head-gap = #(/ further -2)
  \once \override LaissezVibrerTie.extra-offset = #(cons (/ further 2) 0)
#})
%{
\relative c' {
  \extendLV #2.5
  e8 \laissezVibrer r16 r8
}
%}
%% => https://lists.gnu.org/archive/html/lilypond-user/2015-03/msg00365.html :
%% => https://lists.gnu.org/archive/html/lilypond-user/2015-03/msg00365.html :
set-connected-beam-counts =
#(define-music-function (val music)(integer? ly:music?)
#{
  \temporary
    \override Stem.after-line-breaking =
      #(lambda (grob)
        (let*((beaming (ly:grob-property grob 'beaming)))
         (if (>= val 0)
             (begin
               (if (and (list? (car beaming))
                        (= (caar beaming) 0))
                   (ly:grob-set-property! grob 'beaming
                     (cons (iota val) (cdr beaming))))
               (if (and (list? (cdr beaming))
                        (= (cadr beaming) 0))
                   (ly:grob-set-property! grob 'beaming
                     (cons (car beaming) (iota val)))))
              (ly:message "negative beam-count detected, ignoring"))))
  $music
  \revert Stem.after-line-breaking
#})
%% http://lsr.di.unimi.it/LSR/Item?id=1068
%% Add by P.P.Schneider on July 2018.
%% see disussion => http://lilypond.1069038.n5.nabble.com/dotted-semicircle-indicating-harmonics-td214580.html
%circled-pattern :
#(define-markup-command
  (circled-pattern layout props radius angle num arg)
  (number? number? number? markup?)
  (interpret-markup layout props
   (let* ((rep (abs num))(rad (abs radius)))
    (cond
     ((= num 0) (markup ""))
     ((= num 1) (markup arg))
     (#t (markup
          (#:combine
           (#:null)
           (fold
            (lambda (i prev)
             (markup
               (#:combine
                (#:rotate
                 (* i (/ angle rep))
                 (#:concat (#:null #:hspace rad arg)))
               prev)))
            (markup (#:null))
            (iota (1+ rep))))))))))
#(define-markup-command
  (circled-pattern-iterative layout props radius angle num arg)
  (number? number? number? markup?)
  (interpret-markup layout props
   (let ((rep (abs num)))
    (cond
     ((= num 0) (markup ""))
     ((= num 1) arg)
     (#t (do ((i 0 (1+ i))
              (res (markup (#:null))
                   (markup
                    (#:combine
                     (#:rotate
                      (* i (/ angle rep))
                      (#:concat (#:null #:hspace radius arg)))
                     res))))
             ((= i (1+ rep)) res)))))))
%%% Tests:
%\markup\circled-pattern-iterative #10 #180 #15 \musicglyph "dots.dot"
#(define-markup-list-command (clip layout props str) (string?)
  (map (lambda (str)
        (interpret-markup layout props
          (markup
           #:general-align Y CENTER
           #:override (cons (quote thickness) 2.5)
           #:circle
           #:hcenter-in 2.1
           #:bold str)))
   (string-split str #\-)))
%% \markup\clip "f"
%% => http://lilypond.1069038.n5.nabble.com/dashedStart-with-RemoveEmpyStaves-gives-an-error-td228835.html
dashedStart = \override Score.SystemStartBar.stencil =
#(lambda (grob)
  (let* ((stencil (ly:system-start-delimiter::print grob)))
    (if (ly:stencil? stencil)
        (let* ((stencil-y-extent
                 (ly:stencil-extent stencil Y))
               (line-thickness
                 (ly:staff-symbol-line-thickness grob))
               (new-stencil-extent
                 (interval-widen stencil-y-extent (* -0.5 line-thickness)))
               (thickness (ly:grob-property grob 'thickness))
               (grob-thickness
                 (* line-thickness thickness)))
          (make-dashed-system-start-bar grob new-stencil-extent grob-thickness))
        '())))

%CopyLeft:
 #(define-markup-command (CC layout props) ()
  (interpret-markup layout props
   (markup
    (#:stencil
     (make-path-stencil
       '( M 697.500 367.500
          C 697.500 549.754 549.754 697.500 367.500 697.500
          C 185.246 697.500  37.500 549.754  37.500 367.500
          C  37.5 185.246 185.246 37.5 367.5 37.5
          C 549.754 37.5 697.5 185.246 697.5 367.5 ;Z
          L 164.25 321
          L 262.5 321
          C 284.535 272.922 337.086 246.684 388.758 257.961
          C 440.43 269.238 477.27 314.988 477.27 367.875
          C 477.27 420.762 440.43 466.512 388.758 477.789
          C 337.086 489.066 284.535 462.828 262.5 414.75
          L 164.25 414.75
          C 188.063 516.789 284.602 584.758 388.695 572.77
          C 492.789 560.785 571.352 472.656 571.352 367.875
          C 571.352 263.094 492.789 174.965 388.695 162.98
          C 284.602 150.992 188.063 218.961 164.25 321 Z
          )
       0 .0023 .0023 #t)))))

bem = \markup\concat { \hspace #-.5 \raise #.3 \tiny\flat }
die = \markup\concat { \hspace #-.5 \raise #.7 \tiny\sharp }
%%% Hemiole
logoHemiole = \markup\stencil
  #(make-path-stencil
    `(M 2.074 0.578
      C 2.254 0.98 2.047 1.391 1.836 1.777 C 1.625 2.16 1.355 2.559
      1.531 2.949 C 1.621 3.16 1.883 3.289 2.129 3.215 C 2.367 3.145 2.488 2.941
      2.434 2.758 C 2.258 2.746 2.129 2.66 2.078 2.543 C 2.008 2.391 2.066 2.18
      2.32 2.105 C 2.551 2.035 2.789 2.188 2.883 2.395 C 3.063 2.805 2.73 3.238
      2.207 3.391 C 1.656 3.559 1.059 3.32 0.859 2.867 C 0.68 2.461 0.887 2.055
      1.094 1.668 C 1.305 1.285 1.578 0.887 1.402 0.496 C 1.309 0.285 1.051 0.156
      0.801 0.23 C 0.563 0.301 0.441 0.504 0.5 0.688 C 0.672 0.699 0.805 0.785
      0.855 0.898 C 0.922 1.055 0.863 1.266 0.609 1.34 C 0.379 1.41 0.145 1.258
      0.051 1.051 C -0.133 0.641 0.199 0.207 0.723 0.051 C 1.277 -0.113 1.871
      0.125 2.074 0.578 Z
      M 2.648 0.578
      C 2.848 0.125 3.445 -0.113 3.996 0.051 C 4.52 0.207 4.852 0.641
      4.672 1.051 C 4.578 1.258 4.34 1.41 4.109 1.34 C 3.855 1.266 3.797 1.055
      3.867 0.898 C 3.918 0.785 4.047 0.699 4.223 0.688 C 4.277 0.504 4.156 0.301
      3.918 0.23 C 3.672 0.156 3.41 0.285 3.32 0.496 C 3.145 0.887 3.414 1.285
      3.625 1.668 C 3.836 2.055 4.043 2.461 3.863 2.867 C 3.66 3.32 3.066 3.559
      2.512 3.391 C 1.988 3.238 1.656 2.805 1.84 2.395 C 1.934 2.188 2.168 2.035
      2.398 2.105 C 2.652 2.18 2.711 2.391 2.645 2.543 C 2.594 2.66 2.461 2.746
      2.289 2.758 C 2.23 2.941 2.352 3.145 2.59 3.215 C 2.84 3.289 3.098 3.16
      3.191 2.949 C 3.367 2.559 3.094 2.16 2.883 1.777 C 2.676 1.391 2.469 0.98
      2.648 0.578 Z
      M 2.648 6.098
      C 2.469 5.695 2.676 5.285 2.883 4.898 C 3.094 4.516 3.367 4.117
      3.191 3.727 C 3.098 3.516 2.84 3.387 2.59 3.461 C 2.352 3.531 2.23 3.734
      2.289 3.918 C 2.461 3.93 2.594 4.016 2.645 4.129 C 2.711 4.285 2.652 4.496
      2.398 4.57 C 2.168 4.641 1.934 4.488 1.84 4.281 C 1.656 3.871 1.988 3.438
      2.512 3.281 C 3.066 3.117 3.66 3.355 3.863 3.809 C 4.043 4.211 3.836 4.621
      3.625 5.008 C 3.414 5.391 3.145 5.789 3.32 6.18 C 3.41 6.391 3.672 6.52
      3.918 6.445 C 4.156 6.375 4.277 6.172 4.223 5.988 C 4.047 5.977 3.918 5.891
      3.867 5.777 C 3.797 5.621 3.855 5.41 4.109 5.336 C 4.34 5.266 4.578 5.418
      4.672 5.625 C 4.852 6.035 4.52 6.469 3.996 6.621 C 3.445 6.789 2.848 6.551
      2.648 6.098 Z
      M 2.074 6.098
      C 1.871 6.551 1.277 6.789 0.723 6.621 C 0.199 6.469 -0.133
      6.035 0.051 5.625 C 0.145 5.418 0.379 5.266 0.609 5.336 C 0.863 5.41 0.922
      5.621 0.855 5.777 C 0.805 5.891 0.672 5.977 0.5 5.988 C 0.441 6.172 0.563
      6.375 0.801 6.445 C 1.051 6.52 1.309 6.391 1.402 6.18 C 1.578 5.789 1.305
      5.391 1.094 5.008 C 0.887 4.621 0.68 4.211 0.859 3.809 C 1.059 3.355 1.656
      3.117 2.207 3.281 C 2.73 3.438 3.063 3.871 2.883 4.281 C 2.789 4.488 2.551
      4.641 2.32 4.57 C 2.066 4.496 2.008 4.285 2.078 4.129 C 2.129 4.016 2.258
      3.93 2.434 3.918 C 2.488 3.734 2.367 3.531 2.129 3.461 C 1.883 3.387 1.621
      3.516 1.531 3.727 C 1.355 4.117 1.625 4.516 1.836 4.898 C 2.047 5.285 2.254
      5.695 2.074 6.098 Z)
    0 .8 .8 #t)


  %LSR contributed by David Nalesnik (see http://lilypond.1069038.n5.nabble.com/So-slashed-beamed-grace-notes-td152817.html)
%LSR original contributed by Valentin Villenave
% The argument `ang' is the amount of slant, expressed in degrees.
%
% Stem-fraction is the distance between the point the slash crosses the stem
% and the notehead-end of the stem.  It is expressed as a number between 0 and 1.
%
% The argument `protrusion' is the extra distance the slash
% extends beyond its intersection with stem and beam
% ex. \acciaccatura { \slash 50 0.6 1.0 d8[ e f g] }
slash =
#(define-music-function (ang stem-fraction protrusion)
   (number? number? number?)
   (remove-grace-property 'Voice 'Stem 'direction) ; necessary?
   #{
     \once \override Stem #'stencil =
     #(lambda (grob)
       (let* ((X-parent (ly:grob-parent grob X))
              (is-rest? (ly:grob? (ly:grob-object X-parent 'rest))))
         (if is-rest?
             empty-stencil
             (let* ((ang (degrees->radians ang))
                    ; We need the beam and its slope so that slash will
                    ; extend uniformly past the stem and the beam
                    (beam (ly:grob-object grob 'beam))
                    (beam-X-pos (ly:grob-property beam 'X-positions))
                    (beam-Y-pos (ly:grob-property beam 'positions))
                    (beam-slope (/ (- (cdr beam-Y-pos) (car beam-Y-pos))
                                   (- (cdr beam-X-pos) (car beam-X-pos))))
                    (beam-angle (atan beam-slope))
                    (stem-Y-ext (ly:grob-extent grob grob Y))
                    ; Stem.length is expressed in half staff-spaces
                    (stem-length (/ (ly:grob-property grob 'length) 2.0))
                    (dir (ly:grob-property grob 'direction))
                    ; if stem points up. car represents segment of stem
                    ; closest to notehead; if down, cdr does
                    (stem-ref (if (= dir 1) (car stem-Y-ext) (cdr stem-Y-ext)))
                    (stem-segment (* stem-length stem-fraction))
                    ; Where does slash cross the stem?
                    (slash-stem-Y (+ stem-ref (* dir stem-segment)))
                    ; These are values for the portion of the slash that
                    ; intersects the beamed group.
                    (dx (/ (- stem-length stem-segment)
                           (- (tan ang) (* dir beam-slope))))
                    (dy (* (tan ang) dx))
                    ; Now, we add in the wings
                    (protrusion-dx (* (cos ang) protrusion))
                    (protrusion-dy (* (sin ang) protrusion))
                    (x1 (- protrusion-dx))
                    (y1 (- slash-stem-Y (* dir protrusion-dy)))
                    (x2 (+ dx protrusion-dx))
                    (y2 (+ slash-stem-Y
                           (* dir (+ dy protrusion-dy))))
                    (th (ly:staff-symbol-line-thickness grob))
                    (stil (ly:stem::print grob)))
              (ly:stencil-add
                stil
                (make-line-stencil th x1 y1 x2 y2))))))
   #})
%% Time signature
#(define ((my-time-parenthesized-time up down upp downp) grob)
   (grob-interpret-markup grob
     #{
       \markup
       \override #'(baseline-skip . 0)
       \concat {
         \center-column\number { #up #down }
         \hspace #.2
         \vcenter {
           \fontsize #5 \scale #'(.7 . 1.2) "("
           \center-column { \number { #upp #downp } }
           \fontsize #5 \scale #'(.7 . 1.2) ")"
         }
       }
     #}))
#(define ((parenthesize-time up down) grob)
   (grob-interpret-markup grob
     (markup #:override '(baseline-skip . 0) #:number
       (#:line (
           #:vcenter "("
           (#:column (up down))
           #:vcenter ")" )))))

%%%% Click %%%%%%%

#(define-markup-command (click layout props) ()
  (interpret-markup layout props
   (markup 
    (#:stencil 
     (make-path-stencil
      '(M 0 3.441 L 0 0 L 3.441 0 C 3.438 1.063 3.445 2.289 3.445 3.285 C 3.547 3.375
        3.621 3.434 3.707 3.508 C 3.711 3.539 3.645 3.602 3.629 3.629 C 3.512 3.574
        3.371 3.473 3.309 3.441 C 2.207 3.441 1.148 3.441 0 3.441 M 2.867 3.102
        C 2.676 2.91 2.508 2.734 2.352 2.574 C 2.016 2.223 1.68 1.832 1.441 1.406
        L 1.434 1.406 C 1.367 1.574 1.289 1.754 1.18 1.898 C 1.137 1.953 1.082 
        2.023 1.008 2.043 C 0.887 2.074 0.754 1.992 0.66 1.922 C 0.609 1.883 0.551
        1.832 0.512 1.777 C 0.633 1.75 0.734 1.641 0.805 1.539 C 0.938 1.344 1.031
        1.117 1.117 0.898 C 1.16 0.801 1.215 0.691 1.23 0.586 C 1.32 0.672 1.43
        0.746 1.535 0.816 C 1.582 0.848 1.66 0.883 1.695 0.93 C 1.73 0.977 1.746
        1.035 1.773 1.086 C 1.836 1.195 1.898 1.309 1.965 1.418 C 2.184 1.777 2.426
        2.125 2.684 2.461 C 2.816 2.637 2.914 2.734 3.098 2.941 L 3.098 0.348 L
        0.34 0.348 L 0.34 3.094
        Z)
       0 .47 .47 #t)))))


%%%%% Bracketify %%%%%%%%%%%%

#(define-public (bracket-stencils grob)
  (let ((lp (grob-interpret-markup grob 
              (markup #:fontsize 8 #:translate (cons -0.8 -1.2)  "[")))
        (rp (grob-interpret-markup grob 
              (markup #:fontsize 8 #:translate (cons -.3 -1.2) "]"))))
    (list lp rp)))

bracketify = #(define-music-function (arg) (ly:music?)
   (_i "Tag @var{arg} to be parenthesized.")
#{
  \once \override Parentheses.stencils = #bracket-stencils
  \parenthesize $arg
#})

%% Majuscules :
#(define-markup-command (uppercase layout props markup-argument)
   (markup?)
   (interpret-markup layout props
     (string-upcase (
(lambda* (m #:optional headers)
  (if headers
      (markup->string m #:props (headers-property-alist-chain headers))
      (markup->string m)))
 markup-argument))))


%{
convert-ly (GNU LilyPond) 2.24.0  convert-ly: Processing `'...
Applying conversion:     Le document n'a pas été modifié.
%}
