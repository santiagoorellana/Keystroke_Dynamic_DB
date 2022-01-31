///////////////////////////////////////////////////////////////////////////////
//
// Autor: Santiago Alejandro Orellana Pérez
//
// Creado: 6/2/2014
//
// Función: Implementa un componente Edit para obtener la
//          biométrica del tecleo del usuario mientras
//          introduce caracteres alfanuméricos.
//
// Creado para ser compilado con: Borland Delphi 7
//
///////////////////////////////////////////////////////////////////////////////

unit UKdEditAlphaNumeric;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Windows, Messages;

//-----------------------------------------------------------------------------
// Conjuntos de caracteres que se pueden observar para la biométrica.
//-----------------------------------------------------------------------------

//Todas las teclas del teclado numérico.
const TvkNumericoExtendido =
         [VK_NUMPAD0..VK_NUMPAD9,    //Números.
          VK_MULTIPLY,               //Símbolo de multiplicación.
          VK_ADD,                    //Símbolo de suma.
          VK_SUBTRACT,               //Símbolo de resta.
          VK_DECIMAL,                //Punto decimal.
          VK_DIVIDE                  //Símbolo de división.
          ];

//Teclas de letras del alfabeto y número superiores.
const TvkAlfaNumerico =
         [Ord('0')..Ord('9'),        //Números de la parte superior del teclado.
          Ord('A')..Ord('Z'),        //Letras del alfabeto.
          VK_SHIFT,                  //Tecla SHIFT.
          VK_CAPITAL,                //Tecla CAPS LOCK.
          VK_SPACE,                  //Tecla de ESPACIO.
          $BA..$BF,                  //Teclas específicas OEM.
          $DB..$DE,                  //Específicas OEM.
          $C0                        //Específicas OEM.
          ];

//Teclas de letras del alfabeto y número superiores.
const TvkGeneral = TvkAlfaNumerico + TvkNumericoExtendido;

//Teclas que se ignoran para no capturarlas en el vector de tiempos.
const TvkIgnoradas =
         [VK_F1..VK_F12,      //Teclas de función desde F1 hasta F12.
          VK_NUMLOCK,         //Num Lock.
          VK_SCROLL,          //Scroll Lock.
          VK_RETURN,          //Tecla Enter.
          VK_ESCAPE,          //Tecla Esc (Escape)
          VK_INSERT,          //Tecla insert
          VK_PRIOR,           //Page Up.
          VK_NEXT,            //Page Down.
          VK_END,             //Tecla End.
          VK_HOME,            //Tecla Home.
          VK_UP,              //Cursor arriba.
          VK_RIGHT,           //Cursor derecha.
          VK_LEFT,            //Cursor izquierda.
          VK_DOWN,            //Cursor abajo.
          VK_DELETE,          //Tecla Delete.
          VK_LWIN,            //Tecla Windows izquierda.
          VK_RWIN,            //Tecla Windows derecha.
          VK_APPS,            //Menú contextual.
          VK_CONTROL,         //Tecla Ctrl (Control)
          VK_BACK,            //Back space (Borrar atrás)
          VK_TAB,             //Tecla Tab (Tabulador)
          VK_PAUSE,           //Tecla Pause/Break.
          VK_MENU	            //Tecla Alt.
          ];

//-----------------------------------------------------------------------------
// Tipo de evento que informa de la ocurrencia de un KeyDown o KeyUp.
//-----------------------------------------------------------------------------

const kteUp     = 'U';                           //Tecla soltada.
const kteDown   = 'D';                           //Tecla presionada.
const kteRepeat = 'R';                           //Repetición automática de la tecla.

type TOnKeyTiming = procedure(Sender: TObject; Event: Char; Key: Byte; Time: Cardinal) of object;

//-----------------------------------------------------------------------------
// Definición del vector de mercas de tiempos.
//-----------------------------------------------------------------------------

type TKeyTiming = record
                  Evento: Char;                //Tipo de evento que ocurre.
                  Tecla: Byte;                 //Código de tecla virtual.
                  MarcaDeTiempo: Cardinal;     //Marca de tiempo en Milisegundos.
                  end;

type TTimingVector = Array of TKeyTiming;

//-----------------------------------------------------------------------------
// Clase que implementa el componente.
//-----------------------------------------------------------------------------
type
  TKdEditAlphaNumeric = class(TCustomEdit)
  private
    FTimingVector: TTimingVector;
    FReset: Boolean;

    FOnTimingVectorInit: TNotifyEvent;
    FOnPressEnterKey: TNotifyEvent;
    FOnKeyDownTiming: TOnKeyTiming;
    FOnKeyUpTiming: TOnKeyTiming;
    FOnBack: TNotifyEvent;

    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMKeyUp(var Message: TWMKeyUp); message WM_KEYUP;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_LBUTTONDOWN;

    function GetTimingVectorLength: Integer;
    procedure TimingVectorAdd(Evento: Char; Tecla: Byte; MarcaDeTiempo: Cardinal);
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function TeclaValida(var Message: TWMKeyDown): Boolean;
    procedure Reset;
    procedure TimingVectorToFileCSV(Name: String);
    property TimingVector: TTimingVector read FTimingVector;
    property TimingVectorLength: Integer read GetTimingVectorLength;
    function TimingVectorExist: Boolean;
  published
    //Propiedades que se heredan.
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;

    property OnKeyDownTiming: TOnKeyTiming read FOnKeyDownTiming write FOnKeyDownTiming;
    property OnKeyUpTiming: TOnKeyTiming read FOnKeyUpTiming write FOnKeyUpTiming;
    property OnPressEnterKey: TNotifyEvent read FOnPressEnterKey write FOnPressEnterKey;
    property OnTimingVectorInit: TNotifyEvent read FOnTimingVectorInit write FOnTimingVectorInit;
    property OnBack: TNotifyEvent read FOnBack write FOnBack;
  end;


procedure Register;

implementation

//-----------------------------------------------------------------------------
// Inicia el componente.
//-----------------------------------------------------------------------------
constructor TKdEditAlphaNumeric.Create(AOwner : TComponent);
begin
inherited Create(AOwner);
FReset := False;
Reset;
end;

//-----------------------------------------------------------------------------
// Destruye el componente.
//-----------------------------------------------------------------------------
destructor TKdEditAlphaNumeric.Destroy;
begin
inherited destroy;
end;

//-----------------------------------------------------------------------------
// Agrega datos al vector de tiempos.
//-----------------------------------------------------------------------------
procedure TKdEditAlphaNumeric.TimingVectorAdd(Evento: Char; Tecla: Byte; MarcaDeTiempo: Cardinal);
begin
SetLength(FTimingVector, Length(FTimingVector) + 1);
FTimingVector[Length(FTimingVector) - 1].Evento := Evento;
FTimingVector[Length(FTimingVector) - 1].Tecla := Tecla;
FTimingVector[Length(FTimingVector) - 1].MarcaDeTiempo := MarcaDeTiempo;
end;

//-----------------------------------------------------------------------------
// Verifica si ya existe un vector de tiempos.
//-----------------------------------------------------------------------------
function TKdEditAlphaNumeric.TimingVectorExist: Boolean;
begin
Result := (Length(Text) > 0) and (Length(FTimingVector) > 0);
end;

//-----------------------------------------------------------------------------
// Devuelve la longitud del vector de tiempos.
//-----------------------------------------------------------------------------
function TKdEditAlphaNumeric.GetTimingVectorLength: Integer;
begin
Result := Length(FTimingVector);
end;

//-----------------------------------------------------------------------------
// Guarda el vector de marcas de tiempo en un fichero CSV.
//-----------------------------------------------------------------------------
procedure TKdEditAlphaNumeric.TimingVectorToFileCSV(Name: String);
var CSV: TextFile;
    Linea: String;
    n: Integer;
begin
try
   AssignFile(CSV, Name);                                   //Declara un fichero con la ruta especificada.
   Rewrite(CSV);                                            //Abre el fichero para agregarle datos.
   for n := 0 to Length(TimingVector) - 1 do                //Recorre el vector de tiempos completo.
       begin
       Linea := TimingVector[n].Evento + ';' +              //Crea una línea con el tipo de evento
                IntToStr(TimingVector[n].Tecla) + ';' +     //el código de la tecla y con la
                IntToStr(TimingVector[n].MarcaDeTiempo);    //marca de tiempo del evento.
       Writeln(CSV, Linea);                                 //Escribe la línea en el fichero.
       end;
finally                                                     //Al terminar la parte protegida:
   CloseFile(CSV);                                          //Cierra el fichero.
end;
end;

//-----------------------------------------------------------------------------
// Verifica si la tecla es válida para el vector de tiempos.
//-----------------------------------------------------------------------------
function TKdEditAlphaNumeric.TeclaValida(var Message: TWMKeyDown): Boolean;
begin
Result := False;
if (Message.CharCode in TvkGeneral) then Result := True;
end;

//-----------------------------------------------------------------------------
// Reinicia el vector de marcas de tiempos.
//-----------------------------------------------------------------------------
procedure TKdEditAlphaNumeric.Reset;
begin
Text := '';
SetLength(FTimingVector, 0);
if Assigned(FOnTimingVectorInit) then FOnTimingVectorInit(self);
end;

//-----------------------------------------------------------------------------
// Atiende los eventos de KeyDown sobre el componente.
//-----------------------------------------------------------------------------
procedure TKdEditAlphaNumeric.WMKeyDown(var Message: TWMKeyDown);
var MarcaDeTiempo: Cardinal;
    Evento: Char;
begin
//Guarda la marca de tiempo del evento.
MarcaDeTiempo := GetTickCount;

//Si se presionó BackSpace y existe un vector
//de tiempos, indica reiniciar el componente.
if TimingVectorExist then
   if (Message.CharCode = VK_BACK) or
      (Message.CharCode = VK_LEFT) then
       FReset := True;

//Reinicia el componente si es necesario.
if FReset then
   begin
   if Assigned(FOnBack) then FOnBack(Self);
   Reset;
   FReset := False;
   end;

//Si la tecla es válida, la agrega al vector de marcas de tiempos.
if TeclaValida(Message) then
   begin
   //Crea el vector de tiempo.
   //Crea el vector de tiempo.
   if ((Message.KeyData shr 30) and 1) = 1 then
      Evento := kteRepeat  //Key Repeat.
   else
      Evento := kteDown;   //Key Down.
   TimingVectorAdd(Evento, Message.CharCode, MarcaDeTiempo);

   //Informa la ocurrencia del evento.
   if Assigned(FOnKeyDownTiming) then
      FOnKeyDownTiming(self, Evento, Message.CharCode, MarcaDeTiempo);
   inherited;
   end
else
   begin
   if not (Message.CharCode in TvkIgnoradas) then
      begin
      MessageBox(0, 'Tecla no válida', '', MB_ICONEXCLAMATION);
      FReset := True;
      end;
   if Message.CharCode = VK_RETURN then
      if TimingVectorExist and Assigned(FOnPressEnterKey) then
         FOnPressEnterKey(self);
   end;
end;

//-----------------------------------------------------------------------------
// Atiende los eventos de KeyUp sobre el componente.
//-----------------------------------------------------------------------------
procedure TKdEditAlphaNumeric.WMKeyUp(var Message: TWMKeyUp);
var MarcaDeTiempo: Cardinal;
begin
//Guarda la marca de tiempo del evento.
MarcaDeTiempo := GetTickCount;

//Si la tecla es válida, la agrega al vector de marcas de tiempos.
if TeclaValida(Message) then
   begin
   //Crea el vector de tiempo.
   TimingVectorAdd(kteUp, Message.CharCode, MarcaDeTiempo);

   //Informa la ocurrencia del evento.
   if Assigned(FOnKeyUpTiming) then
      FOnKeyUpTiming(self, kteUp, Message.CharCode, MarcaDeTiempo);
   inherited;
   end;
end;

//-----------------------------------------------------------------------------
// Atiende los eventos Enter del componente.
//-----------------------------------------------------------------------------
procedure TKdEditAlphaNumeric.CMEnter(var Message: TCMEnter);
begin
FReset := TimingVectorExist;
inherited;
end;

//-----------------------------------------------------------------------------
// Atiende los eventos Exit del componente.
//-----------------------------------------------------------------------------
procedure TKdEditAlphaNumeric.CMExit(var Message: TCMExit);
begin
inherited;
end;

//-----------------------------------------------------------------------------
// Si el usuario hace clic sobre el control, el vector se reinicia.
//-----------------------------------------------------------------------------
procedure TKdEditAlphaNumeric.WMRButtonDown(var Message: TWMRButtonDown);
begin
FReset := TimingVectorExist;
inherited;
end;

//-----------------------------------------------------------------------------
// Registra el componente en la paleta del Delphi
//-----------------------------------------------------------------------------
procedure Register;
begin
RegisterComponents('Keystroke Dynamic', [TKdEditAlphaNumeric]);
end;

end.



