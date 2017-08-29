unit UFrmProgressBar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sLabel, Vcl.ComCtrls,
  acProgressBar, sSkinProvider, TimeFormat;

type TLableMode = (lmAdding, lmSaving, lmLoading, lmDeleting, lmChanging);

type
  TFrmProgressBar = class(TForm)
    sSkinProvider: TsSkinProvider;
    sProgBar: TsProgressBar;
    sLblInfo: TsLabel;
    procedure StartShow(Lbl: TLableMode; MaxValue: Integer);
    procedure ProgressNext(ProgressValue: Int64);
    procedure StopClose;
  private
    { Private declarations }
    LableMode: TLableMode;
    MaxRange: Integer;
  public
    { Public declarations }
    BgnTime: Cardinal;
  end;

var
  FrmProgressBar: TFrmProgressBar;

implementation

Uses ResourceLang, UFrmCreateTask, UFrmMain;

{$R *.dfm}

{ TFrmProgressBar }

procedure TFrmProgressBar.ProgressNext(ProgressValue: Int64);
var
   Percent: Integer;
   lbl: String;
begin
  if BgnTime = 0 then BgnTime := GetTickCount;
  Percent := Trunc((ProgressValue * 100) / MaxRange);
  sProgBar.Position := Percent;

  case LableMode of
    lmAdding:   lbl := lbl_FrmProgresBar_1;
    lmSaving:   lbl := lbl_FrmProgresBar_2;
    lmLoading:  lbl := lbl_FrmProgresBar_3;
    lmDeleting: lbl := lbl_FrmProgresBar_4;
    lmChanging: lbl := lbl_FrmProgresBar_5;
  end;

  sLblInfo.Caption  := lbl + '  ' + IntToStr(ProgressValue) + '     '
                      + IntToStr(Percent) + '%' + '     ' + lbl_FrmProgresBar_6 + ' '
                      + GetMilisecondsFormat(GetTickCount - BgnTime, TS_MINUTE, TS_Alfa);
end;

procedure TFrmProgressBar.StartShow(Lbl: TLableMode; MaxValue: Integer);
begin
  LableMode              := Lbl;
  MaxRange               := MaxValue;
  BgnTime                := 0;
  sProgBar.Position      := 0;
  sProgBar.Max           := 100;
  Show;
end;

procedure TFrmProgressBar.StopClose;
begin
  if Not Visible then Exit;
  //if FrmMain.WindowState = wsMinimized then
  FrmMain.WindowState := wsNormal;
  Application.ProcessMessages;
  Sleep(SLEEP_VISIBLE);
  Close;
end;

end.
