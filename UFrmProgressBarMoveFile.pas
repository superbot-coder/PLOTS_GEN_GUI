unit UFrmProgressBarMoveFile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, acProgressBar,
  sSkinProvider, Vcl.StdCtrls, sLabel;

type
  TFrmProgressBarMoveFile = class(TForm)
    sSkinProvider: TsSkinProvider;
    sProgressBar: TsProgressBar;
    sLblMoveFile: TsLabel;
    sLblFileSize: TsLabel;
    sLblAmount: TsLabel;
    sLblSpeed: TsLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmProgressBarMoveFile: TFrmProgressBarMoveFile;

implementation

USES UFrmMain;

{$R *.dfm}

{ TFrmProgressBarMoveFile }

procedure TFrmProgressBarMoveFile.FormCreate(Sender: TObject);
begin
  Caption := MB_CAPTION;
end;

end.
