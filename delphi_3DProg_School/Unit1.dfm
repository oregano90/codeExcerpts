object Form1: TForm1
  Left = -11
  Top = 6
  Width = 1155
  Height = 838
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = '3D'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 296
    Top = 336
    Width = 245
    Height = 137
    OnMouseDown = PaintBox1MouseDown
    OnMouseMove = PaintBox1MouseMove
    OnMouseUp = PaintBox1MouseUp
  end
  object Label1: TLabel
    Left = 960
    Top = 0
    Width = 142
    Height = 13
    Caption = 'Skalierung in Pixel pro Einheit:'
  end
  object Label2: TLabel
    Left = 1035
    Top = 16
    Width = 3
    Height = 13
    Caption = ':'
  end
  object Label3: TLabel
    Left = 976
    Top = 736
    Width = 32
    Height = 13
    Caption = 'Label3'
  end
  object Label4: TLabel
    Left = 1032
    Top = 736
    Width = 32
    Height = 13
    Caption = 'Label4'
  end
  object Label5: TLabel
    Left = 1017
    Top = 504
    Width = 3
    Height = 13
    Caption = 'I'
  end
  object GroupBox1: TGroupBox
    Left = 968
    Top = 85
    Width = 161
    Height = 180
    Caption = 'Rotation'
    DragKind = dkDock
    TabOrder = 5
    object RadioGroup1: TRadioGroup
      Left = 8
      Top = 16
      Width = 145
      Height = 65
      Caption = 'Rotation'
      ItemIndex = 0
      Items.Strings = (
        'um Koordinatenachsen'
        'um K'#246'rpermittelpunkt')
      TabOrder = 0
    end
    object RadioGroup2: TRadioGroup
      Left = 8
      Top = 80
      Width = 145
      Height = 92
      Caption = 'Rotation um Parallele zur'
      Items.Strings = (
        'y-Achse'
        'z-Achse'
        'x-Achse'
        'y- und z-Achse')
      TabOrder = 1
    end
  end
  object Button1: TButton
    Left = 960
    Top = 40
    Width = 66
    Height = 25
    Caption = 'Zeichnen'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 984
    Top = 16
    Width = 41
    Height = 21
    TabOrder = 1
    Text = '1000'
  end
  object Edit2: TEdit
    Left = 1056
    Top = 16
    Width = 33
    Height = 21
    TabOrder = 2
    Text = '1'
  end
  object Button2: TButton
    Left = 1016
    Top = 40
    Width = 67
    Height = 25
    Caption = 'Rotieren'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 1085
    Top = 40
    Width = 67
    Height = 25
    Caption = 'Ausgang'
    TabOrder = 4
    OnClick = Button3Click
  end
  object MainMenu1: TMainMenu
    Left = 344
    Top = 120
    object vkbdfv1: TMenuItem
      Caption = 'Optionen'
      OnClick = vkbdfv1Click
    end
    object Hilfe1: TMenuItem
      Caption = 'Hilfe'
      OnClick = Hilfe1Click
    end
  end
end
