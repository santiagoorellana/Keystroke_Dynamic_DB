unit UKdEditGetTimingVectorDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UKdEditAlphaNumeric, ActnList;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    KdEditAlphaNumeric1: TKdEditAlphaNumeric;
    Button1: TButton;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    procedure KdEditAlphaNumeric1PressEnterKey(Sender: TObject);
    procedure KdEditAlphaNumeric1TimingVectorInit(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure KdEditAlphaNumeric1KeyDownTiming(Sender: TObject;
      Event: Char; Key: Byte; Tiempo: Cardinal);
    procedure KdEditAlphaNumeric1KeyUpTiming(Sender: TObject; Event: Char;
      Key: Byte; Tiempo: Cardinal);
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
procedure TForm1.KdEditAlphaNumeric1PressEnterKey(Sender: TObject);
var msg: String;
    n: Integer;
begin
msg := 'Vector de tiempos' + #13;
for n := 0 to KdEditAlphaNumeric1.TimingVectorLength - 1 do
    msg := msg + 'Evento: ' + KdEditAlphaNumeric1.TimingVector[n].Evento +
                 '    Tecla: ' +IntToHex(KdEditAlphaNumeric1.TimingVector[n].Tecla, 2) +
                 '    Marca de tiempo: ' + IntToStr(KdEditAlphaNumeric1.TimingVector[n].MarcaDeTiempo) + #13;
Application.MessageBox(PChar(msg), '', MB_OK);
end;

//-----------------------------------------------------------------------------
procedure TForm1.KdEditAlphaNumeric1TimingVectorInit(Sender: TObject);
begin
Memo1.Clear;
end;

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
   KdEditAlphaNumeric1.TimingVectorToFileCSV(SaveDialog1.FileName);
end;

//-----------------------------------------------------------------------------
procedure TForm1.KdEditAlphaNumeric1KeyDownTiming(Sender: TObject; Event: Char; Key: Byte; Tiempo: Cardinal);
begin
if Event = kteDown then
   Memo1.Lines.Add('Down:' + #9 + IntToHex(Key, 2) + #9 + IntToStr(Tiempo))
else
   Memo1.Lines.Add('Repeat:' + #9 + IntToHex(Key, 2) + #9 + IntToStr(Tiempo));
end;

//-----------------------------------------------------------------------------
procedure TForm1.KdEditAlphaNumeric1KeyUpTiming(Sender: TObject; Event: Char; Key: Byte; Tiempo: Cardinal);
begin
Memo1.Lines.Add('Up:' + #9 + IntToHex(Key, 2) + #9 + IntToStr(Tiempo));
end;

end.
