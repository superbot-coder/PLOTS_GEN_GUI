object FrmChengeSettings: TFrmChengeSettings
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'CHANGE COMMANDLINE'
  ClientHeight = 302
  ClientWidth = 530
  Color = clMedGray
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  DesignSize = (
    530
    302)
  PixelsPerInch = 96
  TextHeight = 16
  object sLblMemGb: TsLabel
    Left = 296
    Top = 142
    Width = 28
    Height = 16
    Caption = '= Gb'
  end
  object sLblMem: TsLabel
    Left = 47
    Top = 142
    Width = 153
    Height = 16
    Caption = 'Change parametr "-mem":'
  end
  object sLblThreads: TsLabel
    Left = 21
    Top = 112
    Width = 179
    Height = 16
    Caption = 'Change parametr Threads "-t":'
  end
  object sLblPath: TsLabel
    Left = 21
    Top = 69
    Width = 139
    Height = 16
    Caption = 'Change parametr -path:'
  end
  object sLblGlobalMem: TsLabel
    Left = 363
    Top = 142
    Width = 85
    Height = 16
    Caption = 'sLblGlobalMem'
  end
  object sBtnApply: TsButton
    Left = 189
    Top = 259
    Width = 180
    Height = 35
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'OK'
    TabOrder = 0
    OnClick = sBtnApplyClick
  end
  object sSpEdThreads: TsSpinEdit
    Left = 206
    Top = 109
    Width = 73
    Height = 24
    Color = 3682598
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Text = '2'
    OnChange = sSpEdThreadsChange
    MaxValue = 40
    MinValue = 1
    Value = 2
  end
  object sSpEdMem: TsSpinEdit
    Left = 206
    Top = 139
    Width = 73
    Height = 24
    Color = 3682598
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = '500'
    OnChange = sSpEdMemChange
    Increment = 100
    MaxValue = 32000
    MinValue = 500
    Value = 500
  end
  object sChBoxPathEnable: TsCheckBox
    Left = 167
    Top = 40
    Width = 175
    Height = 20
    Caption = 'Enable Parameter "-path"'
    TabOrder = 3
    ImgChecked = 0
    ImgUnchecked = 0
  end
  object sRdBtnSelectItems: TsRadioButton
    Left = 32
    Top = 178
    Width = 164
    Height = 22
    Caption = 'Change for select items'
    TabOrder = 4
  end
  object sRdBtnAllItems: TsRadioButton
    Left = 32
    Top = 206
    Width = 144
    Height = 22
    Caption = 'Change for all items'
    Checked = True
    TabOrder = 5
    TabStop = True
  end
  object sDirEdPath: TsDirectoryEdit
    Left = 166
    Top = 66
    Width = 193
    Height = 24
    AutoSize = False
    Color = 3682598
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 255
    ParentFont = False
    TabOrder = 6
    Text = ''
    CheckOnExit = True
    GlyphMode.Blend = 0
    GlyphMode.Grayed = False
    Root = 'rfDesktop'
  end
  object sSkinProvider: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 456
    Top = 24
  end
end
