program ejercicio4;
const
	valoralto=9999;
type
	reg_flor= record
		nombre:string[45];
		codigo:integer;
	end;
	
	tArchFlores = file of reg_flor;


procedure leerreg(var reg:reg_flor);
begin
	writeln('lea nombre;');
	readln(reg.nombre);
	writeln('lea codigo (000 corta)');
	readln(reg.codigo);
end;

procedure crearArch(var archivo:tArchFlores); //voy a cargar el archivo con datos
var
	reg:reg_flor;
begin
	reg.codigo:=0;
	rewrite(archivo);
	write(archivo,reg);
	leerreg(reg);
	while (reg.codigo<>000) do begin
		write(archivo,reg);
		leerreg(reg);
	end;
	close(archivo);
end;

procedure agregarFlor(var archivo:tArchFlores; nombre:string; cod:integer);
var
	reg,regnue,regaux:reg_flor;
begin
	reset(archivo);
	regnue.nombre:=nombre;
	regnue.codigo:=cod;
	read(archivo,reg);
	if (reg.codigo=0) then begin
		seek(archivo,filesize(archivo));
		write(archivo,regnue);
	end else begin
		seek(archivo,Abs(reg.codigo)); //me posiciono en el ultimo reg borrado;
		read(archivo,regaux); //copio el reg
		seek(archivo,0);
		write(archivo,regaux); //lo guardo en el reg cabecera
		seek(archivo,Abs(reg.codigo));
		write(archivo,regnue);
	end;
	close(archivo);
end;

procedure listar(var archivo:tArchFlores);
var
	reg:reg_flor;
begin
	reset(archivo);
	read(archivo,reg);//leo reg cabecera
	while(not eof(archivo)) do begin
		read(archivo,reg);
		if (reg.codigo>0) then begin
			writeln('nombre: ',reg.nombre);
			writeln('codigo: ',reg.codigo);
		end;
	end;
	close(archivo);
end;

procedure eliminarFlor(var archivo:tArchFlores; regBaja:reg_flor);
var
	reg,regaux:reg_flor;
	pos:integer;
begin
	reset(archivo);
	read(archivo,reg);
	while (reg.codigo<>regBaja.codigo) and (not eof(archivo)) do
		read(archivo,reg);
	if (reg.codigo=regBaja.codigo) then begin
		pos:= filepos(archivo)-1; //guardo la pos del reg a eliminar;
		seek(archivo,0);
		read(archivo,regaux); //copio el reg cabecera
		seek(archivo,pos);
		write(archivo,regaux); //lo guardo en la pos de borrado
		reg.codigo:=-pos;
		seek(archivo,0);
		write(archivo,reg); //actualizo cabecera
	end else
		writeln('el registro no se encuentra en el archivo');
	close(archivo);
end;
var
	archivo: tArchFlores;
	nombre:string;
	codigo:integer;
	reg:reg_flor;
begin
	assign(archivo,'archivo.txt');
	crearArch(archivo); //creo el archivo e inicializo el reg cabecera
	writeln('Lea el nombre y el codigo a agregar al archivo');
	readln(nombre);
	readln(codigo);
	agregarFlor(archivo,nombre,codigo);
	listar(archivo);
	writeln('Lea codigo de flor a eliminar'); //ejercicio 5
	readln(reg.codigo);
	eliminarFlor(archivo,reg);
end.
