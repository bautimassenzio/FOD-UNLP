program ejercicio202;
const
	valoralto = 9999;
type
	
	alumno=record
		cod:integer;
		apellido:string;
		nombre:string;
		cursadas:integer;
		finales:integer;
	end;
	
	archivo_maestro = file of alumno;
	
	infoalumno=record //INFORMACION SI APROBO O NO
		cod:integer;
		materia:string;
		finall:boolean;
		cursada:boolean;
	end;
	
	archivo_detalle = file of infoalumno;
	
procedure leer(var detalle:archivo_detalle; var reg:infoalumno);
begin
	if not eof(detalle) then
		read(detalle,reg)
	else
		reg.cod:=valoralto;
end;

procedure procesar (var maestro:archivo_maestro; var detalle:archivo_detalle);
var
	regma:alumno;
	regde:infoalumno;
	totalfinal,totalcursada,aux:integer;
begin
	reset (detalle);
	reset (maestro);
	leer(detalle,regde);
	read(maestro,regma);
	while (regde.cod<>valoralto) do begin
		totalfinal:=0;
		totalcursada:=0;
		aux:=regde.cod;
		while (regde.cod=aux) do begin
			if (regde.finall) then
				totalfinal:=totalfinal+1
			else if (regde.cursada) then
				totalcursada:=totalcursada +1;
			leer(detalle,regde);
		end;
		
		//BUSCO EN EL ARCHIVO MAESTRO
		while (regma.cod<>aux) do
			read(maestro,regma);
			
		regma.cursadas:=regma.cursadas + totalcursada; 
		regma.finales:=regma.finales + totalfinal;
		regma.cursadas:=regma.cursadas - totalfinal;
		seek(maestro, filepos(maestro)-1);
		
		write (maestro,regma);
		
		if not eof(maestro) then
			read(maestro,regma);
	end;
	close(maestro);
	close(detalle);
end;

procedure procesartxt(var archivo: Text; reg:alumno);
begin
	if (reg.finales>reg.cursadas) then begin
		write(archivo, 'codigo de alumno: ', reg.cod);
		write(archivo, ' apellido: ', reg.apellido);
		write(archivo, ' nombre; ', reg.nombre);
		write(archivo, ' cantidad de cursadas: ', reg.cursadas);
		writeln(archivo, ' catidad de finales: ', reg.finales);
	end;
end;

procedure exportartxt(var maestro:archivo_maestro);
var
	archivo: Text;
	reg:alumno;
begin
	reset(maestro);
	rewrite(archivo);
	while not eof(maestro) do begin
		read(maestro,reg);
		procesartxt(archivo,reg);
	end;
	close(archivo);
	close(maestro);
end;

var
	detalle:archivo_detalle;
	maestro:archivo_maestro;
	opcion:integer;
begin
	assign(detalle,'C:\Users\bauti\OneDrive\Escritorio\detalle.dat');
	assign(maestro,'C:\Users\bauti\OneDrive\Escritorio\maestro.dat');
	
	repeat		
		writeln('MENU EJECICIO 2 PRAC 2');
		writeln('Seleccione la opcion que corresponda');
		writeln('1. Actualizar archivo maestro');
		writeln('2. Listar archivo de texto');
		writeln('3. Salir');
		readln(opcion);
		
		case opcion of
			1: begin
				procesar(maestro,detalle);
				writeln('Operacion exitosa');
				end;
			2: begin
				exportartxt(maestro);
				end;
		end;
		
	until (opcion=3);
end.
