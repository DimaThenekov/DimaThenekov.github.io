unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, IOUtils,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.Layouts, math;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    Panel2: TPanel;
    Button2: TButton;
    Button3: TButton;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Rectangle1: TRectangle;
    SelectionPoint1: TSelectionPoint;
    SelectionPoint2: TSelectionPoint;
    Timer1: TTimer;
    Button4: TButton;
    Panel3: TPanel;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure reloadimg();
    procedure Timer1Timer(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  imagepaths: array of string;
  ind: longint = -1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  path: string;
begin
  setLength(imagepaths, 0);
  Memo1.Lines.Clear;
  ind := -1;
  for path in TDirectory.GetFiles(Edit1.Text) do
    if path.IndexOf('croped_') <= 0 then
    begin
      ind := 0;
      setLength(imagepaths, length(imagepaths) + 1);
      imagepaths[High(imagepaths)] := path;
      Memo1.Lines.Add('file ' + path + ' faind');
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if ind >= 0 then
  begin
    dec(ind);
    if ind < 0 then
      ind := High(imagepaths);
    reloadimg();
  end;
end;

procedure TForm1.reloadimg();
begin
  Memo1.Lines.Clear;
  Image1.Bitmap.LoadFromFile(imagepaths[ind]);
  SelectionPoint1.Position.X := 20;
  SelectionPoint1.Position.Y := 20;
  SelectionPoint2.Position.X := 50;
  SelectionPoint2.Position.Y := 50;
  Image1.Height := Image1.Bitmap.Height;
  Image1.Width := Image1.Bitmap.Width;
  Memo1.Lines.Add(imagepaths[ind] + ' selected');
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  X, Y, h: longint;
begin
  while (SelectionPoint2.Position.X - SelectionPoint1.Position.X < 5) do
    SelectionPoint2.Position.X := SelectionPoint2.Position.X + 2;
  while (SelectionPoint2.Position.Y - SelectionPoint1.Position.Y < 5) do
    SelectionPoint2.Position.Y := SelectionPoint2.Position.Y + 2;
  h := round(max(SelectionPoint2.Position.X - SelectionPoint1.Position.X, SelectionPoint2.Position.Y - SelectionPoint1.Position.Y));
  X := round((SelectionPoint1.Position.X + SelectionPoint2.Position.X) / 2) - h div 2;
  Y := round((SelectionPoint1.Position.Y + SelectionPoint2.Position.Y) / 2) - h div 2;
  Rectangle1.Position.X := X;
  Rectangle1.Position.Y := Y;
  Rectangle1.Width := h;
  Rectangle1.Height := h;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  // next
  if ind >= 0 then
  begin
    inc(ind);
    if ind > High(imagepaths) then
      ind := 0;
    reloadimg();
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  Bmp: TBitmap;
  xScale, yScale: extended;
  iRect: TRect;
begin

  Bmp := TBitmap.Create;
  xScale := Image1.Bitmap.Width / Image1.Width;
  yScale := Image1.Bitmap.Height / Image1.Height;
  try
    Bmp.Width := round(Rectangle1.Width * xScale);
    Bmp.Height := round(Rectangle1.Height * yScale);
    iRect.Left := round(Rectangle1.Position.X * xScale);
    iRect.Top := round(Rectangle1.Position.Y * yScale);
    iRect.Width := round(Rectangle1.Width * xScale);
    iRect.Height := round(Rectangle1.Height * yScale);
    Bmp.CopyFromBitmap(Image1.Bitmap, iRect, 0, 0);
    Bmp.Resize(100,100);
    Bmp.SaveToFile(Edit2.Text+'croped_'+System.IOUtils.TPath.GetFileNameWithoutExtension(imagepaths[ind])+'.jpg');
  finally
    Bmp.Free;
  end;
end;

end.
