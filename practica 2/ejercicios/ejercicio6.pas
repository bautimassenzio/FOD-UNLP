program ejercicio206;
uses
  SysUtils;
const
	dim=5;
	valoralto=9999;
type
	
	infoDetalle=record
		cod:integer;
		fecha:integer;
		tiempo:real;
	end;
	
	archivo_detalle = file of infoDetalle;
	
	vectorDetalles= array [1..dim] of archivo_detalle;
	vectorRegs= array [1..dim] of infoDetalle;
	
	infoMaestro=record
		cod:integer;
		fecha:integer;
		tiempototal:real;
	end;
	
	archivo_maestro= file of infoMaestro;
	
procedure leer(var detalle:archivo_detalle; var reg:infoDetalle);
begin
	if (not eof(detalle)) then
		read(detalle,reg)
	else
		reg.cod:=valoralto;
end;

procedure minimo(var detalles:vectorDetalles; var regs:vectorRegs; var min:infoDetalle);
var
	i,pos:integer;
begin
	min.cod:= valoralto;
	min.fecha:=valoralto;
	for i:= 1 to dim do begin
		if (regs[i].cod<min.cod)then begin //supongo que se puede representar una fecha con un integer
			min:=regs[i];
			pos:=i;
		end else if (regs[i].cod=min.cod) then begin
					if (regs[i].fecha<min.fecha) then begin
						min:=regs[i];
						pos:=i;
					end;
		end;
	end;
	if(min.cod<>valoralto) then
		leer(detalles[pos],regs[pos]);
end;

procedure resetVector(var detalles:vectorDetalles;var regs:vectorRegs); //abro todos los archivos y ademas ya leo el primer reg
var
	i:integer;
begin
	for i:= 1 to dim do begin
		reset(detalles[i]);
		leer(detalles[i],regs[i]);
	end;
end;

procedure closeVector(var detalles:vectorDetalles);
var
	i:integer;
begin
	for i:= dim downto 1 do begin
		close(detalles[i]);
	end;
end;

procedure procesar(var maestro:archivo_maestro; var detalles:vectorDetalles);
var
	regs:vectorRegs;
	min:infoDetalle;
	regma:infoMaestro;
begin
	rewrite(maestro);
	resetVector(detalles,regs);
	minimo(detalles,regs,min);
	while(min.cod<>valoralto) do begin
		regma.cod:=min.cod;
		regma.fecha:=min.fecha;
		regma.tiempototal:=0;
		while(min.cod=regma.cod) and (min.fecha=regma.fecha) do begin
			regma.tiempototal:=regma.tiempototal + min.tiempo;
			minimo(detalles,regs,min);
		end;
		write(maestro,regma);
	end;
	closeVector(detalles);
	close(maestro);
end;

var
	maestro:archivo_maestro;
	detalles:vectorDetalles;
	i:integer;
begin
	assign(maestro,'C:\Users\bauti\OneDrive\Escritorio\maestro.dat');
	for i:= 1 to dim do begin
		assign(detalles[i],'C:\Users\bauti\OneDrive\Escritorio\detalle' + IntToStr(i) + '.dat');
	end;
	procesar(maestro,detalles);
end.
