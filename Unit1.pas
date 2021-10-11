unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ToolWin, ComCtrls, ExtCtrls, Menus, MyMatrix, Model;

type
  TForm1 = class(TForm)
    pnBig: TPanel;
    pnObjects: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N5: TMenuItem;
    StatusBar1: TStatusBar;
    pnLeft: TPanel;
    Splitter1: TSplitter;
    pnRight: TPanel;
    pnA: TPanel;
    pnB: TPanel;
    pnC: TPanel;
    pnD: TPanel;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    N6: TMenuItem;
    N7: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N8: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N21: TMenuItem;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Timer1: TTimer;
    N20: TMenuItem;
    N22: TMenuItem;
    procedure pnBigResize(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pnAResize(Sender: TObject);
    procedure pnAMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnAMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnAMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
  private
    mods:Array[0..3] of TModel;
    rotation:Extended;
    IsMouseDown:Boolean;
    preX:Integer;
    m:TMyMatrix;
    r:Boolean;
    obj:ShortString;
  public
    lighting,solid:Boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.pnBigResize(Sender: TObject);
begin
  pnLeft.Width:=Round(pnBig.Width/2);
  pnA.Height:=Round(pnBig.Height/2);
  pnC.Height:=Round(pnBig.Height/2);
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  MessageBox(Handle,'Разработчик: Макаров М.М.'#13#10+
                    'Дата создания: 15 мая 2005','О программе',
                    MB_OK or MB_ICONINFORMATION);
end;

procedure TForm1.N5Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  lighting:=True;
  solid:=True;
  m:=TMyMatrix.Create;
  mods[0]:=TModel.Create(Image1.Canvas);
  mods[1]:=TModel.Create(Image2.Canvas);
  mods[2]:=TModel.Create(Image3.Canvas);
  mods[3]:=TModel.Create(Image4.Canvas);
  IsMouseDown:=False;
  r:=True;
  SpeedButton5Click(Self);
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i:Integer;
begin
  m.Destroy;
  for i:=0 to 3 do
    mods[i].Destroy;
end;

procedure TForm1.pnAResize(Sender: TObject);
begin
  m.LoadIdentity;
  m.Scale(3,3,3);
  m.RotateX(90);
  m.RotateY(rotation);
  m.Translate(Image1.Width/2,Image1.Height/2,0);
  mods[0].MultMatrix(m);
  mods[0].Draw(Image1.Width,Image1.Height);

  m.LoadIdentity;
  m.Scale(3,3,3);
  m.RotateX(90);
  m.RotateX(rotation);
  m.Translate(Image2.Width/2,Image2.Height/2,0);
  mods[1].MultMatrix(m);
  mods[1].Draw(Image2.Width,Image2.Height);

  m.LoadIdentity;
  m.Scale(3,3,3);
  m.RotateX(90);
  m.RotateZ(rotation);
  m.Translate(Image3.Width/2,Image3.Height/2,0);
  mods[2].MultMatrix(m);
  mods[2].Draw(Image3.Width,Image3.Height);

  m.LoadIdentity;
  m.Scale(3,3,3);
  m.RotateX(90);
  m.RotateY(rotation);
  m.RotateX(30);
  m.RotateY(-30);
  m.Translate(Image4.Width/2,Image4.Height/2,0);
  mods[3].MultMatrix(m);
  mods[3].Draw(Image4.Width,Image4.Height);
end;

procedure TForm1.pnAMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IsMouseDown:=True;
  preX:=X;
end;

procedure TForm1.pnAMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IsMouseDown:=False;
end;

procedure TForm1.pnAMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if IsMouseDown and (X<>preX) then
  begin
    rotation:=rotation-(X-preX);
    preX:=X;
    if rotation<0 then rotation:=359;
    if rotation>=360 then rotation:=0;
    r:=True;
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 3 do
    mods[i].LoadFromFile('models\Cube.txt');
  r:=True;
  obj:='Куб';
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if r then
  begin
    pnAResize(self);
    r:=False;
    if lighting then
      StatusBar1.Panels[0].Text:='Освещение:  есть'
    else
      StatusBar1.Panels[0].Text:='Освещение:  нет';
    if solid then
      StatusBar1.Panels[1].Text:='Заливка:  есть'
    else
      StatusBar1.Panels[1].Text:='Заливка:  нет';
    StatusBar1.Panels[2].Text:='Объект:  '+obj;
  end;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 3 do
    mods[i].LoadFromFile('models\Dummie.txt');
  r:=True;
  obj:='Чайник';
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 3 do
    mods[i].LoadFromFile('models\Sphere.txt');
  r:=True;
  obj:='Сфера';
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 3 do
    mods[i].LoadFromFile('models\Cylinder.txt');
  r:=True;
  obj:='Цилиндр';
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 3 do
    mods[i].LoadFromFile('models\Torus.txt');
  r:=True;
  obj:='Тор';
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 3 do
    mods[i].LoadFromFile('models\Cone.txt');
  r:=True;
  obj:='Конус';
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 3 do
    mods[i].LoadFromFile('models\Tube.txt');
  r:=True;
  obj:='Труба';
end;

procedure TForm1.SpeedButton8Click(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 3 do
    mods[i].LoadFromFile('models\Pyramid.txt');
  r:=True;
  obj:='Пирамида';
end;

procedure TForm1.SpeedButton10Click(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 3 do
    mods[i].LoadFromFile('models\CCube.txt');
  r:=True;
  obj:='Скруглённый куб';
end;

procedure TForm1.SpeedButton11Click(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 3 do
    mods[i].LoadFromFile('models\CCyl.txt');
  r:=True;
  obj:='Скруглённый цилиндр';
end;

procedure TForm1.SpeedButton12Click(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 3 do
    mods[i].LoadFromFile('models\Capsule.txt');
  r:=True;
  obj:='Капсула';
end;

procedure TForm1.SpeedButton13Click(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 3 do
    mods[i].LoadFromFile('models\TorusKnot.txt');
  r:=True;
  obj:='Тороидальный узел';
end;

procedure TForm1.N19Click(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 3 do
    mods[i].LoadFromFile('models\Tetra.txt');
  r:=True;
  obj:='Тетраэдр';
end;

procedure TForm1.N21Click(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 3 do
    mods[i].LoadFromFile('models\Octa.txt');
  r:=True;
  obj:='Октаэдр';
end;

procedure TForm1.N20Click(Sender: TObject);
begin
  lighting:=not lighting;
  r:=True;
end;

procedure TForm1.N22Click(Sender: TObject);
begin
  solid:=not solid;
  r:=True;
end;

end.
