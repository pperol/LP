\version "2.25.10"

%{
\markup\center-column { 
    \line { "" \caps "" }
    \vspace #-.4
    \small\italic\concat { " " (ca."\hspace #.1 " " \hspace #.3 "–" \hspace #.2 ")" }
    \vspace #.4
  }
%}

% Médiévale à Renaissance
Cabezon = \markup "Antonio de Cabezón (1510-1566)"
Cutting = \markup\concat { 
  "Francis Cutting (ca." 
  \hspace #.1 "1550-ca." 
  \hspace #.1 "1596)" 
}
DallAquila = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Marco" \caps "dall'Aquila" }
      \concat\small\italic { 
        " (ca." \hspace #.2 "1480" 
        \hspace #.2 "–" \hspace #.2 
        "1544)" 
      }
      \vspace #.4
    }
  }
Fuenllana = \markup "Miguel de Fuenllana (ca.1525-ca.1579)"
Galilei = \markup "Vincenzo Galilei (ca.1520-1591)"
Judenkonig = \markup "Hans Judenkönig (ca.1445-1526)"
LeRoy = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Adrian " \smallCaps "Le Roy" }
      \small\italic\concat { " (ca."\hspace #.1 "1520" \hspace #.3 "–" \hspace #.2 "1598)" }
    }
    \vspace #.4
  }
Morlaye = \markup "Guillaume de Morlaye (ca.1510-ca.1558)"
Milan = \markup "Luis de Milán (ca.1500-1562)"
Mudarra = \markup\center-column { 
    \line { "Alonso " \smallCaps "Mudarra" }
    \vspace #-.4
    \small\italic\concat { " (ca.1510" \hspace #.3 "–" \hspace #.2 "1580)" }
    \vspace #.4
  }
Narvaez = \markup "Luys de Narvæz (ca.1500-1555)"
Neusidler = \markup\center-column { 
    \line { "Hans " \smallCaps "Neusidler" }
    \vspace #-.4
    \small\italic\concat { " (ca.1508" \hspace #.3 "–" \hspace #.2 "1563)" }
    \vspace #.4
  }
Valderrabano = \markup
  \override #'(baseline-skip . 2.2) 
  \center-column {
    \concat { "Enríquez de V" \fontsize #-2 "ALDERRÁBANO" }
    \small\italic\concat { " (ca." \hspace #.2 "1500" \hspace #.2 "–" \hspace #.2 "après 1557)" }
    \vspace #.4
  }


% Renaissance à Baroque

AnonRowa = \markup "Anonyme, Le manuscrit “Rowallan” (ca.1609)"
Adriaenssen = \markup "Emanuel Adriænssen (1540/55-1604)"
Attaignant = \markup "d'après Pierre Attaignant (ca.1494-ca.1551)"
Bartolotti = \markup "Angelo Michele Bartolotti (ca.1615-ca.1681)"
Besard = \markup "Jean-Baptiste Besard (ca.1567-ca.1625)"
Buxtehude = \markup "Dietrich Buxtehude"
Calvi = \markup "Carlo Calvi"
Corbetta = \markup\right-column { 
  \line { "Francesco Corbetta" } 
  \vspace #-.2
  \line { "dit" \italic "Francisque Corbett" "(ca.1615-1681)" }
  \vspace #.4
}
Derosier = \markup "Nicolas Derosier (ca.1645-ca.1702)"
Dowland =  \markup {
    \override #'(baseline-skip . 2)
    \center-column {
      \line { "John" \caps "Dowland" }
      \concat\small\italic { " (1563" \hspace #.2 "–" \hspace #.2 "1626)" }
      \vspace #.4
    }
  }
Ford = \markup "Thomas Ford (1580-1648)"
Frescobaldi = \markup\center-column { 
    \line { "Girolamo " \smallCaps "Frescobaldi" }
    \vspace #-.4
    \small\italic\concat { " (1583" \hspace #.3 "–" \hspace #.2 "1644)" }
    \vspace #.4
  }
Galilei = \markup "Michelangelo Galilei (ca.1600-1631)"
Garsi = \markup "Santino Garsi da Parma (1542-1604)" 
Gaultier = \markup "Denis Gaultier (1603-1672)"
Holborne = \markup\center-column { 
    \line { "Anthony" \smallCaps "Holborne" }
    \vspace #-.4
    \small\italic\concat { " (1545" \hspace #.3 "–" \hspace #.2 "1602)" }
    \vspace #.4
  }
Johnson = \markup "Robert Johnson (1583-1633)"
Kapsberger = %\markup "Johann Hieronymus Kapsberger (1580-1651)"
\markup {
  \override #'(baseline-skip . 2.2)
  \center-column {
    \line { Johann Hieronymus \caps "Kapsberger" }
    \concat\fontsize #-1.5 \italic { " (1580" \hspace #.2 "–" \hspace #.2 "1651)"
    } \vspace #.4
  }
}   
Pachelbel = \markup "Johann Pachelbel (1653–1706)"
Pellegrini = \markup "Domenico Pellegrini (1617-ca.1682)"
Piccinini = \markup "Alessandro Piccinini (1566-1638)"
Praetorius = \markup "Michael Prætorius (1571-1621)"
Purcell =  \markup\center-column { 
    \line { "Henry" \caps "Purcell" }
    \vspace #-.4
    \small\italic\concat { " (1659" \hspace #.2 "–" \hspace #.2 "1695)" }
    \vspace #.4
  }
Robinson = \markup "Thomas Robinson (ca.1560-ca.1609)"
Sturt = \markup "John Sturt (avant 1610-après 1640)"
Vallet = \markup "Nicolas Vallet (ca.1583-ca.1642)"
Wemyss = \markup "Margaret Wemyss (ca.1610-après 1643)"
Wilson = \markup "John Wilson (1595-1694)"


% Baroque à Classique
Albinoni = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Tomaso" \caps "Albinoni" }
      \concat\small\italic { " (1671" \hspace #.2 "–" \hspace #.2 "1751)" }
      \vspace #.4
    }
  }
Bach = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Johann Sebastian" \caps "Bach" }
      \concat\small\italic { " (1685" \hspace #.2 "–" \hspace #.2 "1750)" }
      \vspace #.4
    }
  }
BachWF = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Wilhelm Friedemann" \caps "Bach" }
      \concat\small\italic { " (1710" \hspace #.2 "–" \hspace #.2 "1784)" }
      \vspace #.4
    }
  }  
Balcarres = \markup "d'après le Balcarres Lute Book (ca.1700)"
Baron = \markup "Ernst Gottlieb Baron (1696-1760)"
Bohrenfels = \markup "Johann Andreas Bohr von Bohrenfels (1663-1728)"
Borsilli = \markup "Giuseppe Borsilli (1672-1750)"
Brescianello = \markup "Guiseppe Antonio Brescianello (ca.1690-1758)"
Buxtehude = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Dietrich" \caps "Buxtehude" }
      \concat\small\italic { " (1637" \hspace #.2 "–" \hspace #.2 "1707)" }
      \vspace #.4
    }
  }
Calegari = \markup "Francesco Antonio Calegari (ca.1660-ca.1740)"
Campion = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "François " \smallCaps "Campion" }
      \small\italic\concat { " (1680" \hspace #.3 "–" \hspace #.2 "1748)" }
    }
    \vspace #.4
  }
Corrette = \markup "Michel Corrette (1709-1795)"
Couperin = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "François" \caps "Couperin" }
      \concat\small\italic { " (1668" \hspace #.2 "–" \hspace #.2 "1733)" }
      \vspace #.4
    }
  }
Dickhut = \markup \concat { "C." \hspace #.2 "Dickhut" }
Durant = \markup "Paul Charles Durant (1712-après 1769)"
Fischer = \markup "Johann Caspar Ferdinand Fischer (1656-1746)"
Fux = \markup "Johann Joseph Fux (1660-1741)"
Gebel = \markup "Georg Gebel (1709-1753)"
Ginter = \markup "Adam Franz Ginter (1661-1706)"
Bergen = \markup "Johann Ferdinand Wilhelm Graf von Bergen (1678-1766)"
Granata = \markup "Giovanni Battista Granata (ca.1620-1687)"
Guerau = \markup "Francisco Guerau (1649–ca.1722)"
Haendel = %\markup "Georg Friedrich Hændel (1685-1759)"
\markup
    \override #'(baseline-skip . 2.1)
    \center-column {
    \concat { "Georg Friedrich H" \fontsize #-2 "ÆNDEL" }
    \concat\italic\fontsize #-1 { "(1685" \hspace #.2 "–" \hspace #.3 "1759)" }
  }
Kellner = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "David" \caps "Kellner" }
      \concat\small\italic { " (1670" \hspace #.2 "–" \hspace #.2 "1748)" }
      \vspace #.4
    }
  }   
Krieger = \markup "Johann Krieger (1651-1735)"
Lobkowitz = \markup "Prince Philipp Hyacinth Lobkowitz (1680-1734)"
%{
Logy = \markup\right-column { 
  \line { "Jan Antonín Losy von Losinthal" } 
  \vspace #-.2
  \line { "dit" \italic "John Anton Logy" "(1650-1721)" }
  \vspace #.4
}
%}
Losy = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Jan Antonín \caps "Losy von Losinthal" }
      \line { "alias" \italic "Jan Anton Losy" "ou" \italic "John Anton Logy"  }
      \concat\small\italic { " (1650" \hspace #.2 "–" \hspace #.2 "1721)" }
      \vspace #.4
    }
  }
Logy = \markup\Losy  
Lully = \markup "Jean-Baptiste Lully (1632-1687)"
Meüsel = \markup "Gottfried Meüsel (1688-1727)"
Murcia =  \markup\center-column { 
    \line { "Santiago" \smallCaps "de Murcia" }
    \vspace #-.4
    \small\italic\concat { " (1682" \hspace #.3 "–" \hspace #.2 "ca." \hspace #.1 "1735)" }
    \vspace #.4
  }
Paradisi = 
\markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Pietro Domenico \caps "Paradisi" }
      %\line { "dit" \italic "Pier Domenico Paradies" }
      \concat\small\italic { " (1707" \hspace #.3 "–" \hspace #.3 "1791)" }
      \vspace #.4
    }
  }
Ribayaz = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Lucas Ruiz \caps "de Ribayaz y Fonseca" }
      \concat\fontsize #-1.5 \italic { 
        " (1626" \hspace #.3 "–" \hspace #.3 "après" \hspace #.1 "1677)"
      } \vspace #.4
    }
  }   
Roncalli = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Ludovico \caps "Roncalli" }
      \concat\fontsize #-1.5 \italic { 
        " (1654" \hspace #.3 "–" \hspace #.3 "1713)"
      } \vspace #.4
    }
  } 
Sanz = \markup {
  \override #'(baseline-skip . 2.2)
  \center-column {
    \line { Gaspar \caps "Sanz" }
    \concat\small \italic { 
      " (1640" \hspace #.3 "–" \hspace #.2 "1710)"
    } \vspace #.4
  }
} 
ScarlattiA = \markup "Alessandro Scarlatti (1660-1715)"
Scarlatti = \markup\center-column { 
    \line { "Domenico " \smallCaps "Scarlatti" }
    \vspace #-.4
    \small\italic\concat { " (1685" \hspace #.3 "–" \hspace #.2 "1757)" }
    \vspace #.4
  }
Telemann = \markup "Georg Philipp Telemann (1681-1767)"
Visee = \markup "Robert de Visée (ca.1650-1725)"
Vivaldi = \markup\center-column { 
    \line { "Antonio " \smallCaps "Vivaldi" }
    \vspace #-.4
    \small\italic\concat { " (1668" \hspace #.3 "–" \hspace #.2 "1741)" }
    \vspace #.4
  }
Weichenberger = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Johann Georg" \caps "Weichenberger" }
      \concat\small\italic { " (1676" \hspace #.2 "–" \hspace #.2 "1740)" }
      \vspace #.4
    }
  }
Weiss = 
\markup {
  \override #'(baseline-skip . 2.2)
  \center-column {
    \line { Silvius Leopold \caps "Weiss" }
    \concat\fontsize #-1.5 \italic { " (1687" \hspace #.2 "–" \hspace #.2 "1750)"
    } \vspace #.4
  }
}  
Zamboni = \markup "Giovanni Zamboni (1674-1718)"

% Classique à Romantique
Aguado = %\markup "Dionisio Aguado (1784-1849)"
\markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Dionisio \caps "Aguado" }
      \concat\small\italic { " (1787" \hspace #.2 "–" \hspace #.2 "1849)" }
      \vspace #.4
    }
  }
Albrechtsberger = \markup {
  \override #'(baseline-skip . 2.2)
  \center-column {
    \line { Johann Georg \caps "Albrechtsberger" }
    \concat\small \italic { 
      " (1736" \hspace #.3 "–" \hspace #.2 "1809)"
    } \vspace #.4
  }
}   
Alexandrov = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Nikolaï" \caps "Alexandrov" }
      \line { "(Николай Иванович Александров)" }
      \concat\fontsize #-1.5 \italic { 
        " (1818" \hspace #.2 "–" \hspace #.2 "1884)"
      } \vspace #.4
    }
  }   
Bathioli = \markup "Francesco Bathioli (ca.1800-1830)"
%% => http://data.bnf.fr/fr/15089000/jean-baptiste_bedard/
Bedard = \markup
    \override #'(baseline-skip . 2.2)
    \center-column {
    \concat { "Jean-Baptiste " \caps "Bedard" }
    \concat\italic\fontsize #-1 { "(1765" \hspace #.2 "–" \hspace #.3 "ca."  \hspace #.1  "1815)" }
  }
Beethoven = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Ludwig" \caps "van Beethoven" }
      \concat\small\italic { " (1770" \hspace #.2 "–" \hspace #.2 "1827)" }
      \vspace #.4
    }
  }
Berbiguier = \markup "Antoine Benoit Tranquille Berbiguier (1782-1835)"
Blum = \markup "Karl Ludwig Blum (1786-1844)"
Boccherini = \markup "Luigi Boccherini (1743-1805)"
Bornhardt = \markup "Johann Heinrich Carl Bornhardt (1774-1843)"
Call = \markup "Leonhard von Call (1767-1815)"
Carcassi = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Matteo \caps "Carcassi" }
      \concat\small\italic { " (1792" \hspace #.2 "–" \hspace #.2 "1853)" }
    }
    \vspace #.4
  }
Carulli =  \markup
  \override #'(baseline-skip . 2.2)
  \center-column { 
    \line { "Ferdinando " \smallCaps "Carulli" }
    \small\italic\concat { " (1770" \hspace #.3 "–" \hspace #.2 "1841)" }
    \vspace #.4
  }
CastroS = \markup "Salvador Castro de Gistau (1770-ca.1832)"
Cimarosa = \markup
  \override #'(baseline-skip . 2.2)
  \center-column { 
    \line { "Domenico" \caps "Cimarosa" }
    \small\italic\concat { " (1749" \hspace #.3 "–" \hspace #.2 "1801)" }
    \vspace #.4
  }
Corbett = \markup "William Corbett (1680-1748)"
CostaO = \markup "Onorato Costa"
Diabelli =  \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Anton" \caps "Diabelli" }
      \concat\fontsize #-1.5 \italic { 
        " (1781" \hspace #.2 "–" \hspace #.2 "1878)"
      } \vspace #.4
    }
  } 
Duvernoy = 
\markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Jean-Baptiste \caps "Duvernoy" }
      \concat\small\italic { " (1801" \hspace #.2 "–" \hspace #.2 "1880)" }
    }
  }
Dotzauer = \markup "Friedrich Dotzauer (1783-1860)"
Ferandiere = \markup "Fernando Ferandiere (ca.1740-ca.1816)"
FurstenauA = \markup "Anton Bernhard Furstenau"
Furstenau = \markup "Kaspar Furstenau (1772-1819)"
Gaude = \markup "Theodor Gaude (1782-1835)"
Giuliani = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Mauro" \caps "Giuliani" }
      \small\italic\concat { " (1781" \hspace #.3 "–" \hspace #.2 "1829)" }
      \vspace #.4
    }
  }
Guichard = \markup "Abbé François Guichard (1745-1807)"
Hallager = \markup "Andreas Hallager (1796–1853)"
Hummel = \markup "Johann Nepomuk Hummel (1778-1837)"
Haydn = \markup\right-column { 
  \line { "Franz Joseph Haydn" } 
  \vspace #-.2
  \line { "dit" \italic "Joseph Haydn" "(1732-1809)" }
  \vspace #.4
}
Kreutzer = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Rodolphe \caps "Kreutzer" }
      \concat\small\italic { " (1766" \hspace #.2 "–" \hspace #.2 "1831)" }
    }
    \vspace #.4
  }
Kueffner = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Joseph \caps "Küffner" }
      \concat\small\italic { " (1776" \hspace #.2 "–" \hspace #.2 "1856)" }
      \vspace #.4
    }
  }
Matiegka = \markup "Wenzel Thomas Matiegka (1773-1830)"
Meissonnier = \markup "Jean Antoine Meissonnier (1783-1857)"
Mertz = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Johann Kaspar \caps "Mertz" }
      \concat\small\italic { " (1806" \hspace #.2 "–" \hspace #.2 "1856)" }
      \vspace #.4
    }
  }
Molino = \markup "Francesco Molino (1768-1847)"
Moretti = \markup "Federico Moretti (1765-1838)"
Mozart = \markup "Wolfgang Amadeus Mozart (1756-1791)"
Nagel = \markup "Johan Jakob Nagel (1807-1885)"
Nava = \markup "Antonio Maria Nava (1755-1826)"
Paganini = \markup "Niccolò Paganini (1782-1840)"
Pollet = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Charles " \caps "Pollet" }
      \concat\small\italic { " (1748" \hspace #.3 "–" \hspace #.2 "1824)" }
      \vspace #.4
    }
  }
Porro = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Pierre-Jean" \smallCaps "Porro" }
      \small\italic\concat { " (1750" \hspace #.3 "–" \hspace #.2 "1831)" }
      \vspace #.4
    }
  }
Praeger = \markup "Heinrich Aloys Præger (1783-1854)"
Ries = \markup "Ferdinand von Ries (1784-1838)"
Romberg = \markup "Bernhard Romberg (1767-1841)"
Schaky = \markup { "Maximilian von Schack dit" \italic "Baron de Schaky" }
Schubert = \markup {
  \override #'(baseline-skip . 2.2)
  \center-column {
    \line { Franz \caps "Schubert" }
    \concat\small \italic { 
      " (1797" \hspace #.3 "–" \hspace #.2 "1828)"
    } \vspace #.4
  }
} 
Seegner = \markup "Franz Gregor Seegner (ca.1780-ca.1810)"
Sor = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Fernando" \caps "Sor" }
      \concat\fontsize #-1.5 \italic { 
        " (1778" \hspace #.2 "–" \hspace #.2 "1839)"
      } \vspace #.4
    }
  } 
Sychra = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Andreï" \caps "Sychra" }
      \line { "(Андрей Осипович Сихра)" }
      \concat\fontsize #-1.5 \italic { 
        " (1773" \hspace #.2 "–" \hspace #.2 "1850)"
      } \vspace #.4
    }
  } 
Steinfels = \markup "Adolphe Steinfels"
Urcullu = \markup "Leopoldo de Urcullu (ca.1800-ca.1830)"
Vidal = \markup "B. Vidal (ca.1750-ca.1800)"
Vysotsky = \markup "Mikhaïl Kalachnikov Vysotsky (ca.1791-1837)"
Weber = \markup "Carl Maria von Weber (1786-1826)"
WeberG = \markup "Gottfried Weber (1779-1839)"
Wenkel = \markup "Johann Friedrich Wilhelm Wenkel (1734-1803)"

%{
% Romantique à Moderne
    Albéniz, Isaac Manuel Francisco (1860-1909)
    Aleksandrov
    Arditi, Luigi (1822-1903)
    Arnold, Friedrich Wilhelm (1810-1864)
    Arcas, Julian (1832-1882)
    
%}
Bayer = \markup "Eduard Bayer (1822-1908)"
Bobrow = \markup\right-column { 
  \line { "Jan Nepomucen Bobrowicz " } 
  \vspace #-.2
  \line { "dit" \italic "Jan Bobrowitz" "(1805-1881)" }
  \vspace #.4
}
%{
    Bodstein, F. A.
%}
Bosch = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Jacques \caps "Bosch" }
      % Bosch, Jaime Felipe José 
      \concat\small\italic { " (1825" \hspace #.2 "–" \hspace #.2 "1895)" }
      \vspace #.4
    }
  }

Brahms = 
\markup {
    \override #'(baseline-skip . 2)
    \center-column {
      \line { Johannes \caps "Brahms" }
      \concat\small\italic { " (1833" \hspace #.2 "–" \hspace #.2 "1897)" }
    }
  }    
%{
    Brocá, José (1805-1882)
%}
Burgmuller = 
\markup {
    \override #'(baseline-skip . 2)
    \center-column {
      \line { Friedrich \concat { \caps "Burgm" \tiny "Ü" \caps "ller" } }
      \concat\small\italic { " (1806" \hspace #.2 "–" \hspace #.2 "1874)" }
    }
  }     
%{
    Campo Castro, José (ca.1845-ca.1900)
    Cannas, C
    Cano, Federico (1838-1904)
%}
Cano =
\markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Antonio \caps "Cano Curiella" }
      \concat\small\italic { " (1811" \hspace #.2 "–" \hspace #.2 "1897)" }
      \vspace #.4
    }
  }
Chilesotti = \markup\center-column { 
    \line { "Arr. Oscar " \smallCaps "Chilesotti" }
    \vspace #-.4
    \small\italic\concat { " (1848" \hspace #.3 "–" \hspace #.2 "1916)" }
    \vspace #.4
  }
Chopin = \markup\center-column { 
    \line { "Frédéric " \smallCaps "Chopin" }
    \vspace #-.4
    \small\italic\concat { " (1810" \hspace #.3 "–" \hspace #.2 "1849)" }
    \vspace #.4
  }

%{
    Cimadevilla, Francisco (1861-1931)
%}
Coste = \markup\center-column { 
      \line {  "Napoléon" \smallCaps "Coste" }
      \vspace #-.4
      \small\italic\concat { " (1805" \hspace #.3 "–" \hspace #.2 "1883)" }
      \vspace #.4
    }
Cottin = \markup\center-column { 
    \line { "Alfred" \smallCaps "Cottin" }
    \vspace #-.4
    \small\italic\concat { " (1863" \hspace #.3 "–" \hspace #.2 "1923)" }
    \vspace #.4
  }
%{
    Damas, Thomas (1825–1890)
    Degen, Søffren (1816-1885)
    Domenico Navone, Giovanni di (1839-1907)
    Dorn, Charles James (1839-1909)
%}
Dubez = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Johann" \caps "Dubez" }
      \concat\small\italic { " (1828" \hspace #.2 "–" \hspace #.2 "1891)" }
      \vspace #.4
    }
  }
Ernst = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Philip \caps "Ernst" }
      \concat\small\italic { " (1792" \hspace #.2 "–" \hspace #.2 "1868)" }
      \vspace #.4
    }
  }
Ferranti = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Marco Aurelio \caps "Zani de Ferranti" }
      \concat\small\italic { " (1800" \hspace #.2 "–" \hspace #.2 "1878)" }
      \vspace #.4
    }
  }
FerrerY = \markup { 
  \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Josep" \caps "Ferrer i Esteve de Pujadas" } 
      \line\small { "dit" 
                    \italic { "José" 
                    \concat { "F" \fontsize #-2 "ERRER" " (1835" 
                              \hspace #.2 "–" \hspace #.2 "1916)" } } }
      \vspace #.4
    }
  }
Ferrer = \markup { 
  \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "José" \caps "Ferrer"}
      \concat\small\italic { " (1835" \hspace #.2 "–" \hspace #.2 "1916)" }
      \vspace #.4
    }
  }
Foster = \markup\right-column { 
  \line { "Stephen Collins Foster" } 
  \vspace #-.2
  \line { "dit" \italic "Stephen Foster" "(1826-1864)" }
  \vspace #.4
}
    %{
    Fischer, Heinrich
    Gade, Niels W.(1817-1890)
    Garcia Fortea, Severino (ca.1850-1931)
    Grisar, Albert (1808-1869)
    Hayden, Warren Luse (1835-1918)
    Hübner, I. G. H.
    Jacobs, Walter (ca.1860-ca.1930)
    Janon, Charles de (1834-1911)
    Kummer, Kaspar (1795-1870)
    Leduc, Alphonse (1804–1868)
    Lindblad, Otto (1809-1864)
    Liszt, Franz (1811-1886)
    Llobet, Miguel (1878-1938)
    Lom, Jean Charles
    Magnien, Victor (1804-1885)
    Makarov, Nikolay Petrovich (1810-1890) & http://classicguitare.com/viewtopic.php?f=37&t=8251
    Manjón, Antonio Jimenez (1866-1919)
    Marschner, Heinrich August (1795-1861)
    Martínez, Antonio (1860-1912)
    Massenet, Jules (1842-1912)
    Mehlhart, Anton
    Mendelssohn-Bartholdy, Felix (1809-1847)
%}
MeissonnierA = \markup "Jean-Antoine Meissonnier (1783-1857)"
Mertz = \markup {
  \override #'(baseline-skip . 2.2)
  \center-column { 
    \line { "Johann Kaspar" \smallCaps "Mertz" }
    \small\italic\concat { " (1806" \hspace #.3 "–" \hspace #.2 "1856)" }
    \vspace #.4
  }
}
%{
    Meyerbeer, Giacomo (1791-1864)
    Neuland, Wilhelm (1806-1889)
    Padowetz, Johann (1800-1873)
    Pastou, Baptiste (1784-1851)
    Petersen, Albert
    Pettoletti, Joachim (ca.1795-ca.1870)
    Pettoletti, Pietro (1800-ca.1870)
    Porro, Pierre-Jean (1750–1831)
    Pratten, Catharina Josepha (1821-1895)
    Raab, Josef (ca.1810-après 1884)
%}
Regondi = \markup {
  \override #'(baseline-skip . 2.2)
  \center-column { 
    \line { "Giulio" \smallCaps "Regondi" }
    \small\italic\concat { " (1822" \hspace #.3 "–" \hspace #.2 "1872)" }
    \vspace #.4
  }
}

Rossini = \markup {
  \override #'(baseline-skip . 2.2)
  \center-column { 
    \line { "Gioachino" \smallCaps "Rossini" }
    \small\italic\concat { " (1792" \hspace #.3 "–" \hspace #.2 "1868)" }
    \vspace #.4
  }
}

%{
    Regondi, Giulio (1822-1872)
    Rinaldi, Giovanni (1840-1895)

    Rossini, Gioachino (1792-1868)
    Ruet, Jaime
    Rung, Henrik (1807-1871)
    Sagreras, Gaspar (1838-1901)
    Sarenko, Vassili Stepanovitch (1814-1881)
    Scherrer, Heinrich
    Schick, Otto (1850-1928)
    Scholander, Sven (1860-1936)
%}
Schulz = \markup\center-column { 
    \line { "Leonard" \caps "Schulz" }
    \vspace #-.4
    \small\italic\concat { " (1814" \hspace #.2 "–" \hspace #.2 "1860)" }
    \vspace #.4
  }
Schumann = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Robert" \caps "Schumann" }
      \concat\small\italic { " (1810" \hspace #.2 "–" \hspace #.2 "1856)" }
      \vspace #.4
    }
  }
%{
    Schuster, Vincenz
    Simeone, Paolo (1869-1910)
    Soria, Luis de (1851-1935)
    Stockmann, J.
    Stoll, Fr.
    Strauss, Johann (1804-1849)
    Svintsov, Vasilij Ivanovitch (ca.1800)
%}
Tarrega = \markup\center-column { 
    \line { "Francisco" 
            \concat { 
              \fontsize #0 "T" 
              \fontsize #-2 "ÁRREGA" 
            } 
          }
    \vspace #-.4
    \small\italic\concat { " (1852" \hspace #.2 "–" \hspace #.2 "1909)" }
    \vspace #.4
  }
Tchaikovsky = \markup\center-column { 
    \line { "Piotr Ilitch"
            \concat { 
              \fontsize #0 "T" 
              \fontsize #-2 "CHAÏKOVSKY"
            } 
          }
    \vspace #-.4 "(Пётръ Ильичъ Чайковскій)" \vspace #-.4
    \small\italic\concat { " (1840" \hspace #.2 "–" \hspace #.2 "1893)" }
    \vspace #.4
  }  
%{
    Thalberg, Sigismund (1812-1871)
    Tonassi, Pietro (ca.1800-1877)
    Viñas y Diaz, José (1823-1888)
    Wagner, Richard (1813-1883)
    Wepf, Johannes (1810-1890)


% Moderne à Contemporaine

    Alba, Antonio (1873-1940)
    Albert, Heinrich (1870-1950)
    Aperte, Pedro (1890-1914)
%}

Abreu = \markup
    \override #'(baseline-skip . 2.2)
    \center-column { 
    \line { "Zequinha" \caps "de Abreu" }
    \concat\small\italic { " (1880" \hspace #.2 "–" \hspace #.2 "1935)" }
    \vspace #.4
  }
Barrios = \markup
    \override #'(baseline-skip . 2.2)
    \center-column {  
    \line { "Agustín" \concat\smallCaps { "Barrios Mangor" \fontsize #-2 "É" } }
    \small\italic\concat { " (1885" \hspace #.3 "–" \hspace #.2 "1944)" }
    \vspace #.4
  }
Bonis = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Mel" \caps "Bonis" }
      \concat\small\italic { " (1858" \hspace #.2 "–" \hspace #.2 "1937)" }
      \vspace #.4
    }
  }  
%{
    Bischoff, Heinz (1898-1963)
    Can, Esim (1969)
    Faraill, Marius Michel François (1872-1958)
    Jacobi, Joseph (1891-1952)
%}
Joplin = \markup "Scott Joplin (1868-1917)"
%{    
    Malats, Joaquim (1872-1912)
    Merikanto, Oskar (1868-1924)
    Moreno Torroba, Federico (1891-1982)
    Mozzani, Luigi (1869-1943)
    Nazareth, Ernesto (1863-1934)
%}

Katchaturian = 
  \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Aram" \smallCaps "Khatchatourian" }
      \small\italic\concat { "  (1903" \hspace #.3 "–" \hspace #.2 "1978) " }
    }
    \vspace #.4
  }    
Piazzolla = 
  \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Astor" \smallCaps "Piazzolla" }
      \small\italic\concat { " (1921" \hspace #.3 "–" \hspace #.2 "1992)" }
    }
    \vspace #.4
  }     
Ponce = \markup {
  \override #'(baseline-skip . 2.2)
  \center-column {
    \line { Manuel María \caps "Ponce" }
    \concat\small\italic { " (1882" \hspace #.2 "–" \hspace #.2 "1948)" }
    \vspace #.4
  }
}    
    %{
    Pernambuco, Joao (Teixeira Guimaraes) (1883-1947)
    Rachmaninov, Sergueï Vassilievitch (1873-1943)
%}
Popper = 
\markup {
  \override #'(baseline-skip . 2.2)
  \center-column {
    \line { David  \caps "Popper" }
    \concat\fontsize #-1.5 \italic { " (1843" \hspace #.2 "–" \hspace #.2 "1913)"
    } \vspace #.4
  }
}  

Roch = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Pascual \caps "Roch" }
      \concat\small\italic { " (1864" \hspace #.2 "–" \hspace #.2 "1921)" }
      \vspace #.4
    }
  }
Sagreras = %\markup "Julio Salvador Sagreras (1879-1942)"
  \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Julio Salvador" \smallCaps "Sagreras" }
      \small\italic\concat { " (1879" \hspace #.3 "–" \hspace #.2 "1942)" }
    }
    \vspace #.4
  }   
  
SagrerasShort = 
  \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Julio S." \smallCaps "Sagreras" }
      \small\italic\concat { " (1879" \hspace #.3 "–" \hspace #.2 "1942)" }
    }
    \vspace #.4
  }     
Satie = 
\markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Erik \caps "Satie" }
      \concat\small\italic { " (1866" \hspace #.2 "–" \hspace #.2 "1925)" }
    }
  }
Sibelius = \markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { "Jean" \caps "Sibelius" }
      \concat\small\italic { " (1865" \hspace #.2 "–" \hspace #.2 "1957)" }
      \vspace #.4
    }
  }  
    %{
    Schwarz-Reiflingen, Erwin (1891-1964)
    Segovia, Andrés Torres (1893-1987)
    Tessarech, Jacques (1862-1940)
    Turína, Joaquin (1882-1949)


% Contemporaine

    Arbiol, Serge (1953)
    Castelnuovo-Tedesco, Mario (1895-1968)
    Coumou, Dingeman
    Gerasimos, Pylarinos (1949)
%}
Villa-Lobos = \markup {
  \override #'(baseline-skip . 2.2)
  \center-column {
    \line { Heitor \caps "Villa-Lobos" }
    \concat\small\italic { " (1887" \hspace #.2 "–" \hspace #.2 "1959)" }
    \vspace #.4
  }
}    

Baden = 
\markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      \line { Baden Powell \caps "de Aquino" }
      \concat { \italic "alias" \hspace #.7 "Baden Powell" }
      \concat\small\italic { " (1937" \hspace #.2 "–" \hspace #.2 "2000)" }
      \vspace #.4
    }
  } 
  
Casseus =
\markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      %\concat { "Frantz " \caps "Cass" \fontsize #-2 "É" \caps "us" }
      \concat { 
        "Frantz C" 
        \fontsize #2 
        \override #'(font-features . ("smcp")) 
        \scale #'(.9 . 1)
        "asséus" 
      }
      \concat\small\italic { " (1915" \hspace #.2 "–" \hspace #.2 "1993)" }
    }
  }

Holst =
\markup {
    \override #'(baseline-skip . 2.2)
    \center-column {
      %\concat { "Gustav " \caps "Holst" }
      \concat { 
        "Gustav H" 
        \fontsize #2 
        \override #'(font-features . ("smcp")) 
        \scale #'(.9 . 1)
        "olst" 
      }
      \concat\small\italic { " (1874" \hspace #.2 "–" \hspace #.2 "1934)" }
    }
  }
  
Lauro = \markup "Antonio Lauro (1917-1986)"
Lopes = \markup "Edson Lopes"
    %{
    Lucía, Paco de (1947)
    Magli, Daniele
    %}
Poulenc = 
\markup {
    \override #'(baseline-skip . 2)
    \center-column {
      \line { Francis \caps "Poulenc" }
      \concat\small\italic { " (1899" \hspace #.2 "–" \hspace #.2 "1963)" }
      \vspace #.4
    }
  }    
Presti= 
\markup {
    \override #'(baseline-skip . 1.9)
    \center-column {
      \line { Ida \caps "Presti" }
      \concat\fontsize #-1.5 \italic { " (1924" \hspace #.2 "–" \hspace #.2 "1967)"
      } \vspace #.4
    }
  }    
    %{
    Pujol, Emilio (1886-1980)
    Pujol, Máximo Diego (1957)
    Reis, Dilermando Reis (1916-1977)
    Sainz de la Maza, Regino (1896-1981)
    Semenzato, Jane Domingos (1908-1993)
    Tansman, Alexandre (1897-1986)
    Terzi, Benvenuto (1892-1980)
%}
Shand = 
\markup {
    \override #'(baseline-skip . 1.2)
    \center-column {
      \line { Ernest \caps "Shand" }
      \concat\fontsize #-1.5 \italic { " (1868" \hspace #.2 "–" \hspace #.2 "1924)"
      } \vspace #.4
    }
  } 
  
%% Jazz
Monk = 
\markup {
  \override #'(baseline-skip . 2.2)
  \center-column {
    \line { Thelonious \caps "Monk" }
    \concat\fontsize #-1.5 \italic { " (1917" \hspace #.2 "–" \hspace #.2 "1982)"
    } \vspace #.4
  }
}  

Strayhorn = 
\markup {
  \override #'(baseline-skip . 2.2)
  \center-column {
    \line { Billy \caps "Strayhorn" }
    \concat\fontsize #-1.5 \italic { " (1915" \hspace #.2 "–" \hspace #.2 "1967)"
    } \vspace #.4
  }
}  


%{
convert-ly (GNU LilyPond) 2.25.10  convert-ly: Processing `'...
Applying conversion: 2.19.11, 2.19.16, 2.19.22, 2.19.24, 2.19.28,
2.19.29, 2.19.32, 2.19.39, 2.19.40, 2.19.46, 2.19.49, 2.20.0, 2.21.0,
2.21.2, 2.22.0, 2.23.1, 2.23.2, 2.23.3, 2.23.4, 2.23.5, 2.23.6,
2.23.7, 2.23.8, 2.23.9, 2.23.10, 2.23.11, 2.23.12, 2.23.13, 2.23.14,
2.24.0, 2.25.0, 2.25.1, 2.25.3, 2.25.4, 2.25.5, 2.25.6, 2.25.8, 2.25.9
%}
