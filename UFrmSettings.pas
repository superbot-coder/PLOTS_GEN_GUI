unit UFrmSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sComboBox, Vcl.Mask,
  sMaskEdit, sCustomComboEdit, sToolEdit, sLabel, Vcl.ComCtrls, sComboBoxes,
  sGroupBox, sSkinProvider, System.IniFiles, ResourceLang;

type
  TFrmSettings = class(TForm)
    sSkinProvider: TsSkinProvider;
    sGrBoxSkins: TsGroupBox;
    sSkinSelector: TsSkinSelector;
    sLblSkins: TsLabel;
    sDirEditSkin: TsDirectoryEdit;
    sLbSelectSkinDir: TsLabel;
    sCmBoxLang: TsComboBox;
    sLblLanguage: TsLabel;
    procedure SearchLanguage;
    procedure FormCreate(Sender: TObject);
    procedure sCmBoxLangSelect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    STLangFileList: TStrings;
    destructor Destroy; override;
  end;

var
  FrmSettings: TFrmSettings;


implementation

USES UFrmMain;

{$R *.dfm}

{ TFrmSettings }

{
constructor TFrmSettings.Create;
begin
  inherited Create;
  STLang := TStringList.Create;
end;
}

destructor TFrmSettings.Destroy;
begin
  STLangFileList.Free;
  inherited;
end;

procedure TFrmSettings.FormCreate(Sender: TObject);
begin
  STLangFileList := TStringList.Create;
  SearchLanguage;
  //sCmBoxLang.ItemIndex := sCmBoxLang.IndexOf(CurrentLanguage);
  sCmBoxLang.ItemIndex := sCmBoxLang.IndexOf('ENG');
  //LoadLangUpDate

  sDirEditSkin.Text    := FrmMain.sSkinManager.SkinDirectory;
end;

procedure TFrmSettings.sCmBoxLangSelect(Sender: TObject);
var
  INI: TIniFile;
  ST: TStrings;
  i: integer;
begin
{
  if sCmBoxLang.ItemIndex = -1 then Exit;

  if Sender = Nil then
  begin
    INI := TIniFile.Create(FileConfig);
    try
      INI.WriteString(SETTINGS, CValue(Language), sCmBoxLang.Items[sCmBoxLang.ItemIndex]);
    finally
      INI.Free;
    end;
  end;

  LoadLangUpDate(STLanguage.Strings[sCmBoxLang.ItemIndex]);
  mm.Lines.Add('LoadLangUpDate: ' + STLanguage.Strings[sCmBoxLang.ItemIndex]);

  // for i:=0 to Length(strGUIVal)-1 do mm.Lines.Add(strGUIVal[TGUIValue(i)]);

  sLblCPU.Caption          := strGUIVal[FrmMain_slblCPU];
  sLblTaskName.Caption     := strGUIVal[FrmMain_sLblTaskName];
  sLbl_id_lable.Caption    := strGUIVal[FrmMain_sLbl_id_lable];
  sLblTaskFileName.Caption := strGUIVal[FrmMain_sLblTaskFileName];
  sLblProcessing.Caption   := strGUIVal[FrmMain_sLblProcessing];
  sLblDestDir.Caption      := strGUIVal[FrmMain_sLblDestDir];
  sChBoxAutorun.Caption    := strGUIVal[FrmMain_sChBoxAutorun];
  sChBoxLock.Caption       := strGUIVal[FrmMain_sChBoxLock];
  sChBoxMoveFile.Caption   := strGUIVal[FrmMain_sChBoxMoveFile];
  sChBoxReWrite.Caption    := strGUIVal[FrmMain_sChBoxReWrite];

  }
end;

procedure TFrmSettings.SearchLanguage;
var INI: TIniFile;
     SR: TSearchRec;
     i : ShortInt;
begin
  if FindFirst(LangPath + '*.*', faAnyFile, SR) = 0 then
  Repeat
    if ((SR.Attr and faDirectory) <> 0) or (SR.Name = '.') or (SR.Name = '..') then Continue;
    FrmMain.log(LangPath + SR.Name);
    STLangFileList.Add(LangPath + SR.Name);
  until (FindNext(SR) <> 0);
  FindClose(SR);

  if STLangFileList.Count = 0 then Exit;

  for i:=0 to STLangFileList.Count -1 do
  begin
    INI := TIniFile.Create(STLangFileList.Strings[i]);
    try
      FrmSettings.sCmBoxLang.Items.Add(INI.ReadString('INFO', 'Language',''));
    finally
      INI.Free;
    end;
  end;

end;

end.
