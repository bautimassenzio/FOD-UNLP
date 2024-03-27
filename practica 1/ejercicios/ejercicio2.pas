program ejercicio2;
type
	archivos_enteros=file of integer;

procedure procesar (var enteros:archivos_enteros);
var
	aux,cant,suma:integer;
begin
	cant:=0;
	suma:=0;
	reset(enteros);
	while (not eof(enteros)) do begin
		read(enteros,aux);
		cant:=cant+1;
		suma:=suma+aux;
		if (aux<1500) then
			writeln('num menor a 1500 ',aux);
		writeln(aux);
	end;
	writeln('promedio ',(suma/cant));
	close(enteros);
end;
		

var
	enteros:archivos_enteros;
	nombre, ruta:string;
begin
	writeln('lea el nombre del archivo a procesar(sin .bat)');
	readln(nombre);
	ruta:='C:\Users\bauti\OneDrive\Escritorio\' + nombre + '.dat';
	assign(enteros, ruta);
	procesar(enteros);
end.
