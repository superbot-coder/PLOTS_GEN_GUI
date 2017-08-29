unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sMemo, sSkinProvider,
  sSkinManager, sButton, sToolEdit, Vcl.Mask, sMaskEdit, sCustomComboEdit,
  sLabel, sCurrEdit, sCurrencyEdit, sEdit, acPopupCtrls, sSpinEdit,
  Vcl.ComCtrls, sComboBoxes, System.ImageList, Vcl.ImgList,
  sDialogs, Vcl.Menus, sStatusBar, acTitleBar, System.IniFiles, cpu_info_xe,
  sCheckBox, Vcl.FileCtrl, acProgressBar, ModFileFormatSize,
  Error, sListView, Compress, GetVer, System.RegularExpressions, Winapi.ShellApi,
  System.win.registry, Vcl.ExtCtrls, TimeFormat, StrUtils, Winapi.CommCtrl,
  sComboBox, System.Math, ResourceLang, System.Actions, Vcl.ActnList, sGroupBox;

type TExitCode = (EX_COMPLETE, EX_STOPED, EX_CLOCE, EX_FILED, EX_UNKNOWN);

type TPlotter   = (XPlotter_sse, XPlotter_avx, XPlotter_avx2, XPlotter_sse_poc2, XPlotter_avx_poc2, XPlotter_avx2_poc2);
type TLockControls = (lcAll, lcStart);
type TConfigValues = (id, Path, StartNonce, SkinName, DestDir, FileMove, ReWrite,
                      Version, SkinDirectory, CommandList, MoveBufferSize, Language, MoveInTurn, ToAddTime);
type TPoC = (POC1, POC2);

var
 strExitCode:  Array[TExitCode] of string = ('Complete', 'Stoped', 'Cloce', 'Filed', 'Unknown');
 strPlotter: Array[TPlotter] of string = ('XPlotter_sse', 'XPlotter_avx', 'XPlotter_avx2',
   'XPlotter_sse_poc2', 'XPlotter_avx_poc2', 'XPlotter_avx2_poc2');
 strConfigValues: Array[0..13] of String = ('id', 'Path', 'StartNonce', 'SkinName',
    'DestDir', 'FileMove', 'ReWrite', 'Version', 'SkinDirectory', 'CommandList', 'MoveBufferSize', 'Language', 'MoveInTurn', 'ToAddTimeResults');
 strPOC: Array[TPoC] of String = ('POC1','POC2');

type
  TFrmMain = class(TForm)
    sBtnStart: TsButton;
    sSkinManager: TsSkinManager;
    sSkinProvider: TsSkinProvider;
    sBtnSaveBat: TsButton;
    sBtnStop: TsButton;
    sSaveDlg: TsSaveDialog;
    sBtnNewTask: TsButton;
    PopMenu: TPopupMenu;
    PM_TaskClaer: TMenuItem;
    OpenDlg: TOpenDialog;
    sLblFXDonate: TsLabelFX;
    sWebLblDonatBurst: TsWebLabel;
    EdDonation: TEdit;
    sLblFXDonateBTC: TsLabelFX;
    sWbLblBTC: TsWebLabel;
    sLblCPU: TsLabel;
    sOpenDlgLastNonce: TsOpenDialog;
    sLV: TsListView;
    ImgListLV: TImageList;
    sLblTaskFileName: TsLabel;
    sBtnAddPlots: TsButton;
    sLblProcessing: TsLabel;
    sLblTaskName: TsLabel;
    sProgressBarProcessing: TsProgressBar;
    PM_TaskEdit: TMenuItem;
    PM_TaskSplit: TMenuItem;
    TimerLoadTaskList: TTimer;
    PopMenuASkin: TPopupMenu;
    PM_ASkinSelectDir: TMenuItem;
    mm: TsMemo;
    sLbl_id_lable: TsLabel;
    sLbl_id_wallet: TsLabel;
    TmrHideLVItems: TTimer;
    sLblCPUData: TsLabel;
    sLblTaskNameData: TsLabel;
    sLblTaskFileNameData: TsLabel;
    sLblProcessingData: TsLabel;
    sLblInstructions: TsLabel;
    sLblInstructionsData: TsLabel;
    PM_CheckBoxAllUP: TMenuItem;
    PM_CheckBoxAllDown: TMenuItem;
    PM_Spit1: TMenuItem;
    PM_ItemsSelectedCheck: TMenuItem;
    PM_ItemsSelectedUnCheck: TMenuItem;
    MainMenu: TMainMenu;
    MM_Files: TMenuItem;
    MM_OpenTaskList: TMenuItem;
    PM_ExportToBatFile: TMenuItem;
    ActionList: TActionList;
    Act_OpenTaskList: TAction;
    Act_ExportToBatFile: TAction;
    Act_OpenAudit: TAction;
    Act_ItemsCheckedAll: TAction;
    Act_ItemsUnCheckedAll: TAction;
    Act_Exit: TAction;
    Act_AddPlots: TAction;
    Act_CreateNewTaskList: TAction;
    MM_Actions: TMenuItem;
    MM_Start: TMenuItem;
    MM_Stop: TMenuItem;
    MM_Audit: TMenuItem;
    MM_Settings: TMenuItem;
    MM_AutoRun: TMenuItem;
    MM_Exit: TMenuItem;
    MM_Split: TMenuItem;
    PM_AddPlots: TMenuItem;
    PM_CreateNewTaskList: TMenuItem;
    Act_Start: TAction;
    Act_Stop: TAction;
    PM_OpenSettings: TMenuItem;
    Act_ItemsSelectedChecked: TAction;
    Act_ItemsSelectedUnChecked: TAction;
    Act_TaskEdit: TAction;
    Act_TaskClear: TAction;
    Act_TaskClose: TAction;
    sLblPocVer: TsLabel;
    sLblPocVerData: TsLabel;
    Act_TaskSplit: TAction;
    MM_ShowDebugsInfo: TMenuItem;
    MM_TaskClose: TMenuItem;
    sGrBoxMove: TsGroupBox;
    sLblDestDir: TsLabel;
    sDirEditDest: TsDirectoryEdit;
    sChBoxReWrite: TsCheckBox;
    sChBoxMoveInTurn: TsCheckBox;
    sChBoxMoveFile: TsCheckBox;
    MM_TaskEdit: TMenuItem;
    MM_Slite: TMenuItem;
    sLblExperemental: TsLabel;
    PM_Split2: TMenuItem;
    PM_TimeResultClear: TMenuItem;
    Act_ClearResults: TAction;
    MM_ToAddTimeResults: TMenuItem;
    function AddAssociatedIcon(FileName: String; ImageList: TImageList): Integer;
    procedure FormCreate(Sender: TObject);
    function ExecAndWait(AppName, CommandLime, CurrentDir: PChar; CmdShow: Integer; LVItem: TListItem): Longword;
    procedure sWbLabelClick(Sender: TObject);
    procedure SaveSettings;
    procedure LoadSettings;
    procedure sSkinProviderTitleButtons0MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    function ExtractParam(Param, StrValue: AnsiString): AnsiString;
    procedure sSkinManagerAfterChange(Sender: TObject);
    function AddLVItem: Integer;
    procedure LVLoadTaskListFromFile(FileName: String);
    procedure LVLoadTaskListFromFileOld(FileName: String);
    procedure PM_OpenTaskListClick(Sender: TObject);
    procedure LVSaveTaskListToFile(FileName: String);
    procedure sBtnAddPlotsClick(Sender: TObject);
    function RemoveSpace(StrValue: AnsiString): AnsiString;
    procedure GetProcessingInformation;
    procedure AddItemsToTaskList;
    Function AutoRunCheck: Boolean;
    Procedure LockControls(LockType: TLockControls);
    Procedure UnLockControls;
    procedure TimerLoadTaskListTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PM_ASkinSelectDirClick(Sender: TObject);
    procedure ReConfig;
    function CValue(TValue: TConfigValues): String;
    function GetComputerNetName: String;
    function LockFileCreate(FileMove: String): Boolean;
    function CheckSelfLocked(FileName: String): Boolean;
    procedure sLVEndColumnResize(sender: TCustomListView; columnIndex,
      columnWidth: Integer);
    procedure TmrHideLVItemsTimer(Sender: TObject);
    procedure LabelsClear;
    function ScanLock(ScanDir: String): boolean;
    procedure Act_OpenAuditExecute(Sender: TObject);
    procedure Act_ItemsCheckedAllExecute(Sender: TObject);
    procedure Act_ItemsUnCheckedAllExecute(Sender: TObject);
    procedure SetCheckBoxItems(SelectedItems, CheckStatus: Boolean);
    procedure Act_ExitExecute(Sender: TObject);
    procedure MM_AutoRunClick(Sender: TObject);
    procedure PM_OpenSettingsClick(Sender: TObject);
    procedure Act_ItemsSelectedCheckedExecute(Sender: TObject);
    procedure Act_ItemsSelectedUnCheckedExecute(Sender: TObject);
    procedure Act_OpenTaskListExecute(Sender: TObject);
    procedure Act_TaskEditExecute(Sender: TObject);
    procedure Act_TaskClearExecute(Sender: TObject);
    procedure Act_CreateNewTaskListExecute(Sender: TObject);
    procedure Act_StartExecute(Sender: TObject);
    procedure Act_StopExecute(Sender: TObject);
    procedure Act_ExportToBatFileExecute(Sender: TObject);
    procedure Act_AddPlotsExecute(Sender: TObject);
    procedure Act_TaskCloseExecute(Sender: TObject);
    procedure Act_TaskSplitExecute(Sender: TObject);
    procedure MM_ShowDebugsInfoClick(Sender: TObject);
    procedure sChBoxMoveFileClick(Sender: TObject);
    procedure log(strValue: String);
    procedure Act_ClearResultsExecute(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  FrmMain              : TFrmMain;
  CurrPath             : string;
  CurrentDisk          : String;
  TERMINATE_PROCESS    : Boolean = false;
  PROCESSING_START     : Boolean = false;
  SELECT_DISK_FREE_SZ  : Int64;
  CURRENT_DISK_FREE_SZ : Int64;
  MaxCore              : SmallInt;
  MemTotalPhys         : Int64;
  INI                  : TIniFile;
  NonceDirection       : Integer;
  CurrentTaskList      : string;
  CPUInstruction       : TCPUInstruction;
  typePlotter          : TPlotter;
  typePlotterPoc2      : TPlotter;
  XPlotterFile         : String;
  XPlotterFilePoc2     : String;
  BgnTimeProcessing    : Cardinal;
  LastTimeProcessing   : Cardinal;
  CurrentTaskName      : String;
  AutoRunCheckPass     : Boolean;
  MOVE_BUFFER_SIZE     : Integer;
  HostName             : String;
  LOCK_MOVE_CREATE     : Boolean;
  FileConfig           : String;
  LangPath             : String;
  CurrentLanguage      : String;
  PoCVersion           : TPoC;

  msg_TaskName         : String;
  msg_TaskFile         : String;
  I                    : Integer;
  WRITE_LOG            : Boolean;


const
  TL_VERSION     = 2;
  NONCE          = 4096;
  REC_RANGE      = 100;
  SLEEP_VISIBLE  = 2000;
  DEFAULT_BUFFER = 1048576;       // 1MB
  SETTINGS       = 'SETTINGS';    // Section SETTINGS Config.ini
  // INI_LANGUAGE  = 'LANGUAGE';    // section Config.ini
  MB_CAPTION     = 'PLOTS_GEN_GUI';
  RegKeyAutoRun  = '\Software\Microsoft\Windows\CurrentVersion\Run';
  char_not_permitted = '[\\/:\*\?"<>\s]';   //   \/:*?"<>|;
  GigaByte       = 1073741824;

  lock_file = 'lock_move.txt';
  c_cmd   = 0;
  c_size  = 1;
  c_time  = 2;
  c_stat  = 3;
  c_move  = 4;
  c_int_time = 5;


implementation

USES
  UFrmCreateTask, UFrmChangeSettings, UFrmSelPlotter, UFrmSplitTask,
  UFrmProgressBar, UFrmProgressBarMoveFile, UFrmAudit, UFrmSettings;

{$R *.dfm}
{$R XPlotter_avx.res}
{$R XPlotter_sse.res}
{$R XPlotter_avx2.res}
{$R XPlotter_sse_poc2.res}
{$R XPlotter_avx_poc2.res}
{$R XPlotter_avx2_poc2.res}

function TFrmMain.AddLVItem: Integer;
begin
  with sLV.Items.Add do
  begin
    Caption := '';
    ImageIndex := -1;
    caption := IntToStr(Index + 1);
    SubItems.Add('');
    SubItems.Add('');
    SubItems.Add('');
    SubItems.Add('');
    SubItems.Add('');
    SubItems.Add('0');
    SubItemImages[0] := 0;
    Result := Index;
  end;
end;

function TFrmMain.AutoRunCheck: Boolean;
var
  Reg: TRegistry;
begin
  Result := false;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly(RegKeyAutoRun) then
    begin
      if Reg.ValueExists(MB_CAPTION) then
        if LowerCase(Reg.ReadString(MB_CAPTION)) = LowerCase(Application.ExeName) then
          Result := True;
      Reg.CloseKey;
    end;

  finally
    Reg.Free;
  end;
end;

procedure TFrmMain.Act_ItemsUnCheckedAllExecute(Sender: TObject);
begin
  SetCheckBoxItems(false, false);
end;

procedure TFrmMain.Act_ItemsCheckedAllExecute(Sender: TObject);
begin
  SetCheckBoxItems(false, true);
end;

procedure TFrmMain.Act_ItemsSelectedCheckedExecute(Sender: TObject);
begin
  SetCheckBoxItems(true, true);
end;

procedure TFrmMain.Act_ItemsSelectedUnCheckedExecute(Sender: TObject);
begin
  SetCheckBoxItems(true, false);
end;

procedure TFrmMain.Act_AddPlotsExecute(Sender: TObject);
begin
  with FrmCreateTask do
  begin
    Apply                  := false;
    FrmShowMode            := FRM_ADDPLOTS;
    sBtnApply.Caption      := 'ADD PLOTS';
    sEdNewNameTask.Text    := CurrentTaskName;
    sEdNewNameTask.Enabled := false;
    sChBoxPoc2.Enabled     := false;
    ShowModal;
    sChBoxPoc2.Enabled     := true;
    if Not Apply then Exit;
  end;
  LockControls(lcAll);
  AddItemsToTaskList;
  UnLockControls;
  LVSaveTaskListToFile(CurrentTaskList);
  GetProcessingInformation;
  SaveSettings;
end;

procedure TFrmMain.Act_CreateNewTaskListExecute(Sender: TObject);
var
  INI: TIniFile;
begin
  With FrmCreateTask do
  begin
    Apply                  := false;
    FrmShowMode            := FRM_NEWTASK;
    sBtnAPPLY.Caption      := 'CREATE TASK';
    sEdNewNameTask.Text    := '';
    sEdNewNameTask.Enabled := True;
    ShowModal;
    if Not Apply then Exit;
  end;

  sLV.Clear;
  AddItemsToTaskList;
  CurrentTaskName :=  FrmCreateTask.sEdNewNameTask.Text;
  CurrentTaskList :=  CurrPath +  TregEx.Replace(CurrentTaskName, char_not_permitted, '', [roIgnoreCase]) +
                      '_' + FormatDateTime('dd.mm.yyyy_hh.mm.ss', Date+Time) + '.txt';

  if FrmCreateTask.sChBoxPoc2.Checked then PoCVersion := POC2
  else PoCVersion := POC1;
  sLblPocVerData.Caption       := strPOC[TPoC(PoCVersion)];
  sLblTaskNameData.Caption     := CurrentTaskName;
  sLblTaskFileNameData.Caption := ExtractFileName(CurrentTaskList);
  sLbl_id_wallet.Caption       := FrmCreateTask.sEdID.Text;
  GetProcessingInformation;
  LVSaveTaskListToFile(CurrentTaskList);
  SaveSettings;
end;

procedure TFrmMain.Act_TaskEditExecute(Sender: TObject);
var
  s_temp : String;
  i      : integer;
begin
  if sLV.Items.Count = 0 then Exit;

    //s_temp :=  ExtractParam('-t', sLV.Items[sLV.Selected.Index].Caption);
    //s_temp := s_temp + ' ' + ExtractParam('-path', sLV.Items[sLV.Selected.Index].Caption);
    //s_temp := s_temp + ' ' + ExtractParam('-mem', sLV.Items[sLV.Selected.Index].Caption);
    //ShowMessage(s_temp);

  With FrmChengeSettings do
  begin
    s_temp := ExtractParam('-path', sLV.Items[sLV.Selected.Index].SubItems[c_cmd]);
    if s_temp <> '' then
    begin
      sChBoxPathEnable.Checked := true;
      sDirEdPath.Text          := s_temp;
    end;
    s_temp := ExtractParam('-t', sLV.Items[sLV.Selected.Index].SubItems[c_cmd]);
    if s_temp <> '' then sSpEdThreads.Value := StrToInt(s_temp);
    sSpEdThreadsChange(Nil);
    Apply := false;
    ShowModal;

   // close FrmChengeSettings
   LockControls(lcAll);

   if sLV.Items.Count > REC_RANGE then
     FrmProgressBar.StartShow(lmChanging, sLV.Items.Count-1);

   sLV.SkinData.BeginUpdate;
   sLV.Items.BeginUpdate;
   if sRdBtnAllItems.Checked then
   begin
     for i := 0 to sLV.Items.Count -1 do
     begin
       if (i mod 10) = 0 then Application.ProcessMessages;
       if FrmProgressBar.Visible then FrmProgressBar.ProgressNext(i);

      // Old metod
      //s_temp := '%Plotter%';
      //s_temp := s_temp + ' -id ' + ExtractParam('-id', sLV.Items[sLV.Selected.Index].Caption);
      //s_temp := s_temp + ' -sn ' + ExtractParam('-sn', sLV.Items[sLV.Selected.Index].Caption);
      //s_temp := s_temp + ' -n ' + ExtractParam('-n', sLV.Items[sLV.Selected.Index].Caption);

      s_temp := '-n ' + ExtractParam('-n', sLV.Items[i].SubItems[c_cmd]);
      s_temp := Copy(sLV.Items[i].SubItems[c_cmd], 1 ,
                    AnsiPos(s_temp, sLV.Items[i].SubItems[c_cmd]) + Length(s_temp)-1);
      s_temp := s_temp + ' -t ' + IntToStr(sSpEdThreads.Value);
      if sChBoxPathEnable.Checked then s_temp := s_temp + ' -path ' + sDirEdPath.Text;
      s_temp := s_temp + ' -mem ' + StringReplace(FloatToStr(sSpEdMem.Value * 0.001), ',', '.', [])+'G';
      sLV.Items[i].SubItems[c_cmd] := s_temp;

     end;
   end
     else
   begin
     for i:=0 to sLV.Items.Count -1 do
     begin
       if sLV.Items[i].Selected then
       begin
         if (i mod 10) = 0 then Application.ProcessMessages;
         if FrmProgressBar.Visible then FrmProgressBar.ProgressNext(i);

         s_temp := '-n ' + ExtractParam('-n', sLV.Items[i].SubItems[c_cmd]);
         s_temp := Copy(sLV.Items[i].SubItems[c_cmd], 1 ,
                    AnsiPos(s_temp, sLV.Items[i].SubItems[c_cmd]) + Length(s_temp)-1);
         s_temp := s_temp + ' -t ' + IntToStr(sSpEdThreads.Value);
         if sChBoxPathEnable.Checked then s_temp := s_temp + ' -path ' + sDirEdPath.Text;
         s_temp := s_temp + ' -mem ' + StringReplace(FloatToStr(sSpEdMem.Value * 0.001), ',', '.', [])+'G';
         sLV.Items[i].SubItems[c_cmd] := s_temp;
       end;
     end;
   end;

   sLV.Items.EndUpdate;
   sLV.SkinData.EndUpdate;
   slv.Refresh;
   FrmProgressBar.StopClose;
  end;

  LVSaveTaskListToFile(CurrentTaskList);
  UnLockControls;
end;

procedure TFrmMain.Act_TaskSplitExecute(Sender: TObject);
var
  i,j, sale, share, cnt_share, counter: Integer;
  Section: String;
  INI : TIniFile;
begin

  if sLV.Items.Count < 2 then
  begin
    MessageBox(Handle, PChar(msg_FrmMain_PM_SplitTask_01),
                     PChar(MB_CAPTION), MB_ICONWARNING);
    Exit;
  end;

  with FrmSplitTask do
  begin
    Apply                     := false;
    //sDirEditTask.Text         := ExcludeTrailingPathDelimiter(CurrPath);
    sLblTaskNameData.Caption  := CurrentTaskName;
    sSpEditCountNode.MaxValue := sLV.Items.Count;
    sSpEditCountNode.Value    := 2;
    sLVFileNameList.Clear;
    ImageList.Clear;
    AddAssociatedIcon(CurrentTaskList, ImageList);
    sSpEditCountNodeChange(Nil);
    ShowModal;

    // Close FrmSplitTask

    if Apply = false then Exit;

    share  := sLV.Items.Count div sSpEditCountNode.Value;
    sale   := slv.Items.Count mod sSpEditCountNode.Value;

    counter := 0;
    for i:=0 to sLVFileNameList.Items.Count -1 do
    begin

      if FileExists(sLVFileNameList.Items[i].Caption) then
        DeleteFile(sLVFileNameList.Items[i].Caption);

      INI := TIniFile.Create(sLVFileNameList.Items[i].Caption);

      try
        INI.WriteString('INFO', 'TaskName', CurrentTaskName + '_Node' + Format('%.3d', [Succ(i)]));
        INI.WriteString('INFO', 'ID_Wallet', sLbl_id_wallet.Caption);
        INI.WriteInteger('INFO', 'Version', TL_VERSION);
        INI.WriteInteger('INFO', 'POCVersion', Integer(TPoC(PoCVersion)));

        if i <= Pred(sale) then cnt_share := succ(share)
        else cnt_share := share;

        for j:=1 to cnt_share do
        begin
          Section := ExtractParam('-sn', AnsiLowerCase(sLV.Items[counter].SubItems[c_cmd]));
          INI.WriteString(Section,'Command', sLV.Items[counter].SubItems[c_cmd]);
          INI.WriteBool(Section, 'Checked', sLV.Items[counter].Checked);
          INI.WriteString(Section, 'FileSize', sLV.Items[counter].SubItems[c_size]);
          INI.WriteString(Section, 'ProcessStatus', sLV.Items[counter].SubItems[c_stat]);
          INI.WriteString(Section, 'ProcessTime', sLV.Items[counter].SubItems[c_int_time]);
          inc(counter);
        end;

      finally
        INI.Free;
      end;

      Application.ProcessMessages;
    end;
  end;
end;

procedure TFrmMain.Act_ClearResultsExecute(Sender: TObject);
var SectionName: String;
begin
  if (sLV.Items.Count = 0) or (sLV.SelCount = 0) Then Exit;

  INI := TIniFile.Create(CurrentTaskList);
  try
    slv.Items.BeginUpdate;
    for I:=0 to sLV.Items.Count -1 do
    begin
      if Not slv.Items[I].Selected then Continue;
      sLV.Items[I].SubItems[c_int_time] := '0';
      slV.Items[I].SubItems[c_time]     := '00d 00h 00m 00s'; //GetMilisecondsFormat(0, TS_DAY, TS_Alfa);
      sLV.Items[I].SubItems[c_stat]     := '';
      sLV.Items[I].SubItems[c_move]     := '';
      SectionName := ExtractParam('-sn', AnsiLowerCase(sLV.Items[I].SubItems[c_cmd]));
      INI.WriteInteger(SectionName, 'ProcessTime', 0);
      INI.WriteString(SectionName, 'ProcessStatus', '');
      INI.WriteString(SectionName, 'Move', '');
    end;
    sLV.Items.EndUpdate;
  finally
    INI.Free;
  end;
  GetProcessingInformation;
end;

procedure TFrmMain.Act_ExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.Act_ExportToBatFileExecute(Sender: TObject);
var st: TStrings;
    i : integer;
    Plotter: TPlotter;
    selectXPlotter: TPlotter;
    NameXPlotter: String;
begin
  if sLV.Items.Count = 0 then
  begin
    MessageBox(Handle, PChar(msg_FrmMain_sBtnSaveBat_01), PChar(MB_CAPTION), MB_ICONWARNING);
    Exit;
  end;

  if Not sSaveDlg.Execute then Exit;
  st := TStringList.Create;

  Case typePlotter of
    XPlotter_sse:  FrmSelPlotter.sRdBtnXPlotter_sse.Checked  := true;
    XPlotter_avx:  FrmSelPlotter.sRdBtnXPlotter_avx.Checked  := true;
    XPlotter_avx2: FrmSelPlotter.sRdBtnXPlotter_avx2.Checked := true;
  End;

  FrmSelPlotter.ShowModal;

  selectXPlotter := XPlotter_sse;
  if FrmSelPlotter.sRdBtnXPlotter_avx.Checked then selectXPlotter  := XPlotter_avx;
  if FrmSelPlotter.sRdBtnXPlotter_avx2.Checked then selectXPlotter := XPlotter_avx2;

  st.Add('@setlocal');
  st.Add('@cd /d %~dp0');
  st.Add('set Plotter=' + strPlotter[selectXPlotter]+'.exe');
  st.Add('set id_wallet=' + sLbl_id_wallet.Caption);

  //if (FrmCreateTask.sCmBoxExSelectDisk.Text <> '') and (FrmCreateTask.sEdPath.Text <> '') then
  //  st.Add('mkdir ' + FrmCreateTask.sCmBoxExSelectDisk.Text + FrmCreateTask.sEdPath.Text);

  try
    for i := 0 to sLV.Items.Count - 1 do
    begin
      st.Add(sLV.Items[i].SubItems[c_cmd]);
    end;
    st.SaveToFile(sSaveDlg.FileName);
  finally
    st.Free;
  end;

  MessageBox(Handle, PChar(msg_FrmMain_sBtnSaveBat_02), PChar(MB_CAPTION), MB_ICONINFORMATION);
end;

procedure TFrmMain.Act_OpenAuditExecute(Sender: TObject);
var i, x : Integer;
    PlotName: String;
    s_nonce: String;
    GB: Int64;
begin

  if sLV.Items.Count = 0 then
  begin
    MessageBox(Handle, PChar('The List empty'), PChar(MB_CAPTION),
                MB_ICONWARNING);
    Exit;
  end;

  FrmAudit.slv.Items.BeginUpdate;
  FrmAudit.slv.Items.Clear;
  GB := 1073741824; // 1 GigaByte


  for i:=0 to sLV.Items.Count -1 do
  begin
    x := FrmAudit.AddLVItem;
    s_nonce  := ExtractParam('-n', sLV.Items[i].SubItems[c_cmd]);
    case PoCVersion of
      POC1: PlotName := sLbl_id_wallet.Caption + '_'
                        + ExtractParam('-sn', sLV.Items[i].SubItems[c_cmd])
                        + '_' + s_nonce + '_' + s_nonce;
      POC2: PlotName := sLbl_id_wallet.Caption + '_'
                        + ExtractParam('-sn', sLV.Items[i].SubItems[c_cmd])
                        + '_' + s_nonce;
    end;

    FrmAudit.sLV.Items[x].SubItems[c_aud_fname] := PlotName;
    FrmAudit.sLV.Items[x].SubItems[c_aud_fz]    := FormatFileSize((StrToInt(s_nonce) div NONCE) * GB);
  end;

  FrmAudit.sLV.Items.EndUpdate;
  FrmAudit.Apply := false;
  FrmAudit.ShowModal;

  if FrmAudit.Apply = false then exit;

  for i := 0 to sLV.Items.Count -1 do
    if FrmAudit.sLV.Items[i].Checked then sLV.Items[i].Checked := true;

end;

procedure TFrmMain.Act_OpenTaskListExecute(Sender: TObject);
var INI : TIniFile;
begin
  OpenDlg.Filter := 'Text files *.txt|*.txt';
  OpenDlg.InitialDir := CurrPath;
  if Not OpenDlg.Execute then Exit;

  sLV.Clear;
  LockControls(lcAll);
  LVLoadTaskListFromFile(OpenDlg.FileName);
  CurrentTaskList := OpenDlg.FileName;
  INI := TIniFile.Create(FileConfig);
  try
    INI.WriteString(SETTINGS, CValue(CommandList), CurrentTaskList);
  finally
    INI.free;
  end;
  UnLockControls;
end;

procedure TFrmMain.Act_StartExecute(Sender: TObject);
var
    SR           : TSearchRec;
    FindDir      : String;
    SourcePath   : String;
    FileSourPlot : String;
    FileDestPlot : string;
    INI          : TIniFile;
    i, j         : integer;
    FindPlot     : Boolean;
    ProcExitCode : Cardinal;
    CommandLine  : String;
    SectionName  : String;
    MoveResult   : TMoveResult;
    BeginTime1   : Cardinal;
    BeginTime2   : Cardinal;
    CommonTime   : Cardinal;
    STLock       : TStrings;
    time_wait    : Cardinal;
    sum_time     : Cardinal;
begin

  if sLV.Items.Count = 0 then Exit;

  case PoCVersion of
    POC1:
      begin
        log('MODE: POC1');
        if Not FileExists(XPlotterFile) then
        begin
          if Not DecompressResNameToFile(strPlotter[typePlotter], RT_RCDATA, XPlotterFile) then
          begin
            MessageBox(Handle,
                 PChar(strGUIVal[msg_FrmMain_sBtnStart_01] + MB_CAPTION
                 + strGUIVal[msg_FrmMain_sBtnStart_02] + strPlotter[typePlotter]
                 + #13#10 + Error.GetSysErrorMessage(GetLastError)),
                 PChar(MB_CAPTION), MB_ICONERROR);
            Exit;
          end;
        end;
      end;

    POC2:
      Begin
        log('MODE: POC2');
        if Not FileExists(XPlotterFilePoc2) then
        begin
          if Not DecompressResNameToFile(strPlotter[typePlotterPoc2], RT_RCDATA, XPlotterFilePoc2) then
          begin
            MessageBox(Handle,
                 PChar(strGUIVal[msg_FrmMain_sBtnStart_01] + MB_CAPTION
                 + strGUIVal[msg_FrmMain_sBtnStart_02] + strPlotter[typePlotterPoc2]
                 + #13#10 + Error.GetSysErrorMessage(GetLastError)),
                 PChar(MB_CAPTION), MB_ICONERROR);
            Exit;
          end;
        end;
      End;
  end; {end case}

  INI := TIniFile.Create(CurrentTaskList);

  // Save list command to log
  {
  for i := 0 to sLv.Items.Count - 1 do
    SectionName := ExtractParam('-id', AnsiLowerCase(sLV.Items[i].Caption))
                   + '_' + ExtractParam('-sn', AnsiLowerCase(sLV.Items[i].Caption));

    INI.WriteString(SectionName, 'command', sLV.Items[i].Caption);
    INI.WriteBool(SectionName, 'Checked', sLV.Items[i].Checked);
  end;   }

  LockControls(lcStart);

  try

    TERMINATE_PROCESS := false;
    PROCESSING_START  := true;

    for i := 0 to sLV.Items.Count - 1 do
    begin
      Application.ProcessMessages;
      if TERMINATE_PROCESS then Break;
      if Not sLV.Items[i].Checked then Continue;
      for  j := 0 to sLV.Items.Count - 1 do sLV.Items[j].Selected := false;
      sLV.SetFocus;
      sLV.SelectItem(i);

      SectionName := ExtractParam('-sn', AnsiLowerCase(sLV.Items[i].SubItems[c_cmd]));

      // *** Create CommandLine ***
      Case PoCVersion of
        POC1: CommandLine := StringReplace(sLV.Items[i].SubItems[c_cmd], '%Plotter%', XPlotterFile, [rfIgnoreCase]);
        POC2: CommandLine := StringReplace(sLV.Items[i].SubItems[c_cmd], '%Plotter%', XPlotterFilePoc2, [rfIgnoreCase]);
      End;

      CommandLine := StringReplace(CommandLine, '%id_wallet%', sLbl_id_wallet.Caption, [rfIgnoreCase]);

      //*******  Create Process *******
      // clear saved time counter
      if sLV.Items[i].SubItems[c_stat] = strExitCode[EX_COMPLETE] then
      begin
        // no dialog
        //sLV.Items[i].SubItems[c_int_time] := '0';

        //if mast dialog
        if MessageBox(Handle, PChar('Do I need to reset the time counter.' +#10#13+
                            'If yes, press "YES". If no, press "NO"'),
                            PChar(MB_CAPTION), MB_YESNO or MB_ICONEXCLAMATION) = ID_YES then
          sLV.Items[i].SubItems[c_int_time] := '0';
      end;

      sLV.Items[i].SubItems[c_stat] := 'Create';

      BgnTimeProcessing := GetTickCount;
      ProcExitCode      := ExecAndWait(nil, PChar(CommandLine), PChar(ExtractFilePath(XPlotterFile)), SW_NORMAL, sLV.Items[i]);

      INI.WriteString(SectionName, 'ProcessTime', sLV.Items[i].SubItems[c_int_time]);
      INI.WriteInteger('INFO', 'ProgressBarProcessing', sProgressBarProcessing.Position);

      // Processing EXIT CODE
      case ProcExitCode of
        STATUS_WAIT_0:
          begin
            if TERMINATE_PROCESS then
            begin
              sLV.Items[i].SubItems[c_stat] := strExitCode[TExitCode(EX_STOPED)];  //'Stoped';
              INI.WriteString(SectionName, 'ProcessStatus', strExitCode[TExitCode(EX_CLOCE)]);
            end
            else
            begin
              sLV.Items[i].SubItems[c_stat] := strExitCode[TExitCode(EX_COMPLETE)];
              //if Not TERMINATE_PROCESS then
              sLV.Items[i].Checked := false;
              INI.WriteBool(SectionName, 'checked', false);
              INI.WriteString(SectionName, 'ProcessStatus', strExitCode[TExitCode(EX_COMPLETE)]);
              GetProcessingInformation;
            end;
          end;
        STATUS_CONTROL_C_EXIT:
          begin
            sLV.Items[i].SubItems[c_stat] := strExitCode[TExitCode(EX_CLOCE)];
            sLv.Items[i].Checked          := False;
            INI.WriteBool(SectionName, 'checked', false);
            INI.WriteString(SectionName, 'ProcessStatus', strExitCode[TExitCode(EX_CLOCE)]);
          end;
        WAIT_FAILED:
          begin
            sLV.Items[i].SubItems[c_stat] := strExitCode[TExitCode(EX_FILED)];
            sLV.Items[i].Checked          := false;
            INI.WriteBool(SectionName, 'checked', false);
            INI.WriteString(SectionName, 'ProcessStatus', strExitCode[TExitCode(EX_FILED)]);
            Break;
          end;
       else
         begin
           sLV.Items[i].SubItems[c_stat] := strExitCode[TExitCode(EX_UNKNOWN)];
           sLV.Items[i].Checked          := false;
           INI.WriteBool(SectionName, 'checked', false);
           INI.WriteString(SectionName, 'ProcessStatus', strExitCode[TExitCode(EX_UNKNOWN)]);
         end;
      end;

      // ********************  Move created file *********************

      if sChBoxMoveFile.Checked and (sDirEditDest.Text <> '')
         and (ProcExitCode = STATUS_WAIT_0) and (Not TERMINATE_PROCESS) then
      begin

        FindPlot   := false;
        SourcePath := ExtractParam('-path', sLV.Items[i].SubItems[c_cmd]);
        if SourcePath = '' then SourcePath := ExtractFileDir(XPlotterFile);
        SourcePath := IncludeTrailingPathDelimiter(SourcePath);

        // ******************** Find file *****************************
        if FindFirst(SourcePath + '*.*', faAnyFile, SR) = 0 then
        Repeat
          Application.ProcessMessages;
          if TERMINATE_PROCESS then
          begin
            MoveResult := MR_STOPED;
            Break;
          end;

          if ((SR.Attr and faDirectory) <> 0) or (SR.Name = '.') or (SR.Name = '..') then Continue;

          if (AnsiPos(sLbl_id_wallet.Caption + '_' + SectionName, SR.Name) <> 0) then
          begin
            FindPlot  := true;
            FileSourPlot := SR.Name;
            FileDestPlot := IncludeTrailingPathDelimiter(sDirEditDest.Text) + FileSourPlot;
            FindClose(SR);
            Break;
          end;

        until (FindNext(SR) <> 0);


        // **************************** Move **************************
        if FindPlot then
        begin

          //////////////////////////////////////////////////////////////////////
          // ------------------------ <Lock Move> --------------------------
          While sChBoxMoveInTurn.Checked and sChBoxMoveFile.Checked do
          begin
            Application.ProcessMessages;
            if TERMINATE_PROCESS then
            begin
              UnLockControls;
              sBtnStart.SetFocus;
              Exit;
            end;

            time_wait  := 0;
            BeginTime1 := 0;
            BeginTime2 := GetTickCount;
            CommonTime := GetTickCount;

            while (sChBoxMoveFile.Checked and sChBoxMoveInTurn.Checked) do
            begin
              Application.ProcessMessages;
              if TERMINATE_PROCESS then
              begin
                UnLockControls;
                sBtnStart.SetFocus;
                exit;
              end;

              if ((GetTickCount - BeginTime1) div 1000) > time_wait then
              begin

                log('Range > time_wait');
                if FileExists(IncludeTrailingPathDelimiter(sDirEditDest.Text)+ lock_file) then
                begin

                  if CheckSelfLocked(IncludeTrailingPathDelimiter(sDirEditDest.Text) + lock_file) then
                  begin
                    log('CheckSelfLocked = true');
                    Break;
                  end;

                end
                else
                begin
                  break;
                end;

                BeginTime1 := GetTickCount;
                time_wait  := RandomRange(10, 30);
              end;


              if ((GetTickCount - BeginTime2) div 1000) > 1 then
              begin
                sLV.Items[i].SubItems[c_move] := 'pause: ' + GetMilisecondsFormat((GetTickCount - CommonTime), TS_HOUR, TS_Colon);
                BeginTime2 := GetTickCount;
              end;

              sleep(100);
            end;

            if LockFileCreate(FileSourPlot) then
            begin
              sLV.Items[i].SubItems[c_move] := '';
              log('FileExists 1 = false');
              Break;
            end;

            sleep(500);

          end; // ----------------------- < End Lock move > ------------------
          //////////////////////////////////////////////////////////////////////

          if Not (FileExists(FileDestPlot) and (sChBoxReWrite.Checked = false)) then
          begin
            if ExtractFileDrive(SourcePath) = ExtractFileDrive(sDirEditDest.Text) then
            begin
              if MoveFile(PChar(SourcePath + FileSourPlot), PChar(FileDestPlot)) then
                MoveResult := MR_COMPLETE
              else
                MoveResult := MR_ERROR;
            end
            else
            begin
              FrmProgressBarMoveFile.ShowmodalMoveFile(SourcePath + FileSourPlot, FileDestPlot);
              MoveResult := FrmProgressBarMoveFile.MoveResult;
              if MoveResult = MR_COMPLETE then
              begin
                // To Add time result
                if MM_ToAddTimeResults.Checked then
                begin
                  sum_time := StrToInt(sLV.Items[i].SubItems[c_int_time]) + FrmProgressBarMoveFile.TimeResult;
                  sLV.Items[i].SubItems[c_int_time] := IntToStr(sum_time);
                  sLV.Items[i].SubItems[c_time]     := GetMilisecondsFormat(sum_time, TS_DAY, TS_Alfa);
                  INI.WriteString(SectionName, 'ProcessTime', sLV.Items[i].SubItems[c_int_time]);
                end;
              end;
            end;
          end;

          sLV.Items[i].SubItems[c_move] := strMoveResult[MoveResult];

          if LOCK_MOVE_CREATE = true then
          begin
            if DeleteFile(IncludeTrailingPathDelimiter(sDirEditDest.Text) + lock_file) then
            begin
              LOCK_MOVE_CREATE := false;
              log('DeleteFile = true ' + IncludeTrailingPathDelimiter(sDirEditDest.Text) + lock_file)
            end
            else log('DeleteFile = false ' + IncludeTrailingPathDelimiter(sDirEditDest.Text) + lock_file)
          end;
        end;

        if (NOT FindPlot) and (NOT TERMINATE_PROCESS) then MoveResult := MR_NOTFOUND;
        INI.WriteString(SectionName, 'Move', strMoveResult[MoveResult]);
      end;

    end;

  finally
    INI.Free;
    PROCESSING_START := false;
  end;


  UnLockControls;
  sBtnStart.SetFocus;
end;

procedure TFrmMain.Act_StopExecute(Sender: TObject);
begin
  TERMINATE_PROCESS := true;
end;

procedure TFrmMain.Act_TaskClearExecute(Sender: TObject);
var
  st: TStrings;
   i: Integer;
begin
  if sLV.Items.Count = 0 then Exit;
  if MessageBox(Handle, PChar(msg_FrmMain_ClearTaskList),PChar(MB_CAPTION),
                MB_ICONWARNING or MB_YESNO) = ID_NO then Exit;

  LockControls(lcAll);
  INI := TIniFile.Create(CurrentTaskList);
  st  := TStringList.Create;

  try
    INI.ReadSections(st);

    if st.Count > REC_RANGE then FrmProgressBar.StartShow(lmDeleting, st.Count-1);

    for i := 0 to st.Count -1 do
    begin
      if (i mod 10) = 0 Then Application.ProcessMessages;
      if FrmProgressBar.Visible then FrmProgressBar.ProgressNext(i);

      if st.Strings[i] = 'INFO' then continue;
      INI.EraseSection(st.Strings[i]);
    end;

    INI.WriteInteger('INFO', 'ProgressBarProcessing',0);
  finally
    st.Free;
    INI.Free;
    UnLockControls;
  end;

  sLV.Clear;
  FrmProgressBar.StopClose;
end;

procedure TFrmMain.Act_TaskCloseExecute(Sender: TObject);
begin
  CurrentTaskList := '';
  CurrentTaskName := '';
  sLblTaskFileNameData.Caption := '';
  sLblTaskNameData.Caption     := '';
  sLblPocVerData.Caption       := '';
  sLbl_id_wallet.Caption       := '';
  sLV.Clear;
end;

function TFrmMain.AddAssociatedIcon(FileName: String;
  ImageList: TImageList): Integer;
var
  icon: Ticon;
  wd: WORD;
begin
  // Add associated Icon
  Result := -1;
  try
    Icon := TIcon.Create;
    wd := 0;
    Icon.Handle := ExtractAssociatedIcon(HInstance, PChar(FileName), wd);
    if icon.HandleAllocated then
      Result := ImageList.AddIcon(icon)
    else
    begin
      //ImageList.GetIcon(wd, icon);
      //ImageList.AddIcon(icon);
    end;

  finally
    Icon.Free;
  end;
end;

procedure TFrmMain.AddItemsToTaskList;
var
  i, x: Integer;
  s1, s2   : String;
  path     : String;
  FileSize : String;
  sn: Int64;
begin

  sn := StrToInt64(Trim(FrmCreateTask.sEdStartNonce.Text));
  if FrmCreateTask.sChBoxPathEnable.Checked then
    path := ' -path ' + FrmCreateTask.sCmBoxExSelectDisk.Text +
            ExcludeTrailingPathDelimiter(TRegEx.Replace(FrmCreateTask.sEdPath.Text,'^[\\]', '', []));

  //s1 := '%Plotter%' + ' -id ' + FrmCreateTask.sEdID.Text + ' -sn ';
  s1 := '%Plotter% -id %id_wallet% -sn ';
  s2 := ' -n ' + FrmCreateTask.sSpEdNonces.Text
              + ' -t ' + FrmCreateTask.sSpEdThreads.Text + path
              + ' -mem ' + FrmCreateTask.ConvertValueMem + 'G';

  if FrmCreateTask.sSpEdCount.Value > REC_RANGE then
    FrmProgressBar.StartShow(lmAdding, FrmCreateTask.sSpEdCount.Value);
  sLV.SkinData.BeginUpdate;
  sLV.Items.BeginUpdate;
  FileSize := IntToStr(FrmCreateTask.sSpEdNonces.Value div NONCE) + ' GB';

  for i := 1 to FrmCreateTask.sSpEdCount.Value do
  begin
    if (i mod 10) = 0 then Application.ProcessMessages;
    if FrmProgressBar.Visible then FrmProgressBar.ProgressNext(i);
    x := AddLVItem;
    sLV.Items[x].Checked          := true;
    sLV.Items[x].SubItems[c_cmd]  := s1 + intToStr(sn) + s2;
    sLV.Items[x].SubItems[c_size] := FileSize;
    inc(sn, FrmCreateTask.sSpEdNonces.Value);
  end;

  sLV.Items.EndUpdate;
  sLV.SkinData.EndUpdate;
  sLV.Refresh;
  FrmCreateTask.sEdStartNonce.Text := IntToStr(sn);
  FrmProgressBar.StopClose;

end;

function TFrmMain.CheckSelfLocked(FileName: String): Boolean;
var STlock: TStrings;
 s_temp: String;
 pos, i: SmallInt;

begin
  Result := false;
  STlock := TStringList.Create;
  try

    try
      STlock.LoadFromFile(FileName);
      if (STlock.Count = 0) or (STlock.Count > MAXSHORT) then exit;
      for i:=0 to STlock.Count -1 do
      begin
        pos := AnsiPos('HostName', STlock.Strings[i]);
        if pos <> 0 then
        begin
          pos := AnsiPos(':', STlock.Strings[i]);
          copy(STlock.Strings[i], pos + 1, length(STlock.Strings[i]) - (length('HostName') + 1));
          if pos <> 0 then s_temp := copy(STlock.Strings[i], pos + 1, length(STlock.Strings[i]) - (length('HostName') + 1));
          if s_temp = GetComputerNetName then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;
    except
      Exit;
    end;

  finally
    STlock.Free;
  end;

end;



function TFrmMain.CValue(TValue: TConfigValues): String;
begin
  Result := strConfigValues[Integer(TConfigValues(TValue))];
end;


function TFrmMain.ExtractParam(Param, StrValue: AnsiString): AnsiString;
var
  i, n: SmallInt;
    pos: integer;
    ls: integer;
begin
  Result := '';
  pos := AnsiPos(Param, StrValue);
  if pos = 0 then Exit;
  ls := pos + Length(Param+' ');
  while StrValue[ls] <> #0 do
  begin
    if StrValue[ls] = ' ' then Break;
    Inc(ls);
  end;
  result := copy(StrValue, pos + Length(Param) + 1,  ls - (pos + Length(Param) + 1) );
end;

function TFrmMain.ExecAndWait(AppName, CommandLime, CurrentDir: PChar; CmdShow: integer; LVItem: TListItem): Longword;
var { by Pat Ritchey }
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  AppIsRunning: DWORD;
  Counter: SmallInt;
  ProcessTime: Cardinal;
  SavedTime  : Cardinal;
begin
  Counter := 0;
  GetDir(0, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb          := SizeOf(StartupInfo);
  StartupInfo.dwFlags     := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := CmdShow;
  SavedTime               := StrToInt(LVItem.SubItems[c_int_time]);
  if not CreateProcess(AppName,
    CommandLime,          // pointer to command line string
    nil,                  // pointer to process security attributes
    nil,                  // pointer to thread security attributes
    False,                // handle inheritance flag
    CREATE_NEW_CONSOLE or // creation flags
    NORMAL_PRIORITY_CLASS,
    nil,                  //pointer to new environment block
    CurrentDir,           // pointer to current directory name
    StartupInfo,          // pointer to STARTUPINFO
    ProcessInfo)          // pointer to PROCESS_INF
    then Result := WAIT_FAILED
  else
  begin
    while WaitForSingleObject(ProcessInfo.hProcess, 0) = WAIT_TIMEOUT do
    begin
      Application.ProcessMessages;
      if TERMINATE_PROCESS then TerminateProcess(ProcessInfo.hProcess, NO_ERROR);

      // *** Time Progress Info ***
      if Counter > 20 then
      begin
        Counter := 0;
        ProcessTime                 := (GetTickCount - BgnTimeProcessing) + SavedTime;
        LVItem.SubItems[c_time]     := GetMilisecondsFormat(ProcessTime, TS_DAY, TS_Alfa);
        LVItem.SubItems[c_int_time] := IntToStr(ProcessTime);
        GetProcessingInformation;
      end
      else Inc(Counter);

      Sleep(50);
    end;

    ProcessTime                 := (GetTickCount - BgnTimeProcessing) + SavedTime;
    LVItem.SubItems[c_time]     := GetMilisecondsFormat(ProcessTime, TS_DAY, TS_Alfa);
    LVItem.SubItems[c_int_time] := IntToStr(ProcessTime);
    GetProcessingInformation;

    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TERMINATE_PROCESS := true;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  suport: string;
  SysInfo: TSystemInfo;
  MemStatEx: TMemoryStatusEx;
  s: string;
begin
  WRITE_LOG             := true;
  Constraints.MinHeight := Height;
  Constraints.MinWidth  := Width;

  HostName    := GetComputerNetName;
  CurrPath    := ExtractFilePath(Application.ExeName);
  CurrentDisk := ExtractFileDrive(Application.ExeName);
  FileConfig  := CurrPath + 'Config.ini';
  LangPath    := CurrPath + 'Language\';
  sSkinManager.SkinDirectory := CurrPath + 'Skins';

  Caption := Caption + '  v. ' + Get_vertionInfo(Application.ExeName, True);
  LabelsClear;

  // CPU Instructions detect
  if IsCPUIDSuported then
  begin
    if DetectCPUFeature(cpu_SSE) then suport := 'SSE';
    if DetectCPUFeature(cpu_SSE2) then suport := suport + ', SSE2';
    if DetectCPUFeature(cpu_SSE3) then suport := suport + ', SSE3';
    if DetectCPUFeature(cpu_SSSE3) then suport := suport + ', SSSE3';
    if DetectCPUFeature(cpu_SSE_4_1) then suport := suport + ', SSE4.1';
    if DetectCPUFeature(cpu_SSE_4_2) then suport := suport + ', SSE4.2';
    if DetectCPUFeature(cpu_AVX) then suport := suport + ', AVX';
    if DetectCPUFeature(cpu_AVX2) then suport := suport + ', AVX2';
  end
  else
   begin
     suport := 'Function CPUID not suported';
     CPUInstruction := cpu_UNKNOWN;
   end;

  GetSystemInfo(SysInfo);
  MaxCore := SysInfo.dwNumberOfProcessors;
  sLblCPUData.Caption := TregEx.Replace(GetProcessorNameStr, '\s{3,}', '  ', [roIgnoreCase]) +
                         ' ['+IntToStr(MaxCore) + ' Cores]  ' + suport;
  //sLblInstructionsData.Caption := suport;

  MemStatEx.dwLength := SizeOf(MemStatEx);
  GlobalMemoryStatusEx(MemStatEx);
  MemTotalPhys  := MemStatEx.ullTotalPhys;

  // Set type XPlotter
  typePlotter     := XPlotter_sse;
  typePlotterPoc2 := XPlotter_sse_poc2;
  if DetectCPUFeature(cpu_AVX) then typePlotter      := XPlotter_avx;
  if DetectCPUFeature(cpu_AVX) then typePlotterPoc2  := XPlotter_avx_poc2;
  if DetectCPUFeature(cpu_AVX2) then typePlotter     := XPlotter_avx2;
  if DetectCPUFeature(cpu_AVX2) then typePlotterPoc2 := XPlotter_avx2_poc2;
  XPlotterFile     := CurrPath + strPlotter[typePlotter] + '.exe';
  XplotterFilePoc2 := CurrPath + strPlotter[typePlotterPoc2] + '.exe';

  ReConfig;

  LoadSettings;

  if CurrentTaskList <> '' then
  begin
    if ExtractFileDir(CurrentTaskList) = '' then
    CurrentTaskList := CurrPath + CurrentTaskList;
  end;

end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  sLV.SetFocus;
end;

function TFrmMain.LockFileCreate(FileMove: String): Boolean;
var STLock: TStrings;
begin
  Result := false;
  STLock := TStringList.Create;
  try
    LOCK_MOVE_CREATE := true;
    STLock.Add('HostName:' + HostName);
    STLock.Add('MoveFile:' + FileMove);
    try
      STLock.SaveToFile(sDirEditDest.Text + '\' + lock_file);
      Result := true;
    except
      Exit;
    end;
  finally
    STLock.Free;
  end;
end;

procedure TFrmMain.log(strValue: String);
begin
  if WRITE_LOG = false then exit;
  mm.Lines.Add(strValue);
end;

procedure TFrmMain.LabelsClear;
begin
  sLblTaskNameData.Caption     := '';
  sLblTaskFileNameData.Caption := '';
  sLbl_id_wallet.Caption       := '';
  sLblProcessingData.Caption   := '';
end;

procedure TFrmMain.LoadSettings;
Var INI : TIniFile;
begin

  INI := TIniFile.Create(FileConfig);

  try
    if INI.ReadBool(SETTINGS, 'Started', false) then
    begin
      // .......
    end;
    sDirEditDest.Text           := INI.ReadString(SETTINGS, CValue(DestDir), '');
    sChBoxMoveFile.Checked      := INI.ReadBool(SETTINGS, CValue(FileMove), false);
    sChBoxReWrite.Checked       := INI.ReadBool(SETTINGS, CValue(ReWrite), false);
    CurrentTaskList             := INI.ReadString(SETTINGS, CValue(CommandList), '');
    sSkinManager.SkinDirectory  := INI.ReadString(SETTINGS, CValue(SkinDirectory), '');
    sSkinManager.SkinName       := INI.ReadString(SETTINGS, CValue(SkinName), 'Material Dark (internal)');
    MOVE_BUFFER_SIZE            := INI.ReadInteger(SETTINGS, CValue(MoveBufferSize),0);
    CurrentLanguage             := INI.ReadString(SETTINGS, CValue(Language), '');
    sChBoxMoveInTurn.Checked    := INI.ReadBool(SETTINGS, CValue(MoveInTurn), false);
    MM_ToAddTimeResults.Checked := INI.ReadBool(SETTINGS, CValue(ToAddTime), false);
  finally
    INI.Free;
  end;

end;

procedure TFrmMain.LockControls(LockType: TLockControls);
begin
  case LockType of
    lcAll:
      begin
        Act_Start.Enabled           := false;
        Act_ExportToBatFile.Enabled := false;
        sDirEditDest.Enabled        := false;
        MM_AutoRun.Enabled          := false;
      end;
  end;
  sLV.HideSelection                  := false;
  Act_CreateNewTaskList.Enabled      := false;
  Act_Start.Enabled                  := false;
  Act_OpenTaskList.Enabled           := false;
  Act_AddPlots.Enabled               := false;
  Act_TaskClear.Enabled              := false;
  Act_TaskEdit.Enabled               := false;
  Act_TaskClose.Enabled              := false;
  Act_OpenAudit.Enabled              := false;
  Act_ClearResults.Enabled           := false;
  Act_ItemsCheckedAll.Enabled        := false;
  Act_ItemsUnCheckedAll.Enabled      := false;
  Act_ItemsSelectedChecked.Enabled   := false;
  Act_ItemsSelectedUnChecked.Enabled := false;
end;

procedure TFrmMain.LVLoadTaskListFromFile(FileName: String);
var
  i, x : integer;
  INI : TIniFile;
  st  : TStrings;
  str_cmd : string;
  s_temp: String;
  time  : Int64;
begin
  INI := TIniFile.Create(FileName);
  st  := TStringList.Create;
  try
    INI.ReadSections(st);
    if st.Count = 0 then exit;

    // check version
    if INI.ReadInteger('INFO', 'Version', 0) < TL_VERSION then Exit;

    // show FrmProgressBar
    if st.Count > REC_RANGE then FrmProgressBar.StartShow(lmLoading, st.Count-1);
    CurrentTaskName                 := INI.ReadString('INFO', 'TaskName', 'Default');
    sLblTaskNameData.Caption        := CurrentTaskName;
    sLbl_id_wallet.Caption          := INI.ReadString('INFO', 'ID_Wallet', '');
    sProgressBarProcessing.Position := INI.ReadInteger('INFO', 'ProgressBarProcessing', 0);
    PoCVersion                      := TPoC(INI.ReadInteger('INFO', 'POCVersion', 0));
    sLblPocVerData.Caption          := strPOC[PoCVersion];

    sLV.SkinData.BeginUpdate;
    sLV.Items.BeginUpdate;
    for i:=0 to st.Count - 1 do
    begin
      if (i mod 10) = 0 then Application.ProcessMessages;
      if FrmProgressBar.Visible then FrmProgressBar.ProgressNext(i);

      if st.Strings[i] = 'INFO' then Continue;

      str_cmd := INI.ReadString(st.Strings[i], 'Command','');
      if str_cmd <> '' then
      begin
        x := AddLVItem;
        sLV.Items[x].SubItems[c_cmd]  := str_cmd;
        sLV.Items[x].Checked          := INI.ReadBool(st.Strings[i], 'Checked', false);
        sLV.Items[x].SubItems[c_size] := INI.ReadString(st.Strings[i], 'FileSize', '');
        s_temp := INI.ReadString(st.Strings[i], 'ProcessTime','0');

        try
          time := StrToInt64(s_temp);
          sLV.Items[x].SubItems[c_time]     := GetMilisecondsFormat(time, TS_DAY, TS_Alfa);
          sLV.Items[x].SubItems[c_int_time] := IntToStr(time);
        except
          sLV.Items[x].SubItems[c_int_time] := '0';
        end;

        sLV.Items[x].SubItems[c_stat] := INI.ReadString(st.Strings[i], 'ProcessStatus', '');
        sLV.Items[x].SubItems[c_move] := INI.ReadString(st.Strings[i], 'Move', '');
      end;

    end;
    sLV.Items.EndUpdate;
    sLV.SkinData.EndUpdate;
    sLV.Refresh;

  finally
    INI.Free;
    st.Free;
    FrmProgressBar.StopClose;
  end;

end;

procedure TFrmMain.LVSaveTaskListToFile(FileName: String);
var
  INI: TIniFile;
    i: integer;
    Section: String;
begin
  if FileName = '' then Exit;
  INI := TIniFile.Create(FileName);
  try
    INI.WriteString('INFO','TaskName', CurrentTaskName);
    INI.WriteString('INFO','ID_Wallet', sLbl_id_wallet.Caption);
    INI.WriteInteger('INFO', 'POCVersion', Integer(TPoC(PoCVersion)));
    INI.WriteInteger('INFO', 'Version', TL_VERSION);

    if sLV.Items.Count > REC_RANGE then FrmProgressBar.StartShow(lmSaving, sLV.Items.Count -1);

    for i := 0 to sLV.Items.Count - 1 do
    begin
      if (i mod 10) = 0 then Application.ProcessMessages;
      if FrmProgressBar.Visible then FrmProgressBar.ProgressNext(i);
      //Section := ExtractParam('-id', sLV.Items[i].Caption) + '_' + ExtractParam('-sn', sLV.Items[i].Caption);
      Section := ExtractParam('-sn', sLV.Items[i].SubItems[c_cmd]);
      INI.WriteString(Section, 'Command', sLV.Items[i].SubItems[c_cmd]);
      INI.WriteBool(Section, 'Checked', sLV.Items[i].Checked);
      INI.WriteString(Section, 'FileSize', sLV.Items[i].SubItems[c_size]);
    end;

  finally
    INI.Free;
    FrmProgressBar.StopClose;
  end;
end;

procedure TFrmMain.MM_AutoRunClick(Sender: TObject);
var Reg: Tregistry;
begin

  if AutoRunCheckPass then
  begin
    AutoRunCheckPass := false;
    exit;
  end;

  if MM_AutoRun.Checked then
  begin
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKey(RegKeyAutoRun, false) then
      begin
        Reg.WriteString(MB_CAPTION, Application.ExeName);
        Reg.CloseKey;
        MessageBox(Handle, PChar(msg_FrmMain_AutoRunEnabledOk),
                   PChar(MB_CAPTION), MB_ICONINFORMATION);
      end
      else
      begin
        MessageBox(Handle, PChar(msg_FrmMain_AutoRunEnableBad),
                   PChar(MB_CAPTION), MB_ICONWARNING);
        AutoRunCheckPass   := true;
        MM_AutoRun.Checked := false;
      end;

    finally
      Reg.Free;
    end;
  end
    else
  begin

    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKey(RegKeyAutoRun, false) then
      begin
        if Reg.DeleteValue(MB_CAPTION) then
          MessageBox(Handle, PChar(msg_FrmMain_AutoRunCloseOk),
                     PChar(MB_CAPTION), MB_ICONINFORMATION)
        else
        begin
          MessageBox(Handle, PChar(msg_FrmMain_AutoRunCloseBad),
                     PChar(MB_CAPTION), MB_ICONWARNING);
          AutoRunCheckPass      := true;
          MM_AutoRun.Checked := True;
        end;
      end
      else
      begin
        MessageBox(Handle, PChar(msg_FrmMain_AutoRunCloseBad),
                    PChar(MB_CAPTION), MB_ICONWARNING);
        AutoRunCheckPass   := true;
        MM_AutoRun.Checked := True;
      end;

      AutoRunCheckPass := true;
    finally
      Reg.Free;
    end;

  end;
end;

procedure TFrmMain.MM_ShowDebugsInfoClick(Sender: TObject);
begin
  if MM_ShowDebugsInfo.Checked then
  begin
    mm.Visible := true;
  end
  else
  begin
    mm.Visible := false;
  end;
end;

procedure TFrmMain.LVLoadTaskListFromFileOld(FileName: String);
var i, x: integer;
    st: TStrings;
    s_temp: string;
begin
  st := TStringList.Create;
  try
    st.LoadFromFile(FileName);
    if st.Count = 0 then exit;

    // show FrmProgressBar
    if st.Count > REC_RANGE then FrmProgressBar.StartShow(lmLoading, st.Count-1);

    sLV.SkinData.BeginUpdate;
    sLV.Items.BeginUpdate;

    for i := 0 to st.Count - 1 do
    begin
      if (i mod 10) = 0 then Application.ProcessMessages;
      if FrmProgressBar.Visible then FrmProgressBar.ProgressNext(i);
      x := AddLVItem;
      sLV.Items[x].SubItems[c_cmd] := st.Strings[i];
      s_temp := ExtractParam('-sn', st.Strings[i]);
      if s_temp <> '' then sLV.Items[x].SubItems[c_size] := IntToStr(StrToInt(s_temp) div NONCE) + ' GB';
    end;

    sLV.Items.EndUpdate;
    slv.SkinData.EndUpdate;
    sLV.Refresh;

  finally
    st.free;
    FrmProgressBar.StopClose;
  end;

end;

procedure TFrmMain.PM_ASkinSelectDirClick(Sender: TObject);
var INI: TIniFile;
  Options: TSelectDirExtOpts;
  ChosenDirectory: String;
begin

  Options := [sdShowShares, sdNewUI];
  if Not SelectDirectory(strGUIVal[pm_ASkinSelectDir_SelDir],'',ChosenDirectory, Options, Nil) then Exit;
  if ChosenDirectory = '' then Exit;

  sSkinManager.SkinDirectory := ChosenDirectory;

  INI := TIniFile.Create(FileConfig);
  try
    INI.WriteString(SETTINGS, CValue(SkinDirectory), ChosenDirectory);
  finally
    INI.Free;
  end;

end;

procedure TFrmMain.PM_OpenSettingsClick(Sender: TObject);
begin
  FrmSettings.ShowModal;
end;

procedure TFrmMain.PM_OpenTaskListClick(Sender: TObject);
var INI : TIniFile;
begin
  OpenDlg.Filter := 'Text files *.txt|*.txt';
  OpenDlg.InitialDir := CurrPath;
  if Not OpenDlg.Execute then Exit;

  sLV.Clear;
  LockControls(lcAll);
  LVLoadTaskListFromFile(OpenDlg.FileName);
  CurrentTaskList := OpenDlg.FileName;
  INI := TIniFile.Create(FileConfig);
  try
    INI.WriteString(SETTINGS, CValue(CommandList), CurrentTaskList);
  finally
    INI.free;
  end;
  UnLockControls;
end;

procedure TFrmMain.ReConfig;
var st: TStrings;
     i: Integer;
begin
  INI := TIniFile.Create(FileConfig);
  try
    st := TStringList.Create;
    INI.ReadSections(st);
    if st.Count = 0 then Exit;

    // Delete Old Sections
    INI.EraseSection('');
    for i := 0 to st.Count-1 do
       if (st.Strings[i] <> SETTINGS) then INI.EraseSection(st.Strings[i]);

    st.Clear;

    INI.ReadSectionValues(SETTINGS, st);
    if st.Count = 0 then Exit;

    // Deletr Old Key
    for i := 0  to st.Count -1 do
    begin
      st.Strings[i] := Copy(st.Strings[i], 1, AnsiPos('=', st.Strings[i])-1);
      if Not AnsiMatchStr(st.Strings[i], strConfigValues) then INI.DeleteKey(SETTINGS, st.Strings[i]);
    end;

    // Add Vertion
    INI.WriteString(SETTINGS, CValue(Version), Get_vertionInfo(Application.ExeName, True));

    // ADD new Key;
    if Not INI.ValueExists(SETTINGS, CValue(MoveBufferSize)) then
      INI.WriteInteger(SETTINGS, CValue(MoveBufferSize), 0);

  finally
    st.Free;
    INI.Free;
  end;
end;

function TFrmMain.RemoveSpace(StrValue: AnsiString): AnsiString;
var
 Maxlen: Integer;
 cnt,i: integer;
 MAX_SPACE : Integer;
begin
  Result    := StrValue;
  cnt       := 1;
  Maxlen    := Length(Result);
  MAX_SPACE := 0;

  while Result[cnt] <> #0 do
  begin;
    Application.ProcessMessages;

    if Result[cnt] = ' ' then
    begin
      inc(i);
      if i > MAX_SPACE then MAX_SPACE := i;
    end
    else i := 0;
    inc(cnt);
  end;

  for i := MAX_SPACE downto 2 do
  begin
    Result := StringReplace(Result, StringOfChar(' ',i), ' ', [rfReplaceAll]);
  end;

end;

procedure TFrmMain.SaveSettings;
var INI: TIniFile;
begin
  INI := TIniFile.Create(FileConfig);
  try
    INI.WriteString(SETTINGS, CValue(Version), Get_vertionInfo(Application.ExeName, True));
    INI.WriteString(SETTINGS, CValue(id), FrmCreateTask.sEdID.Text);
    INI.WriteString(SETTINGS, CValue(Path), FrmCreateTask.sEdPath.Text);
    INI.WriteString(SETTINGS, CValue(StartNonce), FrmCreateTask.sEdStartNonce.Text);
    INI.WriteString(SETTINGS, CValue(DestDir), sDirEditDest.Text);
    INI.WriteBool(SETTINGS, CValue(FileMove), sChBoxMoveFile.Checked);
    INI.WriteBool(SETTINGS, CValue(ReWrite), sChBoxReWrite.Checked);
    INI.WriteBool(SETTINGS,  CValue(MoveInTurn), sChBoxMoveInTurn.Checked);
    INI.WriteString(SETTINGS, CValue(CommandList), CurrentTaskList);
    INI.WriteBool(SETTINGS, CValue(ToAddTime), MM_ToAddTimeResults.Checked);
  finally
    INI.Free;
  end;
end;

procedure TFrmMain.sBtnAddPlotsClick(Sender: TObject);
begin
  with FrmCreateTask do
  begin
    Apply                  := false;
    FrmShowMode            := FRM_ADDPLOTS;
    sBtnApply.Caption      := 'ADD PLOTS';
    sEdNewNameTask.Text    := CurrentTaskName;
    sEdNewNameTask.Enabled := false;
    ShowModal;
    if Not Apply then Exit;
  end;
  LockControls(lcAll);
  AddItemsToTaskList;
  UnLockControls;
  LVSaveTaskListToFile(CurrentTaskList);
  GetProcessingInformation;
  SaveSettings;

end;

function TFrmMain.ScanLock(ScanDir: String): boolean;
var SR: TSearchRec;
    SLocks: TStrings;
    i: SmallInt;
begin
  SLocks := TStringList.Create;

  try
    if FindFirst(ScanDir + '\*.lock', faAnyFile, SR) = 0 then
    Repeat
      if ((SR.Attr and faDirectory) <> 0) or (SR.Name = '.') or (SR.Name = '..') then Continue;
      mm.Lines.Add(SR.Name);
      SLocks.Add(SR.Name);

    until (FindNext(SR) <> 0);
    FindClose(SR);

    if SLocks.Count = 0 then
    begin

      Exit;
    end;

    for i:=0 to SLocks.Count -1 do
    begin

    end;

  finally
    SLocks.Free;
  end;
end;

procedure TFrmMain.sChBoxMoveFileClick(Sender: TObject);
begin
  if sChBoxMoveFile.Checked then
  begin
    sChBoxReWrite.Enabled    := true;
    sChBoxMoveInTurn.Enabled := true;
    sDirEditDest.Enabled     := true;
    sLblDestDir.Enabled      := true;
    sLblExperemental.Enabled := true;
  end
  else
  begin
    sChBoxReWrite.Enabled    := false;
    sChBoxMoveInTurn.Enabled := false;
    sDirEditDest.Enabled     := false;
    sLblDestDir.Enabled      := false;
    sLblExperemental.Enabled := false;
  end;
end;

procedure TFrmMain.SetCheckBoxItems(SelectedItems, CheckStatus: Boolean);
var i: integer;
    INI: TIniFile;
    Section: String;
begin

  if sLV.Items.Count = 0 then
  begin
    // message ...
    Exit;
  end;

  INI := TIniFile.Create(CurrentTaskList);
  try
    for i := 0 to sLV.Items.Count -1 do
    begin
      if SelectedItems = true then
      begin
        if sLV.Items[i].Selected = true then
        begin
          sLV.Items[i].Checked := CheckStatus;
          //mm.Lines.Add(sLV.Items[i].Caption);
          //Section := ExtractParam('-sn', sLV.Items[i].SubItems[c_cmd]);
          //INI.WriteBool(Section, 'Checked',CheckStatus);
        end;
      end
        else
      begin
        sLV.Items[i].Checked := CheckStatus;
        //Section := ExtractParam('-sn', sLV.Items[i].SubItems[c_cmd]);
        //INI.WriteBool(Section, 'Checked',CheckStatus);
      end;
    end;
  finally
    INI.Free;
  end;

end;

procedure TFrmMain.sLVEndColumnResize(sender: TCustomListView; columnIndex,
  columnWidth: Integer);
begin
  if columnIndex = (c_int_time + 1) then TmrHideLVItems.Enabled := true;
end;

function TFrmMain.GetComputerNetName: String;
var size: Cardinal;
begin
  SetLength(Result, 255);
  GetComputerName(@Result[1], size);
  Result := Copy(Result, 1, size);
end;

procedure TFrmMain.GetProcessingInformation;
var i: Integer;
    Complete: Integer;
    Performed: Real;
    TotalTime: Int64;
begin
  Complete := 0;
  sProgressBarProcessing.Max      := sLV.Items.Count;
  for i:=0 to sLV.Items.Count-1 do if sLV.Items[i].SubItems[c_stat] = strExitCode[TExitCode(EX_COMPLETE)] then Inc(Complete);

  sProgressBarProcessing.Position := Complete;

  if sLV.Items.Count = 0 then Performed := 0
  else Performed := (Complete * 100) / sLV.Items.Count;

  TotalTime := 0;
  for i := 0 to sLV.Items.Count -1 do
    TotalTime := TotalTime + StrToInt64(sLV.Items[i].SubItems[c_int_time]);

  sLblProcessingData.Caption := 'All Files: ' + IntToStr(sLV.Items.Count) + '     ' +
                            'Creating Files: ' + IntToStr(Complete) + '     '  +
                            'The task is performed for: ' + FormatFloat('00.00%', Performed) +
                            '   Total time: ' + GetMilisecondsFormat(TotalTime, TS_DAY, TS_Alfa);
end;

procedure TFrmMain.sSkinManagerAfterChange(Sender: TObject);
var
  INI: TIniFile;
begin
  INI := TIniFile.Create(FileConfig);
  try
    INI.WriteString(SETTINGS, CValue(SkinName), sSkinManager.SkinName);
  finally
    INI.Free;
  end;
end;

procedure TFrmMain.sSkinProviderTitleButtons0MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then SaveSettings;
end;

procedure TFrmMain.sWbLabelClick(Sender: TObject);
begin
  EdDonation.Text := TsWebLabel(sender).Caption;
  EdDonation.SelectAll;
  EdDonation.CopyToClipboard;
end;

procedure TFrmMain.TimerLoadTaskListTimer(Sender: TObject);
begin
  TimerLoadTaskList.Enabled := false;

  if FileExists(CurrentTaskList) then
  begin
    sLblTaskFileNameData.Caption := CurrentTaskList;
    LockControls(lcAll);
    LVLoadTaskListFromFile(CurrentTaskList);
    UnLockControls;
  end;

  GetProcessingInformation;

  if AutoRunCheck = true then
  begin
    AutoRunCheckPass   := true;
    MM_AutoRun.Checked := true;
    Act_StartExecute(Nil);
    //sBtnStartClick(Nil);
  end;

  if slv.Items.Count = 0 then sBtnNewTask.SetFocus
  else sBtnStart.SetFocus;

end;

procedure TFrmMain.TmrHideLVItemsTimer(Sender: TObject);
begin
  TmrHideLVItems.Enabled := false;
  if sLV.Columns[c_int_time + 1].Width = 0 then Exit;
    sLV.Columns[c_int_time + 1].Width := 0;
end;

procedure TFrmMain.UnLockControls;
begin
  MM_AutoRun.Enabled            := true;
  Act_CreateNewTaskList.Enabled := true;
  Act_OpenTaskList.Enabled      := true;
  Act_AddPlots.Enabled          := true;
  Act_ExportToBatFile.Enabled   := true;
  Act_Start.Enabled             := true;
  Act_TaskClear.Enabled         := true;
  Act_TaskEdit.Enabled          := true;
  Act_TaskClear.Enabled         := true;
  Act_TaskSplit.Enabled         := true;
  sDirEditDest.Enabled          := true;
  Act_TaskClose.Enabled         := true;
  Act_OpenAudit.Enabled         := true;
  Act_ClearResults.Enabled      := true;
  Act_ItemsCheckedAll.Enabled   := true;
  Act_ItemsUnCheckedAll.Enabled := true;
  Act_ItemsSelectedChecked.Enabled   := true;
  Act_ItemsSelectedUnChecked.Enabled := true;

end;

initialization



end.
