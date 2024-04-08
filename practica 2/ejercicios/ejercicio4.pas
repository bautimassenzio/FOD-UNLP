program ejercicio204;
const
	valoralto='ZZZZ';
type
	
	provincia=record
		nombre:string;
		cantidad:integer;
		encuestados:integer;
	end;
	
	archivo_maestro= file of provincia;
	
	censo=record
		nombre:string;
		cod:integer;
		cantidad:integer;
		encuestados:integer;
	end;
	
	archivo_detalle= file of censo;

procedure leer(var detalle:archivo_detalle; var reg:censo);
begin
	if (not eof(detalle)) then
		read(detalle,reg)
	else
		reg.nombre:=valoralto;
end;

procedure minimo(var detalle1,detalle2:archivo_detalle; var reg1,reg2,min:censo);
begin
	if (reg1.nombre<=reg2.nombre)then begin
		min:=reg1;
		leer(detalle1,reg1);
	end else begin
		min:=reg2;
		leer(detalle2,reg2);
	end;
end;

procedure procesar (var maestro:archivo_maestro; var detalle1,detalle2:archivo_detalle);
var
	regde1,regde2,min:censo;
	regma:provincia;
begin
	reset(maestro);
	reset(detalle1);
	reset(detalle2);
	leer(detalle1,regde1);
	leer(detalle2,regde2);
	minimo(detalle1,detalle2,regde1,regde2,min);
	while(min.nombre<>valoralto) do begin
		read(maestro,regma);
		while(regma.nombre<>min.nombre) and (not eof(maestro)) do
			read(maestro,regma);
		while(regma.nombre=min.nombre) do begin
			regma.cantidad:=regma.cantidad+min.cantidad;
			regma.encuestados:= regma.encuestados + min.encuestados;
			minimo(detalle1,detalle2,regde1,regde2,min);
		end;
		seek(maestro,filepos(maestro)-1);
		write(maestro,regma);
	end;
	close(detalle2);
	close(detalle1);
	close(maestro);
end;

var
	maestro:archivo_maestro;
	detalle1:archivo_detalle;
	detalle2:archivo_detalle;
begin
	assign(maestro,'C:\Users\bauti\OneDrive\Escritorio\maestro.dat');
	assign(detalle1,'C:\Users\bauti\OneDrive\Escritorio\detalle1.dat');
	assign(detalle2,'C:\Users\bauti\OneDrive\Escritorio\detalle2.dat');
	procesar(maestro,detalle1,detalle2);
end.
