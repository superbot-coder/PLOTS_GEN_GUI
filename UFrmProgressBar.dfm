object FrmProgressBar: TFrmProgressBar
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'PLOTS_GEN_GUI'
  ClientHeight = 69
  ClientWidth = 458
  Color = clMedGray
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object sLblInfo: TsLabel
    Left = 8
    Top = 17
    Width = 71
    Height = 16
    Caption = 'Information:'
  end
  object sProgBar: TsProgressBar
    Left = 8
    Top = 36
    Width = 439
    Height = 25
    MarqueeInterval = 1
    TabOrder = 0
  end
  object sSkinProvider: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 400
  end
end
