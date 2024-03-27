program ejercicio1;
type
	archivos_enteros= file of integer;


procedure leernum(var num:integer);
begin
	writeln('lea un numero a guardar o 30000 para finalizar');
	readln(num);
end;

procedure cargarnumeros(var enteros:archivos_enteros);
var
	num:integer;
begin
	rewrite(enteros);
	leernum(num);
	while (num<>30000) do begin
		write(enteros,num);
		leernum(num);
	end;
	close(enteros);
end;

var
	enteros: archivos_enteros;
	nombre:string;
	ruta:string;
begin
	writeln('Lea el nombre que quiera agregar al archivo (sin extension .dat)');
	readln(nombre);
	ruta:= 'C:\Users\bauti\OneDrive\Escritorio\' + nombre + '.dat';
	assign (enteros, ruta);	
	cargarnumeros(enteros);
end.
