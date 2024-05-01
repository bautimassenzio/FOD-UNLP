program ejercicio207;
uses
  SysUtils;
const
	dim=10;
	valoralto=9999;
type
	
	infoMaestro=record
		cod_loc:integer;
		nombre_loc:string;
		cod_cepa:integer;
		nombre_cepa:string;
		casos_activos:integer;
		casos_nuevos:integer;
		casos_recuperados:integer;
		fallecidos:integer;
	end;
	
	archivo_maestro = file of infoMaestro;
	
	infoDetalle=record
		cod_loc:integer;
		cod_cepa:integer;
		casos_activos:integer;
		casos_nuevos:integer;
		casos_recuperados:integer;
		fallecidos:integer;
	end;
	
	archivo_detalle = file of infoDetalle;
	
	vectorDetalles = array [1..dim] of archivo_detalle;
	regsDetalles = array[1..dim] of infoDetalle;

procedure leer(var detalle:archivo_detalle; var reg:infoDetalle);
begin
	if(not eof(detalle))then
		read(detalle,reg)
	else
		reg.cod_loc:=valoralto;
end;

procedure minimo(var detalles:vectorDetalles; var regs:regsDetalles; var min:infoDetalle);
var
	i,pos:integer;
begin
	min.cod_loc:=valoralto;
	min.cod_cepa:=valoralto;
	for i:=1 to dim do begin
		if(regs[i].cod_loc<min.cod_loc) then begin
			pos:=i;
			min:=regs[i];
		end else if (regs[i].cod_loc=min.cod_loc) then begin
					if (regs[i].cod_cepa<min.cod_cepa) then begin
						pos:=i;
						min:=regs[i];
					end;
				end;
	end;
	if (min.cod_loc<>valoralto) then
		leer(detalles[pos],regs[pos]);
end;
			

var
	maestro:archivo_maestro;
	detalles:vectorDetalles;
	regs:regsDetalles;
	i:integer;
	min:infoDetalle;
	regma:infoMaestro;
begin
	assign(maestro,'maestro.dat');
	reset(maestro);
	for i:=1 to dim do begin
		assign(detalles[i],'detalle' + IntToStr(i) + '.dat');
		reset(detalles[i]);
		leer(detalles[i],regs[i]);
	end;
	minimo(detalles,regs,min);
	read(maestro,regma);
	while (min.cod_loc<>valoralto) do begin
		while (regma.cod_loc<>min.cod_loc) do
			read(maestro,regma);
		while (regma.cod_loc=min.cod_loc) do begin
			while (regma.cod_cepa<>min.cod_cepa) do
				read(maestro,regma);
			while (regma.cod_loc=min.cod_loc) and (regma.cod_cepa=min.cod_cepa) do begin
				regma.fallecidos:=regma.fallecidos+min.fallecidos;
				regma.casos_recuperados:=regma.casos_recuperados+min.casos_recuperados;
				regma.casos_activos:=min.casos_activos;
				regma.casos_nuevos:=min.casos_nuevos;
				minimo(detalles,regs,min);
			end;
			seek(maestro,filepos(maestro)-1);
			write(maestro,regma);
		end;
	end;
	for i:= dim downto 1 do begin
		close(detalles[i]);
	end;
	close(maestro);
end.
	
