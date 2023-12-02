%{
  Copyleft 2015 under GPLv3, https://www.gnu.org/licenses/quick-guide-gplv3.fr.html
  Author: Pierre P. Schneider
  Special thanks to Gilles Thibault and Paul Morris for their precious help.
%}

\version "2.19.16"
\pointAndClickOff
#(set-global-staff-size 300)

\paper {
  top-margin = 0
  tagline = ""
}

%%%% graphPaper commands:

#(define-markup-command
  (layer-x layout props lines pad width origin-x origin-y thickness)
  (number? number? number? number? number? number?)
  (let*
   ((neg-width (* -1 width))
    (the-path
     (cons `(moveto ,origin-x ,origin-y)
       (fold
        (lambda (i prev)
          (cons
           `(rlineto ,width  0)
           (cons
            `(rmoveto ,neg-width ,pad)
            prev)))
        '()
        (iota lines)))))
   (interpret-markup layout props
     (markup (#:path thickness the-path)))))

#(define-markup-command
  (layer-y layout props lines pad height origin-x origin-y thickness)
  (number? number? number? number? number? number?)
  (let*
   ((neg-height (* -1 height))
    (the-path
     (cons `(moveto ,origin-x ,origin-y)
       (fold
        (lambda (i prev)
          (cons
           `(rlineto 0 ,height)
           (cons
            `(rmoveto ,pad ,neg-height)
            prev)))
        '()
        (iota lines)))))
   (interpret-markup layout props
     (markup (#:path thickness the-path)))))


%%%% graphPaper tool:

graphPaper =
\markup
\with-dimensions #'(0 . 0) #'(0 . 0)
{
  %% layer #1-x
  \combine
  \with-color #(x11-color 'LightCyan)
  \layer-x #200 #0.1 #20 #-10 #(+ -10 0.05) #0.001
  %% layer #1-y
  \combine
  \with-color #(x11-color 'LightCyan)
  \layer-y #200 #0.1 #20 #(+ -10 0.05) #-10 #0.001

  %% layer #2-x
  \combine
  \with-color #(x11-color 'LightCyan)
  \layer-x #200 #0.1 #20 #-10 #-10 #0.005
  %% layer #2-y
  \combine
  \with-color #(x11-color 'LightCyan)
  \layer-y #200 #0.1 #20 #-10 #-10 #0.005

  %% layer #3-x
  \combine
  \with-color #(x11-color 'DarkSeaGreen1)
  \layer-x #20 #1 #20 #-10 #(+ -10 0.5) #0.01
  %% layer #3-y
  \combine
  \with-color #(x11-color 'DarkSeaGreen1)
  \layer-y #20 #1 #20 #(+ -10 0.5) #-10 #0.01

  %% layer #4-x
  \combine
  \with-color #(x11-color 'pink)
  \layer-x #20 #1 #20 #-10 #-10 #0.01
  %% layer #4-y
  \combine
  \with-color #(x11-color 'pink)
  \layer-y #20 #1 #20 #-10 #-10 #0.01

  %% X
  \combine
  \with-color #(x11-color 'HotPink)
  \path #0.01 #'((moveto  -10  0) (lineto  10  0))
  %% Y
  \combine
  \with-color #(x11-color 'HotPink)
  \path #0.01 #'((moveto  0 -10) (lineto  0 10))

  %% X refs:
  \combine
  \translate #'(10 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "10"
  \combine
  \translate #'(9 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "9"
  \combine
  \translate #'(8 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "8"
  \combine
  \translate #'(7 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "7"
  \combine
  \translate #'(6 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "6"
  \combine
  \translate #'(5 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "5"
  \combine
  \translate #'(4 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "4"
  \combine
  \translate #'(3 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "3"
  \combine
  \translate #'(2 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "2"
  \combine
  \translate #'(1 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "1"
  \combine
  \fontsize #-32 \with-color #(x11-color 'HotPink) "0"
  \combine
  \translate #'(-1 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-1"
  \combine
  \translate #'(-2 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-2"
  \combine
  \translate #'(-3 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-3"
  \combine
  \translate #'(-4 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-4"
  \combine
  \translate #'(-5 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-5"
  \combine
  \translate #'(-6 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-6"
  \combine
  \translate #'(-7 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-7"
  \combine
  \translate #'(-8 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-8"
  \combine
  \translate #'(-9 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-9"
  \combine
  \translate #'(-10 . 0)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-10"

  %% Y refs:
  \combine
  \translate #'(0 . 10)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "10"
  \combine
  \translate #'(0 . 9)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "9"
  \combine
  \translate #'(0 . 8)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "8"
  \combine
  \translate #'(0 . 7)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "7"
  \combine
  \translate #'(0 . 6)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "6"
  \combine
  \translate #'(0 . 5)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "5"
  \combine
  \translate #'(0 . 4)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "4"
  \combine
  \translate #'(0 . 3)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "3"
  \combine
  \translate #'(0 . 2)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "2"
  \combine
  \translate #'(0 . 1)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "1"

  \combine
  \translate #'(0 . -1)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-1"
  \combine
  \translate #'(0 . -2)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-2"
  \combine
  \translate #'(0 . -3)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-3"
  \combine
  \translate #'(0 . -4)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-4"
  \combine
  \translate #'(0 . -5)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-5"
  \combine
  \translate #'(0 . -6)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-6"
  \combine
  \translate #'(0 . -7)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-7"
  \combine
  \translate #'(0 . -8)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-8"
  \combine
  \translate #'(0 . -9)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-9"
  \translate #'(0 . -10)
  \fontsize #-32 \with-color #(x11-color 'HotPink) "-10"
}

%% Bézier tools:
#(define-markup-command (tanX layout props rotation translations-X)
   (number? number?)
   (interpret-markup layout props
     #{
       \markup
       \translate #(cons translations-X 0)
       \rotate #rotation
       {
         \with-dimensions #'(0 . 0) #'(0 . 0)
         \override #'(thickness . 0.05)
         \with-color #blue
         %% helps centering rotation:
         \translate #'(0 . 20)
         \draw-line #'(0 . -40)
       }
     #}))

#(define-markup-command (tanY layout props rotation translations-Y)
   (number? number?)
   (interpret-markup layout props
     #{
       \markup
       \translate #(cons 0  translations-Y)
       \rotate #rotation
       {
         \with-dimensions #'(0 . 0) #'(0 . 0)
         \override #'(thickness . 0.05)
         \with-color #red
         %% helps centering rotation:
         \translate #'(20 . 0)
         \draw-line #'(-40 . 0)
       }
     #}))

%%% END graph-paper.ily