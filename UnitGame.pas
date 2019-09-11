unit UnitGame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,JPEG, ImgList, Menus;

type
  TGame = class(TForm)
    Terrain: TImage;
    ImageList1: TImageList;
    Timer1: TTimer;
    Timer2: TTimer;
    PauseMenu: TMainMenu;
    Pause1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MapStructurization;
    procedure PictureProcessing(j: Integer);
    procedure Randomizing(j: Integer);
    procedure FormRepaint;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Move;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Pause1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Game: TGame;
  GOM,Invert: Boolean;
  i,j,m,n,k,px,py,ph,pw,TL,CarCount: Integer;
  Picture: TBitmap;
  Map: array [-1200..1200,-1200..1500] of Integer;
  Speed,Cord,Size: array [1..2,1..15] of Integer;
  TrafficLights: array [1..3,0..3] of Integer;
implementation

uses UnitMainMenu;

{$R *.dfm}

procedure TGame.FormCreate(Sender: TObject);
begin
  Game.ClientHeight:=600;
  Game.ClientWidth:=900;
  GOM:=false;
  Randomize;
  TL:=random(3);
  case TL of
    0,1:Invert:=false;
    2:Invert:=true;
  end;
  CarCount:=15;
  PictureProcessing(0);
  ph:=Picture.Height;
  pw:=Picture.Width;
  Picture.Free;
  MapStructurization;
  for i:=1 to CarCount do Randomizing(i);
  Timer1.Enabled:=true;
  Timer2.Enabled:=true;
  FormRepaint;
end;

procedure TGame.MapStructurization;
var
  i1,i2,j1,j2,k: Integer;
begin
  for i:=-1200 to 1200 do
    for j:=-1200 to 1500 do
      Map[i,j]:=6;
  for i:=0 to Game.ClientHeight do
    for j:=0 to Game.ClientWidth do
      Map[i,j]:=1;
  for i:=0 to 600 do
    for j:=400 to 500 do
      Map[i,j]:=0;
  for i:=250 to 350 do
    for j:=1 to 900 do
      Map[i,j]:=0;
  for k:=1 to 7 do begin
    if k=1 then begin
      i1:=0;
      i2:=200;
      j1:=250;
      j2:=350;
    end
    else if k=2 then begin
      i1:=100;
      i2:=200;
      j1:=750;
      j2:=900;
    end
    else if k=3 then begin
      i1:=100;
      i2:=200;
      j1:=0;
      j2:=200;
    end
    else if k=4 then begin
      i1:=400;
      i2:=500;
      j1:=0;
      j2:=350;
    end
    else if k=5 then begin
      i1:=450;
      i2:=600;
      j1:=600;
      j2:=900;
    end
    else if k=6 then begin
      i1:=0;
      i2:=200;
      j1:=550;
      j2:=650;
    end
    else if k=7 then begin
      i1:=100;
      i2:=200;
      j1:=650;
      j2:=700;
    end;
    for i:=i1 to i2 do
      for j:=j1 to j2 do
        Map[i,j]:=2;
  end;
  for i:=0 to Game.ClientHeight do begin
    Map[i,0]:=3;
    Map[i,Game.ClientWidth]:=3;
  end;
  for j:=0 to Game.ClientWidth do begin
    Map[0,j]:=3;
    Map[Game.ClientHeight,j]:=3;
  end;
  for i:=75 to 100 do
    for j:=650 to 675 do
      Map[i,j]:=5;
  TrafficLights[1,0]:=500;
  TrafficLights[1,1]:=500;
  TrafficLights[1,2]:=390;
  TrafficLights[1,3]:=390;
  TrafficLights[2,0]:=240;
  TrafficLights[2,1]:=350;
  TrafficLights[2,2]:=350;
  TrafficLights[2,3]:=240;
  repeat
    k:=0;
    px:=random(Game.ClientWidth-pw);
    py:=random(Game.ClientHeight-ph);
    for i:=py to py+ph do
      for j:=px to px+pw do
        if Map[i,j]<>1 then inc(k);
    for i:=py-200 to py+ph+200 do
      for j:=px-300 to px+pw+300 do
        if Map[i,j]=5 then inc(k);
  until k=0;
end;

procedure TGame.PictureProcessing(j: Integer);
begin
  Picture:=TBitmap.Create;
  Picture.Transparent:=true;
  ImageList1.GetBitmap(j,Picture);
end;

procedure TGame.Randomizing(j: Integer);
var
  Interval: Integer;
begin
  Interval:=400;
  repeat
    k:=0;
    Speed[1,j]:=random(4);
    Speed[2,j]:=random(6)+15;
    case Speed[1,j] of
      0:begin
        Size[1,j]:=80;
        Size[2,j]:=30;
        Cord[1,j]:=random(Interval)+Game.ClientWidth;
        Cord[2,j]:=255;
      end;
      1:begin
        Size[1,j]:=30;
        Size[2,j]:=80;
        Cord[1,j]:=455;
        Cord[2,j]:=random(Interval)+Game.ClientHeight;
      end;
      2:begin
        Size[1,j]:=80;
        Size[2,j]:=30;
        Cord[1,j]:=-random(Interval)-Size[1,i];
        Cord[2,j]:=305;
      end;
      3:begin
        Size[1,j]:=30;
        Size[2,j]:=80;
        Cord[1,j]:=405;
        Cord[2,j]:=-random(Interval)-Size[2,i];
      end;
    end;
    for m:=Cord[2,j] to Cord[2,j]+Size[2,j] do
      for n:=Cord[1,j] to Cord[1,j]+Size[1,j] do
        if Map[m,n]=4 then inc(k);
  until k=0;
  for m:=Cord[2,j] to Cord[2,j]+Size[2,j] do
    for n:=Cord[1,j] to Cord[1,j]+Size[1,j] do
      Map[m,n]:=4;
end;

procedure TGame.FormRepaint;
begin
  with Terrain.Canvas do begin
    Brush.Color:=clOlive;
    FillRect(Rect(0,0,Game.ClientWidth,Game.ClientHeight));
    Brush.Color:=cl3DDkShadow;
    FillRect(Rect(400,0,500,600));
    FillRect(Rect(0,250,900,350));
    Brush.Color:=clWhite;
    for i:=0 to 5 do begin
      Rectangle(350,258+(10+5)*i,395,268+(10+5)*i);
      Rectangle(505,258+(10+5)*i,550,268+(10+5)*i);
      Rectangle(408+(10+5)*i,200,418+(10+5)*i,245);
      Rectangle(408+(10+5)*i,355,418+(10+5)*i,400);
    end;
    Brush.Color:=clGray;
    Rectangle(250,0,350,200);
    Rectangle(0,100,200,200);
    Rectangle(750,100,900,200);
    Rectangle(0,400,350,500);
    Rectangle(600,450,900,600);
    Rectangle(550,0,650,200);
    Rectangle(650,100,700,200);
    PictureProcessing(0);
    StretchDraw(Rect(px,py,px+pw,py+ph),Picture);
    Picture.Free;
    for i:=1 to CarCount do begin
      case Speed[1,i] of
        0,2:PictureProcessing(i);
        1,3:PictureProcessing(i+15);
      end;
      StretchDraw(Rect(Cord[1,i],Cord[2,i],Cord[1,i]+Size[1,i],Cord[2,i]+Size[2,i]),Picture);
      Picture.Free;
    end;
    for i:=0 to 3 do begin
      case TrafficLights[3,i] of
        0:Brush.Color:=clGreen;
        1:Brush.Color:=clYellow;
        2:Brush.Color:=clRed;
      end;
      Ellipse(TrafficLights[1,i],TrafficLights[2,i],TrafficLights[1,i]+10,TrafficLights[2,i]+10);
    end;
    Font.Color:=clRed;
    Font.Size:=15;
    Brush.Style:=bsClear;
    TextOut(590,30,'Ø');
    TextOut(590,50,'Ê');
    TextOut(590,70,'Î');
    TextOut(590,90,'Ë');
    TextOut(590,110,'À');
    PictureProcessing(31);
    StretchDraw(Rect(650,75,675,100),Picture);
    Picture.Free;
  end;
end;

procedure TGame.Timer1Timer(Sender: TObject);
begin
  if Timer1.Enabled then begin
    Timer1.Interval:=80;
    Move;
    FormRepaint;
    for m:=py to py+ph do
      for n:=px to px+pw do
        if Map[m,n]=4 then inc(k);
    if k>0 then begin
      GOM:=true;
      Timer1.Enabled:=false;
      with Terrain.Canvas do begin
        Font.Size:=25;
        Font.Color:=clGreen;
        TextOut(20,Game.ClientHeight-40,'WASTED')
      end;
    end
    else begin
      k:=0;
      for m:=py to py+ph do
        for n:=px to px+pw do
          if Map[m,n]=5 then inc(k);
      if k>0 then begin
        GOM:=true;
        Timer1.Enabled:=false;
        with Terrain.Canvas do begin
          Font.Size:=25;
          Font.Color:=clGreen;
          TextOut(20,Game.ClientHeight-40,'YOU WIN!')
        end;
      end;
    end;
  end;
end;

procedure TGame.Timer2Timer(Sender: TObject);
begin
  if Timer2.Enabled then
    case TL of
      0:begin
        Timer2.Interval:=4000;
        TrafficLights[3,0]:=0;
        TrafficLights[3,1]:=2;
        TrafficLights[3,2]:=0;
        TrafficLights[3,3]:=2;
        inc(TL);
      end;
      1:begin
        Timer2.Interval:=2000;
        for i:=0 to 3 do TrafficLights[3,i]:=1;
        if not Invert then begin
          inc(TL);
          Invert:=true;
        end
        else if Invert then begin
          dec(TL);
          Invert:=false;
        end;
      end;
      2:begin
        Timer2.Interval:=4000;
        TrafficLights[3,0]:=2;
        TrafficLights[3,1]:=0;
        TrafficLights[3,2]:=2;
        TrafficLights[3,3]:=0;
        dec(TL);
      end;
    end;
end;

procedure TGame.Move;
begin
  for i:=1 to CarCount do begin
    if not GOM then begin
      Terrain.Canvas.FillRect(Rect(Cord[1,i],Cord[2,i],Cord[1,i]+Size[1,i],Cord[2,i]+Size[2,i]));
      case Speed[1,i] of
        0:begin
          if (Cord[1,i]+Size[1,i])<0 then begin
            for m:=Cord[2,i] to Cord[2,i]+Size[2,i] do
              for n:=Cord[1,i] to Cord[1,i]+Size[1,i] do
                Map[m,n]:=0;
            Randomizing(i);
          end
          else if ((Cord[1,i]+Size[1,i])>=0) and (Map[Cord[2,i],(Cord[1,i]-25)]<>4) then
            if ((Cord[1,i]>=525) and (Cord[1,i]<=550) and (TrafficLights[3,Speed[1,i]]=0)) or (Cord[1,i]<=525) or (Cord[1,i]>=550) then begin
              for m:=Cord[2,i] to Cord[2,i]+Size[2,i] do
                for n:=Cord[1,i] to Cord[1,i]+Size[1,i] do
                  Map[m,n]:=0;
              Cord[1,i]:=Cord[1,i]-Speed[2,i];
              for m:=Cord[2,i] to Cord[2,i]+Size[2,i] do
                for n:=Cord[1,i] to Cord[1,i]+Size[1,i] do
                  Map[m,n]:=4;
            end;
        end;
        1:begin
          if (Cord[2,i]+Size[2,i])<0 then begin
            for m:=Cord[2,i] to Cord[2,i]+Size[2,i] do
              for n:=Cord[1,i] to Cord[1,i]+Size[1,i] do
                Map[m,n]:=0;
            Randomizing(i);
          end
          else if ((Cord[2,i]+Size[2,i])>=0) and (Map[(Cord[2,i]-25),Cord[1,i]]<>4) then
            if ((Cord[2,i]>=380) and (Cord[2,i]<=400) and (TrafficLights[3,Speed[1,i]]=0)) or (Cord[2,i]<=380) or (Cord[2,i]>=400) then begin
              for m:=Cord[2,i] to Cord[2,i]+Size[2,i] do
                for n:=Cord[1,i] to Cord[1,i]+Size[1,i] do
                  Map[m,n]:=0;
              Cord[2,i]:=Cord[2,i]-Speed[2,i];
              for m:=Cord[2,i] to Cord[2,i]+Size[2,i] do
                for n:=Cord[1,i] to Cord[1,i]+Size[1,i] do
                  Map[m,n]:=4;
            end;
        end;
        2:begin
          if (Cord[1,i]+Size[1,i])>Game.ClientWidth then  begin
            for m:=Cord[2,i] to Cord[2,i]+Size[2,i] do
              for n:=Cord[1,i] to Cord[1,i]+Size[1,i] do
                Map[m,n]:=0;
            Randomizing(i);
          end
          else if ((Cord[1,i]+Size[1,i])<=Game.ClientWidth) and (Map[Cord[2,i],(Cord[1,i]+Size[1,i]+25)]<>4) then
            if ((Cord[1,i]+Size[1,i]>=350) and (Cord[1,i]+Size[1,i]<=375) and (TrafficLights[3,Speed[1,i]]=0)) or (Cord[1,i]+Size[1,i]<=350) or (Cord[1,i]+Size[1,i]>=375) then begin
              for m:=Cord[2,i] to Cord[2,i]+Size[2,i] do
                for n:=Cord[1,i] to Cord[1,i]+Size[1,i] do
                  Map[m,n]:=0;
              Cord[1,i]:=Cord[1,i]+Speed[2,i];
              for m:=Cord[2,i] to Cord[2,i]+Size[2,i] do
                for n:=Cord[1,i] to Cord[1,i]+Size[1,i] do
                  Map[m,n]:=4;
            end;
        end;
        3:begin
          if (Cord[2,i]+Size[2,i])>Game.ClientHeight then  begin
            for m:=Cord[2,i] to Cord[2,i]+Size[2,i] do
              for n:=Cord[1,i] to Cord[1,i]+Size[1,i] do
                Map[m,n]:=0;
            Randomizing(i);
          end
          else if ((Cord[2,i]+Size[2,i])<=Game.ClientHeight) and (Map[(Cord[2,i]+Size[2,i]+25),Cord[1,i]]<>4) then
            if ((Cord[2,i]+Size[2,i]>=200) and (Cord[2,i]+Size[2,i]<=225) and (TrafficLights[3,Speed[1,i]]=0)) or (Cord[2,i]+Size[2,i]<=200) or (Cord[2,i]+Size[2,i]>=225) then begin
              for m:=Cord[2,i] to Cord[2,i]+Size[2,i] do
                for n:=Cord[1,i] to Cord[1,i]+Size[1,i] do
                  Map[m,n]:=0;
              Cord[2,i]:=Cord[2,i]+Speed[2,i];
              for m:=Cord[2,i] to Cord[2,i]+Size[2,i] do
                for n:=Cord[1,i] to Cord[1,i]+Size[1,i] do
                  Map[m,n]:=4;
            end;
        end;
      end;
    end;
  end;
end;

procedure TGame.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not GOM then begin
    case Key of
      'w','ö':begin
        if ((Map[py-1,px]<>2) and (Map[py-1,px+pw]<>3) and (Map[py-1,px+pw]<>2) and (Map[py-1,px]<>3)) then py:=py-1;
      end;
      's','û','³':begin
        if ((Map[py+ph+1,px]<>2) and (Map[py+ph+1,px]<>3) and (Map[py+ph+1,px+pw]<>2) and (Map[py+ph+1,px+pw]<>3)) then py:=py+1;
      end;
      'a','ô':begin
        if ((Map[py,px-1]<>2) and (Map[py,px-1]<>3) and (Map[py+ph,px-1]<>2) and (Map[py+ph,px-1]<>3)) then px:=px-1;
      end;
      'd','â':begin
        if ((Map[py,px+pw+1]<>2) and (Map[py,px+pw+1]<>3) and (Map[py+ph,px+pw+1]<>2) and (Map[py+ph,px+pw+1]<>3)) then px:=px+1;
      end;
    end;
  end
  else if GOM then
    case Key of
      #27:begin
        Game.Close;
        MainMenu.Visible:=true;
      end;
    end;
end;

procedure TGame.Pause1Click(Sender: TObject);
begin
  Game.Close;
  MainMenu.Visible:=true;
end;

end.
