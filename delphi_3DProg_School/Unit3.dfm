object Form3: TForm3
  Left = 268
  Top = 165
  Width = 619
  Height = 421
  Caption = 'Hilfe'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 593
    Height = 505
    Lines.Strings = (
      'Hilfe'
      '-------'
      ''
      
        'Bei diesem Programm geht es darum, mathematische K'#246'rper dreidime' +
        'nsional darzustellen, sie drehen, verschieben und '
      
        'vergr'#246#223'ern zu k'#246'nnen. Es ist nur maximal ein K'#246'rper auf der Zeic' +
        'henfl'#228'che m'#246'glich. Derzeit gibt es nur zwei darstellbare '
      
        'K'#246'rper: einen Qauder und eine Pyramide mit gleichseitig vielecki' +
        'ger Grundfl'#228'che.'
      ''
      
        'Im Hauptfenster sieht man auf der rechten Seite, welche Art der ' +
        'Rotation ausgew'#228'hlt wurde. Es kann entweder um den '
      
        'Schwerpunkt oder um die Koordinatenachsen rotiert werden. Des We' +
        'iteren kann darunter bestimmt werden, zu welcher '
      'Achse parallel rotiert werden soll.'
      
        'Durch das Verh'#228'ltnis Pixel/ Elementareinheit (rechts oben) kann ' +
        'man die St'#228'rke der Vergr'#246#223'erung bestimmen.'
      
        'Wenn man in eines der beiden oberen Editfelder klickt, kann man ' +
        'mit Hilfe der Pfeiltasten und "Bild auf" und "Bild ab" den '
      'dargestellten K'#246'rper verschieben.'
      ''
      
        'Unter "Optionen" findet man eine Unterteilung in allgemeine und ' +
        'k'#246'rperspezifische Programmkonfigurationen. Die '
      
        'k'#246'rperspezifischen Einstellung beinhalten die Positionierung und' +
        ' Gr'#246#223'e des K'#246'rpers. Weiterhin k'#246'nnnen die Eckpunkte des '
      
        'K'#246'rpers ausgerechnet werden. Auch die Farben der K'#246'rperfl'#228'chen k' +
        #246'nnen bestimmt werden. Bei der Pyramide wird die '
      
        'Farbe der Mantelfl'#228'che in Rot-, Gelb- und Blauwerten (0..255) da' +
        'rgestellt, wobei beliebig viele Variablen mit "v" '
      
        'gekennzeichnet werden k'#246'nnen. Das bedeutet dann, dass der gekenn' +
        'zeichnete Farbanteil f'#252'r die unterschiedlichen '
      
        'Fl'#228'chen mit Werten von 0..255 belegt wird (Farbanteil steigt lin' +
        'ear an). Die Option "harte Farbverl'#228'ufe" ist f'#252'r K'#246'rper mit '
      
        'weniger Ecken besser geeignet, da sie jede Farbe nur einmal verg' +
        'ibt und gleiche Fraben nicht nebeneinander sein k'#246'nnen. '
      
        'Im Gegensatz dazu steht die andere Auswahlm'#246'glichkeit "weiche Fa' +
        'rbverl'#228'ufe"; sie ist eher bei Pyramiden mit vielen Ecken '
      
        'sinnvoll, denn hier treten Farben doppelt auf und k'#246'nnen auch di' +
        'rekt nebeneinander liegen, was bei K'#246'rpern mit weniger als '
      '15 Grundfl'#228'chenecken etwas unpraktisch ist.'
      
        'Bei den allgemeinen Einstellungen kann festgelegt werden, ob die' +
        ' Fl'#228'chen des K'#246'rpers gef'#228'rbt werden sollen und ob die '
      
        '(eigentlich nicht sichtbaren) gestrichelten Linien angezeigt wer' +
        'den sollen, die Nichtaktivierung kann erheblich Rechenzeit '
      
        'sparen (besonders die Fl'#228'chenf'#228'rbung). Man kann auch einstellen,' +
        ' wie stark die Verschiebung durch den Tastaturdruck sein '
      'soll.')
    TabOrder = 0
  end
end
