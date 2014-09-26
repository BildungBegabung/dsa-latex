%% 
%% LaTeX2e-Dokumentenklasse für neues BuB-Doku-Layout
%% Stand 17.04.2009
%%

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{newlayout}[2007/09/19 LaTeX2e BuB New Layout]

%% Basisklasse: scrreprt

\LoadClass[10pt,smallheadings,twocolumn]{scrreprt}

\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}

\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{microtype}

%% Wir brauchen ein paar Zusatzangaben über die Akademie

\def\Akademie#1#2#3%  Steinmühle,2006,4
  {\def\thecourseprefix{#3.}%
   \def\theacademy{Akademie #1 #2-#3}}

\def\thecourse{$\langle$kein Kurs$\rangle$}

%% Kurse und Titel

\let\nl@newcoursehook\empty

\def\course%
  {\@ifstar\docoursestar\docourse}
\def\docourse#1#2%
  {\dodocourse{#1}{#2}{Kurs \thecourseprefix#1 -- #2}}
\def\docoursestar#1#2%
  {\dodocourse{#1}{#2}{#2}}
\def\dodocourse#1#2#3%
  {\gdef\thecourseno{#1}%
   \gdef\thecoursetitle{#2}%
   \gdef\thecourse{#3}%
   \stepcounter{chapter}% Das setzt die ganzen abhängigen Zähler zurück
   \setcounter{chapter}{\thecourseno}}

\def\coursetitle%
  {\setbox2=\vbox\bgroup\huge\bf\centering\hsize\textwidth}
\def\endcoursetitle%
  {\par\bigskip\egroup
   \clearpage
   \twocolumn[\unvbox2]%
   \addcontentsline{toc}{chapter}%
     {\protect\numberline{\thecourseno}\thecoursetitle}%
   \expandafter\markright\expandafter{\thecourse}%
   \thispagestyle{plain}%
   \nl@newcoursehook
   \dosettocdepth}

%% Seitenspiegel -- sehr eng, weil wenig Geld ...

\RequirePackage[dvips,pdftex]{geometry}
\geometry{a4paper,twoside}
\geometry{top=2.5cm,bottom=3cm}
\geometry{inner=3cm,outer=2cm}
\geometry{headheight=12pt,headsep=18pt,footskip=44pt}
\geometry{columnsep=0.75cm}

\usepackage{fancyhdr}
\pagestyle{fancy}

\fancyhead{}
\fancyhead[LE,RO]{\textsc{\rightmark}}
\fancyhead[RE,LO]{\textsc{\theacademy}}


\fancyfoot{}
\fancyfoot[LE,RO]{\thepage}

\fancypagestyle{plain}% für Titelseiten
  {\fancyhead{}\fancyfoot{}
   \fancyfoot[LE,RO]{\thepage}
   \renewcommand{\headrulewidth}{0pt}}

%% Brotschrift ist die TheSans

%\RequirePackage{thesans}

%% Mathefont: Euler

\RequirePackage{euler}

%% amsmath, damit wir align nutzen koennen

\RequirePackage{amsmath}

%% booktabs, url

\RequirePackage{booktabs}
\RequirePackage{url}

%% Hier wird's experimentell: Abbildungen

\RequirePackage{dsafigure}
\setcaptionprefix{\thecourseno.}

%% Überschriften oder was dafür durchgeht

\def\doifemptyelse#1%
  {\def\reserved@a{#1}\ifx\reserved@a\empty
     \expandafter\@firstoftwo
   \else
     \expandafter\@secondoftwo
   \fi}

\def\dosection[#1]%
  {\@tempskipb-\lastskip
   \@ifstar
     {\dosectiona[#1]\iffalse}
     {\dosectiona[#1]\iftrue}}
\def\dosectiona[#1]#2%
  {\let\if@hasnumber#2%
   \@ifnextchar[%
     {\dosectionc[#1]}
     {\dosectionb[#1]}}
\def\dosectionb[#1]#2%
  {\dosectionc[#1][#2]{#2}}
\def\dosectionc[#1][#2]#3%
  {\@ifnextchar\authors
    {\dosectiond[#1][#2]{#3}}
    {\dosectiond[#1][#2]{#3}\authors{}}}
\def\dosectiond[#1,#2,#3,#4,#5,#6][#7]#8\authors#9% type before after numstyle numwidth secstyle
  {\par
   \goodbreak
   \if@hasnumber
     \refstepcounter{#1}%
   \fi
   \advance\@tempskipb#2\baselineskip\relax
   \ifdim\@tempskipb>\z@
     \vskip\@tempskipb
   \fi
   \bgroup
     \raggedright\def\\{\hfil\break}%
     \interlinepenalty\@M 
     \setbox0=\hbox{\normalfont#4#5\unskip\enskip}%
     \setbox2=\hbox{\normalfont#4\@nameuse{the#1}\unskip}%
     \if@hasnumber\else
       \setbox2=\hbox\bgroup
         \color@begingroup\color{lightgray}%
         \vrule\@height 4pt\@depth-3pt\@width\wd2
         \color@endgroup
       \egroup
     \fi
     \setbox0=\hb@xt@\wd0{\unhbox2\hfil}%
     \noindent
       \hangindent\wd0
       \box0{\bf#6#8}%
       \doifemptyelse{#9}{}
         {\\\textit{#9}}%
     \par
     \if@hasnumber
       \addcontentsline{toc}{#1}%
         {\protect\numberline{\@nameuse{the#1}}#7}%
     \fi
   \egroup
   \nobreak\vskip#3\baselineskip
   \@afterindentfalse\@afterheading\ignorespaces}

\def\section%
  {\dosection[section,2,1,\large,99,\large]}
\def\subsection%
  {\dosection[subsection,1,1,,9.99,]}
\def\subsubsection%
  {\dosection[subsubsection,1,0,,9.9.99,]}

\def\thesection      {\arabic{section}}
\def\thesubsection   {\thesection.\arabic{subsection}}
\def\thesubsubsection{\thesubsection.\arabic{subsubsection}}

% Das hier ist noch mehr gehackt als der Rest \ldots

\def\paragraph#1%
  {\vskip\baselineskip
   \@noskipsectrue
   \def\@svsechd{\bf#1}\@xsect{-1em}}

%% Inhaltsverzeichnis

\def\settocdepth#1%
  {\gdef\nl@nextcoursetocdepth{#1}}
\def\dosettocdepth%
  {\immediate\write\@auxout%
    {\noexpand\@writefile{toc}%
       {\noexpand\setcounter{tocdepth}{\nl@nextcoursetocdepth}}}}
\edef\nl@nextcoursetocdepth
  {\the\c@tocdepth}

\def\tableofcontents%
  {\begingroup
     \onecolumn
     \thispagestyle{plain}%
     \markright{\contentsname}%
     \noindent{\LARGE\bf\contentsname}%
     \vskip0.5\baselineskip
     \let\sffamily\rmfamily %% Ok, ist geschummelt, aber ...
     \@starttoc{toc}%
     \twocolumn
   \endgroup}

% Das Standardlayout ist _fast_ schon richtig, nur müssen unbedingt
% alle Seitenzahlen mit Punkten eingeleitet werden ...

\usepackage{titletoc}
\dottedcontents{chapter}[1.5em]{\vskip1em\sectfont}{1.5em}{0.8em}

%% Hurenkinder verbieten, Registerhaltigkeit und Listen.

\widowpenalty=\@M
\parskip0pt

\def\@listi%
  {\leftmargin\leftmargini
  \topsep\z@ \partopsep\z@ \parsep\z@ \itemsep\z@}
\def\@listii%
  {\leftmargin\leftmarginii
  \topsep\z@ \partopsep\z@ \parsep\z@ \itemsep\z@}
\let\@listI\@listi

\def\labelitemi{--}
\def\labelitemii{--}

%% Formatierung der Fußnoten

\deffootnote{1.5em}{1.5em}
  {\textsuperscript{\normalfont\thefootnotemark\ }}

%% Extra-Kerning für Guillemets, d.h. Umschalten der Anführungszeichen von " auf ...

\DeclareTextCommand{\quotedblbase}{T1}{\guillemotright\kern.1ex}
\DeclareTextCommand{\grqq}{T1}{\kern.1ex\guillemotleft}

%% Absatzeinrückung

\parindent5mm

%% Bibliographie

% kein neues Kapitel, keine Überschrift
% Durchnummerieren innerhalb eines Kapitels

\newcounter{bibcounter}[chapter]

\def\thebibliography#1%
  {\list{\@biblabel{\@arabic\c@bibcounter}}%
     {\settowidth\labelwidth{\@biblabel{#1}}%
      \leftmargin\labelwidth
      \advance\leftmargin\labelsep
      \@nmbrlisttrue
      \def\@listctr{bibcounter}}%
   \sloppy\clubpenalty4000\widowpenalty4000%
   \sfcode`\.=\@m}
\def\endthebibliography%
  {\endlist}

%% Verschiedenes

% Special nodes wie die von \write haben die unangenehme
% Eigenschaft, \lastskip zu 0.0pt zu machen -- das ist besonders
% unangenehm bei Sequenzen wie
%
%     \section{...}
%     \label{...}         % hier ist ein \write drin
%
%     \subsection{...}
%
% Da beim zweiten Subsection der Abstand nicht richtig gesetzt
% wird. Daher patchen wir \label so, daß es \lastskip sichert.

\let\label@orig\label
\def\label#1%
  {\ifvmode
     \@tempskipa\lastskip
     \ifdim\lastskip=\z@\else
       \nobreak\vskip-\@tempskipa
     \fi
     \label@orig{#1}%
     \ifdim\@tempskipa=\z@\else
       \vskip\@tempskipa
     \fi
   \else
     \label@orig{#1}%
   \fi}

% Stretchable Glue arbeitet nicht gut mit dsafigure
% zusammen -- hier ist ein Workaround.

\abovedisplayskip\z@             \abovedisplayshortskip\z@
\belowdisplayskip\baselineskip   \belowdisplayshortskip\baselineskip

% Vordefinierte Mathematikumgebungen

\usepackage{theorem}

\begingroup
  \makeatletter
  \gdef\th@dsa%
    {\def\@begintheorem##1##2%
       {\item\textsc{##1\hbox{~}##2}\enskip}
     \def\@opargbegintheorem##1##2##3%
       {\item\textsc{##1\hbox{~}##2}\enskip \textit{(##3)}\enskip}}
\endgroup
\theoremstyle{dsa}

\newtheorem{hauptsatz}{Hauptsatz}
\newtheorem{satz}{Satz}
\newtheorem{hilfssatz}{Hilfssatz}
\newtheorem{theorem}{Theorem}
\newtheorem{lemma}{Lemma}

\newtheorem{folgerung}{Folgerung}
\newtheorem{proposition}{Proposition}
\newtheorem{bemerkung}{Bemerkung}
\newtheorem{beispiel}{Beispiel}
\newtheorem{definition}{Definition}

\def\beweis%
  {\noindent\textsc{Beweis}\enskip}
\def\endbeweis%
  {\hfill$\Box$\par}

\let\proof\beweis
\let\endproof\endbeweis
