unit UKdMemoGetTimingVectorDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, UKdEditAlphaNumeric, UKdMemo;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    KdMemo1: TKdMemo;
    Button3: TButton;
    Button4: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure KdMemo1TimingVectorInit(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure KdMemo1KeyDownTiming(Sender: TObject; Event: Char; Key: Byte; Tiempo: Cardinal);
    procedure KdMemo1KeyUpTiming(Sender: TObject; Event: Char; Key: Byte; Tiempo: Cardinal);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//-----------------------------------------------------------------------------
procedure TForm1.Button2Click(Sender: TObject);
var msg: String;
begin
msg := 'Lic. Santiago A. Orellana Pérez' + #13;
msg := msg + 'La Habana, Cuba, 2014' + #13;
Application.MessageBox(PChar(msg), 'Procedencia:', MB_OK);
end;

//-----------------------------------------------------------------------------
procedure TForm1.Button1Click(Sender: TObject);
begin
if SaveDialog1.Execute then
   KdMemo1.TimingVectorToFileCSV(SaveDialog1.FileName);
end;

//-----------------------------------------------------------------------------
procedure TForm1.KdMemo1TimingVectorInit(Sender: TObject);
begin
Memo1.Clear;
end;

//-----------------------------------------------------------------------------
procedure TForm1.Button3Click(Sender: TObject);
var msg: String;
    n: Integer;
begin
msg := 'Vector de tiempos' + #13;
for n := 0 to KdMemo1.TimingVectorLength - 1 do
    msg := msg + 'Evento: ' + KdMemo1.TimingVector[n].Evento +
                 '    Tecla: ' +IntToHex(KdMemo1.TimingVector[n].Tecla, 2) +
                 '    Marca de tiempo: ' + IntToStr(KdMemo1.TimingVector[n].MarcaDeTiempo) + #13;
Application.MessageBox(PChar(msg), '', MB_OK);
end;

//-----------------------------------------------------------------------------
procedure TForm1.Button4Click(Sender: TObject);
begin
KdMemo1.Reset;
Memo1.Clear;
end;

//-----------------------------------------------------------------------------
procedure TForm1.KdMemo1KeyDownTiming(Sender: TObject; Event: Char; Key: Byte; Tiempo: Cardinal);
begin
if Event = kteDown then
   Memo1.Lines.Add('Down:' + #9 + IntToHex(Key, 2) + #9 + IntToStr(Tiempo))
else
   Memo1.Lines.Add('Repeat:' + #9 + IntToHex(Key, 2) + #9 + IntToStr(Tiempo));
end;

//-----------------------------------------------------------------------------
procedure TForm1.KdMemo1KeyUpTiming(Sender: TObject; Event: Char; Key: Byte; Tiempo: Cardinal);
begin
Memo1.Lines.Add('Up:' + #9 + IntToHex(Key, 2) + #9 + IntToStr(Tiempo));
end;

end.
