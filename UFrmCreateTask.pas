unit UFrmCreateTask;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sButton, sSkinProvider,
  sSpinEdit, JvExControls, JvLabel, sCheckBox, sEdit, Vcl.ComCtrls, sComboBoxes,
  sLabel, Winapi.ShellAPI, ModFileFormatSize, System.ImageList, Vcl.ImgList,
  System.IniFiles;

type TFrmShowMode = (FRM_NEWTASK, FRM_ADDPLOTS);

type
  TFrmCreateTask = class(TForm)
    sSkinProvider: TsSkinProvider;
    sBtnAPPLY: TsButton;
    sLblDrive: TsLabel;
    sCmBoxExSelectDisk: TsComboBoxEx;
    sLblPath: TsLabel;
    sEdPath: TsEdit;
    sChBoxPathEnable: TsCheckBox;
    sEdID: TsEdit;
    JvOverflowed: TJvLabel;
    JvLblGLMemOverflowed: TJvLabel;
    sLblStatDisk: TsLabel;
    sLblGlobalMem: TsLabel;
    sLblPlotsSumGb: TsLabel;
    sLblMemGb: TsLabel;
    sSpEdMem: TsSpinEdit;
    sSpEdCount: TsSpinEdit;
    sLblCountPlots: TsLabel;
    sLblMem: TsLabel;
    sSpEdThreads: TsSpinEdit;
    sLblThreads: TsLabel;
    sLblGB: TsLabel;
    sBtnLastPlots: TsButton;
    sSpEdNonces: TsSpinEdit;
    sLblNonces: TsLabel;
    sEdStartNonce: TsEdit;
    sLblSN: TsLabel;
    sLblID: TsLabel;
    sLblSelectDiskSpace: TsLabel;
    sLblCurrDiskSpace: TsLabel;
    ImageListDrive: TImageList;
    sEdNewNameTask: TsEdit;
    sLblNameTask: TsLabel;
    procedure sBtnAPPLYClick(Sender: TObject);
    procedure CheckFreeSpace;
    function ConvertValueMem: string;
    procedure FormCreate(Sender: TObject);
    procedure GetCurrentDiskSpace;
    procedure GetSelectDiskSpace;
    function GetNextNonceFromName(PlotsName: String): String;
    procedure sBtnLastPlotsClick(Sender: TObject);
    procedure ScanDrive;
    procedure sChBoxPathEnableClick(Sender: TObject);
    procedure sCmBoxExSelectDiskChange(Sender: TObject);
    procedure sCmBoxExSelectDiskKeyPress(Sender: TObject; var Key: Char);
    //procedure sEditChange(Sender: TObject);
    //procedure sEditKeyPress(Sender: TObject; var Key: Char);
    procedure sSpEdCountChange(Sender: TObject);
    procedure sSpEdMemChange(Sender: TObject);
    procedure sSpEdNoncesChange(Sender: TObject);
    procedure sSpEdThreadsChange(Sender: TObject);
    procedure LoadeSettings;
    function CheckInsertChar(StrValue: String): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
    FrmShowMode : TFrmShowMode;
    Apply: Boolean;
  end;

var
  FrmCreateTask: TFrmCreateTask;

implementation

USES ResourceLang, UFrmMain;

{$R *.dfm}

function TFrmCreateTask.CheckInsertChar(StrValue: String): Boolean;
var i: integer;
  d_char: set of char;
begin
  Result := true;
  d_char := ['0'..'9'];
  for i:=1 to Length(StrValue) do
  begin
    if not (StrValue[i] in d_char) then
    begin
      Result := false;
      Break;
    end;
  end;

end;


function TFrmCreateTask.ConvertValueMem: string;
begin
  Result := StringReplace(FloatToStr(sSpEdMem.Value * 0.001), ',', '.', []);
end;


procedure TFrmCreateTask.FormCreate(Sender: TObject);
begin

  ScanDrive;
  sSpEdNonces.Increment     := NONCE;
  JvLblGLMemOverflowed.Left := sLblMemGb.Left;
  JvLblGLMemOverflowed.Top  := sLblMemGb.Top;
  JvOverflowed.Left         := sLblPlotsSumGb.Left;
  JvOverflowed.Top          := sLblPlotsSumGb.Top;

  sSpEdThreads.Value := MaxCore;

  sLblGlobalMem.Caption := 'Global Memory: ' +  FormatFileSize(MemTotalPhys);
  sSpEdMem.Value := MaxCore * 500;
  sCmBoxExSelectDisk.ItemIndex := sCmBoxExSelectDisk.Items.IndexOf(CurrentDisk+'\');
  sLblStatDisk.Caption := IntToStr(CURRENT_DISK_FREE_SZ) +
                          ' GB free space [' +CurrentDisk + '\]';

  sSpEdMemChange(Nil);
  GetCurrentDiskSpace;
  sCmBoxExSelectDiskChange(Nil);
  sChBoxPathEnableClick(Nil);
  LoadeSettings;

end;

procedure TFrmCreateTask.GetCurrentDiskSpace;
var  Free_Bytes, TotalSize, FreeSize: Int64;
begin
  GetDiskFreeSpaceEx(PChar(ExtractFileDrive(CurrPath)), Free_Bytes, TotalSize, @FreeSize);
  CURRENT_DISK_FREE_SZ := (FreeSize div 1024 div 1024 div 1024);

  sLblCurrDiskSpace.Caption := 'Current disk [' + CurrentDisk + '\] '
       + 'Total space: ' + FormatFileSize(TotalSize) + ', Free space: ' +  FormatFileSize(FreeSize);
end;

function TFrmCreateTask.GetNextNonceFromName(PlotsName: String): String;
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

procedure TFrmCreateTask.GetSelectDiskSpace;
var  Free_Bytes, TotalSize, FreeSize: Int64;
begin
  GetDiskFreeSpaceEx(PChar(sCmBoxExSelectDisk.Text), Free_Bytes, TotalSize, @FreeSize);
  SELECT_DISK_FREE_SZ := (FreeSize div 1024 div 1024 div 1024);

  sLblSelectDiskSpace.Caption := 'Selected disk [' + sCmBoxExSelectDisk.Text + ']'
       + ' Total space: ' + FormatFileSize(TotalSize) + '; Free space: ' + FormatFileSize(FreeSize);

  if sChBoxPathEnable.Checked then
  sLblStatDisk.Caption :=  IntToStr(SELECT_DISK_FREE_SZ) +
                         ' GB free space [' + sCmBoxExSelectDisk.Text + ']';
end;

procedure TFrmCreateTask.LoadeSettings;
Var INI : TIniFile;
begin

  INI := TIniFile.Create(CurrPath + 'config.ini');

  try
    FrmCreateTask.sEdPath.Text := INI.ReadString('SETTINGS', 'Path','');
    FrmCreateTask.sEdID.Text   := INI.ReadString('SETTINGS', 'id','');
    FrmCreateTask.sEdStartNonce.Text := INI.ReadString('SETTINGS', 'StartNonce', '');
  finally
    INI.Free;
  end;

end;

procedure TFrmCreateTask.CheckFreeSpace;
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

procedure TFrmCreateTask.sBtnAPPLYClick(Sender: TObject);
begin
  if sEdNewNameTask.Text  = '' then
  begin
    MessageBox(Handle, Pchar(msg_FrmCreateTask_sBtnApply_01),
               PChar(MB_CAPTION), MB_ICONWARNING);
    Exit;
  end;

  // Check ID
  if Not CheckInsertChar(Trim(sEdID.Text)) then
  begin
    MessageBox(Handle, PChar(msg_FrmCreateTask_sBtmApply_02), PChar(MB_CAPTION), MB_ICONWARNING);
    Exit;
  end;

  // Check Nonce
    if Not CheckInsertChar(Trim(sEdStartNonce.Text)) then
  begin
    MessageBox(Handle, PChar(msg_FrmCreateTask_sBtmApply_03), PChar(MB_CAPTION), MB_ICONWARNING);
    Exit;
  end;

  Apply := true;
  Close;
end;

procedure TFrmCreateTask.sBtnLastPlotsClick(Sender: TObject);
var
  NextNonce: String;
begin
  if Not FrmMain.sOpenDlgLastNonce.Execute then Exit;
  NextNonce := GetNextNonceFromName(FrmMain.sOpenDlgLastNonce.FileName);
  if NextNonce = '' then Exit;
  sEdStartNonce.Text := NextNonce;
end;

procedure TFrmCreateTask.ScanDrive;
var
  Drive: Char;
  index: ShortInt;
begin
  for Drive := 'C' to 'Z' do
  begin

    Case GetDriveType(PWideChar(Drive+':\')) of

      DRIVE_FIXED:
       begin
         index := sCmBoxExSelectDisk.Items.Add(Drive+':\');
         sCmBoxExSelectDisk.ItemsEx[index].ImageIndex := FrmMain.AddAssociatedIcon(Drive+':\', ImageListDrive);
       end;

      DRIVE_REMOVABLE:
       begin
         index := sCmBoxExSelectDisk.Items.Add(Drive+':\');
         sCmBoxExSelectDisk.ItemsEx[index].ImageIndex := FrmMain.AddAssociatedIcon(Drive+':\', ImageListDrive);
       end;

      //DRIVE_REMOTE:
      // begin
      //   index := sCmBoxExSelectDisk.Items.Add(sh+':\');
      //   sCmBoxExSelectDisk.ItemsEx[index].ImageIndex := AddAssociatedIcon(sh+':\');
      // end;

      DRIVE_RAMDISK:
       begin
         index := sCmBoxExSelectDisk.Items.Add(Drive+':\');
         sCmBoxExSelectDisk.ItemsEx[index].ImageIndex := FrmMain.AddAssociatedIcon(Drive+':\', ImageListDrive);
       end;

    End;

  end;
end;

procedure TFrmCreateTask.sChBoxPathEnableClick(Sender: TObject);
begin
  if sChBoxPathEnable.Checked then
  begin
    sLblStatDisk.Caption :=  IntToStr(SELECT_DISK_FREE_SZ) +
                         ' GB free space [' + sCmBoxExSelectDisk.Text + ']'
  end
  else
    sLblStatDisk.Caption :=  IntToStr(CURRENT_DISK_FREE_SZ) +
                         ' GB free space [' + CurrentDisk + '\]';
end;

procedure TFrmCreateTask.sCmBoxExSelectDiskChange(Sender: TObject);
begin
  GetSelectDiskSpace;
end;

procedure TFrmCreateTask.sCmBoxExSelectDiskKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := #0;
end;

{
procedure TFrmCreateTask.sEditChange(Sender: TObject);
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
end;   }

{
procedure TFrmCreateTask.sEditKeyPress(Sender: TObject; var Key: Char);
var d_char: set of char;
begin

  d_char := ['0'..'9',#8];
  if not (key in d_char) then Key := #0;

end;
}

procedure TFrmCreateTask.sSpEdCountChange(Sender: TObject);
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

procedure TFrmCreateTask.sSpEdMemChange(Sender: TObject);
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

//exit;

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

procedure TFrmCreateTask.sSpEdNoncesChange(Sender: TObject);
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

procedure TFrmCreateTask.sSpEdThreadsChange(Sender: TObject);
begin
  sSpEdMem.Value := sSpEdThreads.Value * 500;
end;

end.