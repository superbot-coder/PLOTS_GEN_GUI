object FrmProgressBarMoveFile: TFrmProgressBarMoveFile
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Move File'
  ClientHeight = 90
  ClientWidth = 576
  Color = clMedGray
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object sLblMoveFile: TsLabel
    Left = 16
    Top = 8
    Width = 59
    Height = 16
    Caption = 'Move File:'
  end
  object sLblFileSize: TsLabel
    Left = 16
    Top = 30
    Width = 53
    Height = 16
    Caption = 'File Size:'
  end
  object sLblAmount: TsLabel
    Left = 192
    Top = 30
    Width = 49
    Height = 16
    Caption = 'Amount:'
  end
  object sLblSpeed: TsLabel
    Left = 362
    Top = 30
    Width = 41
    Height = 16
    Caption = 'Speed:'
  end
  object sProgressBar: TsProgressBar
    Left = 8
    Top = 52
    Width = 560
    Height = 25
    TabOrder = 0
  end
  object sSkinProvider: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 504
    Top = 8
  end
end
