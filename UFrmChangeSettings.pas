unit UFrmChangeSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sRadioButton,
  Vcl.ComCtrls, sComboBoxes, sCheckBox, sLabel, sEdit, sSpinEdit, sButton,
  sSkinProvider, ModFileFormatSize, Vcl.Mask, sMaskEdit, sCustomComboEdit,
  sToolEdit;

type
  TFrmChengeSettings = class(TForm)
    sBtnApply: TsButton;
    sSpEdThreads: TsSpinEdit;
    sLblMemGb: TsLabel;
    sSpEdMem: TsSpinEdit;
    sLblMem: TsLabel;
    sLblThreads: TsLabel;
    sChBoxPathEnable: TsCheckBox;
    sLblPath: TsLabel;
    sRdBtnSelectItems: TsRadioButton;
    sRdBtnAllItems: TsRadioButton;
    sSkinProvider: TsSkinProvider;
    sLblGlobalMem: TsLabel;
    sDirEdPath: TsDirectoryEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sSpEdThreadsChange(Sender: TObject);
    procedure sSpEdMemChange(Sender: TObject);
    procedure sBtnApplyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Apply: Boolean;
  end;

var
  FrmChengeSettings: TFrmChengeSettings;

implementation

USES UFrmMain, UFrmCreateTask, ResourceLang;

{$R *.dfm}

procedure TFrmChengeSettings.FormCreate(Sender: TObject);
begin
  sLblGlobalMem.Caption := 'Global Memory: ' +  FormatFileSize(MemTotalPhys);
  Caption := MB_CAPTION;
end;

procedure TFrmChengeSettings.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then Close;
end;

procedure TFrmChengeSettings.sBtnApplyClick(Sender: TObject);
begin
  if sChBoxPathEnable.Enabled then
    if sDirEdPath.Text = '' then
    begin
      MessageBox(Handle, PChar(msg_FrmChengeSettings_01), PChar(MB_CAPTION), MB_ICONWARNING);
      Exit;
    end;

  Apply := true;
  Close;
end;

procedure TFrmChengeSettings.sSpEdMemChange(Sender: TObject);
begin
  sLblMemGb.Caption := '= ' + StringReplace(FloatToStr(sSpEdMem.Value * 0.001), ',', '.', []) + ' Gb';
end;

procedure TFrmChengeSettings.sSpEdThreadsChange(Sender: TObject);
begin
  sSpEdMem.Value := sSpEdThreads.Value * 500;
end;

end.
