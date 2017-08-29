unit UFrmSplitTask;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, Vcl.StdCtrls, sButton,
  Vcl.ComCtrls, sListView, sLabel, Vcl.Mask, sMaskEdit, sCustomComboEdit,
  sToolEdit, sEdit, sSpinEdit, System.ImageList, Vcl.ImgList,
  System.RegularExpressions;

type
  TFrmSplitTask = class(TForm)
    sBtnOk: TsButton;
    sSkinProvider: TsSkinProvider;
    sSpEditCountNode: TsSpinEdit;
    sLblCountNade: TsLabel;
    sLblSaveDir: TsLabel;
    sLVFileNameList: TsListView;
    sLblTaskName: TsLabel;
    ImageList: TImageList;
    sDirEditTask: TsDirectoryEdit;
    procedure sBtnOkClick(Sender: TObject);
    procedure sSpEditCountNodeChange(Sender: TObject);
    procedure sDirEditSaveTaskChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Apply: Boolean;
  end;

var
  FrmSplitTask: TFrmSplitTask;

implementation

Uses UFrmMain;

{$R *.dfm}

procedure TFrmSplitTask.FormCreate(Sender: TObject);
begin
  sDirEditTask.Text := ExcludeTrailingPathDelimiter(CurrPath);
end;

procedure TFrmSplitTask.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 27 then Close;
end;

procedure TFrmSplitTask.sBtnOkClick(Sender: TObject);
begin
  Apply := true;
  Close;
end;

procedure TFrmSplitTask.sDirEditSaveTaskChange(Sender: TObject);
begin
  sSpEditCountNodeChange(Nil);
end;

procedure TFrmSplitTask.sSpEditCountNodeChange(Sender: TObject);
var
  i: integer;
  NewItem: TListItem;
  share, sale: integer;
begin
  sLVFileNameList.Clear;

  share := FrmMain.sLV.Items.Count div sSpEditCountNode.Value;
  sale  := FrmMain.sLV.Items.Count mod sSpEditCountNode.Value;

  for i:=1 to sSpEditCountNode.Value do
  begin
    NewItem := sLVFileNameList.Items.Add;
    NewItem.Caption := IncludeTrailingPathDelimiter(sDirEditTask.Text) +
                       TregEx.Replace(CurrentTaskName,'[*|\:"<>?/\s{1,}]', '', [roIgnoreCase]) +
                       '_Node' + Format('%.3d', [i]) + '.txt';

    if i <= sale then NewItem.SubItems.Add(IntToStr(Succ(share)))
    else NewItem.SubItems.Add(IntToStr(share));

    NewItem.ImageIndex := 0;
  end;
end;

end.
