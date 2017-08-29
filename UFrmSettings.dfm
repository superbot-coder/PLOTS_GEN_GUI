object FrmSettings: TFrmSettings
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 269
  ClientWidth = 470
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object sLblLanguage: TsLabel
    Left = 16
    Top = 35
    Width = 60
    Height = 16
    Caption = 'Language:'
  end
  object sGrBoxSkins: TsGroupBox
    Left = 16
    Top = 72
    Width = 441
    Height = 105
    Caption = 'Skin Settings'
    TabOrder = 0
    DesignSize = (
      441
      105)
    object sLblSkins: TsLabel
      Left = 256
      Top = 45
      Width = 66
      Height = 16
      Caption = 'Select skin:'
    end
    object sLbSelectSkinDir: TsLabel
      Left = 16
      Top = 47
      Width = 120
      Height = 16
      Caption = 'Select skin directory:'
    end
    object sSkinSelector: TsSkinSelector
      Left = 256
      Top = 64
      Width = 172
      Height = 25
      Anchors = [akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16772838
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object sDirEditSkin: TsDirectoryEdit
      Left = 16
      Top = 69
      Width = 225
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
      TabOrder = 1
      Text = ''
      CheckOnExit = True
      GlyphMode.Grayed = False
      GlyphMode.Blend = 0
      Root = 'rfDesktop'
    end
  end
  object sCmBoxLang: TsComboBox
    Left = 108
    Top = 32
    Width = 100
    Height = 24
    Alignment = taLeftJustify
    VerticalAlignment = taAlignTop
    Color = 3682598
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemIndex = -1
    ParentFont = False
    TabOrder = 1
    Text = 'Default'
    OnSelect = sCmBoxLangSelect
  end
  object sSkinProvider: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 376
    Top = 16
  end
end
