unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sMemo, sSkinProvider,
  sSkinManager, sButton, sToolEdit, Vcl.Mask, sMaskEdit, sCustomComboEdit,
  sLabel, sCurrEdit, sCurrencyEdit, sEdit, acPopupCtrls, sSpinEdit,
  Vcl.ComCtrls, sComboBoxes, System.ImageList, Vcl.ImgList, Winapi.ShellAPI,
  sDialogs, Vcl.Menus, sStatusBar, acTitleBar, System.IniFiles, cpu_info_xe,
  sCheckBox, JvExControls, JvLabel;

type
  TFrmMain = class(TForm)
    sLblXPlotter: TsLabel;
    sFNameEdPlotter: TsFilenameEdit;
    sLblPath: TsLabel;
    sBtnStart: TsButton;
    sSkinManager: TsSkinManager;
    sSkinProvider: TsSkinProvider;
    smm: TsMemo;
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
    PM_LoadFromFile: TMenuItem;
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
    procedure CreateBat;
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
    procedure PM_LoadFromFileClick(Sender: TObject);
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
    procedure INIUpStarted;
    procedure INIDownStarted;
    procedure sChBoxPathEnableClick(Sender: TObject);


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

const
  NONCE = 4096;
  LogFile = 'CreatePlotsLog.txt';

implementation

{$R *.dfm}

function TFrmMain.AddAssociatedIcon(Path: String): Integer;
var
  icon: Ticon;
  wd: WORD;
begin
  // Добавление ассоциированной иконки 
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

procedure TFrmMain.CreateBat;
var i: SmallInt;
    s_temp, path: String;
    sn: Integer;
begin
  if (sFNameEdPlotter.Text = '') then
  begin
    Exit;
  end;


  sn := StrToInt(sEdStartNonce.Text);

  //if smm.Lines.IndexOf('@setlocal') = -1 then smm.Lines.Add('@setlocal');
  //if smm.Lines.IndexOf('@cd /d %~dp0') = -1  then smm.lines.Add('@cd /d %~dp0 ');

  smm.Lines.Add('@setlocal');
  smm.lines.Add('@cd /d %~dp0');

  if sChBoxPathEnable.Checked then
  begin
     if (sCmBoxExSelectDisk.Text <> '') and (sEdPath.Text <> '') then
       smm.Lines.Add('mkdir ' + sCmBoxExSelectDisk.Text + sEdPath.Text);
     path := ' -path ' + sCmBoxExSelectDisk.Text + sEdPath.Text;
  end;

  for i := 1 to sSpEdCount.Value do
  begin
    s_temp := sFNameEdPlotter.Text + ' -id ' + sEdID.Text
              + ' -sn ' + IntToStr(sn) + ' -n ' +sSpEdNonces.Text
              + ' -t ' + sSpEdThreads.Text
              + path
              + ' -mem ' + ConvertValueMem + 'G';
    smm.Lines.Add(s_temp);
    inc(sn, sSpEdNonces.Value + 1);
  end;

  sEdStartNonce.Text := IntToStr(sn);
  SaveSettings;

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

  // Хардваре детек
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


  sLblGlobalMem.Caption := 'Global Memory: ' +
                           FormatFloat('#,###" MB "', MemTotalPhys div 1024 div 1024);

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


end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  smm.SetFocus;
end;

procedure TFrmMain.GetCurrentDiskSpace;
var  Free_Bytes, TotalSize, FreeSize: Int64;
begin
  GetDiskFreeSpaceEx(PChar(ExtractFileDrive(CurrPath)), Free_Bytes, TotalSize, @FreeSize);
  CURRENT_DISK_FREE_SZ := (FreeSize div 1024 div 1024 div 1024);

  sLblCurrDiskSpace.Caption := 'Current disk  ' + CurrentDisk + '\'
       + ' total: ' + IntToStr(TotalSize div 1024 div 1024 div 1024) + ' GB'
       + ' free: ' + IntToStr(FreeSize div 1024 div 1024 div 1024) + ' GB';
end;

procedure TFrmMain.GetSelectDiskSpace;
var  Free_Bytes, TotalSize, FreeSize: Int64;
begin
  GetDiskFreeSpaceEx(PChar(sCmBoxExSelectDisk.Text), Free_Bytes, TotalSize, @FreeSize);
  SELECT_DISK_FREE_SZ := (FreeSize div 1024 div 1024 div 1024);

  sLblSelectDiskSpace.Caption := 'Selected disk '
       + ' total: ' + IntToStr(TotalSize div 1024 div 1024 div 1024) + ' GB'
       + ' free: ' + IntToStr(FreeSize div 1024 div 1024 div 1024) + ' GB';

  if sChBoxPathEnable.Checked then
    sLblStatDisk.Caption :=  IntToStr(SELECT_DISK_FREE_SZ) +
                         ' GB free space Disk [' + sCmBoxExSelectDisk.Text + ']';

end;

procedure TFrmMain.INIDownStarted;
begin
  INI := TIniFile.Create(CurrPath + 'config.ini');
  try
    INI.WriteBool('SETTINGS', 'Started', false);
  finally
    INI.Free;
  end;
end;

procedure TFrmMain.INIUpStarted;
begin
  INI := TIniFile.Create(CurrPath + 'config.ini');
  try
    INI.WriteBool('SETTINGS','Started',true);
  finally
    INI.Free;
  end;
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
      smm.Lines.LoadFromFile(CurrPath + 'CreatePlotsLog.txt');
  finally
    INI.Free;
  end;

end;

procedure TFrmMain.PM_ClearMemoClick(Sender: TObject);
begin
  smm.Lines.Clear;
end;

procedure TFrmMain.PM_LoadFromFileClick(Sender: TObject);
begin
  OpenDlg.InitialDir := CurrPath;
  if Not OpenDlg.Execute then Exit;
  smm.Lines.LoadFromFile(OpenDlg.FileName);
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
  finally
    INI.Free;
  end;

end;

procedure TFrmMain.sBtnSaveBatClick(Sender: TObject);
begin
  if Not sSaveDlg.Execute then Exit;
  smm.Lines.SaveToFile(sSaveDlg.FileName);
end;

procedure TFrmMain.sBtnCreateCommandClick(Sender: TObject);
begin
  CreateBat;
end;

procedure TFrmMain.sBtnStartClick(Sender: TObject);
var i: SmallInt;
    s_temp: String;
    sn: Integer;
begin

  if (sFNameEdPlotter.Text = '') then
  begin
    Exit;
  end;

  sBtnStart.Enabled         := false;
  sBtnCreateCommand.Enabled := true;
  PM_ClearMemo.Enabled      := false;
  PM_LoadFromFile.Enabled   := false;
  INIUpStarted;

  TERMINATE_PROCESS := false;

  for i := 0 to smm.Lines.Count - 1 do
  begin

    Application.ProcessMessages;
    if   TERMINATE_PROCESS then Break;
    if Pos(':: passed:' ,smm.Lines[i]) <> 0 then Continue;

    // detect XPlotter
    s_temp := LowerCase(smm.Lines[i]);

    if (Pos('xplotter_sse.exe', s_temp) <> 0) or (Pos('xplotter_avx.exe', s_temp) <> 0) then
    begin
      s_temp := copy(s_temp, 1, Pos('.exe',s_temp) + pred(length('.exe')));
      ExecAndWait(nil, PChar(smm.Lines[i]), PChar(ExtractFileDir(s_temp)), SW_NORMAL);
    end
      else
    begin
      ExecAndWait(nil, PChar(ComSpec + ' /C ' + '"' + smm.Lines[i] + '"'), Nil, SW_NORMAL);
    end;

    if Not TERMINATE_PROCESS then smm.Lines[i] := ':: passed: ' + smm.Lines[i];
    smm.Lines.SaveToFile(CurrPath + 'CreatePlotsLog.txt');
  end;

  INIDownStarted;
  sBtnStart.Enabled         := true;
  sBtnCreateCommand.Enabled := true;
  PM_ClearMemo.Enabled      := true;
  PM_LoadFromFile.Enabled   := true;
end;

procedure TFrmMain.sBtnStopClick(Sender: TObject);
begin
  TERMINATE_PROCESS := true;
  INIDownStarted;
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

      DRIVE_REMOTE:
       begin
         index := sCmBoxExSelectDisk.Items.Add(sh+':\');
         sCmBoxExSelectDisk.ItemsEx[index].ImageIndex := AddAssociatedIcon(sh+':');
       end;

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
