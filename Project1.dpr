program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {mainForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows11 Polar Dark');
  Application.Title := 'Revisor Automático de Esquematicos  By Doctor BIOS';
  Application.CreateForm(TmainForm, mainForm);
  Application.Run;
end.
