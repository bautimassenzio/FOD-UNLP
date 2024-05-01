program ejercicio3;
type
	novela=record
		cod:integer;
		genero:string;
		nombre:string;
		duracion:real;
		director:string;
		precio:real;
	end;
	
	archivo_novelas = file of novela;
	
procedure imprimir(var novelas:archivo_novelas);
var
	n: novela;
begin
	reset(novelas);
	while not eof(novelas) do
	begin
		read(novelas, n);
		writeln('Codigo: ', n.cod);
		writeln('Genero: ', n.genero);
		writeln('Nombre: ', n.nombre);
		writeln('Duracion: ', n.duracion);
		writeln('Director: ', n.director);
		writeln('Precio: ', n.precio);
		writeln('-------------------------');
	end;
	close(novelas);
end;

procedure asignar(var novelas:archivo_novelas);
var
	nombre:string;
begin
	writeln('lea el nombre del archivo sin extension');
	readln(nombre);
	assign(novelas,'C:\Users\bauti\OneDrive\Escritorio\' + nombre + '.dat');
end;

procedure leerreg(var reg:novela);
begin
	writeln('lea codigo');
	readln(reg.cod);
	writeln('lea genero');
	readln(reg.genero);
	if (reg.genero<>'fin') then begin
		writeln('lea nombre');
		readln(reg.nombre);
		writeln('lea duracion');
		readln(reg.duracion);
		writeln('lea director');
		readln(reg.director);
		writeln('lea precio');
		readln(reg.precio);
	end;
end;
procedure cargar (var novelas:archivo_novelas);
var
	reg:novela;
begin
	rewrite(novelas);
	reg.cod:=0;
	write(novelas,reg);
	leerreg(reg);
	while (reg.genero<>'fin') do begin
		write(novelas,reg);
		leerreg(reg);
	end;
	close(novelas);
end;

procedure darAlta(var novelas:archivo_novelas);
var
	reg,inreg,regaux:novela;
begin
	leerreg(inreg);
	reset(novelas);
	read(novelas,reg);
	if (reg.cod=0) then begin
		seek(novelas,FileSize(novelas));
		write(novelas,inreg);
	end else begin
		seek(novelas,Abs(reg.cod));
		read(novelas,regaux);
		seek(novelas,0);
		write(novelas,regaux);
		seek(novelas,Abs(reg.cod));
		write(novelas,inreg);
	end;
	close(novelas);		
end;

procedure eliminar(var novelas:archivo_novelas);
var
	cod,pos:integer;
	reg,regaux:novela;
begin
	writeln('lea codigo a eliminar');
	readln(cod);
	reset(novelas);
	read(novelas,reg);
	while(reg.cod<>cod) and (not eof(novelas)) do
		read(novelas,reg);
	if (reg.cod=cod) then begin
		pos:=FilePos(novelas)-1;
		seek(novelas,0);
		read(novelas,regaux);
		seek(novelas,pos);
		write(novelas,regaux);
		seek(novelas,0);
		regaux.cod:=-pos;
		write(novelas,regaux);
	end else
		writeln('no se encuentra el codigo');
	close(novelas);
end;

procedure leerregmod(var reg:novela);
begin
	writeln('lea genero');
	readln(reg.genero);
	writeln('lea duracion');
	readln(reg.duracion);
	writeln('lea director');
	readln(reg.director);
	writeln('lea precio');
	readln(reg.precio);
end;

procedure modificarNovela(var novelas:archivo_novelas);
var
	nombre:string;
	reg,regmod:novela;
begin
	reset(novelas);
	writeln('lea el nombre de la novela a modificar');
	readln(nombre);
	read(novelas,reg);
	while (reg.nombre<>nombre) and (not eof(novelas)) do
		read(novelas,reg);
	if (reg.nombre=nombre) then begin
		regmod.nombre:=nombre;
		regmod.cod:=reg.cod;
		leerregmod(regmod);
		seek(novelas,filepos(novelas)-1);
		write(novelas,regmod);
	end else
		writeln('la novela no se encuentra');
end;

procedure generartxt(var novelas:archivo_novelas);
var
	txt: Text;
	reg:novela;
begin
	assign(txt,'C:\Users\bauti\OneDrive\Escritorio\novelas.txt');
	rewrite(txt);
	reset(novelas);
	while not eof(novelas) do begin
		read(novelas,reg);
		writeln(txt,'codigo: ',reg.cod);
		writeln(txt,'genero: ',reg.genero);
		writeln(txt,'nombre: ',reg.nombre);
		writeln(txt,'duracion: ',reg.duracion);
		writeln(txt,'director: ',reg.director);
		writeln(txt,'precio: ',reg.precio);
		writeln(txt,'-------------------');
	end;
	close(novelas);
	close(txt);
end;

var
	opcion:integer;
	novelas:archivo_novelas;
begin
	asignar(novelas);  
	asignar(novelas);  
	repeat
		writeln('MENU');
		writeln('Seleccione la opcion que corresponda: ');
		writeln('1. cargar novelas desde teclado');
		writeln('2. Dar de alta una novela');
		writeln('3. Modificar novela');
		writeln('4. Eliminar una novela');
		writeln('5. Imprimir Novelas');
		writeln('6. Generar TXT');
		writeln('7. Salir');
		readln(opcion);
		case opcion of
			1:begin
				cargar(novelas);
				end;			
			2:begin
				darAlta(novelas);
				end;
			3:begin
				modificarNovela(novelas);
				end;
			4:begin
				eliminar(novelas);
				end;
			5:begin
				imprimir(novelas);
				end;
			6:begin
				generartxt(novelas);
				end;
		end;
	until (opcion=7);
end.
