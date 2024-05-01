program ejercicio2;
type
	asistente=record
		num:integer;
		apellido:string;
		nombre:string;
		email:string;
		telefono:integer;
		dni:integer;
	end;

	asistentes= file of asistente;
	
procedure leerreg(var reg:asistente);
begin
	writeln('numero de asistente');
	readln(reg.num);
	writeln('lea apellido');
	readln(reg.apellido);
	if (reg.apellido<>'fin') then begin
		writeln('lea nombre');
		readln(reg.nombre);
		writeln('lea mail');
		readln(reg.email);
		writeln('lea cel');
		readln(reg.telefono);
		writeln('lea dni');
		readln(reg.dni);
	end;
end;

procedure cargar(var archivo:asistentes);
var
	reg:asistente;
begin
	rewrite(archivo);
	leerreg(reg);
	while (reg.apellido<>'fin') do begin
		write(archivo,reg);
		leerreg(reg);
	end;
	close(archivo);
end;

procedure bajas(var archivo:asistentes);
var
	reg:asistente;
begin
	reset(archivo);
	while not eof(archivo) do begin
		read(archivo,reg);
		if (reg.num<1000) then begin
			reg.apellido:='***';
			seek(archivo,filepos(archivo)-1);
			write(archivo,reg);
		end;
	end;
	close(archivo);
end;

procedure imprimir(var archivo: asistentes);
var
  reg: asistente;
begin
  // Abrir el archivo en modo lectura
  reset(archivo);

  // Leer y mostrar cada registro del archivo
  while not eof(archivo) do
  begin
    read(archivo, reg);
    writeln('Número: ', reg.num);
    writeln('Apellido: ', reg.apellido);
    writeln('Nombre: ', reg.nombre);
    writeln('Email: ', reg.email);
    writeln('Teléfono: ', reg.telefono);
    writeln('DNI: ', reg.dni);
    writeln('------------------------------------');
  end;

  // Cerrar el archivo
  close(archivo);
end;


var
	archivo:asistentes;
begin
	assign(archivo,'C:\Users\bauti\OneDrive\Escritorio\asistentes.dat');
	cargar(archivo);
	bajas(archivo);
	imprimir(archivo);
end.
