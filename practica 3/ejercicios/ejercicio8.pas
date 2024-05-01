program ejercicio8;  //para la lista hay que usar el campo desarrolladores, bueno yo hice lo que se me canto y use el campo anio xd
type
	distribucion = record
		nombre:string;
		anio:integer;
		version:string;
		desarrolladores:integer;
		desc:string;
	end;
	
	archivo_distribuciones = file of distribucion;

procedure imprimir(var archivo: archivo_distribuciones);
var
  reg: distribucion;
begin
  reset(archivo);
  while not eof(archivo) do
  begin
    read(archivo, reg);
    writeln('Nombre: ', reg.nombre);
    writeln('Año: ', reg.anio);
    writeln('Versión: ', reg.version);
    writeln('Desarrolladores: ', reg.desarrolladores);
    writeln('Descripción: ', reg.desc);
    writeln('----------------------------------');
  end;

  close(archivo);
end;


procedure leerreg(var reg:distribucion);
begin
	writeln('lea nombre (zzz corte)');
	readln(reg.nombre);
	if (reg.nombre<>'zzz') then begin
		writeln('lea año');
		readln(reg.anio);
		writeln('lea version');
		readln(reg.version);
		writeln('lea desarrolladores');
		readln(reg.desarrolladores);
		writeln('lea descripcion');
		readln(reg.desc);
	end;
end;

procedure cargar(var archivo: archivo_distribuciones);
var
	reg:distribucion;
begin
	rewrite(archivo);
	reg.anio:=0;
	write(archivo,reg);
	leerreg(reg);
	while(reg.nombre<>'zzz') do begin
		write(archivo,reg);
		leerreg(reg);
	end;
	close(archivo);
end;

function existeDistribucion(var archivo:archivo_distribuciones; nombre:string):boolean;
var
	reg:distribucion;
	encontre:boolean;
begin
	encontre:=false;
	reset(archivo);
	while not eof(archivo) and not encontre do begin
		read(archivo,reg);
		if(reg.nombre=nombre) then
			encontre:=true;
	end;
	existeDistribucion:=encontre;
	close(archivo);
end;

procedure altaDistribucion(var archivo:archivo_distribuciones);
var
	regaux,inreg,reg:distribucion;
begin
	reset(archivo);
	writeln('lea la distribucion a dar de alta');
	leerreg(inreg);
	read(archivo,reg);
	if (reg.anio=0) then begin
		seek(archivo,filesize(archivo));
		write(archivo,inreg);
	end else begin
		seek(archivo,Abs(reg.anio)); //voy a la posicion libre que me indica la cabecera
		read(archivo,regaux); //leo el registro
		seek(archivo,0); //voy a la cabecera
		write(archivo,regaux); //escribo el registro
		seek(archivo,Abs(reg.anio)); //vuelvo a la posicion libre
		write(archivo,inreg); //escribo el registro a dar de alta
	end;
	close(archivo);
end;

procedure bajaDistribucion(var archivo:archivo_distribuciones);
var
	nombre:string;
	pos:integer;
	reg:distribucion;
begin
	writeln('lea una distribucion a dar de baja');
	readln(nombre);
	if (existeDistribucion(archivo,nombre)) then begin
		reset(archivo);
		read(archivo,reg);
		while (reg.nombre<>nombre) do
			read(archivo,reg);
		pos:=filepos(archivo)-1;
		seek(archivo,0);
		read(archivo,reg);
		seek(archivo,pos);
		write(archivo,reg);
		seek(archivo,0);
		reg.anio:=-pos;
		write(archivo,reg);
	end else
		writeln('Distribucion no existente');
	close(archivo);
end;
		
var
	archivo: archivo_distribuciones;
	opcion:integer;
	nombre:string;
begin
	assign(archivo,'C:\Users\bauti\OneDrive\Escritorio\aves.dat');
	
	repeat
		writeln('1. cargar archivo');
		writeln('2. imprimir archivo');
		writeln('3. existe distribucion');
		writeln('4. alta distribucion');
		writeln('5. baja distribucion');
		writeln('6. salir');
		readln(opcion);

		case opcion of
			1:begin
				cargar(archivo);
			end;
			2:begin
				imprimir(archivo);
			end;
			3:begin
				writeln('lea un nombre a buscar en el archivo');
				readln(nombre);
				writeln(existeDistribucion(archivo,nombre));
			end;
			4:begin
				altaDistribucion(archivo);
			end;
			5:begin
				bajaDistribucion(archivo);
			end;
		end;
		
	until(opcion = 6);
end.

