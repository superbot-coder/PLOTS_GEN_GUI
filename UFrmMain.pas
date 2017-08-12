unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sMemo, sSkinProvider,
  sSkinManager, sButton, sToolEdit, Vcl.Mask, sMaskEdit, sCustomComboEdit,
  sLabel, sCurrEdit, sCurrencyEdit, sEdit, acPopupCtrls, sSpinEdit,
  Vcl.ComCtrls, sComboBoxes, System.ImageList, Vcl.ImgList,
  sDialogs, Vcl.Menus, sStatusBar, acTitleBar, System.IniFiles, cpu_info_xe,
  sCheckBox, JvExControls, JvLabel, Vcl.FileCtrl, acProgressBar, ModFileFormatSize,
  Error, sListView, Compress, GetVer, System.RegularExpressions, Winapi.ShellApi,
  System.win.registry;

type TExitCode = (EX_COMPLETE, EX_STOPED, EX_CLOCE, EX_FILED, EX_UNKNOWN);
type TMoveResult = (MR_COMPLETE, MR_STOPED, MR_ERROR, MR_NOTFOUND);
type TPlotter   = (XPlotter_sse, XPlotter_avx, gpuPlotGenerator_x86, gpuPlotGenerator_x64);

var
 strExitCode:  Array[TExitCode] of string = ('Complete', 'Stoped', 'Cloce', 'Filed', 'Unknown');
 strMoveResult: Array[TMoveResult] of string = ('Complete', 'Stoped', 'Error', 'Not found');
 strPlotter: Array[TPlotter] of string = ('XPlotter_sse', 'XPlotter_avx', 'gpuPlotGenerator_x86', 'gpuPlotGenerator_x64');

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
    PM_ClearLVItems: TMenuItem;
    PM_ImportFromBatFile: TMenuItem;
    OpenDlg: TOpenDialog;
    sLblFXDonate: TsLabelFX;
    sWebLblDonatBurst: TsWebLabel;
    EdDonation: TEdit;
    sLblFXDonateBTC: TsLabelFX;
    sWbLblBTC: TsWebLabel;
    sLblCPUNameStr: TsLabel;
    sChBoxMoveFile: TsCheckBox;
    sLblDestDir: TsLabel;
    sProgressBar: TsProgressBar;
    sLblAmount: TsLabel;
    sLblFileInfo: TsLabel;
    sLblFileSize: TsLabel;
    sChBoxReWrite: TsCheckBox;
    sLblCopySpeed: TsLabel;
    sDirEditDest: TsDirectoryEdit;
    sSkinSelector1: TsSkinSelector;
    sOpenDlgLastNonce: TsOpenDialog;
    sLV: TsListView;
    ImgListLV: TImageList;
    PM_LoadTaskListFromFileOLD: TMenuItem;
    sLblTaskFileName: TsLabel;
    sBtnAddPlots: TsButton;
    sLblProcessing: TsLabel;
    sLblTaskName: TsLabel;
    sProgressBarProcessing: TsProgressBar;
    PM_ChangeSettings: TMenuItem;
    PM_SplitTask: TMenuItem;
    sChBoxAutorun: TsCheckBox;
    function AddAssociatedIcon(FileName: String; ImageList: TImageList): Integer;
    procedure sBtnSaveBatClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sBtnStartClick(Sender: TObject);
    function ExecAndWait(AppName, CommandLime, CurrentDir: PChar; CmdShow: Integer; LVItem: TListItem): Longword;
    procedure sBtnNewTaskClick(Sender: TObject);
    procedure sBtnStopClick(Sender: TObject);
    procedure PM_ClearLVItemsClick(Sender: TObject);
    procedure PM_ImportFromBatFileClick(Sender: TObject);
    procedure sWbLabelClick(Sender: TObject);
    procedure SaveSettings;
    procedure LoadeSettings;
    procedure sSkinProviderTitleButtons0MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    function CopyFileStrmProgress(FSource, FDest: String): Boolean;
    function ExtractParam(Param, StrValue: AnsiString): AnsiString;
    procedure sSkinManagerAfterChange(Sender: TObject);
    procedure AddLVItem(StrValue: String);
    procedure LVLoadTaskListFromFile(FileName: String);
    procedure LVLoadTaskListFromFileOld(FileName: String);
    procedure PM_LoadTaskListFromFileOLDClick(Sender: TObject);
    procedure LVSaveTaskListToFile(FileName: String);
    procedure sBtnAddPlotsClick(Sender: TObject);
    function RemoveSpace(StrValue: AnsiString): AnsiString;
    function GetMilisecondsFormat(Milliseconds: Cardinal): String;
    procedure GetProcessingInformation;
    procedure AddItemsToTaskList;
    procedure PM_ChangeSettingsClick(Sender: TObject);
    procedure PM_SplitTaskClick(Sender: TObject);
    procedure sChBoxAutorunClick(Sender: TObject);
    Function AutoRunCheck: Boolean;

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
  SELECT_DISK_FREE_SZ  : Int64;
  CURRENT_DISK_FREE_SZ : Int64;
  MaxCore              : SmallInt;
  MemTotalPhys         : Int64;
  INI                  : TIniFile;
  NonceDirection       : Integer;
  CurrentTaskList      : string;
  CPUInstruction       : TCPUInstruction;
  typePlotter          : TPlotter;
  XPlotterFile         : String;
  BgnTimeProcessing    : Cardinal;
  LastTimeProcessing   : Cardinal;
  CurrentTaskName      : String;
  AutoRunCheckPass     : Boolean;

  msg_TaskName         : String;
  msg_TaskFile         : String;

const
  NONCE         = 4096;
  CommandList   = 'CommandList'; //'CreatePlotsLog.txt';
  MB_CAPTION    = 'PLOTS_GEN_GUI';
  RegKeyAutoRun = '\Software\Microsoft\Windows\CurrentVersion\Run';
  //Char_not_permitted = '*|\:"<>?/';

implementation

USES ResourceLang, UFrmCreateTask, UFrmChangeSettings, UFrmSelPlotter, UFrmSplitTask;

{$R *.dfm}
{$R XPlotter_avx.res}
{$R XPlotter_sse.res}
// {$R gpuPlotGenerator_x86}
// {$R gpuPlotGenerator_x64}

procedure TFrmMain.AddLVItem(StrValue: String);
var NewItem: TListItem;
begin
  NewItem         := sLV.Items.Add;
  NewItem.Caption := StrValue;
  NewItem.Checked := true;
  NewItem.ImageIndex := 0;
  NewItem.SubItems.Add('');
  NewItem.SubItems.Add('');
  NewItem.SubItems.Add('');
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
  i: SmallInt;
  s_temp, path: String;
  sn: Integer;
begin

  sn := StrToInt(Trim(FrmCreateTask.sEdStartNonce.Text));
  if FrmCreateTask.sChBoxPathEnable.Checked then
  begin
    s_temp := TRegEx.Replace(FrmCreateTask.sEdPath.Text,'^[\\]', '', []);
    path := ' -path ' + FrmCreateTask.sCmBoxExSelectDisk.Text + ExcludeTrailingPathDelimiter(s_temp);
  end;

  for i := 1 to FrmCreateTask.sSpEdCount.Value do
  begin
    s_temp := '%Plotter%' + ' -id ' + Trim(FrmCreateTask.sEdID.Text)
              + ' -sn ' + IntToStr(sn) + ' -n ' + FrmCreateTask.sSpEdNonces.Text
              + ' -t ' + FrmCreateTask.sSpEdThreads.Text
              + path
              + ' -mem ' + FrmCreateTask.ConvertValueMem + 'G';
    AddLVItem(s_temp);
    inc(sn, FrmCreateTask.sSpEdNonces.Value);
  end;
  FrmCreateTask.sEdStartNonce.Text := IntToStr(sn);

end;

function TFrmMain.CopyFileStrmProgress(FSource, FDest: String): Boolean;
var
  FStrmSource : TFileStream;
  FStrmDest   : TFileStream;
  ByteRead    : integer;
  FileSize    : Int64;
  PBuffer     : Pointer;
  BufferSize  : LongWord;
  ByteAmount  : Int64;
  Count       : Int64;
  BeginTime   : Cardinal;
  BreakeMove  : Boolean;
begin
  Result     := false;
  FileSize   := 0;
  ByteAmount := 0;
  Count      := 1;
  BeginTime  := GetTickCount;
  BreakeMove := false;

  FStrmSource := TFileStream.Create(FSource, fmOpenRead);
  if FStrmSource.Size = 0 then Exit;
  FileSize  := FStrmSource.Size;
  sLblFileSize.Caption := 'File Size: ' + FormatFileSize(FileSize);
  if FileExists(FDest) then
     FStrmDest := TFileStream.Create(FDest, fmOpenWrite or fmExclusive)
  else FStrmDest := TFileStream.Create(FDest, fmCreate or fmExclusive);

  BufferSize := 1024 * 1024 * 10; // 10MB
  GetMem(PBuffer, BufferSize);

  try
    repeat
      if TERMINATE_PROCESS then
      begin
        BreakeMove := true;
        Break;
      end;
      Application.ProcessMessages;
      ByteRead := FStrmSource.Read(PBuffer^, BufferSize);
      Application.ProcessMessages;
      FStrmDest.Write(PBuffer^, ByteRead);
      ByteAmount := ByteAmount + ByteRead;
      if Count > 10 then
      begin
        sLblCopySpeed.Caption := 'Speed: ' + FormatFileSize(ByteAmount / ((GetTickCount - BeginTime) / 1000)) + '/s';
        sLblAmount.Caption    := 'Amount: ' + FormatFileSize(ByteAmount);
        sProgressBar.Position := Round((ByteAmount * 100) / FileSize);
        count := 1;
      end;
      Inc(Count);
    until ByteRead < BufferSize;

    sLblCopySpeed.Caption := 'Speed: ' + FormatFileSize(ByteAmount / ((GetTickCount - BeginTime) / 1000)) + '/s';
    sLblAmount.Caption    := 'Amount: ' + FormatFileSize(ByteAmount);
    sProgressBar.Position := Round((ByteAmount * 100) / FileSize);

    if Not BreakeMove then Result := true;

  finally
    FreeMem(PBuffer);
    FStrmSource.Free;
    FStrmDest.Free;
  end;

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
  zAppName: array[0..512] of Char;
  zCurDir: array[0..255] of Char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  AppIsRunning: DWORD;
  Counter: SmallInt;
begin
  Counter := 0;
  //StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  //StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb          := SizeOf(StartupInfo);
  StartupInfo.dwFlags     := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := CmdShow;
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
        LVItem.SubItems[0] := GetMilisecondsFormat(GetTickCount - BgnTimeProcessing);
      end
      else Inc(Counter);

      Sleep(50);
    end;
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  suport: string;
  SysInfo: TSystemInfo;
  MemStatEx: TMemoryStatusEx;
  s: string;
begin

  Constraints.MinHeight := Height;
  Constraints.MinWidth  := Width;

  CurrPath    := ExtractFilePath(Application.ExeName);
  CurrentDisk := ExtractFileDrive(Application.ExeName);

  // CPU Instructions detect
  if IsCPUIDSuported then
  begin
    if DetectCPUFeature(cpu_SSE) then suport := '  Suport: SSE';
    if DetectCPUFeature(cpu_SSE2) then suport := suport + ', SSE2';
    if DetectCPUFeature(cpu_SSE3) then suport := suport + ', SSE3';
    if DetectCPUFeature(cpu_SSSE3) then suport := suport + ', SSSE3';
    if DetectCPUFeature(cpu_SSE_4_1) then suport := suport + ', SSE4.1';
    if DetectCPUFeature(cpu_SSE_4_2) then suport := suport + ', SSE4.2';
    if DetectCPUFeature(cpu_AVX) then suport := suport + ', AVX';
    if DetectCPUFeature(cpu_AVX2) then suport := suport + ', AVX2';
    //if DetectCPUFeature(cpu_AVX512) then suport := suport + ', AVX512';
  end
  else
   begin
     suport := ' CPUID not suported';
     CPUInstruction := cpu_UNKNOWN;
   end;

  GetSystemInfo(SysInfo);
  MaxCore := SysInfo.dwNumberOfProcessors;
  sLblCPUNameStr.Caption := 'Processor: '
                           + TregEx.Replace(GetProcessorNameStr, '\s{3,}', '  ', [roIgnoreCase])
                           + ' ['+IntToStr(MaxCore) + ' Cores]' + suport;

  MemStatEx.dwLength := SizeOf(MemStatEx);
  GlobalMemoryStatusEx(MemStatEx);
  MemTotalPhys  := MemStatEx.ullTotalPhys;


  if DetectCPUFeature(cpu_AVX) or DetectCPUFeature(cpu_AVX2) then
  begin
    typePlotter := XPlotter_avx;
  end
  else
  begin
    typePlotter := XPlotter_sse;
  end;

  XPlotterFile := CurrPath + strPlotter[typePlotter]+'.exe';
  LoadeSettings;

  if CurrentTaskList <> '' then
  begin
    if ExtractFileDir(CurrentTaskList) = '' then
    CurrentTaskList := CurrPath + CurrentTaskList;
    if FileExists(CurrentTaskList) then
    begin
      LVLoadTaskListFromFile(CurrentTaskList);
      GetProcessingInformation;
      sLblTaskFileName.Caption := 'Task File: ' + ExtractFileName(CurrentTaskList);
    end;
  end;

  Caption := Caption + '  v. ' + Get_vertionInfo(Application.ExeName, True);

  if AutoRunCheck = true then
  begin
    AutoRunCheckPass      := true;
    sChBoxAutorun.Checked := true;
    sBtnStartClick(Nil);
  end;

end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  //smm.SetFocus;
  sLV.SetFocus;
end;

function TFrmMain.GetMilisecondsFormat(Milliseconds: Cardinal): String;
var
 D, H, M, S, ATime: Cardinal;
begin
  ATime := Milliseconds div 1000;
  D := ATime div 86400;
  H := (ATime - D*86400) div 3600;
  M := (ATime - D*86400 - H*3600) div 60;
  S := ATime - D*86400 - H*3600 - M*60;
  Result := Format('%.2dd %.2dh %.2dm %.2ds', [D, H, M, S]);
end;

procedure TFrmMain.LoadeSettings;
Var INI : TIniFile;
begin

  INI := TIniFile.Create(CurrPath + 'config.ini');

  try
    if INI.ReadBool('SETTINGS','Started', false) then
    begin
      // .......
    end;
    sDirEditDest.Text      := INI.ReadString('SETTINGS', 'DestDir', '');
    sChBoxMoveFile.Checked := INI.ReadBool('SETTINGS', 'FileMove', false);
    sChBoxReWrite.Checked  := INI.ReadBool('SETTINGS', 'ReWrite', false);
    CurrentTaskList        := INI.ReadString('SETTINGS', CommandList, '');
    sSkinManager.SkinName  := INI.ReadString('SETTINGS', 'SkinName', 'Material Dark (internal)');
  finally
    INI.Free;
  end;

end;

procedure TFrmMain.LVLoadTaskListFromFile(FileName: String);
var
  i,j: integer;
  INI: TIniFile;
  st: TStrings;
  s: string;
begin
  INI := TIniFile.Create(FileName);
  st  := TStringList.Create;
  try
    INI.ReadSections(st);
    if st.Count = 0 then exit;

    for i:=0 to st.Count - 1 do
    begin
      if st.Strings[i] = 'INFO' then
      begin
        CurrentTaskName := INI.ReadString(st.Strings[i], 'TaskName', 'Default');
        sLblTaskName.Caption := 'Task name: ' + CurrentTaskName;
        sProgressBarProcessing.Position :=  INI.ReadInteger(st.Strings[i], 'ProgressBarProcessing', 0);
        Continue;
      end;
      s := INI.ReadString(st.Strings[i], 'Command','');
      if s <> '' then
      begin
        AddLVItem(s);
        sLV.Items[sLV.Items.Count - 1].Checked      := INI.ReadBool(st.Strings[i], 'Checked', false);
        sLV.Items[sLV.Items.Count - 1].SubItems[0]  := INI.ReadString(st.Strings[i], 'ProcessTime','');
        sLV.Items[sLV.Items.Count - 1].SubItems[1]  := INI.ReadString(st.Strings[i], 'ProcessStatus', '');
        sLV.Items[sLV.Items.Count - 1].SubItems[2]  := INI.ReadString(st.Strings[i], 'Move', '');
      end;
    end;
  finally
    INI.Free;
    st.Free;
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
    for i := 0 to sLV.Items.Count - 1 do
    begin
      Section := ExtractParam('-id', sLV.Items[i].Caption) + '_' + ExtractParam('-sn', sLV.Items[i].Caption);
      INI.WriteString(Section, 'Command', sLV.Items[i].Caption);
      INI.WriteBool(Section, 'Checked', sLV.Items[i].Checked);
    end;
  finally
    INI.Free;
  end;
end;

procedure TFrmMain.LVLoadTaskListFromFileOld(FileName: String);
var i: integer;
    st: TStrings;
begin
  st := TStringList.Create;
  try
    st.LoadFromFile(FileName);
    if st.Count = 0 then exit;
    for i := 0 to st.Count - 1 do
    begin
      AddLVItem(st.Strings[i]);
    end;
  finally
    st.free;
  end;
end;

procedure TFrmMain.PM_ChangeSettingsClick(Sender: TObject);
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
    s_temp := ExtractParam('-path', sLV.Items[sLV.Selected.Index].Caption);
    if s_temp <> '' then
    begin
      sChBoxPathEnable.Checked := true;
      sEdPath.Text             := s_temp;
    end;
    s_temp := ExtractParam('-t', sLV.Items[sLV.Selected.Index].Caption);
    if s_temp <> '' then sSpEdThreads.Value := StrToInt(s_temp);
    sSpEdThreadsChange(Nil);
   Apply := false;
   ShowModal;

   if sRdBtnAllItems.Checked then
   begin
     for i := 0 to sLV.Items.Count -1 do
     begin
      // Old metod
      //s_temp := '%Plotter%';
      //s_temp := s_temp + ' -id ' + ExtractParam('-id', sLV.Items[sLV.Selected.Index].Caption);
      //s_temp := s_temp + ' -sn ' + ExtractParam('-sn', sLV.Items[sLV.Selected.Index].Caption);
      //s_temp := s_temp + ' -n ' + ExtractParam('-n', sLV.Items[sLV.Selected.Index].Caption);

      s_temp := '-n ' + ExtractParam('-n', sLV.Items[i].Caption);
      s_temp := Copy(sLV.Items[i].Caption, 1 ,
                    AnsiPos(s_temp, sLV.Items[i].Caption) + Length(s_temp)-1);
      s_temp := s_temp + ' -t ' + IntToStr(sSpEdThreads.Value);
      if sChBoxPathEnable.Checked then s_temp := s_temp + ' -path ' + sEdPath.Text;
      s_temp := s_temp + ' -mem ' + StringReplace(FloatToStr(sSpEdMem.Value * 0.001), ',', '.', [])+'G';
      sLV.Items[i].Caption := s_temp;

     end;
   end
     else
   begin
     for i:=0 to sLV.Items.Count -1 do
     begin
       if sLV.Items[i].Selected then
       begin
         s_temp := '-n ' + ExtractParam('-n', sLV.Items[i].Caption);
         s_temp := Copy(sLV.Items[i].Caption, 1 ,
                    AnsiPos(s_temp, sLV.Items[i].Caption) + Length(s_temp)-1);
         s_temp := s_temp + ' -t ' + IntToStr(sSpEdThreads.Value);
         if sChBoxPathEnable.Checked then s_temp := s_temp + ' -path ' + sEdPath.Text;
         s_temp := s_temp + ' -mem ' + StringReplace(FloatToStr(sSpEdMem.Value * 0.001), ',', '.', [])+'G';
         sLV.Items[i].Caption := s_temp;
       end;
     end;
   end;

  end;

  LVSaveTaskListToFile(CurrentTaskList);

end;

procedure TFrmMain.PM_ClearLVItemsClick(Sender: TObject);
var
  st: TStrings;
   i: Integer;
begin
  if sLV.Items.Count = 0 then Exit;
  if MessageBox(Handle, PChar(msg_FrmMain_ClearTaskList),PChar(MB_CAPTION),
                MB_ICONWARNING or MB_YESNO) = ID_NO then Exit;

exit;
  INI := TIniFile.Create(CurrentTaskList);
   st := TStringList.Create;
  try
    INI.ReadSections(st);
    for i := 0 to st.Count -1 do
    begin
      if st.Strings[i] = 'INFO' then continue;
      INI.EraseSection(st.Strings[i]);
    end;
    INI.WriteInteger('INFO', 'ProgressBarProcessing',0);
  finally
     st.Free;
    INI.Free;
  end;

  sLV.Clear;
end;

procedure TFrmMain.PM_LoadTaskListFromFileOLDClick(Sender: TObject);
var INI : TIniFile;
begin
  OpenDlg.Filter := 'Text files *.txt|*.txt';
  OpenDlg.InitialDir := CurrPath;
  if Not OpenDlg.Execute then Exit;

  sLV.Clear;
  LVLoadTaskListFromFile(OpenDlg.FileName);
  CurrentTaskList := OpenDlg.FileName;
  INI := TIniFile.Create(CurrPath + 'config.ini');
  try
    INI.WriteString('SETTINGS', CommandList, CurrentTaskList);
  finally
    INI.free;
  end;

end;

procedure TFrmMain.PM_SplitTaskClick(Sender: TObject);
var
  i,j, sale, share, cnt_share, counter: Integer;
  SectionName: String;
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
    sLblTaskName.Caption      := 'TaskName: ' + CurrentTaskName;
    sSpEditCountNode.MaxValue := sLV.Items.Count;
    sSpEditCountNode.Value    := 2;
    sLVFileNameList.Clear;
    ImageList.Clear;
    AddAssociatedIcon(CurrentTaskList, ImageList);
    sSpEditCountNodeChange(Nil);
    ShowModal;

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

        if i <= Pred(sale) then cnt_share := succ(share)
        else cnt_share := share;

        for j:=1 to cnt_share do
        begin
          SectionName := ExtractParam('-id', AnsiLowerCase(sLV.Items[counter].Caption))
                     + '_' + ExtractParam('-sn', AnsiLowerCase(sLV.Items[counter].Caption));
          INI.WriteString(SectionName,'Command', sLV.Items[counter].Caption);
          INI.WriteBool(SectionName, 'Checked', True);
          inc(counter);
        end;

      finally
        INI.Free;
      end;

      Application.ProcessMessages;
    end;
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

procedure TFrmMain.PM_ImportFromBatFileClick(Sender: TObject);
var INI: TIniFile;
begin
  OpenDlg.Filter := 'Bat files *.bat|*.bat';
  OpenDlg.InitialDir := CurrPath;
  if Not OpenDlg.Execute then Exit;
  LVLoadTaskListFromFileOld(OpenDlg.FileName);

  CurrentTaskList :=  CurrPath + CommandList + '_' + FormatDateTime('dd.mm.yyyy_hh.mm.ss', Date+Time) + '.txt';
  LVSaveTaskListToFile(CurrentTaskList);

  INI := TIniFile.Create(CurrPath + 'config.ini');
  try
    INI.WriteString('SETTINGS', CommandList, CurrentTaskList);
  finally
    INI.Free;
  end;

end;

procedure TFrmMain.SaveSettings;
var INI: TIniFile;
begin
  INI := TIniFile.Create(CurrPath + 'config.ini');

  try
    INI.WriteString('SETTINGS', 'Version', Get_vertionInfo(Application.ExeName, True));
    INI.WriteString('SETTINGS', 'id', FrmCreateTask.sEdID.Text);
    INI.WriteString('SETTINGS', 'Path', FrmCreateTask.sEdPath.Text);
    INI.WriteString('SETTINGS', 'StartNonce', FrmCreateTask.sEdStartNonce.Text);
    INI.WriteString('SETTINGS', 'DestDir', sDirEditDest.Text);
    INI.WriteBool('SETTINGS', 'FileMove', sChBoxMoveFile.Checked);
    INI.WriteBool('SETTINGS', 'ReWrite', sChBoxReWrite.Checked);
    INI.WriteString('SETTINGS', CommandList, CurrentTaskList);
  finally
    INI.Free;
  end;

end;

procedure TFrmMain.sBtnSaveBatClick(Sender: TObject);
var st: TStrings;
    i : integer;
    Plotter: TPlotter;
begin
  if sLV.Items.Count = 0 then
  begin
    MessageBox(Handle, PChar(msg_FrmMain_sBtnSaveBat_01), PChar(MB_CAPTION), MB_ICONWARNING);
    Exit;
  end;

  if Not sSaveDlg.Execute then Exit;
  st := TStringList.Create;

  Case typePlotter of
    XPlotter_sse: FrmSelPlotter.sRdBtnXPlotter_sse.Checked := true;
    XPlotter_avx: FrmSelPlotter.sRdBtnXPlotter_avx.Checked := true;
  End;

  FrmSelPlotter.ShowModal;

  st.Add('@setlocal');
  st.Add('@cd /d %~dp0');
  if FrmSelPlotter.sRdBtnXPlotter_avx.Checked then
    st.Add('set Plotter=' + strPlotter[XPlotter_avx]+'.exe')
  else st.Add('set Plotter=' + strPlotter[XPlotter_sse]+'.exe');
  if (FrmCreateTask.sCmBoxExSelectDisk.Text <> '') and (FrmCreateTask.sEdPath.Text <> '') then
    st.Add('mkdir ' + FrmCreateTask.sCmBoxExSelectDisk.Text + FrmCreateTask.sEdPath.Text);

  try
    for i := 0 to sLV.Items.Count - 1 do
    begin
      st.Add(sLV.Items[i].Caption);
    end;
    st.SaveToFile(sSaveDlg.FileName);
  finally
    st.Free;
  end;

  MessageBox(Handle, PChar(msg_FrmMain_sBtnSaveBat_02), PChar(MB_CAPTION), MB_ICONINFORMATION);

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

  AddItemsToTaskList;
  LVSaveTaskListToFile(CurrentTaskList);
  GetProcessingInformation;
  SaveSettings;

end;

procedure TFrmMain.sBtnNewTaskClick(Sender: TObject);
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
  CurrentTaskList :=  CurrPath +  TregEx.Replace(CurrentTaskName,'[*|\:"<>?/\s{1,}]', '', [roIgnoreCase]) +
                      '_' + FormatDateTime('dd.mm.yyyy_hh.mm.ss', Date+Time) + '.txt';
  sLblTaskName.Caption     := 'Task name: ' + CurrentTaskName;
  sLblTaskFileName.Caption := 'Task File: ' + ExtractFileName(CurrentTaskList);
  GetProcessingInformation;
  LVSaveTaskListToFile(CurrentTaskList);
  SaveSettings;
end;

procedure TFrmMain.sBtnStartClick(Sender: TObject);
var
    SR: TSearchRec;
    FindDir: String;
    SourceDir: String;
    INI: TIniFile;
    i, j: integer;
    FindPlot: Boolean;
    ProcExitCode: Cardinal;
    CommandLine : String;
    SectionName: String;
    MoveResult: TMoveResult;
    BeginTime : Cardinal;

begin

  if sLV.Items.Count = 0 then Exit;

  // *** Check file exists XPloter end Extract from recource ***
  if Not FileExists(XPlotterFile) then
  begin
    if Not DecompressResNameToFile(strPlotter[typePlotter], RT_RCDATA, XPlotterFile) then
    begin
      MessageBox(Handle,
                 PChar(msg_FrmMain_sBtnStart_01 + MB_CAPTION + msg_FrmMain_sBtnStart_02 + strPlotter[typePlotter]
                       + #13#10 + Error.GetSysErrorMessage(GetLastError)),
                 PChar(MB_CAPTION), MB_ICONERROR);
      Exit;
    end;

  end;

  INI := TIniFile.Create(CurrentTaskList);

  // Save list command to log
  {
  for i := 0 to sLv.Items.Count - 1 do
    SectionName := ExtractParam('-id', AnsiLowerCase(sLV.Items[i].Caption))
                   + '_' + ExtractParam('-sn', AnsiLowerCase(sLV.Items[i].Caption));

    INI.WriteString(SectionName, 'command', sLV.Items[i].Caption);
    INI.WriteBool(SectionName, 'Checked', sLV.Items[i].Checked);
  end;   }

  sLV.HideSelection                  := False;
  sBtnStart.Enabled                  := false;
  sBtnNewTask.Enabled                := false;
  sBtnAddPlots.Enabled               := false;
  PM_ClearLVItems.Enabled            := false;
  PM_ImportFromBatFile.Enabled       := false;
  PM_LoadTaskListFromFileOLD.Enabled := false;
  PM_ChangeSettings.Enabled          := false;
  PM_SplitTask.Enabled               := false;

  try

    TERMINATE_PROCESS := false;

    for i := 0 to sLV.Items.Count - 1 do
    begin
      Application.ProcessMessages;
      if TERMINATE_PROCESS then Break;
      if Not sLV.Items[i].Checked then Continue;
      for  j := 0 to sLV.Items.Count - 1 do sLV.Items[j].Selected := false;
      sLV.SetFocus;
      sLV.SelectItem(i);

      SectionName := ExtractParam('-id', AnsiLowerCase(sLV.Items[i].Caption))
                     + '_' + ExtractParam('-sn', AnsiLowerCase(sLV.Items[i].Caption));

      // *** Create CommandLine ***
      CommandLine := StringReplace(sLV.Items[i].Caption, '%Plotter%', XPlotterFile, [rfIgnoreCase]);

      //*******  Create Process *******
      sLV.Items[i].SubItems[1] := 'Create';

      BgnTimeProcessing := GetTickCount;
      ProcExitCode := ExecAndWait(nil, PChar(CommandLine), PChar(ExtractFilePath(XPlotterFile)), SW_NORMAL, sLV.Items[i]);

      INI.WriteString(SectionName, 'ProcessTime', sLV.Items[i].SubItems[0]);
      INI.WriteInteger('INFO', 'ProgressBarProcessing', sProgressBarProcessing.Position);

      // Processing EXIT CODE
      case ProcExitCode of
        STATUS_WAIT_0:
          begin
            if TERMINATE_PROCESS then
            begin
              sLV.Items[i].SubItems[1] := strExitCode[TExitCode(EX_STOPED)];  //'Stoped';
              INI.WriteString(SectionName, 'ProcessStatus', strExitCode[TExitCode(EX_CLOCE)]);
            end
            else
            begin
              sLV.Items[i].SubItems[1] := strExitCode[TExitCode(EX_COMPLETE)];
              //if Not TERMINATE_PROCESS then
              sLV.Items[i].Checked := false;
              INI.WriteBool(SectionName, 'checked', false);
              INI.WriteString(SectionName, 'ProcessStatus', strExitCode[TExitCode(EX_COMPLETE)]);
              GetProcessingInformation;
            end;
          end;
        STATUS_CONTROL_C_EXIT:
          begin
            sLV.Items[i].SubItems[1] := strExitCode[TExitCode(EX_CLOCE)];
            sLv.Items[i].Checked     := False;
            INI.WriteBool(SectionName, 'checked', false);
            INI.WriteString(SectionName, 'ProcessStatus', strExitCode[TExitCode(EX_CLOCE)]);
          end;
        WAIT_FAILED:
          begin
            sLV.Items[i].SubItems[1] := strExitCode[TExitCode(EX_FILED)];
            sLV.Items[i].Checked     := false;
            INI.WriteBool(SectionName, 'checked', false);
            INI.WriteString(SectionName, 'ProcessStatus', strExitCode[TExitCode(EX_FILED)]);
            Break;
          end;
       else
         begin
           sLV.Items[i].SubItems[1] := strExitCode[TExitCode(EX_UNKNOWN)];
           sLV.Items[i].Checked     := false;
           INI.WriteBool(SectionName, 'checked', false);
           INI.WriteString(SectionName, 'ProcessStatus', strExitCode[TExitCode(EX_UNKNOWN)]);
         end;
      end;

      // *************** Move created file *****************
      if sChBoxMoveFile.Checked and (sDirEditDest.Text <> '')
         and (ProcExitCode = STATUS_WAIT_0) and (Not TERMINATE_PROCESS) then
      begin

        FindPlot  := false;
        SourceDir := ExtractParam('-path', sLV.Items[i].Caption);
        if SourceDir = '' then SourceDir := ExtractFileDir(XPlotterFile);
        SourceDir := IncludeTrailingPathDelimiter(SourceDir);

        if FindFirst(SourceDir + '*.*', faAnyFile, SR) = 0 then
        Repeat
          Application.ProcessMessages;
          if TERMINATE_PROCESS then
          begin
            MoveResult := MR_STOPED;
            Break;
          end;
          if ((SR.Attr and faDirectory) <> 0) or (SR.Name = '.') or (SR.Name = '..') then Continue;

          if (AnsiPos(SectionName, SR.Name) <> 0) then
          begin
            FindPlot := true;
            sLblFileInfo.Caption := 'File to move: ' + SR.Name;

            if FileExists(sDirEditDest.Text + '\' + SR.Name) and (sChBoxReWrite.Checked = false) then
              Continue;

            if ExtractFileDrive(SourceDir) = ExtractFileDrive(sDirEditDest.Text) then
            begin
              if MoveFile(PChar(SourceDir + SR.Name), PChar(sDirEditDest.Text + '\' + SR.Name)) then
                MoveResult := MR_COMPLETE
              else
                MoveResult := MR_ERROR;
            end
              else
            begin
              try
                if CopyFileStrmProgress(SourceDir + SR.Name,
                              sDirEditDest.Text + '\' + SR.Name) then
                begin
                  Application.ProcessMessages;
                    DeleteFile(SourceDir + SR.Name);
                  MoveResult := MR_COMPLETE;
                end
                 else
                begin
                  if FileExists(sDirEditDest.Text + '\' + SR.Name) then
                    DeleteFile(sDirEditDest.Text + '\' + SR.Name);
                   if TERMINATE_PROCESS then MoveResult := MR_STOPED;
                end;

              except
                MoveResult := MR_ERROR;
                ShowMessage(Error.SystemErrorMessage(GetLastError));
              end;
            end;

            sLblFileInfo.Caption  := 'File to move: ';
            sLblAmount.Caption    := 'Amount: 0,00 %';
            sLblFileSize.Caption  := 'File Size: 0 B';
            sLblCopySpeed.Caption := 'Speed: 0 Mb/s';
            sProgressBar.Position := 0;
            Break;

          end;

        until (FindNext(SR) <> 0);
        FindClose(SR);
        if (NOT FindPlot) and (NOT TERMINATE_PROCESS) then MoveResult := MR_NOTFOUND;

        sLV.Items[i].SubItems[2] := strMoveResult[MoveResult];
        INI.WriteString(SectionName, 'Move', strMoveResult[MoveResult]);

      end;

    end;

  finally
    INI.Free;
  end;

  sBtnStart.Enabled                  := true;
  sBtnNewTask.Enabled                := true;
  sBtnAddPlots.Enabled               := True;;
  PM_ClearLVItems.Enabled            := true;
  PM_ImportFromBatFile.Enabled       := true;
  PM_LoadTaskListFromFileOLD.Enabled := true;
  PM_ChangeSettings.Enabled          := true;
  PM_SplitTask.Enabled               := true;

end;

procedure TFrmMain.sBtnStopClick(Sender: TObject);
begin
  TERMINATE_PROCESS := true;
end;

procedure TFrmMain.sChBoxAutorunClick(Sender: TObject);
var Reg: Tregistry;
begin

  if AutoRunCheckPass then
  begin
    AutoRunCheckPass := false;
    exit;
  end;

  if sChBoxAutorun.Checked then
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
        AutoRunCheckPass      := true;
        sChBoxAutorun.Checked := false;
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
          sChBoxAutorun.Checked := True;
        end;
      end
      else
      begin
        MessageBox(Handle, PChar(msg_FrmMain_AutoRunCloseBad),
                    PChar(MB_CAPTION), MB_ICONWARNING);
        AutoRunCheckPass      := true;
        sChBoxAutorun.Checked := True;
      end;

      AutoRunCheckPass := true;
    finally
      Reg.Free;
    end;

  end;
end;

procedure TFrmMain.GetProcessingInformation;
var i: Integer;
    Complete: Integer;
    Performed: Real;
begin
  Complete := 0;
  sProgressBarProcessing.Max      := sLV.Items.Count;
  for i:=0 to sLV.Items.Count-1 do
    if sLV.Items[i].SubItems[1] = strExitCode[TExitCode(EX_COMPLETE)] then Inc(Complete);

  sProgressBarProcessing.Position := Complete;

  if sLV.Items.Count = 0 then Performed := 0
  else Performed := (Complete * 100) / sLV.Items.Count;

  sLblProcessing.Caption := 'Processing Information:  ' +
                             'All Files: ' + IntToStr(sLV.Items.Count) + '     ' +
                             'Creating Files: ' + IntToStr(Complete) + '     '  +
                             'The task is performed for: ' + FormatFloat('00.00%', Performed);

end;

procedure TFrmMain.sSkinManagerAfterChange(Sender: TObject);
var
  INI: TIniFile;
begin
  INI := TIniFile.Create(CurrPath + 'config.ini');
  try
    INI.WriteString('SETTINGS', 'SkinName', sSkinManager.SkinName);
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

end.
