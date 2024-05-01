program ejercico210;
uses
  SysUtils;
const
	valoralto='ZZZZ';
	dim=2;
type
	vuelos=record
		destino:string;
		fecha:integer;
		hora:integer;
		asientos:integer;
	end;
	
	archivo_maestro = file of vuelos;
	
	infoDetalle=record
		destino:string;
		fecha:integer;
		hora:integer;
		asientos:integer;
	end;
	
	archivo_detalle = file of infoDetalle;
	
	vectorDetalles= array[1..dim] of archivo_detalle;
	regsDetalles= array[1..dim] of infoDetalle;
	
procedure leer(var detalle:archivo_detalle; var reg:infoDetalle);
begin
	if(not eof(detalle)) then
		read(detalle,reg)
	else
		reg.destino:=valoralto;
end;

procedure minimo (var detalles:vectorDetalles; var regs:regsDetalles; var min:infoDetalle);
var
	i,pos:integer;
begin
	min.destino:=valoralto;
	for i:= 1 to dim do begin
		if (regs[i].destino<min.destino) or 
		((regs[i].destino=min.destino) and (regs[i].fecha <min.fecha)) or 
		((regs[i].destino=min.destino[i]) and (regs[i].fecha=min.fecha) and (regs[i].hora<min.hora)) then begin
			min:=regs[i];
			pos:=i;
		end;
	end;
	if (min.destino<>valoralto) then
		leer(detalles[pos],regs[pos]);
end;

var
	maestro:archivo_maestro;
	detalles:vectorDetalles;
	regs:regsDetalles;
	min:infoDetalle;
	regma:vuelos;
	i,cant:integer;
	listado: Text;
begin
	writeln('ingrese una cantidad de asientos');
	readln(cant);
	assign(maestro,'maestro.dat');
	assign(listado,'listado.txt');
	rewrite(listado);
	for i:= 1 to dim do begin
		assign(detalles[i],'detalle' + IntToStr(i)+ '.dat');
		reset(detalles[i]);
		leer(detalles[i],regs[i]);
	end;
	reset(maestro);
	minimo(detalles,regs,min);
	read(maestro,regma);
	while (min.destino<>valoralto)do begin
		while (regma.destino<>min.destino) do
			read(maestro,regma);
		while(regma.destino=min.destino) do begin
			while(regma.fecha<>min.fecha) do
				read(maestro,regma);
			while(regma.destino=min.destino) and (regma.fecha=min.fecha) do begin
				while(regma.hora<>min.hora) do
					read(maestro,regma);
				while(regma.destino=min.destino) and (regma.fecha=min.fecha) and(regma.hora<>min.hora) do begin
					regma.asientos:=regma.asientos - min.asientos;
					minimo(detalles,regs,min);
				end;
				if (regma.asientos<cant) then
					writeln(listado, regma.destino,regma.fecha,regma.hora);
				seek(maestro,filepos(maestro)-1);
				write(maestro,regma);
			end;
		end;
	end;
	close(listado);
	close(maestro);
	for i:= dim downto 1 do begin
		close(detalles[i]);
	end;
end.
