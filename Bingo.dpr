program Bingo;

uses
  FMX.Forms,
  BingoMain in 'BingoMain.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
