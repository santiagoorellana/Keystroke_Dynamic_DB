unit UKdEditGetIntervalsDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UKdEditAlphaNumeric, ActnList, UKdIntervalCreator;

type
  TForm1 = class(TForm)
    KdEditAlphaNumeric1: TKdEditAlphaNumeric;
    Button2: TButton;
    KdIntervalCreator1: TKdIntervalCreator;
    ComboBox1: TComboBox;
    Memo1: TMemo;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure KdEditAlphaNumeric1TimingVectorInit(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure KdEditAlphaNumeric1KeyDownTiming(Sender: TObject; Event: Char; Key: Byte; Time: Cardinal);
    procedure KdEditAlphaNumeric1KeyUpTiming(Sender: TObject; Event: Char; Key: Byte; Time: Cardinal);
    procedure KdIntervalCreator1Duration(Sender: TObject; Key: Byte;
      Tiempo: Cardinal);
    procedure KdIntervalCreator1DiGraph(Sender: TObject; Key1, Key2: Byte;
      Tiempo: Cardinal);
    procedure KdIntervalCreator1PentaGraph(Sender: TObject; Key1, Key2,
      key3, Key4, Key5: Byte; Tiempo: Cardinal);
    procedure KdIntervalCreator1TetraGraph(Sender: TObject; Key1, Key2,
      key3, Key4: Byte; Tiempo: Cardinal);
    procedure KdIntervalCreator1TriGraph(Sender: TObject; Key1, Key2,
      key3: Byte; Tiempo: Cardinal);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
procedure TForm1.FormCreate(Sender: TObject);
begin
ComboBox1.ItemIndex := 0;
end;

//-----------------------------------------------------------------------------
procedure TForm1.ComboBox1Change(Sender: TObject);
begin
Memo1.Clear;
KdEditAlphaNumeric1.Reset;
KdIntervalCreator1.Reset;
end;

//-----------------------------------------------------------------------------
procedure TForm1.KdEditAlphaNumeric1TimingVectorInit(Sender: TObject);
begin
Memo1.Clear;
KdIntervalCreator1.Reset;
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
procedure TForm1.KdEditAlphaNumeric1KeyDownTiming(Sender: TObject; Event: Char; Key: Byte; Time: Cardinal);
begin
KdIntervalCreator1.AddEvent(Event, Key, Time);
end;

//-----------------------------------------------------------------------------
procedure TForm1.KdEditAlphaNumeric1KeyUpTiming(Sender: TObject; Event: Char; Key: Byte; Time: Cardinal);
begin
KdIntervalCreator1.AddEvent(Event, Key, Time);
end;

//-----------------------------------------------------------------------------
procedure TForm1.KdIntervalCreator1Duration(Sender: TObject; Key: Byte; Tiempo: Cardinal);
begin
if ComboBox1.ItemIndex <> 0 then Exit;
Memo1.Lines.Add('Duración de la tecla: ' + IntToStr(Key) + ' = ' + IntToStr(Tiempo) + ' ms');
end;

//-----------------------------------------------------------------------------
procedure TForm1.KdIntervalCreator1DiGraph(Sender: TObject; Key1, Key2: Byte; Tiempo: Cardinal);
begin
if ComboBox1.ItemIndex <> 1 then Exit;
Memo1.Lines.Add('DiGraph entre teclas: ' +
                 IntToStr(Key1) + '-' +
                 IntToStr(Key2) + ' = ' +
                 IntToStr(Tiempo) + ' ms'
                 );
end;

//-----------------------------------------------------------------------------
procedure TForm1.KdIntervalCreator1TriGraph(Sender: TObject; Key1, Key2, key3: Byte; Tiempo: Cardinal);
begin
if ComboBox1.ItemIndex <> 2 then Exit;
Memo1.Lines.Add('TriGraph entre teclas: ' +
                 IntToStr(Key1) + '-' +
                 IntToStr(Key2) + '-' +
                 IntToStr(Key3) + ' = ' +
                 IntToStr(Tiempo) + ' ms'
                 );
end;

//-----------------------------------------------------------------------------
procedure TForm1.KdIntervalCreator1TetraGraph(Sender: TObject; Key1, Key2, key3, Key4: Byte; Tiempo: Cardinal);
begin
if ComboBox1.ItemIndex <> 3 then Exit;
Memo1.Lines.Add('TetraGraph entre teclas: ' +
                 IntToStr(Key1) + '-' +
                 IntToStr(Key2) + '-' +
                 IntToStr(Key3) + '-' +
                 IntToStr(Key4) + ' = ' +
                 IntToStr(Tiempo) + ' ms'
                 );
end;

//-----------------------------------------------------------------------------
procedure TForm1.KdIntervalCreator1PentaGraph(Sender: TObject; Key1, Key2, key3, Key4, Key5: Byte; Tiempo: Cardinal);
begin
if ComboBox1.ItemIndex <> 4 then Exit;
Memo1.Lines.Add('PentaGraph entre teclas: ' +
                 IntToStr(Key1) + '-' +
                 IntToStr(Key2) + '-' +
                 IntToStr(Key3) + '-' +
                 IntToStr(Key4) + '-' +
                 IntToStr(Key5) + ' = ' +
                 IntToStr(Tiempo) + ' ms'
                 );
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if OpenDialog1.Execute then
   begin
   Memo1.Clear;
   KdIntervalCreator1.AddEventsFromFile(OpenDialog1.FileName);
   end;
end;

end.
