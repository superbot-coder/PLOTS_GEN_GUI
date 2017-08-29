unit UFrmSelPlotter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sButton, sRadioButton,
  sSkinProvider;

type
  TFrmSelPlotter = class(TForm)
    sSkinProvider: TsSkinProvider;
    sRdBtnXPlotter_sse: TsRadioButton;
    sRdBtnXPlotter_avx: TsRadioButton;
    sBtnOk: TsButton;
    sRdBtnXPlotter_avx2: TsRadioButton;
    procedure sBtnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSelPlotter: TFrmSelPlotter;

implementation

Uses UfrmMain;

{$R *.dfm}

procedure TFrmSelPlotter.sBtnOkClick(Sender: TObject);
begin
  Close;
end;

end.
