unit Model;

interface

uses
  Windows, MyMatrix, Graphics, Math;

type
  TModel=class
  private
    cvs:TCanvas;
    bmp:TBitmap;
    arr,arr2:TMyMatrix;
    f:TextFile;
  public
    constructor Create(Canvas:TCanvas);
    destructor Destroy;override;
    procedure LoadFromFile(FileName:ShortString);
    procedure MultMatrix(m:TMyMatrix);
    procedure Draw(w,h:Integer);
  end;

implementation

uses
  Unit1;

destructor TModel.Destroy;
begin
  arr.Destroy;
  arr2.Destroy;
  bmp.Destroy;
end;

constructor TModel.Create(Canvas:TCanvas);
begin
  cvs:=Canvas;
  bmp:=TBitmap.Create;
  bmp.PixelFormat:=pf24bit;
  arr:=TMyMatrix.Create;
  arr2:=TMyMatrix.Create;
end;

procedure TModel.LoadFromFile(FileName:ShortString);
var
  a,b,c:Extended;
begin
  AssignFile(f,FileName);
  Reset(f);
  arr.Clear;
  while not EOF(f) do
  begin
    Read(f,a,b,c);
    arr.AddLine(a,b,c,1);
  end;
  CloseFile(f);
  arr.Copy(arr2);
end;

procedure TModel.MultMatrix(m:TMyMatrix);
begin
  arr.Copy(arr2);
  arr2.MultMatrix(m);
end;

procedure TModel.Draw(w,h:Integer);
var
  i:Integer;
  a,b,c:TPoint;
  r:Integer;
  ax,ay,az,bx,by,bz,nx,ny,nz,d:Extended;
begin
  with bmp do
  begin
    Width:=w;
    Height:=h;
    with Canvas do
    begin
      Pen.Color:=clBtnFace;
      Brush.Color:=clBtnFace;
      Rectangle(0,0,w,h);
      Pen.Color:=clBlack;
      Brush.Color:=clGreen;
    end;
    if arr2.hsize>0 then
    begin
      i:=-3;
      arr2.Sort;
      while i<arr2.hsize-3 do
      begin
        i:=i+3;
        a.X:=Floor(arr2.arr[i,0]);
        a.Y:=Floor(arr2.arr[i,1]);
        b.X:=Floor(arr2.arr[i+1,0]);
        b.Y:=Floor(arr2.arr[i+1,1]);
        c.X:=Floor(arr2.arr[i+2,0]);
        c.Y:=Floor(arr2.arr[i+2,1]);
        ax:=arr2.arr[i,0];
        ay:=arr2.arr[i,1];
        az:=arr2.arr[i,2];
        bx:=arr2.arr[i+1,0];
        by:=arr2.arr[i+1,1];
        bz:=arr2.arr[i+1,2];
        nx:=ay*bz-az*by;
        ny:=az*bx-ax*bz;
        nz:=ax*by-ay*bx;
        d:=sqrt(nx*nx+ny*ny+nz*nz);
        if d=0 then d:=10e10;
        nx:=nx/d;
        nx:=Abs(nx);
        r:=Round(nx*255);
        r:=Abs(r);
        if r>255 then r:=255;
        r:=255-r;
        if Form1.solid then
        begin
          if Form1.lighting then
            Canvas.Brush.Color:=RGB(r,r,r)
          else
            Canvas.Brush.Color:=RGB(255,255,255);
            Canvas.Polygon([a,b,c]);
        end else begin
          with Canvas do
          begin
            MoveTo(a.X,a.Y);
            LineTo(b.X,b.Y);
            LineTo(c.X,c.Y);
            LineTo(a.X,a.Y);
          end;
        end;
      end;
    end;
  end;
  cvs.Draw(0,0,bmp);
end;


end.
