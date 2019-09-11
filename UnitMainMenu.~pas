unit UnitMainMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMainMenu = class(TForm)
    Play: TButton;
    Help: TButton;
    Exit: TButton;
    Back: TButton;
    HelpTip: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure MainWindow;
    procedure HelpWindow;
    procedure PlayClick(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure BackClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainMenu: TMainMenu;

implementation

uses UnitGame;

{$R *.dfm}

procedure TMainMenu.FormCreate(Sender: TObject);
begin
  MainMenu.ClientWidth:=200;
  MainMenu.ClientHeight:=300;
  Play.Visible:=false;
  Help.Visible:=false;
  Exit.Visible:=false;
  MainWindow;
end;

procedure TMainMenu.MainWindow;
begin
  MainMenu.Canvas.FillRect(Rect(0,0,MainMenu.ClientWidth,MainMenu.ClientHeight));
  Play.Visible:=true;
  Help.Visible:=true;
  Exit.Visible:=true;
  Back.Visible:=false;
  HelpTip.Visible:=false;
end;

procedure TMainMenu.HelpWindow;
begin
  Play.Visible:=false;
  Help.Visible:=false;
  Exit.Visible:=false;
  Back.Visible:=true;
  with HelpTip do begin
    Font.Size:=14;
    Font.Color:=clRed;
    Visible:=true;
    Caption:='To move left use `a`;'#13#10'To move up use `w`;'#13#10'To move right use `d`;'#13#10'To move down use `s`;'#13#10'To win move to the'#13#10'marker;'#13#10'Don`t fall under the'#13#10'wheels!'#13#10'Good luck!';
  end;
end;

procedure TMainMenu.PlayClick(Sender: TObject);
begin
  if (not Assigned(Game)) then
    Application.CreateForm(TGame,Game);
  MainMenu.Visible:=false;
  Game.ShowModal;
end;

procedure TMainMenu.HelpClick(Sender: TObject);
begin
  HelpWindow;
end;

procedure TMainMenu.ExitClick(Sender: TObject);
begin
  MainMenu.Close;
end;

procedure TMainMenu.BackClick(Sender: TObject);
begin
  MainWindow;
end;

end.
