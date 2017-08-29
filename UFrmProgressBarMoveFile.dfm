object FrmProgressBarMoveFile: TFrmProgressBarMoveFile
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Move File'
  ClientHeight = 119
  ClientWidth = 555
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
  DesignSize = (
    555
    119)
  PixelsPerInch = 96
  TextHeight = 16
  object sLblMoveFile: TsLabel
    Left = 16
    Top = 12
    Width = 59
    Height = 16
    Caption = 'Move File:'
  end
  object sLblFileSize: TsLabel
    Left = 16
    Top = 38
    Width = 53
    Height = 16
    Caption = 'File Size:'
  end
  object sLblAmount: TsLabel
    Left = 190
    Top = 38
    Width = 49
    Height = 16
    Caption = 'Amount:'
  end
  object sLblSpeed: TsLabel
    Left = 370
    Top = 38
    Width = 41
    Height = 16
    Caption = 'Speed:'
  end
  object sLblTime: TsLabel
    Left = 16
    Top = 92
    Width = 41
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = 'Time:'
  end
  object sProgressBar: TsProgressBar
    Left = 8
    Top = 61
    Width = 539
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 0
    ExplicitTop = 60
    ExplicitWidth = 535
  end
  object sSkinProvider: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 504
    Top = 8
  end
end
