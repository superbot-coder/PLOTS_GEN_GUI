program PLOTS_GEN_GUI;

uses
  Vcl.Forms,
  UFrmMain in 'UFrmMain.pas' {FrmMain},
  UFrmCreateTask in 'UFrmCreateTask.pas' {FrmCreateTask},
  UFrmChangeSettings in 'UFrmChangeSettings.pas' {FrmChengeSettings},
  UFrmSelPlotter in 'UFrmSelPlotter.pas' {FrmSelPlotter},
  UFrmSplitTask in 'UFrmSplitTask.pas' {FrmSplitTask},
  ResourceLang in 'ResourceLang.pas',
  UFrmProgressBar in 'UFrmProgressBar.pas' {FrmProgressBar},
  UFrmProgressBarMoveFile in 'UFrmProgressBarMoveFile.pas' {FrmProgressBarMoveFile},
  UFrmAudit in 'UFrmAudit.pas' {FrmAudit},
  UFrmSettings in 'UFrmSettings.pas' {FrmSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmCreateTask, FrmCreateTask);
  Application.CreateForm(TFrmChengeSettings, FrmChengeSettings);
  Application.CreateForm(TFrmSelPlotter, FrmSelPlotter);
  Application.CreateForm(TFrmSplitTask, FrmSplitTask);
  Application.CreateForm(TFrmProgressBar, FrmProgressBar);
  Application.CreateForm(TFrmProgressBarMoveFile, FrmProgressBarMoveFile);
  Application.CreateForm(TFrmAudit, FrmAudit);
  Application.CreateForm(TFrmSettings, FrmSettings);
  Application.Run;
end.
