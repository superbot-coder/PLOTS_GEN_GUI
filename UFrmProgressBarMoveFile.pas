unit UFrmProgressBarMoveFile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, acProgressBar,
  sSkinProvider, Vcl.StdCtrls, sLabel, Vcl.Buttons, sSpeedButton, Vcl.ExtCtrls,
  TimeFormat, System.ImageList, Vcl.ImgList, ModFileFormatSize, Error;

type TMoveResult = (MR_START, MR_COMPLETE, MR_STOPED, MR_ERROR, MR_NOTFOUND, MR_PAUSE);
var  strMoveResult: Array[TMoveResult] of string = ('Start', 'Complete', 'Stoped', 'Error', 'Not found', 'Pause');

type
  TFrmProgressBarMoveFile = class(TForm)
    sSkinProvider: TsSkinProvider;
    sProgressBar: TsProgressBar;
    sLblSourFileS: TsLabel;
    sLblFileSize: TsLabel;
    sLblAmount: TsLabel;
    sLblSpeed: TsLabel;
    sLblTime: TsLabel;
    sSpeedBtnPlay: TsSpeedButton;
    sSpeedBtnPause: TsSpeedButton;
    TmrCopy: TTimer;
    sLblDestDirS: TsLabel;
    sLblSourFile: TsLabel;
    sLblDestDir: TsLabel;
    ImageList: TImageList;
    sSpeedBtn: TsSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure StopClose;
    procedure TmrCopyTimer(Sender: TObject);
    procedure sSpeedBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sSpeedBtnPlayClick(Sender: TObject);
    procedure sSpeedBtnPauseClick(Sender: TObject);
    function CheckFreeSpace(RequestSpace: int64;  Drive: String): Boolean;
  private
    FTimeResult      : Cardinal;
    FFileDestination : String;
    FFileSource      : String;
    FMoveResult      : TMoveResult;
    frm_caption      : String;
  public
    property MoveResult: TMoveResult read FMoveResult;
    property TimeResult: Cardinal read FTimeResult;
    procedure ShowmodalMoveFile(FileSource, FileDestination: String);
  end;

type
 TThreadCopy = class(TThread)
 private
   FFileSour   : String;
   FFileDest   : String;
   FPause      : Boolean;
   FComplete   : Boolean;
   FByteAmount : Int64;
 protected
   procedure Execute; override;
 public
   property ByteAmount: int64 read FByteAmount;
   property Complete: boolean read FComplete;
   procedure Pause;
   procedure ToContinue;
   constructor Create(FileSour, FileDest: String);
 end;

var
  FrmProgressBarMoveFile: TFrmProgressBarMoveFile;
  TERMINATE_COPY    : Boolean;
  ThrCopyFile       : TThreadCopy;
  GStartTime        : Cardinal;
  GSourceSize       : Int64;
  GByteAmount       : Int64;
  GDriveFreeSize    : Int64;
  ShowCommitCount   : Integer;

const
  DEFAUT_BUFFER = 1048576; // 1MB
  SHOW_COMMIT   = 3;

implementation

USES UFrmMain;

{$R *.dfm}

{ TFrmProgressBarMoveFile }

function TFrmProgressBarMoveFile.CheckFreeSpace(RequestSpace: int64;
  Drive: String): Boolean;
var
  FreeByte, DriveTotalSpace, DriveFreeSpace, DFreeSpace: Int64;
  CountReadSecond: Int64;
  LastBuffer: Boolean;
  TimeStep  : Cardinal;
begin
  Result     := false;
  LastBuffer := false;
  if Not GetDiskFreeSpaceEx(PChar(Drive), FreeByte, DriveFreeSpace, @DriveFreeSpace) then Exit;

  if Assigned(ThrCopyFile) then
    if Not ThrCopyFile.Finished then
    begin

      TimeStep := (GetTickCount - GStartTime) div 1000;

      // check the last buffer
      if (GByteAmount <> 0) and ((MOVE_BUFFER_SIZE * DEFAUT_BUFFER) >= (GSourceSize - GByteAmount)) then LastBuffer := true;

      if LastBuffer or ((GByteAmount > 0) and (TimeStep > 0)) then
      begin
        if FreeByte > RequestSpace then Result := true;
       //FrmMain.mm.Lines.Add('[03] CheckFreeSpace()');
      end
       else
      begin
        CountReadSecond := Trunc(GByteAmount / TimeStep);
       //FrmMain.mm.Lines.Add('CountReadSecond = '+IntToStr(CountReadSecond));
        if (RequestSpace + CountReadSecond) < FreeByte then Result := true
      end;
      Exit;
    end;

  //FrmMain.mm.Lines.Add('TimeStep = '+IntToStr(TimeStep));

  if RequestSpace < DriveFreeSpace then Result := true;
  FrmMain.mm.Lines.Add('[03] без потока');

end;

procedure TFrmProgressBarMoveFile.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  if ThrCopyFile.Finished then
  begin
    TmrCopy.Enabled := false;
    try
      ThrCopyFile.Free;
    except
      ShowMessage(Error.SystemErrorMessage(GetLastError));
    end;
    //if MoveResult then DeleteFile(FFileSource);
  end
    else
  begin
    if MessageBox(Handle, PChar('Вы собираетесь отменить перемещение файла ' +#10#13
                + 'Что бы подтвердить свои действия нажмите "ДА",' +#10#13
                + 'или нажмите "Нет" для отмены'),
                PChar('MOVE FILE'), MB_YESNO or MB_ICONWARNING) = ID_NO then
    begin
      Action := caNone;
      Exit;
    end;
    TmrCopy.Enabled := false;
    FMoveResult     := MR_STOPED;
    try
      ThrCopyFile.Terminate;
      ThrCopyFile.Free;
    except
      ShowMessage(Error.SystemErrorMessage(GetLastError));
    end;
    DeleteFile(FFileDestination);
  end;

end;

procedure TFrmProgressBarMoveFile.FormCreate(Sender: TObject);
begin
  //Caption := MB_CAPTION;
  frm_caption := Caption;
end;

procedure TFrmProgressBarMoveFile.ShowmodalMoveFile(FileSource,
  FileDestination: String);
begin
  FMoveResult           := MR_START;
  if Not FileExists(FileSource) then Exit;
  FFileSource           := FileSource;
  FFileDestination      := FileDestination;
  sLblSourFile.Caption  := FileSource;
  sLblDestDir.Caption   := ExtractFileDir(FileDestination);
  GSourceSize           := GetFileSz(FileSource);
  GByteAmount           := 0;
  ShowCommitCount       := 0;
  sProgressBar.Position := 0;
  FTimeResult           := 0;
  sLblFileSize.Caption  := 'File size: ' + FormatFileSize(GSourceSize);
  sLblSpeed.Caption     := 'Speed: 0 Mb/s';
  sLblAmount.Caption    := 'Amount: 0 Mb';
  GStartTime            := GetTickCount;

  //  free space drive
  if Not CheckFreeSpace(GSourceSize , ExtractFileDrive(FileDestination)) then
  begin
    FrmMain.log('TFrmProgressBarMoveFile.ShowmodalMoveFile CheckFreeSpace = exit');
    Exit;
  end
  else
  begin
    FrmMain.log('TFrmProgressBarMoveFile.ShowmodalMoveFile CheckFreeSpace = continue');
  end;

  ThrCopyFile     := TThreadCopy.Create(FileSource, FiledeStination);
  TmrCopy.Enabled := True;
  ShowModal;
end;

procedure TFrmProgressBarMoveFile.sSpeedBtnClick(Sender: TObject);
begin
  close;
end;

procedure TFrmProgressBarMoveFile.sSpeedBtnPauseClick(Sender: TObject);
begin
  Caption := FRM_CAPTION + ' [PAUSE]';
  ThrCopyFile.Pause;
  FMoveResult := MR_PAUSE;
  TmrCopy.Enabled := false;
end;

procedure TFrmProgressBarMoveFile.sSpeedBtnPlayClick(Sender: TObject);
begin
  ThrCopyFile.ToContinue;
  Caption := FRM_CAPTION;
  TmrCopy.Enabled := true;
end;

procedure TFrmProgressBarMoveFile.StopClose;
begin
  FrmMain.WindowState := wsNormal;
  Application.ProcessMessages;
  sleep(SLEEP_VISIBLE);
  Close;
end;

procedure TFrmProgressBarMoveFile.TmrCopyTimer(Sender: TObject);
var
  p_time : Cardinal; // Passed time
  f_time : Cardinal; // Forecast of time
  r_time : Cardinal; // Remained to time
begin
  if (GByteAmount <> 0)then
  begin
    // forecast of time
    p_time := GetTickCount - GStartTime;
    f_time := Trunc((((p_time) * GSourceSize) / GByteAmount));
    r_time := f_time - p_time;

    sProgressBar.Position := Trunc((GByteAmount * 100) / GSourceSize);
    sLblAmount.Caption := 'Amount: ' + FormatFileSize(GByteAmount);
    sLblSpeed.Caption  := 'Speed: ' +  FormatFileSize(GByteAmount / ((p_time) / 1000)) + '/s';
    sLblTime.Caption   := '[Passed time: ' + GetMilisecondsFormat(p_time, TS_HOUR, TS_Colon) +
                        ' ] [Forecast of time: ' + GetMilisecondsFormat(f_time, TS_HOUR, TS_Colon) +
                        ' ] [Remained to time: ' + GetMilisecondsFormat(r_time, TS_HOUR, TS_Colon) + ']';
  end;

  // Check free space
  If Not ThrCopyFile.Finished then
  begin
    if Not CheckFreeSpace((GSourceSize - GByteAmount), ExtractFileDrive(FFileDestination)) then
    begin
      ThrCopyFile.Pause;
      Caption := FRM_CAPTION + ' [PAUSE] there is no empty seat';
    end;
  end;

  // Sign operation completion
  if ThrCopyFile.Finished then
  begin
    Inc(ShowCommitCount);
    if ShowCommitCount < SHOW_COMMIT then Exit;
    FTimeResult := p_time;
    if ThrCopyFile.Complete then FMoveResult := MR_COMPLETE;

    if MoveResult = MR_COMPLETE then FrmMain.log('MoveResult = Complete')
    else FrmMain.log('MoveResult = false');

    Close;
  end;

end;

{ TThreadCopy }
constructor TThreadCopy.Create(FileSour, FileDest: String);
begin
  FFileSour   := FileSour;
  FFileDest   := FileDest;
  FComplete   := False;
  FByteAmount := 0;
  inherited Create(false);
end;

procedure TThreadCopy.Execute;
var
  StrmSour   : TFileStream;
  StrmDest   : TFileStream;
  ByteRead   : integer;
  FileSize   : Int64;
  PBuffer    : Pointer;
  BufferSize : LongWord;
  Count      : Int64;
begin

  FileSize    := 0;
  Count       := 1;

  StrmSour := TFileStream.Create(FFileSour, fmOpenRead);
  FileSize := StrmSour.Size;

  if FileExists(FFileDest) then
    StrmDest := TFileStream.Create(FFileDest, fmOpenWrite or fmExclusive)
  else
    StrmDest := TFileStream.Create(FFileDest, fmCreate or fmExclusive);

  try
    // Range: Buffer >= 1MB and Buffer <= 50MB
    if (MOVE_BUFFER_SIZE > 1) and (MOVE_BUFFER_SIZE <= 50) then
      BufferSize := DEFAUT_BUFFER * MOVE_BUFFER_SIZE
    else
      BufferSize := DEFAUT_BUFFER; //Default Buffer 1 MB, оld parametr 4MB, 10mb

    GetMem(PBuffer, BufferSize);

    Count := 0;
    repeat
      if FPause and (Not Terminated) then
      begin
        sleep(100);
        continue;
      end;

      ByteRead := StrmSour.Read(PBuffer^, BufferSize);
      StrmDest.Write(PBuffer^, ByteRead);
      GByteAmount := GByteAmount + ByteRead;
      FByteAmount := FByteAmount + ByteRead;

    until (ByteRead < BufferSize) or Terminated;

    if FByteAmount = FileSize then FComplete := True;

  finally
    FreeMem(PBuffer);
    StrmSour.Free;
    StrmDest.Free;
  end;

end;

procedure TThreadCopy.Pause;
begin
  FPause := true;
end;

procedure TThreadCopy.ToContinue;
begin
  FPause := false;
end;

{ TFrmCopy }

end.
