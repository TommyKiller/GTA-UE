program GTAUE;

uses
  Forms,
  UnitGame in 'UnitGame.pas' {Game},
  UnitMainMenu in 'UnitMainMenu.pas' {MainMenu};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainMenu, MainMenu);
  Application.Run;
end.
