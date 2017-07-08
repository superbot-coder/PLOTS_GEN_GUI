unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sMemo, sSkinProvider,
  sSkinManager, sButton, sToolEdit, Vcl.Mask, sMaskEdit, sCustomComboEdit,
  sLabel, sCurrEdit, sCurrencyEdit, sEdit, acPopupCtrls, sSpinEdit,
  Vcl.ComCtrls, sComboBoxes, System.ImageList, Vcl.ImgList, Winapi.ShellAPI,
  sDialogs, Vcl.Menus, sStatusBar, acTitleBar, System.IniFiles, cpu_info_xe,
  sCheckBox, JvExControls, JvLabel, Vcl.FileCtrl, acProgressBar, ModFileFormatSize,
  Error, sListView;

type TExitCode = (EX_COMPLETE, EX_STOPED, EX_CLOCE, EX_FILED, EX_UNKNOWN);
type TMoveResult = (MR_COMPLETE, MR_STOPED, MR_ERROR, MR_NOTFOUND);

var
 strExitCode:  Array[TExitCode] of string = ('Complete', 'Stoped', 'Cloce', 'Filed', 'Unknown');
 strMoveResult: Array[TMoveResult] of string = ('Complete', 'Stoped', 'Error', 'Not found');

type
  TFrmMain = class(TForm)
    sLblXPlotter: TsLabel;
    sFNameEdPlotter: TsFilenameEdit;
    sLblPath: TsLabel;
    sBtnStart: TsButton;
    sSkinManager: TsSkinManager;
    sSkinProvider: TsSkinProvider;
    sEdID: TsEdit;
    sLblID: TsLabel;
    sEdStartNonce: TsEdit;
    sLblSN: TsLabel;
    sLblNonces: TsLabel;
    sLblThreads: TsLabel;
    sLblGB: TsLabel;
    sLblMem: TsLabel;
    sLblCountPlots: TsLabel;
    sBtnSaveBat: TsButton;
    sLblPlotsSumGb: TsLabel;
    sSpEdCount: TsSpinEdit;
    sSpEdThreads: TsSpinEdit;
    sSpEdNonces: TsSpinEdit;
    sSpEdMem: TsSpinEdit;
    sLblMemGb: TsLabel;
    sBtnStop: TsButton;
    sCmBoxExSelectDisk: TsComboBoxEx;
    ImageList: TImageList;
    sLblDrive: TsLabel;
    sEdPath: TsEdit;
    sSaveDlg: TsSaveDialog;
    sBtnCreateCommand: TsButton;
    PopMenu: TPopupMenu;
    PM_ClearMemo: TMenuItem;
    PM_ImportFromBatFile: TMenuItem;
    OpenDlg: TOpenDialog;
    sLblFXDonate: TsLabelFX;
    sWebLblDonatBurst: TsWebLabel;
    EdDonation: TEdit;
    sLblFXDonateBTC: TsLabelFX;
    sWbLblBTC: TsWebLabel;
    sLblCPUNameStr: TsLabel;
    sChBoxPathEnable: TsCheckBox;
    sLblGlobalMem: TsLabel;
    sLblSelectDiskSpace: TsLabel;
    JvOverflowed: TJvLabel;
    sLblCurrDiskSpace: TsLabel;
    JvLblGLMemOverflowed: TJvLabel;
    sLblStatDisk: TsLabel;
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
    sBtnLastPlots: TsButton;
    sOpenDlgLastNonce: TsOpenDialog;
    sLV: TsListView;
    ImgListLV: TImageList;
    PM_LoadFromCommanLog: TMenuItem;
    procedure sBtnSaveBatClick(Sender: TObject);
    procedure sSpEdNoncesChange(Sender: TObject);
    procedure sSpEdCountChange(Sender: TObject);
    procedure ScanDrive;
    procedure FormCreate(Sender: TObject);
    function AddAssociatedIcon(Path: String): Integer;
    function ConvertValueMem: string;
    procedure sBtnStartClick(Sender: TObject);
    procedure sSpEdMemChange(Sender: TObject);
    function ExecAndWait(AppName, CommandLime, CurrentDir: PChar; CmdShow: Integer): Longword;
    procedure sBtnCreateCommandClick(Sender: TObject);
    procedure sBtnStopClick(Sender: TObject);
    procedure sCmBoxExSelectDiskKeyPress(Sender: TObject; var Key: Char);
    procedure PM_ClearMemoClick(Sender: TObject);
    procedure PM_ImportFromBatFileClick(Sender: TObject);
    procedure sWbLabelClick(Sender: TObject);
    procedure SaveSettings;
    procedure LoadeSettings;
    procedure sSkinProviderTitleButtons0MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure sCmBoxExSelectDiskChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sSpEdThreadsChange(Sender: TObject);
    procedure GetCurrentDiskSpace;
    procedure GetSelectDiskSpace;
    procedure CheckFreeSpace;
    procedure sEditKeyPress(Sender: TObject; var Key: Char);
    procedure sEditChange(Sender: TObject);
    procedure sChBoxPathEnableClick(Sender: TObject);
    function CopyFileStrmProgress(FSource, FDest: String): Boolean;
    function ExtractParam(Param, StrValue: String): string;
    procedure sSkinManagerAfterChange(Sender: TObject);
    procedure sBtnLastPlotsClick(Sender: TObject);
    function GetNextNonceFromName(PlotsName: String): String;
    procedure AddLVItem(StrValue: String);
    procedure LVLoadCommandListFromFile(FileName: String);
    procedure LVCommandLisrFromFileOld(FileName: String);
    procedure PM_LoadFromCommanLogClick(Sender: TObject);
    procedure LVCommandListSaveToFile(FileName: String);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;
  ComSpec: String;
  CurrPath: string;
  CurrentDisk: String;
  TERMINATE_PROCESS: Boolean = false;
  SELECT_DISK_FREE_SZ: Int64;
  CURRENT_DISK_FREE_SZ: Int64;
  MaxCore: SmallInt;
  MemTotalPhys: Int64;
  INI: TIniFile;
  NonceDirection : Integer;
  CurrentCommandList: string;

const
  NONCE = 4096;
  CommandList = 'CommandList'; //'CreatePlotsLog.txt';
  MB_CAPTION = 'PLOTS_GEN_GUI';

implementation

{$R *.dfm}

function TFrmMain.AddAssociatedIcon(Path: String): Integer;
var
  icon: Ticon;
  wd: WORD;
begin
  // Add associated Icon
  Result := -1;
  try
    Icon := TIcon.Create;
    wd := 0;
    Icon.Handle := ExtractAssociatedIcon(HInstance, PChar(Path), wd);
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

procedure TFrmMain.AddLVItem(StrValue: String);
var NewItem: TListItem;
begin
  NewItem         := sLV.Items.Add;
  NewItem.Caption := StrValue;
  NewItem.Checked := true;
  NewItem.ImageIndex := 0;
  NewItem.SubItems.Add('');
  NewItem.SubItems.Add('');
end;

procedure TFrmMain.CheckFreeSpace;
begin
     if sChBoxPathEnable.Checked then
     begin
       if SELECT_DISK_FREE_SZ <> 0 then
         if SELECT_DISK_FREE_SZ < (sSpEdCount.Value * (sSpEdNonces.Value div NONCE)) then
         begin
           sLblPlotsSumGb.Visible := false;
           JvOverflowed.Caption   := sLblPlotsSumGb.Caption + ' > ';
           JvOverflowed.Visible   := true;
         end
           else
         begin
           JvOverflowed.Visible := false;
           JvOverflowed.Caption := '';
           sLblPlotsSumGb.Visible := true;
         end;
     end
       else
     begin
       if CURRENT_DISK_FREE_SZ < (sSpEdCount.Value * (sSpEdNonces.Value div NONCE)) then
       begin
         sLblPlotsSumGb.Visible := false;
         JvOverflowed.Caption   := sLblPlotsSumGb.Caption + ' > ';
         JvOverflowed.Visible   := true;
       end
         else
       begin
         JvOverflowed.Visible := false;
         JvOverflowed.Caption := '';
         sLblPlotsSumGb.Visible := true;
       end;
     end;

end;

function TFrmMain.ConvertValueMem: string;
begin
  Result := StringReplace(FloatToStr(sSpEdMem.Value * 0.001), ',', '.', []);
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

  BufferSize := 1024 * 1024 * 10; // 1MB
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

function TFrmMain.ExtractParam(Param, StrValue: String): string;
var
  n: SmallInt;
begin
  n := AnsiPos(Param, StrValue);
  if n = 0 then exit;
  Result := copy(StrValue, n + Length(Param + ' '), Length(StrValue) - n + Length(Param + ' '));
  Result := copy(Result, 1 , AnsiPos(' ', Result)-1);
end;

function TFrmMain.ExecAndWait(AppName, CommandLime, CurrentDir: PChar; CmdShow: integer): Longword;
var { by Pat Ritchey }
  zAppName: array[0..512] of Char;
  zCurDir: array[0..255] of Char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  AppIsRunning: DWORD;
begin
  //StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  //StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb          := SizeOf(StartupInfo);
  StartupInfo.dwFlags     := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := CmdShow;
  if not CreateProcess(AppName,
    CommandLime,   // pointer to command line string
    nil,                  // pointer to process security attributes
    nil,                  // pointer to thread security attributes
    False,                // handle inheritance flag
    CREATE_NEW_CONSOLE or // creation flags
    NORMAL_PRIORITY_CLASS,
    nil,         //pointer to new environment block
    CurrentDir,         // pointer to current directory name
    StartupInfo, // pointer to STARTUPINFO
    ProcessInfo) // pointer to PROCESS_INF
    then Result := WAIT_FAILED
  else
  begin
    while WaitForSingleObject(ProcessInfo.hProcess, 0) = WAIT_TIMEOUT do
    begin
      Application.ProcessMessages;
      if TERMINATE_PROCESS then TerminateProcess(ProcessInfo.hProcess, NO_ERROR);
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

  ScanDrive;
  Constraints.MinHeight := Height;
  Constraints.MinWidth  := Width;

  CurrPath    := ExtractFilePath(Application.ExeName);
  CurrentDisk := ExtractFileDrive(Application.ExeName);
  ComSpec     := GetEnvironmentVariable('ComSpec');
  sSpEdNonces.Increment := NONCE;

  JvLblGLMemOverflowed.Left := sLblMemGb.Left;
  JvLblGLMemOverflowed.Top  := sLblMemGb.Top;
  JvOverflowed.Left         := sLblPlotsSumGb.Left;
  JvOverflowed.Top          := sLblPlotsSumGb.Top;

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
  end
  else suport := ' CPUID not suported';

  GetSystemInfo(SysInfo);
  MaxCore := SysInfo.dwNumberOfProcessors;
  sLblCPUNameStr.Caption := 'Processor: ' + GetProcessorNameStr +
                            ' ['+IntToStr(MaxCore) + ' Core]' + suport;
  sSpEdThreads.Value := MaxCore;

  MemStatEx.dwLength := SizeOf(MemStatEx);
  GlobalMemoryStatusEx(MemStatEx);
  MemTotalPhys  := MemStatEx.ullTotalPhys;


  sLblGlobalMem.Caption := 'Global Memory: ' +  FormatFileSize(MemTotalPhys);

  sSpEdMem.Value := MaxCore * 500;


  if DetectCPUFeature(cpu_AVX) or DetectCPUFeature(cpu_AVX2) then
  begin
    if FileExists(CurrPath + 'XPlotter_avx.exe') then
      sFNameEdPlotter.Text := CurrPath + 'XPlotter_avx.exe'
  end
  else
  begin
    if FileExists(CurrPath + 'XPlotter_sse.exe') then
      sFNameEdPlotter.Text := CurrPath + 'XPlotter_sse.exe'
  end;
  LoadeSettings;

  sSpEdMemChange(Nil);
  GetCurrentDiskSpace;

  sCmBoxExSelectDisk.ItemIndex := sCmBoxExSelectDisk.Items.IndexOf(CurrentDisk+'\');

  sLblStatDisk.Caption := IntToStr(CURRENT_DISK_FREE_SZ) +
                          ' GB free space Disk [' +CurrentDisk + '\]';

  if CurrentCommandList = '' then;
    LVLoadCommandListFromFile(CurrentCommandList);
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  //smm.SetFocus;
  sLV.SetFocus;
end;

procedure TFrmMain.GetCurrentDiskSpace;
var  Free_Bytes, TotalSize, FreeSize: Int64;
begin
  GetDiskFreeSpaceEx(PChar(ExtractFileDrive(CurrPath)), Free_Bytes, TotalSize, @FreeSize);
  CURRENT_DISK_FREE_SZ := (FreeSize div 1024 div 1024 div 1024);

  sLblCurrDiskSpace.Caption := 'Current disk  ' + CurrentDisk + '\'
       + ' total: ' + FormatFileSize(TotalSize) + ' free: ' +  FormatFileSize(FreeSize);
end;

function TFrmMain.GetNextNonceFromName(PlotsName: String): String;
var
  st : TStrings;
  sn : integer;
  E  : integer;
  nonces: integer;
begin
  Result := '';
  st := TStringList.Create;
  try
    st.Text := StringReplace(ExtractFileName(PlotsName), '_', #13#10, [rfReplaceAll, rfIgnoreCase]);
    if st.Count <> 4 then Exit;

    val(st.Strings[1], sn, E);
    if E <> 0 then Exit;

    val(st.Strings[2], nonces, E);
    if E <> 0 then Exit;

    Result := IntToStr(sn + nonces + 1);

  finally
    st.Free
  end;
end;

procedure TFrmMain.GetSelectDiskSpace;
var  Free_Bytes, TotalSize, FreeSize: Int64;
begin
  GetDiskFreeSpaceEx(PChar(sCmBoxExSelectDisk.Text), Free_Bytes, TotalSize, @FreeSize);
  SELECT_DISK_FREE_SZ := (FreeSize div 1024 div 1024 div 1024);

  sLblSelectDiskSpace.Caption := 'Selected disk '
       + ' total: ' + FormatFileSize(TotalSize) + ' free: ' + FormatFileSize(FreeSize);

  if sChBoxPathEnable.Checked then
    sLblStatDisk.Caption :=  IntToStr(SELECT_DISK_FREE_SZ) +
                         ' GB free space Disk [' + sCmBoxExSelectDisk.Text + ']';

end;

procedure TFrmMain.LoadeSettings;
Var INI : TIniFile;
      s : string;
begin

  INI := TIniFile.Create(CurrPath + 'config.ini');

  try
    s := INI.ReadString('SETTINGS', 'Plotter','');
    if s <> '' then  sFNameEdPlotter.Text := s;
    sEdPath.Text := INI.ReadString('SETTINGS', 'Path','');
    sEdID.Text   := INI.ReadString('SETTINGS', 'id','');
    sEdStartNonce.Text := INI.ReadString('SETTINGS', 'StartNonce', '');
    if INI.ReadBool('SETTINGS','Started', false) then
    begin
      // .......
    end;
    sDirEditDest.Text      := INI.ReadString('SETTINGS', 'DestDir', '');
    sChBoxMoveFile.Checked := INI.ReadBool('SETTINGS', 'FileMove', false);
    sChBoxReWrite.Checked  := INI.ReadBool('SETTINGS', 'ReWrite', false);
    CurrentCommandList     := INI.ReadString('SETTINGS', CommandList, '');
    sSkinManager.SkinName  := INI.ReadString('SETTINGS', 'SkinName', 'Material Dark (internal)');
  finally
    INI.Free;
  end;

end;

procedure TFrmMain.LVLoadCommandListFromFile(FileName: String);
var
  i,j: integer;
  INI: TIniFile;
  st: TStrings;
  s: string;
begin
  INI := TIniFile.Create(FileName);
   st := TStringList.Create;
  try
    INI.ReadSections(st);
    if st.Count = 0 then exit;
    for i:=0 to st.Count - 1 do
    begin
      s := INI.ReadString(st.Strings[i], 'Command','');
      if s <> '' then
      begin
        AddLVItem(s);
        sLV.Items[sLV.Items.Count - 1].Checked     := INI.ReadBool(st.Strings[i], 'Checked', false);
        j := INI.ReadInteger(st.Strings[i], 'ProcessStatus', -1);
        if j <> -1 then sLV.Items[sLV.Items.Count - 1].SubItems[0] := strExitCode[TExitCode(j)];
        sLV.Items[sLV.Items.Count - 1].SubItems[1] := INI.ReadString(st.Strings[i], 'Move', '');
      end;
    end;
  finally
    INI.Free;
    st.Free;
  end;
end;

procedure TFrmMain.LVCommandListSaveToFile(FileName: String);
var
  INI: TIniFile;
    i: integer;
    Section: String;
begin
  if FileName = '' then Exit;
  INI := TIniFile.Create(FileName);
  try
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

procedure TFrmMain.LVCommandLisrFromFileOld(FileName: String);
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

procedure TFrmMain.PM_ClearMemoClick(Sender: TObject);
begin
  //smm.Lines.Clear;
  sLV.Clear;
end;

procedure TFrmMain.PM_LoadFromCommanLogClick(Sender: TObject);
var INI : TIniFile;
begin
  OpenDlg.Filter := 'Text files *.txt|*.txt';
  OpenDlg.InitialDir := CurrPath;
  if Not OpenDlg.Execute then Exit;

  sLV.Clear;
  LVLoadCommandListFromFile(OpenDlg.FileName);
  CurrentCommandList := OpenDlg.FileName;
  INI := TIniFile.Create(CurrPath + 'config.ini');
  try
    INI.WriteString('SETTINGS', CommandList, CurrentCommandList);
  finally
    INI.free;
  end;

end;

procedure TFrmMain.PM_ImportFromBatFileClick(Sender: TObject);
var INI: TIniFile;
begin
  OpenDlg.Filter := 'Bat files *.bat|*.bat';
  OpenDlg.InitialDir := CurrPath;
  if Not OpenDlg.Execute then Exit;
  LVCommandLisrFromFileOld(OpenDlg.FileName);
  //CurrentCommandList := OpenDlg.FileName;

  CurrentCommandList :=  CurrPath + CommandList + '_' + FormatDateTime('dd.mm.yyyy_hh.mm.ss', Date+Time) + '.txt';
  LVCommandListSaveToFile(CurrentCommandList);

  INI := TIniFile.Create(CurrPath + 'config.ini');
  try
    INI.WriteString('SETTINGS', CommandList, CurrentCommandList);
  finally
    INI.Free;
  end;

end;

procedure TFrmMain.SaveSettings;
var INI: TIniFile;
begin
  INI := TIniFile.Create(CurrPath + 'config.ini');

  try
    INI.WriteString('SETTINGS', 'Plotter', sFNameEdPlotter.Text);
    INI.WriteString('SETTINGS', 'id', sEdID.Text);
    INI.WriteString('SETTINGS', 'Path', sEdPath.Text);
    INI.WriteString('SETTINGS', 'StartNonce', sEdStartNonce.Text);
    INI.WriteString('SETTINGS', 'DestDir', sDirEditDest.Text);
    INI.WriteBool('SETTINGS', 'FileMove', sChBoxMoveFile.Checked);
    INI.WriteBool('SETTINGS', 'ReWrite', sChBoxReWrite.Checked);
    INI.WriteString('SETTINGS', CommandList, CurrentCommandList);
  finally
    INI.Free;
  end;

end;

procedure TFrmMain.sBtnSaveBatClick(Sender: TObject);
var st: TStrings;
    i : integer;
begin
  if sLV.Items.Count = 0 then
  begin
    MessageBox(Handle, PChar('There are no lines'), PChar(MB_CAPTION), MB_ICONWARNING);
    Exit;
  end;

  if Not sSaveDlg.Execute then Exit;
  st := TStringList.Create;

  st.Add('@setlocal');
  st.Add('@cd /d %~dp0');
  if (sCmBoxExSelectDisk.Text <> '') and (sEdPath.Text <> '') then
    st.Add('mkdir ' + sCmBoxExSelectDisk.Text + sEdPath.Text);

  try
    for i := 0 to sLV.Items.Count - 1 do
    begin
      st.Add(sLV.Items[i].Caption);
    end;
    st.SaveToFile(sSaveDlg.FileName);
  finally
    st.Free;
  end;

end;

procedure TFrmMain.sBtnCreateCommandClick(Sender: TObject);
var i: SmallInt;
    s_temp, path: String;
    sn: Integer;
    INI: TIniFile;
begin
  if (sFNameEdPlotter.Text = '') then
  begin
    MessageBox(Handle, PChar('Not selected plotter'), PChar('PLOTS_GEN_GUI'), MB_ICONWARNING);
    Exit;
  end;

  sn := StrToInt(sEdStartNonce.Text);

  if sChBoxPathEnable.Checked then path := ' -path ' + sCmBoxExSelectDisk.Text + sEdPath.Text;

  for i := 1 to sSpEdCount.Value do
  begin
    s_temp := sFNameEdPlotter.Text + ' -id ' + sEdID.Text
              + ' -sn ' + IntToStr(sn) + ' -n ' +sSpEdNonces.Text
              + ' -t ' + sSpEdThreads.Text
              + path
              + ' -mem ' + ConvertValueMem + 'G';
    AddLVItem(s_temp);
    inc(sn, sSpEdNonces.Value + 1);
  end;

  sEdStartNonce.Text := IntToStr(sn);

  CurrentCommandList :=  CurrPath + CommandList + '_' + FormatDateTime('dd.mm.yyyy_hh.mm.ss', Date+Time) + '.txt';
  LVCommandListSaveToFile(CurrentCommandList);
  SaveSettings;

end;

procedure TFrmMain.sBtnLastPlotsClick(Sender: TObject);
var
  NextNonce: String;
begin
  if Not sOpenDlgLastNonce.Execute then Exit;
  NextNonce := GetNextNonceFromName(sOpenDlgLastNonce.FileName);
  if NextNonce = '' then Exit;
  sEdStartNonce.Text := NextNonce;

end;

procedure TFrmMain.sBtnStartClick(Sender: TObject);
var
    //s_temp: String;
    SR: TSearchRec;
    FindDir: String;
    SourceDir: String;
    INI: TIniFile;
    i, j: integer;
    FindPlot: Boolean;
    ProcExitCode: Cardinal;
    Plotter : String;
    SectionName: String;
    MoveResult: TMoveResult;

begin

  if sLV.Items.Count = 0 then Exit;

  INI := TIniFile.Create(CurrentCommandList);

  // Save list command to log
  {
  for i := 0 to sLv.Items.Count - 1 do
    SectionName := ExtractParam('-id', AnsiLowerCase(sLV.Items[i].Caption))
                   + '_' + ExtractParam('-sn', AnsiLowerCase(sLV.Items[i].Caption));

    INI.WriteString(SectionName, 'command', sLV.Items[i].Caption);
    INI.WriteBool(SectionName, 'Checked', sLV.Items[i].Checked);
  end;   }

  sLV.HideSelection            := False;
  sBtnStart.Enabled            := false;
  sBtnCreateCommand.Enabled    := false;
  PM_ClearMemo.Enabled         := false;
  PM_ImportFromBatFile.Enabled := false;

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

      // detect XPlotter
      Plotter := LowerCase(sLV.Items[i].Caption);

      //*******  Create Process *******
      if (Pos('xplotter_sse.exe', Plotter) <> 0) or (Pos('xplotter_avx.exe', Plotter) <> 0) then
      begin
        Plotter := copy(Plotter, 1, Pos('.exe', Plotter) + pred(length('.exe')));
        sLV.Items[i].SubItems[0] := 'Create';
        ProcExitCode := ExecAndWait(nil, PChar(sLV.Items[i].Caption), PChar(ExtractFileDir(Plotter)), SW_NORMAL);
      end
       else
      begin
        sLV.Items[i].SubItems[0] := 'Create';
        ProcExitCode := ExecAndWait(nil, PChar(ComSpec + ' /C ' + '"' + sLV.Items[i].Caption + '"'), Nil, SW_NORMAL);
      end;

      // Processing EXIT CODE
      case ProcExitCode of
        STATUS_WAIT_0:
          begin
            if TERMINATE_PROCESS then
            begin
              sLV.Items[i].SubItems[0] := strExitCode[TExitCode(EX_STOPED)];  //'Stoped';
              INI.WriteInteger(SectionName, 'ProcessStatus', integer(TExitCode(EX_STOPED)));
            end
            else
            begin
              sLV.Items[i].SubItems[0] := strExitCode[TExitCode(EX_COMPLETE)];
              //if Not TERMINATE_PROCESS then
              sLV.Items[i].Checked := false;
              INI.WriteBool(SectionName, 'checked', false);
              INI.WriteInteger(SectionName, 'ProcessStatus', integer(TExitCode(EX_COMPLETE)));
            end;
          end;
        STATUS_CONTROL_C_EXIT:
          begin
            sLV.Items[i].SubItems[0] := strExitCode[TExitCode(EX_CLOCE)];
            sLv.Items[i].Checked     := False;
            INI.WriteBool(SectionName, 'checked', false);
            INI.WriteInteger(SectionName, 'ProcessStatus', integer(TExitCode(EX_CLOCE)));
          end;
        WAIT_FAILED:
          begin
            sLV.Items[i].SubItems[0] := strExitCode[TExitCode(EX_FILED)];
            sLV.Items[i].Checked     := false;
            INI.WriteBool(SectionName, 'checked', false);
            INI.WriteInteger(SectionName, 'ProcessStatus', integer(TExitCode(EX_FILED)));
            Break;
          end;
       else
         begin
           sLV.Items[i].SubItems[0] := strExitCode[TExitCode(EX_UNKNOWN)];
           sLV.Items[i].Checked     := false;
           INI.WriteBool(SectionName, 'checked', false);
           INI.WriteInteger(SectionName, 'ProcessStatus', integer(TExitCode(EX_UNKNOWN)));
         end;
      end;

      // *************** Move created file *****************
      if sChBoxMoveFile.Checked and (sDirEditDest.Text <> '')
         and (ProcExitCode = STATUS_WAIT_0) and (Not TERMINATE_PROCESS) then
      begin

        FindPlot  := false;
        SourceDir := ExtractParam('-path', sLV.Items[i].Caption);
        if SourceDir = '' then SourceDir := ExtractFileDir(Plotter);
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

        sLV.Items[i].SubItems[1] := strMoveResult[MoveResult];
        INI.WriteString(SectionName, 'Move', strMoveResult[MoveResult]);

      end;

    end;

  finally
    INI.Free;
  end;

  sBtnStart.Enabled            := true;
  sBtnCreateCommand.Enabled    := true;
  PM_ClearMemo.Enabled         := true;
  PM_ImportFromBatFile.Enabled := true;
end;

procedure TFrmMain.sBtnStopClick(Sender: TObject);
begin
  TERMINATE_PROCESS := true;
end;

procedure TFrmMain.ScanDrive;
var
  sh: Char;
  index: ShortInt;
begin
  for sh := 'A' to 'Z' do
  begin

    Case GetDriveType(PWideChar(sh+':\')) of

      DRIVE_FIXED:
       begin
         index := sCmBoxExSelectDisk.Items.Add(sh+':\');
         sCmBoxExSelectDisk.ItemsEx[index].ImageIndex := AddAssociatedIcon(sh+':\');
       end;

      DRIVE_REMOVABLE:
       begin
         index := sCmBoxExSelectDisk.Items.Add(sh+':\');
         sCmBoxExSelectDisk.ItemsEx[index].ImageIndex := AddAssociatedIcon(sh+':\');
       end;

      //DRIVE_REMOTE:
      // begin
      //   index := sCmBoxExSelectDisk.Items.Add(sh+':\');
      //   sCmBoxExSelectDisk.ItemsEx[index].ImageIndex := AddAssociatedIcon(sh+':\');
      // end;

      DRIVE_RAMDISK:
       begin
         index := sCmBoxExSelectDisk.Items.Add(sh+':\');
         sCmBoxExSelectDisk.ItemsEx[index].ImageIndex := AddAssociatedIcon(sh+':\');
       end;

    End;

  end;
end;

procedure TFrmMain.sChBoxPathEnableClick(Sender: TObject);
begin
  if sChBoxPathEnable.Checked then
  begin
    sLblStatDisk.Caption :=  IntToStr(SELECT_DISK_FREE_SZ) +
                         ' GB free space Disk [' + sCmBoxExSelectDisk.Text + ']'
  end
  else
    sLblStatDisk.Caption :=  IntToStr(CURRENT_DISK_FREE_SZ) +
                         ' GB free space Disk [' + CurrentDisk + '\]';
end;

procedure TFrmMain.sCmBoxExSelectDiskChange(Sender: TObject);
begin
  GetSelectDiskSpace;
end;

procedure TFrmMain.sCmBoxExSelectDiskKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TFrmMain.sEditChange(Sender: TObject);
var i: integer;
d_char: set of char;
begin
  d_char := ['0'..'9'];
  for i := 1 to Length(TEdit(Sender).Text) do
  begin
    if not (TEdit(Sender).Text[i] in d_char) then
    begin
      TEdit(Sender).Text := '';
      Break;
    end;
  end;
end;

procedure TFrmMain.sEditKeyPress(Sender: TObject; var Key: Char);
var d_char: set of char;
begin

  d_char := ['0'..'9',#8];
  if not (key in d_char) then Key := #0;

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

procedure TFrmMain.sSpEdCountChange(Sender: TObject);
begin
  if sSpEdNonces.Value = 0 then
  begin
    sSpEdCount.Value := 1;
    sLblPlotsSumGb.Caption := '= max Gb';
  end
    else
  begin
    sLblPlotsSumGb.Caption := '= ' + IntToStr(sSpEdCount.Value * (sSpEdNonces.Value div NONCE)) + ' Gb';

    CheckFreeSpace;

  end;
end;

procedure TFrmMain.sSpEdMemChange(Sender: TObject);
begin
  sLblMemGb.Caption := '= ' + ConvertValueMem + ' Gb';

  if sSpEdMem.Value > ((MemTotalPhys div 1024 div 1024) - 1024) then
  begin

    sLblMemGb.Visible := false;
    JvLblGLMemOverflowed.Font.Color := $00007DFB;
    JvLblGLMemOverflowed.Caption := sLblMemGb.Caption + ' > ';
    JvLblGLMemOverflowed.Visible := true;

    if sSpEdMem.Value > (MemTotalPhys div 1024 div 1024) then
    begin
      sLblMemGb.Visible := false;
      JvLblGLMemOverflowed.Font.Color := clRed;
      JvLblGLMemOverflowed.Caption := sLblMemGb.Caption + ' > ';
      JvLblGLMemOverflowed.Visible := true;
      exit;
    end;

  end
   else
  begin
    JvLblGLMemOverflowed.Visible := false;
    sLblMemGb.Visible := true;
  end;

exit;

  if sSpEdMem.Value > (MemTotalPhys div 1024 div 1024) then
  begin
    sLblMemGb.Visible := false;
    JvLblGLMemOverflowed.Font.Color := clRed;
    JvLblGLMemOverflowed.Caption := sLblMemGb.Caption + ' > ';
    JvLblGLMemOverflowed.Visible := true;
  end
   else
  begin
    JvLblGLMemOverflowed.Visible := false;
    sLblMemGb.Visible := true;
  end;

end;

procedure TFrmMain.sSpEdNoncesChange(Sender: TObject);
begin

 if sSpEdNonces.Value = NONCE then
 begin
   if NonceDirection < NONCE then
      sSpEdNonces.Value := NONCE * 2
   else sSpEdNonces.Value := 0;
 end;
 NonceDirection := sSpEdNonces.Value;

 if sSpEdNonces.Value < 0 then sSpEdNonces.Value := 0;
 if sSpEdNonces.Value = 0 then
 begin
   sLblPlotsSumGb.Caption := '= max Gb';
   sLblGB.Caption         := '= Auto';
   sSpEdCount.Value       := 1;
   sSpEdCount.MaxValue    := 1;
 end
   else
 begin
   sLblGB.Caption         :=  '= ' + IntToStr(sSpEdNonces.Value div NONCE) + ' Gb';
   //sSpEdCount.MaxValue    :=  NONCE div (sSpEdNonces.Value div NONCE);
   sLblPlotsSumGb.Caption := '= ' + IntToStr((sSpEdNonces.Value div NONCE) * sSpEdCount.Value) + ' Gb';
 end;
 CheckFreeSpace;
end;

procedure TFrmMain.sSpEdThreadsChange(Sender: TObject);
begin
  sSpEdMem.Value := sSpEdThreads.Value * 500;
end;

procedure TFrmMain.sWbLabelClick(Sender: TObject);
begin
  EdDonation.Text := TsWebLabel(sender).Caption;
  EdDonation.SelectAll;
  EdDonation.CopyToClipboard;
end;

end.
