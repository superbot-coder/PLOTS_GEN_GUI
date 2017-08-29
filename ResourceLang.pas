unit ResourceLang;

interface

USES System.StrUtils, System.Classes, System.IniFiles;

type TLang = (LANG_ENG, LANG_RUS);
var strLang: array[TLang] of string = ('ENG', 'RUS');

type TGUIValue =
(
  FrmMain_BtnNewTask,
  FrmMain_BtmAdd,
  FrmMain_Save,
  FrmMain_Start,
  FrmMain_Stop,
  FrmMain_sLblCPU,
  FrmMain_sLblInstructions,
  FrmMain_sLblTaskName,
  FrmMain_sLbl_id_lable,
  FrmMain_sLblTaskFileName,
  FrmMain_sLblProcessing,
  FrmMain_sChBoxAutorun,
  FrmMain_sChBoxLock,
  FrmMain_sChBoxMoveFile,
  FrmMain_sChBoxReWrite,
  FrmMain_sLblDestDir,
  FrmMain_sLVSub0,
  FrmMain_sLVSub1,
  FrmMain_sLVSub2,
  FrmMain_sLVSub3,
  FrmMain_sLVSub4,
  FrmCreateTask_sLblNameTask,
  FrmCreateTask_sLblDrive,
  FrmCreateTask_sLblPath,
  FrmCreateTask_sLblCurrDiskSpace,
  FrmCreateTask_sLblCurrDiskSpace_01,
  FrmCreateTask_sLblCurrDiskSpace_02,
  FrmCreateTask_sLblCurrDiskSpace_03,
  FrmCreateTask_sLblSelectDiskSpace,
  FrmCreateTask_sLblSelectDiskSpace_01,
  FrmCreateTask_sLblID,
  FrmCreateTask_sLblSN,
  FrmCreateTask_sLblNonces,
  FrmCreateTask_sLblThreads,
  FrmCreateTask_sLblMem,
  FrmCreateTask_sLblCountPlots,
  FrmCreateTask_sLblMaxCount,
  FrmCreateTask_sChBoxPathEnable,
  FrmCreateTask_sBtnAPPLY,
  FrmCreateTask_sLblGlobalMem,
  FrmCreateTask_sLblStatDisk,
  FrmProgressBarMF_sLblMoveFile,
  FrmProgressBarMF_sLblFileSize,
  FrmProgressBarMF_sLblAmount,
  FrmProgressBarMF_sLblSpeed,
  FrmProgressBarMF_sLblTime,
  FrmProgressBar_sLblInfo,
  msg_FrmCreateTask_sBtnApply_01,
  msg_FrmCreateTask_sBtmApply_02,
  msg_FrmCreateTask_sBtmApply_03,
  msg_FrmMain_PM_SplitTask_01,
  msg_FrmMain_sBtnSaveBat_01,
  msg_FrmMain_sBtnSaveBat_02,
  msg_FrmMain_sBtnStart_01,
  msg_FrmMain_sBtnStart_02,
  msg_FrmMain_AutoRunEnabledOk,
  msg_FrmMain_AutoRunEnableBad,
  msg_FrmMain_AutoRunCloseOk,
  msg_FrmMain_AutoRunCloseBad,
  msg_FrmMain_ClearTaskList,
  msg_FrmChengeSettings_01,
  lbl_FrmProgresBar_1,
  lbl_FrmProgresBar_2,
  lbl_FrmProgresBar_3,
  lbl_FrmProgresBar_4,
  lbl_FrmProgresBar_5,
  lbl_FrmProgresBar_6,
  lbl_FrmProgressBarMoveFile_Movefile,
  lbl_FrmProgressBarMoveFile_FileSize,
  lbl_FrmProgressBarMoveFile_Amount,
  lbl_FrmProgressBarMoveFile_Speed,
  pm_ASkinSelectDir_SelDir
);

var  strGUI: array[0..71] of string =
(
  'FrmMain_BtnNewTask',
  'FrmMain_BtmAdd',
  'FrmMain_Save',
  'FrmMain_Start',
  'FrmMain_Stop',
  'FrmMain_sLblCPU',
  'FrmMain_sLblInstructions',
  'FrmMain_sLblTaskName',
  'FrmMain_sLbl_id_lable',
  'FrmMain_sLblTaskFileName',
  'FrmMain_sLblProcessing',
  'FrmMain_sChBoxAutorun',
  'FrmMain_sChBoxLock',
  'FrmMain_sChBoxMoveFile',
  'FrmMain_sChBoxReWrite',
  'FrmMain_sLblDestDir',
  'FrmMain_sLVSub0',
  'FrmMain_sLVSub1',
  'FrmMain_sLVSub2',
  'FrmMain_sLVSub3',
  'FrmMain_sLVSub4',
  'FrmCreateTask_sLblNameTask',
  'FrmCreateTask_sLblDrive',
  'FrmCreateTask_sLblPath',
  'FrmCreateTask_sLblCurrDiskSpace',
  'FrmCreateTask_sLblCurrDiskSpace_01',
  'FrmCreateTask_sLblCurrDiskSpace_02',
  'FrmCreateTask_sLblCurrDiskSpace_03',
  'FrmCreateTask_sLblSelectDiskSpace',
  'FrmCreateTask_sLblSelectDiskSpace_01',
  'FrmCreateTask_sLblID',
  'FrmCreateTask_sLblSN',
  'FrmCreateTask_sLblNonces',
  'FrmCreateTask_sLblThreads',
  'FrmCreateTask_sLblMem',
  'FrmCreateTask_sLblCountPlots',
  'FrmCreateTask_sLblMaxCount',
  'FrmCreateTask_sChBoxPathEnable',
  'FrmCreateTask_sBtnAPPLY',
  'FrmCreateTask_sLblGlobalMem',
  'FrmCreateTask_sLblStatDisk',
  'FrmProgressBarMF_sLblMoveFile',
  'FrmProgressBarMF_sLblFileSize',
  'FrmProgressBarMF_sLblAmount',
  'FrmProgressBarMF_sLblSpeed',
  'FrmProgressBarMF_sLblTime',
  'FrmProgressBar_sLblInfo',
  'msg_FrmCreateTask_sBtnApply_01',
  'msg_FrmCreateTask_sBtmApply_02',
  'msg_FrmCreateTask_sBtmApply_03',
  'msg_FrmMain_PM_SplitTask_01',
  'msg_FrmMain_sBtnSaveBat_01',
  'msg_FrmMain_sBtnSaveBat_02',
  'msg_FrmMain_sBtnStart_01',
  'msg_FrmMain_sBtnStart_02',
  'msg_FrmMain_AutoRunEnabledOk',
  'msg_FrmMain_AutoRunEnableBad',
  'msg_FrmMain_AutoRunCloseOk',
  'msg_FrmMain_AutoRunCloseBad',
  'msg_FrmMain_ClearTaskList',
  'msg_FrmChengeSettings_01',
  'lbl_FrmProgresBar_1',
  'lbl_FrmProgresBar_2',
  'lbl_FrmProgresBar_3',
  'lbl_FrmProgresBar_4',
  'lbl_FrmProgresBar_5',
  'lbl_FrmProgresBar_6',
  'lbl_FrmProgressBarMoveFile_Movefile',
  'lbl_FrmProgressBarMoveFile_FileSize',
  'lbl_FrmProgressBarMoveFile_Amount',
  'lbl_FrmProgressBarMoveFile_Speed',
  'pm_ASkinSelectDir_SelDir'
);


var strGUIVal: array[TGUIValue] of string;

procedure LoadLangUpDate(FileNameLang: String);

implementation

procedure LoadLangUpDate(FileNameLang: String);
var
  INI: TIniFile;
  ST : TStrings;
  i, x: SmallInt;
  Section: String;
   strVal: String;
begin
  INI := TIniFile.Create(FileNameLang);
  ST  := TStringList.Create;


  try
    Section := INI.ReadString('INFO', 'Language','');
    if Section = '' then Exit;
    INI.ReadSection(Section, ST);
    if ST.Count = 0 then Exit;

    for i := 0 to ST.Count -1 do
    begin
      x := AnsiIndexStr(ST.Strings[i], strGUI);
      if x = -1 then continue;
      strVal := INI.ReadString(Section, ST.Strings[i], '');
      if strVal <> '' then strGUIVal[TGUIValue(x)] := strVal;
    end;

  finally
    ST.Free;
    INI.Free;
  end;


end;



initialization

  strGUIVal[FrmMain_BtnNewTask]                := 'CREATE NEW TASK';
  strGUIVal[FrmMain_BtmAdd]                    := 'ADD PLOTS';
  strGUIVal[FrmMain_Save]                      := 'SAVE AS BAT-FILE';
  strGUIVal[FrmMain_Start]                     := 'START';
  strGUIVal[FrmMain_Stop]                      := 'STOP';
  strGUIVal[FrmMain_sLblCPU]                   := 'Processor:';
  strGUIVal[FrmMain_sLblTaskName]              := 'Task Name: ';
  strGUIVal[FrmMain_sLbl_id_lable]             := 'ID wallet:';
  strGUIVal[FrmMain_sLblTaskFileName]          := 'Task File:';
  strGUIVal[FrmMain_sLblProcessing]            := 'Processing Information:';
  strGUIVal[FrmMain_sChBoxAutorun]             := 'Windows AutoRun / Autostart';
  strGUIVal[FrmMain_sChBoxLock]                := 'Lock Multi move';
  strGUIVal[FrmMain_sChBoxMoveFile]            := 'Move File';
  strGUIVal[FrmMain_sChBoxReWrite]             := 'ReWrite File';
  strGUIVal[FrmMain_sLblDestDir]               := 'Destination  Directory:';
  strGUIVal[FrmMain_sLVSub0]                   := 'Command Line';
  strGUIVal[FrmMain_sLVSub1]                   := 'Size';
  strGUIVal[FrmMain_sLVSub2]                   := 'Time';
  strGUIVal[FrmMain_sLVSub3]                   := 'Status';
  strGUIVal[FrmMain_sLVSub4]                   := 'Move File';
  strGUIVal[FrmCreateTask_sLblNameTask]        := 'New Task Name:';
  strGUIVal[FrmCreateTask_sLblDrive]           := 'Select Disk:';
  strGUIVal[FrmCreateTask_sLblPath]            := 'Path:';
  strGUIVal[FrmCreateTask_sLblCurrDiskSpace]      := 'Current Disk:';
  strGUIVal[FrmCreateTask_sLblCurrDiskSpace_01]   := 'Current disk';
  strGUIVal[FrmCreateTask_sLblCurrDiskSpace_02]   := 'Total space:';
  strGUIVal[FrmCreateTask_sLblCurrDiskSpace_03]   := 'Free space:';
  strGUIVal[FrmCreateTask_sLblSelectDiskSpace]    := 'Selected Disk:';
  strGUIVal[FrmCreateTask_sLblSelectDiskSpace_01] := 'Selected disk';
  strGUIVal[FrmCreateTask_sLblID]              := 'ID:';
  strGUIVal[FrmCreateTask_sLblSN]              := 'Start nonce:';
  strGUIVal[FrmCreateTask_sLblNonces]          := 'Nonces:';
  strGUIVal[FrmCreateTask_sLblThreads]         := 'Threads:';
  strGUIVal[FrmCreateTask_sLblMem]             := 'Mem Mb:';
  strGUIVal[FrmCreateTask_sLblCountPlots]      := 'Count plots:';
  strGUIVal[FrmCreateTask_sLblMaxCount]        := 'Max Count = 10000';
  strGUIVal[FrmCreateTask_sChBoxPathEnable]    := 'Enable Parametr "-path"';
  strGUIVal[FrmCreateTask_sBtnAPPLY]           := 'CREATE TASK';
  strGUIVal[FrmCreateTask_sLblGlobalMem]       := 'Global Memory:';
  strGUIVal[FrmCreateTask_sLblStatDisk]        := 'GB free space';
  strGUIVal[FrmProgressBarMF_sLblMoveFile]     := 'Move File:';
  strGUIVal[FrmProgressBarMF_sLblFileSize]     := 'File Size:';
  strGUIVal[FrmProgressBarMF_sLblAmount]       := 'Amount:';
  strGUIVal[FrmProgressBarMF_sLblSpeed]        := 'Speed:';
  strGUIVal[FrmProgressBarMF_sLblTime]         := 'Time:';
  strGUIVal[FrmProgressBar_sLblInfo]           := 'Information:';

  strGUIVal[msg_FrmCreateTask_sBtnApply_01] := 'Please enter the name of a task';
  strGUIVal[msg_FrmCreateTask_sBtmApply_02] := 'Incorrect "ID", It is necessary to enter only number from 0 to 9';
  strGUIVal[msg_FrmCreateTask_sBtmApply_03] := 'Incorrect "Nonces", It is necessary to enter only number from 0 to 9';
  strGUIVal[msg_FrmMain_PM_SplitTask_01]    := 'There have to be not less than two records in a task';
  strGUIVal[msg_FrmMain_sBtnSaveBat_01]     := 'There are no lines';
  strGUIVal[msg_FrmMain_sBtnSaveBat_02]     := 'Export was successful!';
  strGUIVal[msg_FrmMain_sBtnStart_01]       := 'STOP PROCESSING - ';
  strGUIVal[msg_FrmMain_sBtnStart_02]       := ' can not extract ';
  strGUIVal[msg_FrmMain_AutoRunEnabledOk]   := 'AutoRun and Autostart is established successfully';
  strGUIVal[msg_FrmMain_AutoRunEnableBad]   := 'AutoRun and Autostart is not enable';
  strGUIVal[msg_FrmMain_AutoRunCloseOk]     := 'AutoRun and Autostart is cloced successfully';
  strGUIVal[msg_FrmMain_AutoRunCloseBad]    := 'AutoRun and Autostart is not closed';
  strGUIVal[msg_FrmMain_ClearTaskList]      := 'you really are going to clean TaskLis? if yes click YES if is not present on press NO';
  strGUIVal[msg_FrmChengeSettings_01]       := 'Paràmetr "-Path" is empty';
  strGUIVal[lbl_FrmProgresBar_1]            := 'Addition of records:';
  strGUIVal[lbl_FrmProgresBar_2]            := 'Saving records:';
  strGUIVal[lbl_FrmProgresBar_3]            := 'Loading records:';
  strGUIVal[lbl_FrmProgresBar_4]            := 'Deleting records:';
  strGUIVal[lbl_FrmProgresBar_5]            := 'Chenging records:';
  strGUIVal[lbl_FrmProgresBar_6]            := 'passed time:';

  strGUIVal[lbl_FrmProgressBarMoveFile_Movefile] := 'File to move: ';
  strGUIVal[lbl_FrmProgressBarMoveFile_FileSize] := 'File Size: ';
  strGUIVal[lbl_FrmProgressBarMoveFile_Amount]   := 'Amount: ';
  strGUIVal[lbl_FrmProgressBarMoveFile_Speed]    := 'Speed: ';

  strGUIVal[pm_ASkinSelectDir_SelDir]            := 'Select Directory';


end.
