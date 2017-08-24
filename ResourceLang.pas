unit ResourceLang;

interface

Var
 // **************** MessgeBox dialogs ******************
 msg_FrmCreateTask_sBtnApply_01 : String;
 msg_FrmCreateTask_sBtmApply_02 : String;
 msg_FrmCreateTask_sBtmApply_03 : String;
 msg_FrmMain_PM_SplitTask_01    : String;
 msg_FrmMain_sBtnSaveBat_01     : String;
 msg_FrmMain_sBtnSaveBat_02     : String;
 msg_FrmMain_sBtnStart_01       : String;
 msg_FrmMain_sBtnStart_02       : String;
 msg_FrmMain_AutoRunEnabledOk   : String;
 msg_FrmMain_AutoRunEnableBad   : String;
 msg_FrmMain_AutoRunCloseOk     : String;
 msg_FrmMain_AutoRunCloseBad    : String;
 msg_FrmMain_ClearTaskList      : String;
 msg_FrmChengeSettings_01       : String;

 // ******************* Labels ***************************
 lbl_FrmProgresBar_1                 : String;
 lbl_FrmProgresBar_2                 : String;
 lbl_FrmProgresBar_3                 : String;
 lbl_FrmProgresBar_4                 : String;
 lbl_FrmProgresBar_5                 : String;
 lbl_FrmProgresBar_6                 : String;
 lbl_FrmProgressBarMoveFile_Movefile : String;
 lbl_FrmProgressBarMoveFile_FileSize : String;
 lbl_FrmProgressBarMoveFile_Amount   : String;
 lbl_FrmProgressBarMoveFile_Speed    : String;



implementation

initialization
  msg_FrmMain_PM_SplitTask_01    := 'There have to be not less than two records in a task';
  msg_FrmMain_sBtnSaveBat_01     := 'There are no lines';
  msg_FrmMain_sBtnSaveBat_02     := 'Export was successful!';
  msg_FrmMain_sBtnStart_01       := 'STOP PROCESSING - ';
  msg_FrmMain_sBtnStart_02       := ' can not extract ';
  msg_FrmCreateTask_sBtnApply_01 := 'Please enter the name of a task';
  msg_FrmCreateTask_sBtmApply_02 := 'Incorrect "ID", It is necessary to enter only number from 0 to 9';
  msg_FrmCreateTask_sBtmApply_03 := 'Incorrect "Nonces", It is necessary to enter only number from 0 to 9';
  msg_FrmMain_AutoRunEnabledOk   := 'AutoRun and Autostart is established successfully';
  msg_FrmMain_AutoRunEnableBad   := 'AutoRun and Autostart is not enable';
  msg_FrmMain_AutoRunCloseOk     := 'AutoRun and Autostart is cloced successfully';
  msg_FrmMain_AutoRunCloseBad    := 'AutoRun and Autostart is not closed';
  msg_FrmMain_ClearTaskList      := 'you really are going to clean TaskLis? if yes click YES if is not present on press NO';
  msg_FrmChengeSettings_01       := 'Paremet "-Path" is empty';

  lbl_FrmProgresBar_1            := 'Addition of records:';
  lbl_FrmProgresBar_2            := 'Saving records:';
  lbl_FrmProgresBar_3            := 'Loading records:';
  lbl_FrmProgresBar_4            := 'Deleting records:';
  lbl_FrmProgresBar_5            := 'Chenging records:';
  lbl_FrmProgresBar_6            := 'passed time:';

  lbl_FrmProgressBarMoveFile_Movefile := 'File to move: ';
  lbl_FrmProgressBarMoveFile_FileSize := 'File Size: ';
  lbl_FrmProgressBarMoveFile_Amount   := 'Amount: ';
  lbl_FrmProgressBarMoveFile_Speed    := 'Speed: ';


end.
