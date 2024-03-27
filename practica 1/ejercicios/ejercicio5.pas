program ejercicio5;
type
	celular=record
		cod:integer;
		nombre:string;
		desc:string;
		marca:string;
		precio:real;
		stockmin:integer;
		stockdis:integer;
	end;
	
	archivo_celulares = file of celular;
	
	
procedure asignar(var celulares:archivo_celulares);
var	
	nombre,ruta:string;
begin
	writeln('lea el nombre del archivo (sin extension)');
	readln(nombre);
	ruta:= 'C:\Users\bauti\OneDrive\Escritorio\' + nombre + '.dat';
	assign(celulares,ruta);
end;

procedure procesarreg(var reg:celular; var arc: Text);
var
	espacio:char;
begin
	read(arc, reg.cod);
	read(arc, espacio);
	read(arc, reg.precio);
	read(arc, espacio);
	readln(arc, reg.marca);
	read(arc, reg.stockdis);
	read(arc, espacio);
	read(arc, reg.stockmin);
	read(arc, espacio);
	readln(arc, reg.desc);
	readln(arc, reg.nombre);
end;

procedure cargarcelulares(var celulares:archivo_celulares);
var
	archivo_carga: Text;
	ruta:string;
	reg:celular;
begin
	ruta:='C:\Users\bauti\OneDrive\Escritorio\celulares.txt';
	assign(archivo_carga,ruta);
	reset(archivo_carga);
	rewrite(celulares);
	while (not eof(archivo_carga)) do begin
		procesarreg(reg, archivo_carga);
		write(celulares, reg);
	end;
	close (celulares);
	close (archivo_carga);
end;

procedure imprimirreg(reg:celular);
begin
	write(' codigo: ', reg.cod);
	write(' nombre: ',reg.nombre);
	write(' descripcion: ',reg.desc);
	write(' marca: ', reg.marca);
	write(' precio: ',reg.precio);
	write(' stock minimo: ',reg.stockmin);
	writeln(' stock disponible:',reg.stockdis);
end;

procedure recorrerB(var celulares:archivo_celulares);
var
	reg:celular;
begin
	reset(celulares);
	while not eof(celulares) do begin
		read(celulares,reg);
		if (reg.stockdis<reg.stockmin) then
			imprimirreg(reg);
	end;
	close (celulares);
end;

procedure escribirTXT(var arcgen: Text; reg:celular);
begin
	write(arcgen,reg.cod);
	write(arcgen,'	');
	write(arcgen,reg.precio);
	write(arcgen,'	');
	writeln(arcgen,reg.marca);
	
	write(arcgen,reg.stockdis);
	write(arcgen,'	');
	write(arcgen,reg.stockmin);
	write(arcgen,'	');
	writeln(arcgen,reg.desc);
	writeln(arcgen,reg.nombre);
end;

procedure generarTXT(var celulares:archivo_celulares);
var
	arcgen: Text;
	ruta:string;
	reg:celular;
begin
	ruta:='C:\Users\bauti\OneDrive\Escritorio\celulares.txt';
	assign(arcgen, ruta);
	rewrite(arcgen);
	reset(celulares);
	while not eof(celulares) do begin
		read(celulares,reg);
		escribirTXT(arcgen,reg);
	end;
	close(celulares);
	close(arcgen);
end;

procedure cargarreg(var reg:celular);
begin
	writeln('lea ccodigo');
	readln(reg.cod);
	writeln('lea nombre');
	readln(reg.nombre);
	writeln('lea descripcion');
	readln(reg.desc);
	writeln('lea marca');
	readln(reg.marca);
	writeln('lea precio');
	readln(reg.precio);
	writeln('lea stock minimo');
	readln(reg.stockmin);
	writeln('lea stock disponible');
	readln(reg.stockdis);
end;

procedure agregarCel(var celulares: archivo_celulares);
var
	reg:celular;
begin
	cargarreg(reg);
	reset(celulares);
	seek(celulares, filesize(celulares));
	write(celulares,reg);
	close(celulares);
end;

procedure modificarStock(var celulares:archivo_celulares);
var
	nombre:string;
	reg:celular;
	esta:boolean;
	stock:integer;
begin
	esta:=false;
	reset(celulares);
	writeln('lea nombre del celular a modificar');
	readln(nombre);
	while (not eof(celulares) and not esta) do begin
		read(celulares,reg);
		esta:= reg.nombre=nombre;
	end;
	
	if (esta) then begin
		seek(celulares, filepos(celulares)-1);
		writeln('lea stock a modificar');
		readln(stock);
		reg.stockdis:=stock;
		write(celulares,reg);
	end else
		writeln('no exite el phono');
	close(celulares);
end;

var
	opcion:integer;
	celulares: archivo_celulares;
begin
	repeat
		writeln('MENU');
		writeln('Seleccione la opcion que desea realizar');
		writeln('1. Crear archivo de celulares en txt');
		writeln('2. Listar celulares que tienen menos stock que el stock minino');
		writeln('3. Generar txt para futura carga');
		writeln('4. Agregar mas celulares');
		writeln('5. modificar stock de celular dado');
		writeln('6. Salir');
		readln(opcion);
		
		case opcion of
		1: begin
			asignar(celulares);
			cargarcelulares(celulares);
			end;
		2: begin
			asignar(celulares);
			recorrerB(celulares);
			end;
		3: begin
			asignar(celulares);
			generarTXT(celulares);
			end;
		4: begin
			asignar(celulares);
			agregarCel(celulares);
			end;
		5: begin
			asignar(celulares);
			modificarStock(celulares);
			end;
		end;
	until(opcion=6);
end.
		
