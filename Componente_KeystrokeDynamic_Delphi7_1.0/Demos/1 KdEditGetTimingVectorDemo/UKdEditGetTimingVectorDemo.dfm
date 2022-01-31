object Form1: TForm1
  Left = 202
  Top = 116
  Width = 313
  Height = 300
  Caption = 'Obtener vector de tiempos'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 313
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    305
    266)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 37
    Width = 287
    Height = 191
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object KdEditAlphaNumeric1: TKdEditAlphaNumeric
    Left = 8
    Top = 8
    Width = 287
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnKeyDownTiming = KdEditAlphaNumeric1KeyDownTiming
    OnKeyUpTiming = KdEditAlphaNumeric1KeyUpTiming
    OnPressEnterKey = KdEditAlphaNumeric1PressEnterKey
    OnTimingVectorInit = KdEditAlphaNumeric1TimingVectorInit
  end
  object Button1: TButton
    Left = 157
    Top = 234
    Width = 137
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Guardar como CSV'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 11
    Top = 234
    Width = 137
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Procedencia'
    TabOrder = 3
    OnClick = Button2Click
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'Ficheros CSV|*.csv|Todos los ficheros|*.*'
    Left = 192
    Top = 192
  end
end
