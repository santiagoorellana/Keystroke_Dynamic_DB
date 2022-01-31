
///////////////////////////////////////////////////////////////////////////////
//  Nombre: ULista.pas
//
//  Autor:  Santiago Alejandro Orellana P�rez
//
//  Fechar: 23/03/2014
//
///////////////////////////////////////////////////////////////////////////////

unit ULista;

interface

uses Classes;

//-----------------------------------------------------------------------------
// Datos que se encuentran en el nombre de un fichero.
//-----------------------------------------------------------------------------
type TDatoFichero = record
                    ConError: Boolean;       //Indica si el fichero tiene errores.
                    Usuario: String;         //Identificador del usuario.
                    Anno: Integer;           //N�mero del a�o completo con todos sus d�gitos.
                    Mes: Integer;            //N�mero del m�s.
                    Dia: Integer;            //N�mero del d�a.
                    Hora: Integer;           //N�mero de la hora en formato militar (0-24)
                    Minuto: Integer;         //N�mero de minutos.
                    Segundo: Integer;        //N�mero de segundos.
                    end;

//-----------------------------------------------------------------------------
// Datos de un fichero cargado.
//-----------------------------------------------------------------------------
type TFicheroBiometrico = record
                          Ruta: String;
                          Datos: TDatoFichero;
                          FechaTiempo: TDateTime;
                          end;


//-----------------------------------------------------------------------------
type PFicheroBiometrico = ^TFicheroBiometrico;                     //Puntero a un dato to tipo "TSegmento" creado en la memoria.

//-----------------------------------------------------------------------------
type
  TLista = class                                                   //Clase que define la lista que guarda los segmentos.
  private
     lista: TList;
  public
     constructor Create;                                                  //Inicia la lista.
     procedure Vaciar;                                                    //Vac�a la lista.
     procedure Invalidar(var dato: TFicheroBiometrico);                   //Invalida el dato.
     procedure Insertar(indice: Integer; dato: TFicheroBiometrico);       //Inserta un dato en la posici�n indicada.
     procedure InsertarOrdenadoPorFechaHora(Dato: TFicheroBiometrico);    //Inserta un dato en la posici�n que le corresponde seg�n su fecha y hora.
     procedure Agregar(dato: TFicheroBiometrico); overload;               //Agrega un dato al final de la lista.
     function Extraer(indice: Integer): TFicheroBiometrico;               //Extrae el dato de la posici�n indicada.
     function Obtener(indice: Integer): TFicheroBiometrico;               //Devuelve una copia del dato de la posici�n indicada.
     function Insertados: Integer;                                        //Devuelve el n�mero de datos insertados en la lista.
  end;


///////////////////////////////////////////////////////////////////////////////

implementation

uses DateUtils;

//-----------------------------------------------------------------------------
// Inicia la lista vac�a.
//-----------------------------------------------------------------------------
constructor TLista.Create;
begin
lista := TList.Create;
end;

//-----------------------------------------------------------------------------
// Invalida el dato.
//-----------------------------------------------------------------------------
procedure TLista.Invalidar(var dato: TFicheroBiometrico);
begin
end;

//-----------------------------------------------------------------------------
// Agrega un dato al final de la lista.
//-----------------------------------------------------------------------------
procedure TLista.Agregar(Dato: TFicheroBiometrico);
var NuevoSegmento: PFicheroBiometrico;
begin
new(NuevoSegmento);
NuevoSegmento^ := Dato;
lista.Add(NuevoSegmento);
end;

//-----------------------------------------------------------------------------
// Inserta un dato en la posici�n indicada.
//-----------------------------------------------------------------------------
procedure TLista.Insertar(Indice: Integer; Dato: TFicheroBiometrico);
var NuevoSegmento: PFicheroBiometrico;
begin
if (indice <= lista.Count) then
   begin
   new(NuevoSegmento);
   NuevoSegmento^ := Dato;
   lista.Insert(Indice, NuevoSegmento);
   end;
end;

//-----------------------------------------------------------------------------
// Inserta un dato en la posici�n indicada.
//-----------------------------------------------------------------------------
procedure TLista.InsertarOrdenadoPorFechaHora(Dato: TFicheroBiometrico);
var d: TFicheroBiometrico;
    n: Integer;
begin
if Insertados > 0 then
   begin
   for n := 0 to Insertados - 1 do
       begin
       d := Obtener(n);
       if CompareDateTime(d.FechaTiempo, Dato.FechaTiempo) = 1 then   //Si es menor que el elemento n:
          begin
          Insertar(n, Dato);                                          //Inserta el valor en la poici�n
          Break;                                                      //de n desplazandolo hacia atr�s.
          end
       else                                                           //Si es mayor o igual que el elemento n:
          if n = Insertados - 1 then                                  //Si n es el �ltimo elemento de la lista:
             Agregar(Dato);                                           //Agrega el elemento al final.
       end;
   end
else
   Agregar(Dato);
end;

//-----------------------------------------------------------------------------
// Extrae el dato de la posici�n indicada. Devuelve su
// valor y lo borra de la lista.
//-----------------------------------------------------------------------------
function TLista.Extraer(indice: Integer): TFicheroBiometrico;
var Extraido: PFicheroBiometrico;
begin
Invalidar(Result);
if (lista.Count > 0) and (lista.Count > indice) then
   begin
   Extraido := PFicheroBiometrico(lista.Extract(lista.Items[indice]));
   Result := Extraido^;
   Dispose(Extraido);
   end;
end;

//-----------------------------------------------------------------------------
// Optiene el dato de la posici�n indicada.
//-----------------------------------------------------------------------------
function TLista.Obtener(indice: Integer): TFicheroBiometrico;
begin
Invalidar(Result);
if (lista.Count > 0) and (lista.Count > indice) then
   Result := (PFicheroBiometrico(lista.Items[indice]))^;
end;

//-----------------------------------------------------------------------------
// Vac�a la lista.
//-----------------------------------------------------------------------------
procedure TLista.Vaciar;
begin
if Assigned(lista) then
   if lista.Count > 0 then
      lista.Clear;
end;

//-----------------------------------------------------------------------------
// Devuelve la cantidad de datos insertados.
//-----------------------------------------------------------------------------
function TLista.Insertados: Integer;
begin
Result := lista.Count;
end;

end.
