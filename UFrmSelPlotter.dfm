object FrmSelPlotter: TFrmSelPlotter
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Select Plotter'
  ClientHeight = 131
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object sRdBtnXPlotter_sse: TsRadioButton
    Left = 48
    Top = 24
    Width = 124
    Height = 22
    Caption = 'XPlotter_sse.exe'
    TabOrder = 0
  end
  object sRdBtnXPlotter_avx: TsRadioButton
    Left = 48
    Top = 52
    Width = 124
    Height = 22
    Caption = 'XPlotter_avx.exe'
    TabOrder = 1
  end
  object sBtnOk: TsButton
    Left = 91
    Top = 98
    Width = 102
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = sBtnOkClick
  end
  object sSkinProvider: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 200
    Top = 24
  end
end
