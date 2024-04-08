//Este resolucion no esta compilada, seria como un "pseudocodigo", o la idea de como resolverlo
//No esta resuelto la parte del txt.
program ejercicio205;
uses
  SysUtils;
const
	dim=30;
	valoralto=9999;
type
	producto=record
		cod:integer;
		nombre:string;
		descripcion:string;
		stockdis:integer;
		stockmin:integer;
		precio:real;
	end;
	
	archivo_maestro= file of producto;
	
	infoDetalle=record
		cod:integer;
		cantventas:integer;
	end;
	
	archivo_detalle= file of infoDetalle;

procedure leer(var detalle:archivo_detalle; var reg:infoDetalle);
begin
	if(not eof(detalle)) then
		read(detalle,reg)
	else
		reg.cod:=valoralto;
end;

procedure minimo(var detalles:array of archivo_detalle; var regs: array of infoDetalle; var min:infoDetalle);
var
	i:integer;
	mincod:integer;
begin
	mincod:=9999;
	for i:= 1 to dim do begin
		if (regs[i].cod<mincod) then begin
			mincod:=regs[i].cod;
			min:=regs[i];
			leer(detalles[i],regs[i]);
		end;
	end;
end;
		

procedure procesar(var maestro:archivo_maestro; var detalles: array of archivo_detalle);
var
	regs: array [1..dim] of infoDetalle;
	min: infoDetalle;
	i:integer;
	regma:producto;
begin
	reset(maestro);
	for i:= 1 to dim do begin
		reset(detalles[i]);
		leer(detalles[i],regs[i]);
	end;
	minimo(detalles,regs,min);
	while (min.cod<>valoralto) do begin
		read(maestro,regma);
		while(regma.cod<>min.cod) do
			read(maestro,regma);
		while(regma.cod=min.cod) do begin
			regma.stockdis:=regma.stockdis - min.cantventas;
			minimo(detalles,regs,min);
		end;
		seek(maestro,filepos(maestro)-1);
		write(maestro,regma);
	end;
	for i:= 30 downto 1 do begin
		close(detalles[i]);
	end;
	close(maestro);
end;

var
	maestro:archivo_maestro;
	detalles: array [1..dim] of archivo_detalle;
	i:integer;
begin
	assign(maestro,'C:\Users\bauti\OneDrive\Escritorio\maestro.dat');
	for i := 1 to dim do begin
		assign (detalles[i],'C:\Users\bauti\OneDrive\Escritorio\detalle' + IntToStr(i) + '.dat');
	end;
	procesar(maestro,detalles);
end.
