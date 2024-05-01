program ejercicio208;
const
	valoralto=9999;
type
	venta=record
		cod_cliente:integer;
		nombre:string;
		apellido:string;
		ano:integer;
		mes:integer;
		dia:integer;
		monto:real;
	end;
	
	archivo_ventas = file of venta;

procedure leer(var maestro:archivo_ventas; var reg:venta); 
begin
	if(not eof(maestro)) then
		read(maestro,reg)
	else
		reg.cod_cliente:=valoralto;
end;

var
	maestro:archivo_ventas;
	reg:venta;
	totanual,totmes,tot:real;
	anoaux,mesaux:integer;
	codaux:integer;
begin
	assign(maestro,'C:\Users\bauti\OneDrive\Escritorio\maestro.dat');
	reset(maestro);
	leer(maestro,reg);
	tot:=0;
	while (reg.cod_cliente<>valoralto)do begin
		//Imprimo datos del cliente
		writeln('nombre del cliente: ',reg.nombre, ' ', reg.apellido);
		codaux:=reg.cod_cliente;
		while(codaux=reg.cod_cliente)do begin		
			totanual:=0;
			anoaux:=reg.ano;
			while (codaux=reg.cod_cliente) and (anoaux=reg.ano) do begin
				totmes:=0;
				mesaux:=reg.mes;
				while (codaux=reg.cod_cliente) and (anoaux=reg.ano) and (mesaux=reg.mes) do
					totmes:=totmes+reg.monto;
				totanual:=totanual+totmes;
				//informo total mensual
				writeln('total del mes ', mesaux, ': ',totmes); 
				leer(maestro,reg);
			end;
			tot:=tot+totanual;
			//informo total anual
			writeln('total anual ', anoaux, ': ',totanual);
		end;
	end;
	//informo total ventas
	writeln('monto total de ventas por la empresa: ',tot);
end.

