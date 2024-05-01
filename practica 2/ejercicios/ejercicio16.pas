program ejercicio216;
uses
  SysUtils;
const
	valoralto=9999;
	dim=10;
type
	moto=record
		cod:integer;
		nombre:string;
		des:string;
		modelo:string;
		marca:string;
		stock:integer;
	end;
	
	archivo_maestro= file of moto;
	
	venta=record
		cod:integer;
		precio:real;
		fecha:integer;
	end;
	
	archivo_detalle= file of venta;
	
	vectorDetalles = array[1..dim] of archivo_detalle;
	regsDetalles= array [1..dim] of venta;

procedure leer(var detalle:archivo_detalle; var reg:venta);
begin
	if (not eof(detalle)) then
		read(detalle,reg)
	else
		reg.cod:=valoralto;
end;

procedure minimo(var detalles:vectorDetalles; var regs:regsDetalles; var min:venta);
var
	i,pos:integer;
begin
	min.cod:=valoralto;
	for i:= 1 to dim do begin
		if (regs[i].cod<min.cod) then begin
			pos:=i;
			min.cod:=regs[i].cod;
		end;
	end;
	if (min.cod<>valoralto) then
		leer(detalles[pos],regs[pos]);
end;
var
	maestro:archivo_maestro;
	detalles:vectorDetalles;
	regs:regsDetalles;
	min:venta;
	regma:moto;
	i,cant,max,codmax:integer;
begin
	assign(maestro,'maestro.dat');
	for i:= 1 to dim do begin
		assign(detalles[i],'detalle' + IntToStr(i) + '.dat');
		reset(detalles[i]);
		leer(detalles[i],regs[i]);
	end;
	reset(maestro);
	minimo(detalles,regs,min);
	read(maestro,regma);
	max:=-1; //maximo que voy a usar para indicar la moto mas vendida
	while(min.cod<>valoralto) do begin
		while(regma.cod<>min.cod) do
			read(maestro,regma);
		cant:=0;
		while (regma.cod=min.cod) do begin
			cant:=cant+1;
			minimo(detalles,regs,min);
		end;
		if (cant>max)then begin
			max:=cant;
			codmax:=regma.cod;
		end;
		regma.stock:=regma.stock-cant;
		seek(maestro,filepos(maestro)-1);
		write(maestro,regma);
	end;
	writeln('La moto mas vendida fue: ',codmax);
	close(maestro);
	for i:=dim downto 1 do begin
		close(detalles[i]);
	end;
end.
