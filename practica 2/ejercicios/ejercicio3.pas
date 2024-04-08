program ejercicio203;
const
	valoralto=9999;
type
	producto=record
		cod:integer;
		nombre:string;
		precio:real;
		stockact:integer;
		stockmin:integer;
	end;
	
	archivo_maestro = file of producto;
	
	venta=record
		cod:integer;
		cant:integer; //cantidad de ventas realizadas
	end;
	
	archivo_detalle = file of venta;

procedure leer(var detalle:archivo_detalle; var reg:venta);
begin
	if (not eof(detalle)) then
		read(detalle,reg)
	else
		reg.cod:=valoralto;
end;

procedure actualizar(var maestro:archivo_maestro; var detalle:archivo_detalle);
var
	aux:integer;
	regma:producto;
	regde:venta;
	total:integer;
begin
	reset(maestro);
	reset(detalle);
	read(maestro,regma);
	leer(detalle,regde);
	
	while (regde.cod<>valoralto) do begin
		total:=0;
		aux:=regde.cod;
		while (regde.cod=aux) do begin
			total:=total + regde.cant;
			leer(detalle,regde);
		end;
		
		//busco en el archivo maestro
		while (regma.cod<>aux) do
			read(maestro,regma);
		
		regma.stockact:= regma.stockact - total;
		
		seek(maestro, filepos(maestro)-1);
		write(maestro,regma);
		if not eof(maestro) then
			read(maestro,regma);
	end;
	close(detalle);
	close(maestro);
end;

procedure escribirtxt(var archivo: Text; reg:producto);
begin
	write(archivo, 'codigo de producto: ', reg.cod);
	write(archivo, ' nombre: ', reg.nombre);
	write(archivo, ' precio: ', reg.precio);
	write(archivo, ' stock actual: ', reg.stockact);
	writeln(archivo, ' stock minimo: ', reg.stockmin);
	writeln('escribi');
end;

procedure generartxt(var maestro:archivo_maestro);
var
	reg:producto;
	archivo: Text;
begin
	assign(archivo,'C:\Users\bauti\OneDrive\Escritorio\stock_minimo.txt');
	rewrite(archivo);
	reset(maestro);	
	while (not eof(maestro)) do begin	
		read(maestro,reg);
		if (reg.stockact<reg.stockmin) then
			escribirtxt(archivo,reg);
	end;
	close(maestro);
	close(archivo);
end;
var
	maestro:archivo_maestro;
	detalle:archivo_detalle;
	opcion:integer;
begin
	assign(maestro,'C:\Users\bauti\OneDrive\Escritorio\maestro.dat');
	assign(detalle, 'C:\Users\bauti\OneDrive\Escritorio\detalle.dat');
	
	repeat
		writeln('MENU ejercicio 3');
		writeln('Seleccione la opcion correcta');
		writeln('1. Actualizar archivo maestro');
		writeln('2. Listar stock minimo (.txt)');
		writeln('3. Salir');
		readln(opcion);
		
		case opcion of
		1: begin
			actualizar(maestro,detalle);
			writeln('Operacion exitosa');
			end;
		
		2: begin
			generartxt(maestro);
			writeln('listado realizado');
			end;		
		end;
		
		
	until (opcion=3);
end.
