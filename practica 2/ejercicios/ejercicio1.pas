program ejercicio201;
const
	valoralto=9999;
type
	empleado = record
		cod:integer;
		nombre:string;
		monto:double;
	end;
	
	archivo_empleados= file of empleado;
	
	empleadototal=record
		cod:integer;
		nombre:string;
		total:double;
	end;
	
	archivo_total= file of empleadototal;
	
procedure leer (var detalle:archivo_empleados;reg:empleado);
begin
	if (not eof(detalle)) then
		read(detalle,reg)
	else
		reg.cod=valoralto;
end;

procedure asignar(var detalle:archivo_empleados; var maestro:archivo_total);
var
	ruta:string;
begin
	ruta='C:\Users\bauti\OneDrive\Escritorio\detalle.dat';
	assign(detalle,ruta);
	ruta='C:\Users\bauti\OneDrive\Escritorio\maestro.dat';
	assign(maestro,ruta);
end;
	
var
	detalle:archivo_empleados;
	maestro:archivo_total;
	suma:real;
	regde:empleado;
	regma:empleadototal;
	aux:integer;
begin
	asignar(detalle,maestro);
	reset(detalle);
	rewrite(maestro);
	leer(detalle,regde);	
	while (regde.cod<>valoralto) do begin
		aux:=regde.cod;
		suma:=0;
		regma.cod:=regde.cod;
		regma.nombre:=regde.nombre;
		while (aux=regde.cod) do begin
			suma:= suma + reg.monto;
			leer(detalle,regde);
		end;
		regma.total:=suma;
		write(maestro,regma);	
	end;
	close(maestro);
	close(detalle);
end.
