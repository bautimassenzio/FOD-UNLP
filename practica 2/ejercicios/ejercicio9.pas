program ejercicio209;
const
	valoralto=9999;
type
	mesa=record
		cod_prov:integer;
		cod_localidad:integer;
		num_mesa:integer;
		votos:integer;
	end;
	
	archivo= file of mesa;

procedure leer (var mesas:archivo; var reg:mesa);
begin
	if (not eof(mesas)) then
		read(mesas,reg)
	else
		reg.cod_prov:=valoralto;
end;

var
	mesas:archivo;
	auxprov,auxloc:integer;
	totprov,totloc,tot:integer;
	reg:mesa;
begin
	assign (mesas,'archivo.dat');
	reset(mesas);
	leer(mesas,reg);
	tot:=0;
	while (reg.cod_prov<>valoralto) do begin
		auxprov:=reg.cod_prov;
		totprov:=0;
		writeln('Codigo de provincia: ',auxprov);
		while(reg.cod_prov=auxprov) do begin
			auxloc:=reg.cod_localidad;
			totloc:=0;
			writeln('Codigo de Localidad: ',auxloc);
			while(reg.cod_prov=auxprov) and (reg.cod_localidad=auxloc) do begin
				totloc:=totloc + reg.votos;
				leer(mesas,reg);
			end;
			writeln('Total votos localidad: ',totloc);
			totprov:=totprov + totloc;
		end;
		writeln('Total votos provincia: ',totprov);
		tot:= tot + totprov;
	end;
	writeln('Total general de votos: ',tot);
	close(mesas);
end.
			

