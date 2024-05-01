program ejercicio6;
const
	valoralto=9999;
type
	reg_maestro =record
		cod:integer;
		desc:string;
		colores:string;
		tipo:string;
		stock:integer;
		precio:real;
	end;
	
	archivo_maestro = file of reg_maestro;
	
	obsoleto = record
		cod:integer;
	end;
	
	archivo_obsoletos = file of obsoleto;

procedure imprimirMaestro(var maestro: archivo_maestro);
var
  reg: reg_maestro;
begin
  reset(maestro);

  writeln('Contenido del archivo maestro:');
  while not eof(maestro) do
  begin
    read(maestro, reg);
    writeln('Código: ', reg.cod);
    writeln('Descripción: ', reg.desc);
    writeln('Colores: ', reg.colores);
    writeln('Tipo: ', reg.tipo);
    writeln('Stock: ', reg.stock);
    writeln('Precio: ', reg.precio:0:2);
    writeln('----------------------------------');
  end;

  close(maestro);
end;

procedure leer (var archivo: archivo_obsoletos; var reg:obsoleto);
begin
	if(not eof(archivo)) then
		read(archivo,reg)
	else
		reg.cod:=valoralto;
end;

procedure bajasLogicas(var maestro:archivo_maestro; var obsoletos:archivo_obsoletos);
var
	regma:reg_maestro;
	reg:obsoleto;
begin
	reset(maestro);
	reset(obsoletos);
	leer(obsoletos,reg);
	while (reg.cod<>valoralto) do begin
		read(maestro,regma);
		while (regma.cod<>reg.cod) do
			read(maestro,regma);
		regma.stock:=regma.stock*-1;
		seek(maestro,filepos(maestro)-1);
		write(maestro,regma);
		seek(maestro,0);
		leer(obsoletos,reg);
	end;
	close(obsoletos);
	close(maestro);
end;
	
procedure efectivizarBajas(var maestro:archivo_maestro; var nuevoArch:archivo_maestro);
var
	reg:reg_maestro;
begin
	reset(maestro);
	rewrite(nuevoArch);
	while (not eof(maestro)) do begin
		read(maestro,reg);
		if (reg.stock>=0) then
			write(nuevoArch,reg);
	end;
	close(nuevoArch);
	close(maestro);
end;

var
	maestro:archivo_maestro;
	obsoletos:archivo_obsoletos;
	nuevoArch:archivo_maestro;
begin
	assign(maestro, 'C:\Users\bauti\OneDrive\Escritorio\maestro.dat');
	assign(obsoletos, 'C:\Users\bauti\OneDrive\Escritorio\obsoletos.dat');
	assign (nuevoArch,'C:\Users\bauti\OneDrive\Escritorio\nuevo.dat');
	bajasLogicas(maestro,obsoletos);
	efectivizarBajas(maestro,nuevoArch);
	Erase(maestro); //borro archivo
	Rename(nuevoArch,'maestro.dat');
	imprimirMaestro(nuevoArch);
end.

