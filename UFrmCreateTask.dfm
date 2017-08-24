object FrmCreateTask: TFrmCreateTask
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'CREATE PLOTS'
  ClientHeight = 354
  ClientWidth = 752
  Color = clMedGray
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    752
    354)
  PixelsPerInch = 96
  TextHeight = 16
  object sLblDrive: TsLabel
    Left = 19
    Top = 66
    Width = 67
    Height = 16
    Caption = 'Select Disk:'
  end
  object sLblPath: TsLabel
    Left = 189
    Top = 69
    Width = 30
    Height = 16
    Caption = 'Path:'
  end
  object JvOverflowed: TJvLabel
    Left = 692
    Top = 238
    Width = 67
    Height = 16
    Caption = 'Overflowed'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Visible = False
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -13
    HotTrackFont.Name = 'Tahoma'
    HotTrackFont.Style = []
  end
  object JvLblGLMemOverflowed: TJvLabel
    Left = 692
    Top = 206
    Width = 136
    Height = 16
    Caption = 'JvLblGLMemOverflowed'
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
    Visible = False
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -13
    HotTrackFont.Name = 'Tahoma'
    HotTrackFont.Style = []
  end
  object sLblStatDisk: TsLabel
    Left = 594
    Top = 236
    Width = 68
    Height = 16
    Caption = 'sLblStatDisk'
  end
  object sLblGlobalMem: TsLabel
    Left = 594
    Top = 206
    Width = 85
    Height = 16
    Caption = 'sLblGlobalMem'
  end
  object sLblPlotsSumGb: TsLabel
    Left = 519
    Top = 236
    Width = 56
    Height = 16
    Caption = '= max Gb'
  end
  object sLblMemGb: TsLabel
    Left = 519
    Top = 206
    Width = 28
    Height = 16
    Caption = '= Gb'
  end
  object sLblCountPlots: TsLabel
    Left = 360
    Top = 236
    Width = 69
    Height = 16
    Caption = 'Count plots:'
  end
  object sLblMem: TsLabel
    Left = 375
    Top = 206
    Width = 54
    Height = 16
    Caption = 'Mem Mb:'
  end
  object sLblThreads: TsLabel
    Left = 382
    Top = 176
    Width = 52
    Height = 16
    Caption = 'Threads:'
  end
  object sLblGB: TsLabel
    Left = 292
    Top = 236
    Width = 39
    Height = 16
    Caption = '= Auto'
  end
  object sLblNonces: TsLabel
    Left = 41
    Top = 236
    Width = 46
    Height = 16
    Caption = 'Nonces:'
  end
  object sLblSN: TsLabel
    Left = 16
    Top = 206
    Width = 71
    Height = 16
    Caption = 'Start nonce:'
  end
  object sLblID: TsLabel
    Left = 72
    Top = 176
    Width = 17
    Height = 16
    Caption = 'ID:'
  end
  object sLblSelectDiskSpace: TsLabel
    Left = 26
    Top = 118
    Width = 81
    Height = 16
    Caption = 'Selected Disk:'
  end
  object sLblCurrDiskSpace: TsLabel
    Left = 32
    Top = 96
    Width = 75
    Height = 16
    Caption = 'Current Disk:'
  end
  object sLblNameTask: TsLabel
    Left = 166
    Top = 19
    Width = 98
    Height = 16
    Caption = 'New Task Name:'
  end
  object sLblMaxCount: TsLabel
    Left = 360
    Top = 263
    Width = 112
    Height = 16
    Caption = 'Max Count = 10000'
  end
  object sBtnAPPLY: TsButton
    Left = 250
    Top = 305
    Width = 250
    Height = 33
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'CREATE TASK'
    TabOrder = 0
    OnClick = sBtnAPPLYClick
  end
  object sCmBoxExSelectDisk: TsComboBoxEx
    Left = 92
    Top = 63
    Width = 85
    Height = 25
    ItemsEx = <>
    Color = 3682598
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemIndex = -1
    ParentFont = False
    TabOrder = 1
    OnChange = sCmBoxExSelectDiskChange
    OnKeyPress = sCmBoxExSelectDiskKeyPress
    Images = ImageListDrive
  end
  object sEdPath: TsEdit
    Left = 228
    Top = 66
    Width = 193
    Height = 24
    Color = 3682598
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = 'Burst\plots'
  end
  object sChBoxPathEnable: TsCheckBox
    Left = 427
    Top = 68
    Width = 168
    Height = 20
    Caption = 'Enable Parametr "-path"'
    TabOrder = 3
    OnClick = sChBoxPathEnableClick
    ImgChecked = 0
    ImgUnchecked = 0
  end
  object sEdID: TsEdit
    Left = 92
    Top = 173
    Width = 188
    Height = 24
    Color = 3682598
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 20
    ParentFont = False
    TabOrder = 4
    Text = '7909528429518557192'
  end
  object sSpEdMem: TsSpinEdit
    Left = 436
    Top = 203
    Width = 73
    Height = 24
    Color = 3682598
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Text = '500'
    OnChange = sSpEdMemChange
    Increment = 100
    MaxValue = 64000
    MinValue = 500
    Value = 500
  end
  object sSpEdCount: TsSpinEdit
    Left = 435
    Top = 233
    Width = 73
    Height = 24
    Color = 3682598
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Text = '1'
    OnChange = sSpEdCountChange
    MaxValue = 100000
    MinValue = 1
    Value = 1
  end
  object sSpEdThreads: TsSpinEdit
    Left = 436
    Top = 173
    Width = 73
    Height = 24
    Color = 3682598
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    Text = '2'
    OnChange = sSpEdThreadsChange
    MaxValue = 128
    MinValue = 1
    Value = 2
  end
  object sBtnLastPlots: TsButton
    Left = 286
    Top = 203
    Width = 27
    Height = 24
    Hint = 'Get nonce from Last Plots'
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = sBtnLastPlotsClick
  end
  object sSpEdNonces: TsSpinEdit
    Left = 92
    Top = 233
    Width = 188
    Height = 24
    Color = 3682598
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    Text = '0'
    OnChange = sSpEdNoncesChange
    Increment = 40960
    MaxValue = 104857600
    MinValue = 0
    Value = 0
  end
  object sEdStartNonce: TsEdit
    Left = 92
    Top = 203
    Width = 188
    Height = 24
    Color = 3682598
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 12
    ParentFont = False
    TabOrder = 10
    Text = '400000001'
  end
  object sEdNewNameTask: TsEdit
    Left = 270
    Top = 16
    Width = 219
    Height = 24
    Color = 3682598
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16772838
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 28
    ParentFont = False
    TabOrder = 11
  end
  object sSkinProvider: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 636
    Top = 16
  end
  object ImageListDrive: TImageList
    ColorDepth = cd32Bit
    DrawingStyle = dsTransparent
    Height = 19
    Masked = False
    Width = 19
    Left = 564
    Top = 16
  end
end
