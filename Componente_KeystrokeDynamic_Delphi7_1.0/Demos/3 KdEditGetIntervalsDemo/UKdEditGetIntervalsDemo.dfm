object Form1: TForm1
  Left = 202
  Top = 116
  Width = 564
  Height = 300
  Caption = 'Mostrar intervalos de tiempo entre teclas'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 564
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    556
    266)
  PixelsPerInch = 96
  TextHeight = 13
  object KdEditAlphaNumeric1: TKdEditAlphaNumeric
    Left = 8
    Top = 8
    Width = 303
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnKeyDownTiming = KdEditAlphaNumeric1KeyDownTiming
    OnKeyUpTiming = KdEditAlphaNumeric1KeyUpTiming
    OnTimingVectorInit = KdEditAlphaNumeric1TimingVectorInit
  end
  object Button2: TButton
    Left = 263
    Top = 234
    Width = 137
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Procedencia'
    TabOrder = 1
    OnClick = Button2Click
  end
  object ComboBox1: TComboBox
    Left = 317
    Top = 8
    Width = 233
    Height = 21
    Anchors = [akTop, akRight]
    ItemHeight = 13
    TabOrder = 2
    OnChange = ComboBox1Change
    Items.Strings = (
      'Mostrar Duraci'#243'n'
      'Mostrar Di-Graph'
      'Mostrar Tri-Graph'
      'Mostrar Tetra-Graph'
      'Mostrar Penta-Graph')
  end
  object Memo1: TMemo
    Left = 8
    Top = 35
    Width = 542
    Height = 193
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object Button1: TButton
    Left = 410
    Top = 234
    Width = 137
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cargar fichero CSV'
    TabOrder = 4
    OnClick = Button1Click
  end
  object KdIntervalCreator1: TKdIntervalCreator
    OnDuration = KdIntervalCreator1Duration
    OnDiGraph = KdIntervalCreator1DiGraph
    OnTriGraph = KdIntervalCreator1TriGraph
    OnTetraGraph = KdIntervalCreator1TetraGraph
    OnPentaGraph = KdIntervalCreator1PentaGraph
    Left = 32
    Top = 112
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'csv'
    Filter = 'Ficheros CSV|*.csv|Todos los ficheros|*.*'
    Left = 80
    Top = 120
  end
end
