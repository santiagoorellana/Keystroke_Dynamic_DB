object Form1: TForm1
  Left = 201
  Top = 117
  Width = 600
  Height = 300
  Caption = 'Vector de tiempos (Texto Libre)'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    592
    266)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 120
    Width = 574
    Height = 108
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Button1: TButton
    Left = 299
    Top = 234
    Width = 137
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Guardar como CSV'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 9
    Top = 234
    Width = 137
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Procedencia'
    TabOrder = 3
    OnClick = Button2Click
  end
  object KdMemo1: TKdMemo
    Left = 8
    Top = 8
    Width = 573
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    TabOrder = 0
    OnKeyDownTiming = KdMemo1KeyDownTiming
    OnKeyUpTiming = KdMemo1KeyUpTiming
    OnTimingVectorInit = KdMemo1TimingVectorInit
  end
  object Button3: TButton
    Left = 445
    Top = 234
    Width = 137
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Vector de tiempos'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 153
    Top = 234
    Width = 137
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Reiniciar'
    TabOrder = 5
    OnClick = Button4Click
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'Ficheros CSV|*.csv|Todos los ficheros|*.*'
    Left = 352
    Top = 192
  end
end
