unit MyMatrix;
{
матричные преобразования
разработчик: Макаров М.М.
дата создания: 24 февраля 2005
}
interface

uses
  Math;

type
  TVector3 = Array[0..2] of Extended;
  TVector4 = Array[0..3] of Extended;
  TMatrixArray = Array of TVector4;
  TMyMatrix = class
  public
    hsize:Integer;
    arr:TMatrixArray;
    constructor Create;
    destructor Destroy;override;
    procedure AddLine(a,b,c,d:Extended);overload;
    procedure AddLine(a:TVector4);overload;
    procedure Clear;
    procedure MultMatrix(m:TMyMatrix);
    procedure RotateX(angle:Extended);
    procedure RotateY(angle:Extended);
    procedure RotateZ(angle:Extended);
    procedure Scale(x,y,z:Extended);
    procedure MirrorX;
    procedure MirrorY;
    procedure MirrorZ;
    procedure Translate(x,y,z:Extended);
    procedure LoadIdentity;
    function GetX(line:Integer):Extended;
    function GetY(line:Integer):Extended;
    function GetZ(line:Integer):Extended;
    procedure FrustumProjection(l,r,b,t,n,f:Extended);
    procedure OrthoProjection(l,r,b,t,n,f:Extended);
    procedure ParallelProjectionXY(z0:Extended);
    procedure ParallelProjectionXZ(y0:Extended);
    procedure ParallelProjectionYZ(x0:Extended);
    procedure Perspective(fovy,aspect,znear,zfar:Extended);
    procedure LookAt(eyex,eyey,eyez,
                     centerx,centery,centerz,
                     upx,upy,upz:Extended);
    procedure Normalize(var v:TVector3);
    procedure Cross(v1,v2:TVector3; var r:TVector3);
    procedure Transpose;
    procedure Copy(m:TMyMatrix);
    procedure Sort;
  end;

implementation

constructor TMyMatrix.Create;
{конструктор}
begin
  Clear;
end;

destructor TMyMatrix.Destroy;
{деструктор}
begin
  Clear;
  Inherited Destroy;
end;

procedure TMyMatrix.AddLine(a,b,c,d:Extended);
{добавить строку в матрицу}
begin
  inc(hsize);
  SetLength(arr,hsize);
  arr[hsize-1,0]:=a;
  arr[hsize-1,1]:=b;
  arr[hsize-1,2]:=c;
  arr[hsize-1,3]:=d;
end;

procedure TMyMatrix.AddLine(a:TVector4);
{добавить строку в матрицу}
var
  i:Integer;
begin
  inc(hsize);
  SetLength(arr,hsize);
  for i:=0 to 3 do
    arr[hsize-1,i]:=a[i];
end;

procedure TMyMatrix.Clear;
{очистить массив}
begin
  hsize:=0;
  Finalize(arr);
end;

procedure TMyMatrix.MultMatrix(m:TMyMatrix);
{перемножение матриц}
var
  i,j:Integer;
  tmp:TMatrixArray;
begin
  if m.hsize=4 then
  begin
    SetLength(tmp,hsize);
    for i:=0 to hsize-1 do
      for j:=0 to 3 do
        tmp[i,j]:=arr[i,j];
    for i:=0 to hsize-1 do
      for j:=0 to 3 do
        arr[i,j]:=tmp[i,0]*m.arr[0,j]+
                  tmp[i,1]*m.arr[1,j]+
                  tmp[i,2]*m.arr[2,j]+
                  tmp[i,3]*m.arr[3,j];
    Finalize(tmp);
  end;
end;

procedure TMyMatrix.RotateX(angle:Extended);
{вращение вокруг оси X}
var
  tmp:TMyMatrix;
begin
  tmp:=TMyMatrix.Create;
  tmp.AddLine(1,0,0,0);
  tmp.AddLine(0,cos(DegToRad(angle)),sin(DegToRad(angle)),0);
  tmp.AddLine(0,-sin(DegToRad(angle)),cos(DegToRad(angle)),0);
  tmp.AddLine(0,0,0,1);
  MultMatrix(tmp);
  tmp.Destroy;
end;

procedure TMyMatrix.RotateY(angle:Extended);
{вращение вокруг оси Y}
var
  tmp:TMyMatrix;
begin
  tmp:=TMyMatrix.Create;
  tmp.AddLine(cos(DegToRad(angle)),0,-sin(DegToRad(angle)),0);
  tmp.AddLine(0,1,0,0);
  tmp.AddLine(sin(DegToRad(angle)),0,cos(DegToRad(angle)),0);
  tmp.AddLine(0,0,0,1);
  MultMatrix(tmp);
  tmp.Destroy;
end;

procedure TMyMatrix.RotateZ(angle:Extended);
{вращение вокруг оси Z}
var
  tmp:TMyMatrix;
begin
  tmp:=TMyMatrix.Create;
  tmp.AddLine(cos(DegToRad(angle)),sin(DegToRad(angle)),0,0);
  tmp.AddLine(-sin(DegToRad(angle)),cos(DegToRad(angle)),0,0);
  tmp.AddLine(0,0,1,0);
  tmp.AddLine(0,0,0,1);
  MultMatrix(tmp);
  tmp.Destroy;
end;

procedure TMyMatrix.Scale(x,y,z:Extended);
{масштабирование}
var
  tmp:TMyMatrix;
begin
  tmp:=TMyMatrix.Create;
  tmp.AddLine(x,0,0,0);
  tmp.AddLine(0,y,0,0);
  tmp.AddLine(0,0,z,0);
  tmp.AddLine(0,0,0,1);
  MultMatrix(tmp);
  tmp.Destroy;
end;

procedure TMyMatrix.MirrorX;
{отражение по оси X}
var
  tmp:TMyMatrix;
begin
  tmp:=TMyMatrix.Create;
  tmp.AddLine(-1,0,0,0);
  tmp.AddLine(0,1,0,0);
  tmp.AddLine(0,0,1,0);
  tmp.AddLine(0,0,0,1);
  MultMatrix(tmp);
  tmp.Destroy;
end;

procedure TMyMatrix.MirrorY;
{отражение по оси Y}
var
  tmp:TMyMatrix;
begin
  tmp:=TMyMatrix.Create;
  tmp.AddLine(1,0,0,0);
  tmp.AddLine(0,-1,0,0);
  tmp.AddLine(0,0,1,0);
  tmp.AddLine(0,0,0,1);
  MultMatrix(tmp);
  tmp.Destroy;
end;

procedure TMyMatrix.MirrorZ;
{отражение по оси Z}
var
  tmp:TMyMatrix;
begin
  tmp:=TMyMatrix.Create;
  tmp.AddLine(1,0,0,0);
  tmp.AddLine(0,1,0,0);
  tmp.AddLine(0,0,-1,0);
  tmp.AddLine(0,0,0,1);
  MultMatrix(tmp);
  tmp.Destroy;
end;

procedure TMyMatrix.Translate(x,y,z:Extended);
{перенос на вектор (x,y,z)}
var
  tmp:TMyMatrix;
begin
  tmp:=TMyMatrix.Create;
  tmp.AddLine(1,0,0,0);
  tmp.AddLine(0,1,0,0);
  tmp.AddLine(0,0,1,0);
  tmp.AddLine(x,y,z,1);
  MultMatrix(tmp);
  tmp.Destroy;
end;

procedure TMyMatrix.LoadIdentity;
{единичная матрица}
begin
  Clear;
  AddLine(1,0,0,0);
  AddLine(0,1,0,0);
  AddLine(0,0,1,0);
  AddLine(0,0,0,1);
end;

function TMyMatrix.GetX(line:Integer):Extended;
{взять координату X}
begin
  Result:=999999;
  if line<=hsize then
    Result:=arr[line-1,0]/arr[line-1,3];
end;

function TMyMatrix.GetY(line:Integer):Extended;
{взять координату Y}
begin
  Result:=999999;
  if line<=hsize then
    Result:=arr[line-1,1]/arr[line-1,3];
end;

function TMyMatrix.GetZ(line:Integer):Extended;
{взять координату Z}
begin
  Result:=999999;
  if line<=hsize then
    Result:=arr[line-1,2]/arr[line-1,3];
end;

procedure TMyMatrix.Transpose;
{транспонирование матрицы 4x4}
var
  i,j:Integer;
  tmp:TMatrixArray;
begin
  if hsize=4 then
  begin
    SetLength(tmp,4);
    for i:=0 to 3 do
      for j:=0 to 3 do
        tmp[i,j]:=arr[i,j];
    for i:=0 to 3 do
      for j:=0 to 3 do
        arr[i,j]:=tmp[j,i];
  end;
end;

procedure TMyMatrix.FrustumProjection(l,r,b,t,n,f:Extended);
{перспективная проекция}
var
  tmp:TMyMatrix;
begin
  tmp:=TMyMatrix.Create;
  tmp.AddLine(2*n/(r-l),0,0,0);
  tmp.AddLine(0,2*n/(t-b),0,0);
  tmp.AddLine((r+l)/(r-l),(t+b)/(t-b),-(f+n)/(f-n),-1);
  tmp.AddLine(0,0,-2*f*n/(f-n),0);
  MultMatrix(tmp);
  tmp.Destroy;
end;

procedure TMyMatrix.OrthoProjection(l,r,b,t,n,f:Extended);
{ортогональная проекция}
var
  tmp:TMyMatrix;
begin
  tmp:=TMyMatrix.Create;
  tmp.AddLine(2/(r-l),0,0,0);
  tmp.AddLine(0,2/(t-b),0,0);
  tmp.AddLine(0,0,-2/(f-n),0);
  tmp.AddLine((r+l)/(r-l),(t+b)/(t-b),(f+n)/(f-n),1);
  MultMatrix(tmp);
  tmp.Destroy;
end;

procedure TMyMatrix.ParallelProjectionXY(z0:Extended);
{параллельная проекция в плоскость xy}
var
  tmp:TMyMatrix;
begin
  tmp:=TMyMatrix.Create;
  tmp.AddLine(1,0,0,0);
  tmp.AddLine(0,1,0,0);
  tmp.AddLine(0,0,0,0);
  tmp.AddLine(0,0,z0,1);
  MultMatrix(tmp);
  tmp.Destroy;
end;

procedure TMyMatrix.ParallelProjectionXZ(y0:Extended);
{параллельная проекция в плоскость xz}
var
  tmp:TMyMatrix;
begin
  tmp:=TMyMatrix.Create;
  tmp.AddLine(1,0,0,0);
  tmp.AddLine(0,0,0,0);
  tmp.AddLine(0,0,1,0);
  tmp.AddLine(0,y0,0,1);
  MultMatrix(tmp);
  tmp.Destroy;
end;

procedure TMyMatrix.ParallelProjectionYZ(x0:Extended);
{параллельная проекция в плоскость yz}
var
  tmp:TMyMatrix;
begin
  tmp:=TMyMatrix.Create;
  tmp.AddLine(0,0,0,0);
  tmp.AddLine(0,1,0,0);
  tmp.AddLine(0,0,1,0);
  tmp.AddLine(x0,0,0,1);
  MultMatrix(tmp);
  tmp.Destroy;
end;

procedure TMyMatrix.Perspective(fovy,aspect,znear,zfar:Extended);
{перспективная проекция}
var
  tmp:TMyMatrix;
  cotangent,
  radians,
  sine,
  deltaZ:Extended;
begin
  radians:=(fovy/2)*pi/180;
  sine:=sin(radians);
  cotangent:=cos(radians)/sine;
  deltaZ:=zFar-zNear;
  tmp:=TMyMatrix.Create;
  tmp.AddLine(cotangent/aspect,0,0,0);
  tmp.AddLine(0,cotangent,0,0);
  tmp.AddLine(0,0,-(zFar+zNear)/deltaZ,-1);
  tmp.AddLine(0,0,-2*zNear*zFar/deltaZ,0);
  MultMatrix(tmp);
  tmp.Destroy;
end;

procedure TMyMatrix.Normalize(var v:TVector3);
{нормализация вектора}
var
  r:Extended;
begin
  r:=sqrt(sqr(v[0])+sqr(v[1])+sqr(v[2]));
  if r<>0 then
  begin
    v[0]:=v[0]/r;
    v[1]:=v[1]/r;
    v[2]:=v[2]/r;
  end;
end;

procedure TMyMatrix.Cross(v1,v2:TVector3; var r:TVector3);
{векторное произведение}
begin
  r[0]:=v1[1]*v2[2]-v1[2]*v2[1];
  r[1]:=v1[2]*v2[0]-v1[0]*v2[2];
  r[2]:=v1[0]*v2[1]-v1[1]*v2[0];
end;

procedure TMyMatrix.LookAt(eyex,eyey,eyez,
                           centerx,centery,centerz,
                           upx,upy,upz:Extended);
{позиционирование камеры}
var
  fwd,side,up:TVector3;
  tmp:TMyMatrix;
begin
  fwd[0]:=centerx-eyex;
  fwd[1]:=centery-eyey;
  fwd[2]:=centerz-eyez;
  up[0]:=upx;
  up[1]:=upy;
  up[2]:=upz;
  Normalize(fwd);
  Cross(fwd,up,side);
  Normalize(side);
  Cross(side,fwd,up);
  tmp:=TMyMatrix.Create;
  tmp.AddLine(side[0],up[0],-fwd[0],0);
  tmp.AddLine(side[1],up[1],-fwd[1],0);
  tmp.AddLine(side[2],up[2],-fwd[2],0);
  tmp.AddLine(0,0,0,1);
  MultMatrix(tmp);
  Translate(-eyex,-eyey,-eyez);
  tmp.Destroy;
end;

procedure TMyMatrix.Copy(m:TMyMatrix);
var
  i,j:Integer;
begin
  if hsize>0 then
  begin
    SetLength(m.arr,hsize);
    for i:=0 to hsize-1 do
      for j:=0 to 3 do
        m.arr[i,j]:=arr[i,j];
    m.hsize:=hsize;
  end;
end;

procedure TMyMatrix.Sort;
var
  tmp1,tmp2,tmp3:TVector4;
  j:Integer;
  f:Boolean;
begin
  f:=True;
  while f do
  begin
    f:=False;
    for j:=0 to hsize-4 do
    begin
      if j mod 3 = 0 then
      if (arr[j,2]+arr[j+1,2]+arr[j+2,2])<(arr[j+3,2]+arr[j+4,2]+arr[j+5,2]) then
      begin
        tmp1:=arr[j];
        tmp2:=arr[j+1];
        tmp3:=arr[j+2];

        arr[j]:=arr[j+3];
        arr[j+1]:=arr[j+4];
        arr[j+2]:=arr[j+5];

        arr[j+3]:=tmp1;
        arr[j+4]:=tmp2;
        arr[j+5]:=tmp3;

        f:=True;
      end;
    end;
  end;
end;

end.
