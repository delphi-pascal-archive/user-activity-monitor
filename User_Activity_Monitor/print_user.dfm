object Form2: TForm2
  Left = 397
  Top = 175
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088'/'#1055#1077#1095#1072#1090#1100' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
  ClientHeight = 560
  ClientWidth = 712
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF007777
    7777777777777777777777777777788888888888888888888888888888877888
    8888888888888888888877788887788888888888888787777777777777877788
    8877777777777777777777777777777777777777777788888888887777777777
    777777777887778FFFFF8877777777777777777883333337FFFF877777777777
    77737888333333337FFF877777777777733788872332773238F8777777777777
    3337888A33822287377777777777777711778882338277833377777777777733
    3111778322222332377777777777773313331113222222337777777777777733
    3333331317377777777777788887777777377737777777777777778888877777
    7777777777777777777777888887777777777777777777777777888888877777
    7777777777777778888888888887788888877777777778888888888888877888
    8888888888888888888888888887788888888888888888888888888888877888
    8888888888888888888888888887788888888888888888888888888888877888
    8888888888888888888888888887788888888888888888888888888888877888
    8888888888888888888888888887788888888888888888888888888888877888
    8888888888888888888888888887788888888888888888888888888888877888
    8888888888888888888888888887777777777777777777777777777777770000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object RichEdit1: TRichEdit
    Left = 0
    Top = 0
    Width = 712
    Height = 473
    Align = alTop
    ScrollBars = ssBoth
    TabOrder = 5
    WordWrap = False
  end
  object Button1: TButton
    Left = 200
    Top = 528
    Width = 233
    Height = 25
    Caption = #1055#1077#1095#1072#1090#1100' '#1074#1089#1077#1075#1086' '#1090#1077#1082#1089#1090#1072
    TabOrder = 3
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 288
    Width = 529
    Height = 24
    TabOrder = 6
    Visible = False
  end
  object Button2: TButton
    Left = 576
    Top = 496
    Width = 129
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1083#1086#1075
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 496
    Width = 449
    Height = 25
    Caption = #1055#1088#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1083#1086#1075'-'#1092#1072#1081#1083
    TabOrder = 0
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 464
    Top = 496
    Width = 105
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = Button4Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 328
    Width = 529
    Height = 121
    ScrollBars = ssBoth
    TabOrder = 7
    Visible = False
    WordWrap = False
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 480
    Width = 697
    Height = 10
    Smooth = True
    Step = 1
    TabOrder = 8
  end
  object Button5: TButton
    Left = 440
    Top = 528
    Width = 265
    Height = 25
    Caption = #1055#1077#1095#1072#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1086#1075#1086' '#1092#1088#1072#1075#1084#1077#1085#1090#1072
    TabOrder = 4
    OnClick = Button5Click
  end
  object RichEdit2: TRichEdit
    Left = 16
    Top = 168
    Width = 529
    Height = 105
    ScrollBars = ssBoth
    TabOrder = 9
    Visible = False
    WordWrap = False
  end
  object Button6: TButton
    Left = 8
    Top = 528
    Width = 185
    Height = 25
    Caption = #1055#1086#1089#1082' '#1074' '#1083#1086#1075'-'#1092#1072#1081#1083#1077' ...'
    TabOrder = 10
    OnClick = Button6Click
  end
  object RichEdit3: TRichEdit
    Left = 16
    Top = 56
    Width = 529
    Height = 105
    ScrollBars = ssBoth
    TabOrder = 11
    Visible = False
    WordWrap = False
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 16
    Top = 16
  end
  object FindDialog1: TFindDialog
    OnFind = FindDialog1Find
    Left = 16
    Top = 512
  end
end
