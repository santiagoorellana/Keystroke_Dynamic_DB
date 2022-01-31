///////////////////////////////////////////////////////////////////////////////
//
// Autor: Santiago Alejandro Orellana Pérez
//
// Creado: 6/2/2014
//
// Función: Implementa un componente IntervalCreator para crear los
//          intervalos de la biométrica del tecleo del usuario a partir
//          de los eventos KeyDown y KeyUp que se le informan.
//
// Creado para ser compilado con: Borland Delphi 7
//
///////////////////////////////////////////////////////////////////////////////

unit UKdIntervalCreator;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Windows, Messages;

//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Tipo de evento que informa de la ocurrencia de un KeyDown o KeyUp.
//-----------------------------------------------------------------------------
const kteUp     = 'U';                           //Tecla soltada.
const kteDown   = 'D';                           //Tecla presionada.
const kteRepeat = 'R';                           //Repetición automática de la tecla.

//-----------------------------------------------------------------------------
// Se utiliza para la medición de la duración por cada tecla.
// Cada posición equivale a un código virtual de tecla y almacena
// el tiempo de KeyDown de la tecla correspondiente.
//-----------------------------------------------------------------------------

type TMarcasAnterioresD = Array [0..255] of Cardinal;

//-----------------------------------------------------------------------------
// Se utiliza para la medición de la latencia entre teclas.
//-----------------------------------------------------------------------------

type TMarcaAnteriorG = record
                       Tiempo: Cardinal;
                       Tecla: Byte;
                       end;

type TMarcasAnterioresG = Array [1..5] of TMarcaAnteriorG;

//-----------------------------------------------------------------------------
// Eventos que se puedne generar.
//-----------------------------------------------------------------------------
type TOnDurationEvent = procedure(Sender: TObject; Key: Byte; Time: Cardinal) of object;
type TOnDiGraphEvent = procedure(Sender: TObject; Key1, Key2: Byte; Time: Cardinal) of object;
type TOnTriGraphEvent = procedure(Sender: TObject; Key1, Key2, key3: Byte; Time: Cardinal) of object;
type TOnTetraGraphEvent = procedure(Sender: TObject; Key1, Key2, key3, Key4: Byte; Time: Cardinal) of object;
type TOnPentaGraphEvent = procedure(Sender: TObject; Key1, Key2, key3, Key4, Key5: Byte; Time: Cardinal) of object;
type TOnReadFileProgress = procedure(Sender: TObject; Events: Integer) of object;

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
  TKdIntervalCreator = class(TComponent)
  private
    Eventos: Integer; 
    AnterioresD: TMarcasAnterioresD;
    AnterioresG: TMarcasAnterioresG;

    FOnReset: TNotifyEvent;
    FOnDuration: TOnDurationEvent;
    FOnDiGraph: TOnDiGraphEvent;
    FOnTriGraph: TOnTriGraphEvent;
    FOnTetraGraph: TOnTetraGraphEvent;
    FOnPentaGraph: TOnPentaGraphEvent;
    FOnReadFileProgress: TOnReadFileProgress;

    procedure Init;
    procedure AgregarEventoD(Evento: Char; Tecla: Byte; MarcaDeTiempo: Cardinal);
    procedure AgregarEventoG(Evento: Char; Tecla: Byte; MarcaDeTiempo: Cardinal);
    function ExtrearEvento(Fila: String): Boolean;
    function FiltrarNumeros(Numero: String): String;
  protected
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Reset;
    procedure AddEvent(Event: TKeyTiming); overload;
    procedure AddEvent(Evento: Char; Tecla: Byte; MarcaDeTiempo: Cardinal); overload;
    procedure AddEventsFromFile(Name: String);
  published
    property OnReset: TNotifyEvent read FOnReset write FOnReset;
    property OnDuration: TOnDurationEvent read FOnDuration write FOnDuration;
    property OnDiGraph: TOnDiGraphEvent read FOnDiGraph write FOnDiGraph;
    property OnTriGraph: TOnTriGraphEvent read FOnTriGraph write FOnTriGraph;
    property OnTetraGraph: TOnTetraGraphEvent read FOnTetraGraph write FOnTetraGraph;
    property OnPentaGraph: TOnPentaGraphEvent read FOnPentaGraph write FOnPentaGraph;
    property OnReadFileProgress: TOnReadFileProgress read FOnReadFileProgress write FOnReadFileProgress;
  end;


procedure Register;

implementation

uses StrUtils;

//-----------------------------------------------------------------------------
// Inicia el componente.
//-----------------------------------------------------------------------------
constructor TKdIntervalCreator.Create(AOwner : TComponent);
begin
inherited Create(AOwner);
Reset;
end;

//-----------------------------------------------------------------------------
// Destruye el componente.
//-----------------------------------------------------------------------------
destructor TKdIntervalCreator.Destroy;
begin
inherited destroy;
end;

//-----------------------------------------------------------------------------
// Reinicia el vector de marcas de tiempos.
//-----------------------------------------------------------------------------
procedure TKdIntervalCreator.Init;
var n: Integer;
begin
//Inicia las marcas anteriores de los Graph.
AnterioresG[1].Tiempo := 0;
AnterioresG[2].Tiempo := 0;
AnterioresG[3].Tiempo := 0;
AnterioresG[4].Tiempo := 0;
AnterioresG[5].Tiempo := 0;

AnterioresG[1].Tecla := 0;
AnterioresG[2].Tecla := 0;
AnterioresG[3].Tecla := 0;
AnterioresG[4].Tecla := 0;
AnterioresG[5].Tecla := 0;

//Inicia las marcas anteriores de las duraciones de cada tecla.
for n := 0 to 255 do AnterioresD[n] := 0;
end;

//-----------------------------------------------------------------------------
// Reinicia el vector de marcas de tiempos.
//-----------------------------------------------------------------------------
procedure TKdIntervalCreator.Reset;
begin
Init;
if Assigned(FOnReset) then FOnReset(self);
end;

//-----------------------------------------------------------------------------
// Agrega un nuevo evento a los cálculos de intervalos.
//-----------------------------------------------------------------------------
procedure TKdIntervalCreator.AddEvent(Evento: Char; Tecla: Byte; MarcaDeTiempo: Cardinal);
begin
AgregarEventoD(Evento, Tecla, MarcaDeTiempo);
AgregarEventoG(Evento, Tecla, MarcaDeTiempo);
end;

procedure TKdIntervalCreator.AddEvent(Event: TKeyTiming);
begin
AddEvent(Event.Evento, Event.Tecla, Event.MarcaDeTiempo);
end;

//-----------------------------------------------------------------------------
// Agrega un nuevo evento a los cálculos de intervalos de duración.
// Si se encuentra un nuevo intervalo, se dispara un evento para informarlo.
//-----------------------------------------------------------------------------
procedure TKdIntervalCreator.AgregarEventoD(Evento: Char; Tecla: Byte; MarcaDeTiempo: Cardinal);
begin
case Evento of
     'D': if AnterioresD[Tecla] = 0 then                                     //Si no existe una marca anterior,
             AnterioresD[Tecla] := MarcaDeTiempo;                            //coloca la nueva marca.
     'U': begin
          if Assigned(FOnDuration) and                                       //Si el evento está asignado
             (AnterioresD[Tecla] <> 0) then                                  //y existe una marca anterior:
             FOnDuration(Self, Tecla, MarcaDeTiempo - AnterioresD[Tecla]);   //Dispara el evento.
          AnterioresD[Tecla] := 0;                                           //Borra la marca anterior.
          end;
     end;
end;

//-----------------------------------------------------------------------------
// Agrega un nuevo evento a los cálculos de intervalos de Graph.
// Si se encuentra un nuevo intervalo, se dispara un evento para informarlo.
//-----------------------------------------------------------------------------
procedure TKdIntervalCreator.AgregarEventoG(Evento: Char; Tecla: Byte; MarcaDeTiempo: Cardinal);
begin
if (Evento = 'D') or (Evento = 'R') then
   begin
   //Desplaza las marcas anteriores y agrega la nueva.
   AnterioresG[5] := AnterioresG[4];
   AnterioresG[4] := AnterioresG[3];
   AnterioresG[3] := AnterioresG[2];
   AnterioresG[2] := AnterioresG[1];
   AnterioresG[1].Tecla := Tecla;
   AnterioresG[1].Tiempo := MarcaDeTiempo;

   //Calcula el DiGraph si existen marcas anteriores.
   if Assigned(FOnDiGraph) and                                    //Si el evento está asignado
      (AnterioresG[2].Tiempo <> 0) then                           //y existe una marca anterior:
      FOnDiGraph(Self,                                            //Dispara el evento.
                 AnterioresG[2].Tecla,                            //Devolviendo la tecla #1
                 AnterioresG[1].Tecla,                            //la tecla #2 y la
                 AnterioresG[1].Tiempo - AnterioresG[2].Tiempo    //duración del DiGraph.
                 );

   //Calcula el TriGraph si existen marcas anteriores.
   if Assigned(FOnTriGraph) and                                   //Si el evento está asignado
      (AnterioresG[3].Tiempo <> 0) then                           //y existen dos marcas anteriores:
      FOnTriGraph(Self,                                           //Dispara el evento.
                  AnterioresG[3].Tecla,                           //Devolviendo la tecla #1
                  AnterioresG[2].Tecla,                           //la tecla #2,
                  AnterioresG[1].Tecla,                           //la tecla #3 y la
                  AnterioresG[1].Tiempo - AnterioresG[3].Tiempo   //duración del TriGraph.
                  );

   //Calcula el TetraGraph si existen marcas anteriores.
   if Assigned(FOnTetraGraph) and                                   //Si el evento está asignado
      (AnterioresG[4].Tiempo <> 0) then                             //y existen tres marcas anteriores:
      FOnTetraGraph(Self,                                           //Dispara el evento.
                    AnterioresG[4].Tecla,                           //Devolviendo la tecla #1
                    AnterioresG[3].Tecla,                           //la tecla #2,
                    AnterioresG[2].Tecla,                           //la tecla #3,
                    AnterioresG[1].Tecla,                           //la tecla #4 y la
                    AnterioresG[1].Tiempo - AnterioresG[4].Tiempo   //duración del TriGraph.
                    );

   //Calcula el PentaGraph si existen marcas anteriores.
   if Assigned(FOnPentaGraph) and                                   //Si el evento está asignado
      (AnterioresG[5].Tiempo <> 0) then                             //y existen cuatro marcas anteriores:
      FOnPentaGraph(Self,                                           //Dispara el evento.
                    AnterioresG[5].Tecla,                           //Devolviendo la tecla #1
                    AnterioresG[4].Tecla,                           //la tecla #2,
                    AnterioresG[3].Tecla,                           //la tecla #3,
                    AnterioresG[2].Tecla,                           //la tecla #4,
                    AnterioresG[1].Tecla,                           //la tecla #5 y la
                    AnterioresG[1].Tiempo - AnterioresG[5].Tiempo   //duración del TriGraph.
                    );
   end;
end;

//-----------------------------------------------------------------------------
// Abre un fichero CSV y lee los eventos escritos en este.
//-----------------------------------------------------------------------------
procedure TKdIntervalCreator.AddEventsFromFile(Name: String);
var Fila: String;
    CSV: TextFile;
    Error: Boolean;
begin
Error := False;
Eventos := 0;
if FileExists(Name) then                                  //Si el fichero existe:
   try
      Reset;                                               //Reinicia el componente.
      AssignFile(CSV, Name);                               //Abre el fichero.
      System.Reset(CSV);                                   //Lo prepara para leerlo.
      while not Eof(CSV) do                                //mientras no se llegue al final del fichero:
            begin
            Readln(CSV, Fila);                             //Lee una linea del fichero.
            if not ExtrearEvento(Fila) then Inc(Error);    //Parsea los datos de la String.
            end;
   finally                                                 //Si no ocurrieron errores:
      CloseFile(CSV);                                      //Cerramos el fichero de la base de Datos.
   end;
if Error then
   MessageBox(0, 'Se han encontrado errores en el fichero.', 'Fichero corrupto...', MB_ICONEXCLAMATION);   
end;

//-----------------------------------------------------------------------------
// Filtra una cadena dejando solo los números.
//-----------------------------------------------------------------------------
function TKdIntervalCreator.FiltrarNumeros(Numero: String): String;
var n: Integer;
begin
Result := '';
if Length(Numero) > 0 then
   for n := 1 to Length(Numero) do
       if Numero[n] in ['0'..'9'] then
          Result := Result + Numero[n];
end;

//-----------------------------------------------------------------------------
// Extrae los datos del evento por cada una de las filas que se le pasan.
//-----------------------------------------------------------------------------
function TKdIntervalCreator.ExtrearEvento(Fila: String): Boolean;
const Sep = ';';
var p: Integer;
    s: String;
    Event: TKeyTiming;
    Error: Boolean;
begin
Error := False;
try
   p := Pos(Sep, Fila);                                          //Busca la posición del separador.
   if p > 0 then                                                 //Si encuentra el separador:
      begin
      s := Copy(Fila, 1, p - 1);                                 //Copia la cadena desde el inicio hasta el separador.
      Delete(Fila, 1, p);                                        //Luego borra la cadena incluyendo al separador.
      Event.Evento := AnsiReplaceStr(s, Chr($20), '')[1];        //Se queda con la primera letra.
      end;

   p := Pos(Sep, Fila);                                          //Busca la posición del separador.
   if p > 0 then                                                 //Si encuentra el separador:
      begin
      s := Copy(Fila, 1, p - 1);                                 //Copia la cadena desde el inicio hasta el separador.
      Delete(Fila, 1, p);                                        //Luego borra la cadena incluyendo al separador.
      try
         Event.Tecla := StrToInt(FiltrarNumeros(s));             //Extrae el número de la tecla.
      except
         Error := True;
      end;
      end;

   try
      Event.MarcaDeTiempo := StrToInt(FiltrarNumeros(Fila));     //Extrae el tiempo del evento.
   except
      Error := True;
   end;
finally
   if not Error  then
      begin
      Inc(Eventos);                                              //Cuenta la cantidad de eventos leidos.
      AddEvent(Event.Evento, Event.Tecla, Event.MarcaDeTiempo);
      if Assigned(FOnReadFileProgress) then                      //Si el evento está asignado:
         FOnReadFileProgress(Self, Eventos);                     //Dispara el evento.
      end;
end;
Result := Error;
end;

//-----------------------------------------------------------------------------
// Registra el componente en la paleta del Delphi
//-----------------------------------------------------------------------------
procedure Register;
begin
RegisterComponents('Keystroke Dynamic', [TKdIntervalCreator]);
end;

end.



