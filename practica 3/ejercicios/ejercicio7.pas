program ejercicio7;
type
	ave=record
		cod:longint;
		nombre:string;
		familia:string;
		desc:string;
		zona:string;
	end;
	
	archivo_aves = file of ave;

procedure leerreg(var reg:ave);
begin
	writeln('lea codigo de ave');
	readln(reg.cod);
	if (reg.cod<>-1) then begin
		writeln('lea nombre');
		readln(reg.nombre);
		writeln('lea familia');
		readln(reg.familia);
		writeln('lea descripcion');
		readln(reg.desc);
		writeln('lea zona');
		readln(reg.zona);
	end;
end;

procedure cargarAves(var aves:archivo_aves);
var
	reg:ave;
begin
	rewrite(aves);
	leerreg(reg);
	while(reg.cod<>-1) do begin
		write(aves,reg);
		leerreg(reg);
	end;
	close(aves);
end;

procedure eliminarAves(var aves:archivo_aves);
var
	cod:longint;
	reg:ave;
begin
	reset(aves);
	writeln('lea codigos a eliminar (corte 500000)');
	readln(cod);
	reg.cod:=-1; //inicializo con un valor random negativo para que compile
	while(cod<>500000) do begin	
		while (not eof(aves)) and (reg.cod<>cod) do 
			read(aves,reg);
		if (reg.cod=cod) then begin
			reg.cod:=reg.cod*-1;
			seek(aves,filepos(aves)-1);
			write(aves,reg);
		end else
			writeln('no se encuentra en el archivo');
		writeln('lea codigos a eliminar (corte 500000)');
		readln(cod);
	end;
end;

procedure imprimirreg(reg:ave);
begin
	writeln('codigo; ', reg.cod);
	writeln('nombre: ', reg.nombre);
	writeln('familia: ', reg.familia);
	writeln('descripcion: ', reg.desc);
	writeln('zona; ', reg.zona);
end;

procedure imprimir (var aves:archivo_aves);
var
	reg:ave;
begin
	reset(aves);
	while not eof(aves) do begin
		read(aves,reg);
		imprimirreg(reg);
	end;
	close(aves);
end;

procedure compactar(var aves:archivo_aves);
var
	reg,regaux:ave;
	pos:integer;
begin
	reset(aves);
	while (not eof(aves)) do begin
		read(aves,reg);
		if (reg.cod<0) then begin
			pos:=filepos(aves)-1; //guardo la pos de borrado
			if (eof (aves)) then begin //caso en que el ultimo archivo esta borrado
				seek(aves,filepos(aves)-1);
				Truncate(aves);
			end else begin
				seek(aves,filesize(aves)-1); //posiciono en el ultimo reg
				read(aves,regaux); //guardo ultimo reg en regaux
				seek(aves,filepos(aves)-1); //vuelvo a la ultima pos
				Truncate(aves); //trunco el archivo
				seek(aves,pos); //vuelvo a la posicion de borrado
				write(aves,regaux); //escribo con el ultimo reg
				seek(aves,filepos(aves)-1); //corrigo la posicion por si queda ultimo archivo borrado
			end;
		end;
	end;
	close(aves);
end;

var
	aves:archivo_aves;
	opcion:integer;
begin
	assign(aves,'C:\Users\bauti\OneDrive\Escritorio\aves.dat');
	
	repeat
		writeln('MENU');
		writeln('1. Cargar aves');
		writeln('2. Eliminar aves (marca de borrados)');
		writeln('3. Compactar archivo');
		writeln('4. Imprimir archivo');
		
		readln(opcion);
		
		case opcion of
			1:begin
				cargarAves(aves);
			end;
			
			2:begin
				eliminarAves(aves);
			end;
			3:begin
				compactar(aves);
			end;
			4:begin
				imprimir(aves);
			end;
		end;
	until (opcion = 5);
end.
