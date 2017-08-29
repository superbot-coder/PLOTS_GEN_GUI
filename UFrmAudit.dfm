object FrmAudit: TFrmAudit
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Audit'
  ClientHeight = 444
  ClientWidth = 781
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  DesignSize = (
    781
    444)
  PixelsPerInch = 96
  TextHeight = 16
  object sLV: TsListView
    Left = 0
    Top = 82
    Width = 782
    Height = 361
    Anchors = [akLeft, akRight, akBottom]
    Checkboxes = True
    Color = 3682598
    Columns = <
      item
        AutoSize = True
        Caption = #8470
        MaxWidth = 90
        MinWidth = 50
      end
      item
        AutoSize = True
        Caption = 'Files Name'
        MaxWidth = 400
        MinWidth = 100
      end
      item
        Alignment = taCenter
        AutoSize = True
        Caption = 'Size'
        MaxWidth = 90
        MinWidth = 50
      end
      item
        Alignment = taCenter
        AutoSize = True
        Caption = 'Real Size'
        MaxWidth = 90
        MinWidth = 50
      end
      item
        Alignment = taCenter
        AutoSize = True
        Caption = 'Existes'
        MaxWidth = 90
        MinWidth = 50
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    SmallImages = FrmMain.ImgListLV
    TabOrder = 0
    ViewStyle = vsReport
  end
  object sBtnScan: TsButton
    Left = 248
    Top = 30
    Width = 105
    Height = 25
    Caption = 'START SCAN'
    TabOrder = 1
    OnClick = sBtnScanClick
  end
  object sDirectoryEdit: TsDirectoryEdit
    Left = 8
    Top = 32
    Width = 217
    Height = 21
    AutoSize = False
    Color = 3682598
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 255
    ParentFont = False
    TabOrder = 2
    Text = ''
    CheckOnExit = True
    GlyphMode.Grayed = False
    GlyphMode.Blend = 0
    Root = 'rfDesktop'
  end
  object sBtnOk: TsButton
    Left = 376
    Top = 30
    Width = 105
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = sBtnOkClick
  end
  object sSkinProvider: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 624
    Top = 24
  end
end
