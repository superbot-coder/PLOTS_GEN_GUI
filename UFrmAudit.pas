unit UFrmAudit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, sListView, Vcl.StdCtrls,
  Vcl.Mask, sMaskEdit, sCustomComboEdit, sToolEdit, sSkinProvider, sButton, ModFileFormatSize;

type
  TFrmAudit = class(TForm)
    sLV: TsListView;
    sBtnScan: TsButton;
    sSkinProvider: TsSkinProvider;
    sDirectoryEdit: TsDirectoryEdit;
    sBtnOk: TsButton;
    Function AddLVItem: Integer;
    procedure sBtnScanClick(Sender: TObject);
    procedure sBtnOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    { Private declarations }
  public
    { Public declarations }
    Apply: Boolean;
  end;

var
  FrmAudit: TFrmAudit;

const
  c_aud_fname  = 0;
  c_aud_fz     = 1;
  c_aud_rfz    = 2;
  c_aud_exist  = 3;

implementation

Uses UFrmMain;

{$R *.dfm}

{ TFrmAudit }

function TFrmAudit.AddLVItem: Integer;
begin
  with sLV.Items.Add do
  begin
    Result  := Index;
    Caption := IntToStr(Index + 1);
    SubItems.Add('');
    SubItems.Add('');
    SubItems.Add('');
    SubItems.Add('');
    ImageIndex       := -1;
    SubItemImages[0] := 0;
  end;
end;

procedure TFrmAudit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 27 then Close;
end;

procedure TFrmAudit.sBtnOkClick(Sender: TObject);
begin
  Apply := true;
  Close;
end;

procedure TFrmAudit.sBtnScanClick(Sender: TObject);
var i: Integer;
    i_size: Int64;
    s_size: String;
begin
  if slv.Items.Count = 0 then Exit;

  for i := 0 to sLV.Items.Count -1 do
  begin
    s_size := '';
    s_size := GetFileSizeFormat(sDirectoryEdit.Text + '\' + sLV.Items[i].SubItems[c_aud_fname]);
    if s_size <> '' then
    begin
      sLV.Items[i].SubItems[c_aud_rfz]   := s_size;
      sLV.Items[i].SubItems[c_aud_exist] := '+';
      if sLV.Items[i].SubItems[c_aud_fz] <> sLV.Items[i].SubItems[c_aud_rfz] then sLV.Items[i].Checked := true;
      continue;
    end;
    sLV.Items[i].SubItems[c_aud_exist] := '-';
    sLv.Items[i].Checked := true;
  end;


end;

end.
