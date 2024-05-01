program ejercicio3;
type
	empleado=record
		num:integer;
		apellido:string;
		nombre:string;
		edad:integer;
		dni:integer;
	end;
	
	archivos_empleados= file of empleado;

procedure leerreg(var reg:empleado);
begin
	writeln('lea apellido');
	readln(reg.apellido);
	if (reg.apellido<>'fin') then begin
		writeln('lea codigo de empleado');
		readln(reg.num);
		writeln('lea nombre');
		readln(reg.nombre);
		writeln('lea edad');
		readln(reg.edad);
		writeln('lea dni');
		readln(reg.dni);
	end;
end;

procedure cargarempleados(var empleados:archivos_empleados);
var
	reg:empleado;
begin
	rewrite(empleados);
	leerreg(reg);
	while (reg.apellido<>'fin') do begin
		write(empleados,reg);
		leerreg(reg);
	end;
	close(empleados);
end;

procedure imprimirreg(reg:empleado);
begin
	write('numero de empleado: ');
	write(reg.num, ' ');
	write('apellido: ');
	write(reg.apellido);
	write(' nombre: ');
	write(reg.nombre);
	write(' edad: ');
	write(reg.edad);
	write(' dni: ');
	writeln(reg.dni);
end;

procedure imprimirb(var empleados:archivos_empleados; nombre:string; apellido:string);
var
	reg:empleado;
begin
	reset(empleados);
	while (not eof(empleados)) do begin
		read(empleados,reg);
		if ((reg.nombre=nombre) or (reg.apellido=apellido)) then
			imprimirreg(reg);
	end;
	close (empleados);
end;

procedure asignar(var empleados:archivos_empleados);
var
	nombre,ruta:string;
begin
	writeln('lea nombre del archivo(sin extension)');
	readln(nombre);
	ruta:='C:\Users\bauti\OneDrive\Escritorio\' + nombre + '.dat';
	assign(empleados,ruta);
end;

procedure recorrerarc(var empleados:archivos_empleados);
var
	reg:empleado;
begin
	reset(empleados);
	while(not eof(empleados)) do begin
		read(empleados,reg);
		imprimirreg(reg);
	end;
	close(empleados);
end;

procedure recorrerard(var empleados:archivos_empleados);
var
	reg:empleado;
begin
	reset(empleados);
	while (not eof(empleados)) do begin
		read (empleados,reg);
		if (reg.edad>70) then begin
			imprimirreg(reg);
		end;
	end;
	close(empleados);
end;

procedure agregare(var empleados:archivos_empleados);
var
	reg,regleido:empleado;
	existe:boolean;
begin
	leerreg(reg);
	reset(empleados);
	existe:=false;
	while (not eof(empleados) and not existe) do begin
		read(empleados,regleido);
		existe:= regleido.num=reg.num;
	end;
	
	if (existe) then
		writeln('ya existe el numero de empleado')
	else
		write(empleados,reg);
	close(empleados);
end;

procedure modificarF(var empleados:archivos_empleados; num:integer; edad:integer);
var
	reg:empleado;
	existe:boolean;
begin
	existe:=false;
	reset(empleados);
	while (not eof(empleados) and not existe) do begin
		read(empleados,reg);
		existe:=reg.num=num;
	end;
	
	if (not existe) then
		writeln('no existe empleado')
	else begin
		seek(empleados, filepos(empleados) - 1);
		reg.edad:=edad;
		write(empleados,reg);
	end;
	close(empleados);
end;

procedure bajaEmpleados(var empleados:archivos_empleados);
var
	num:integer;
	reg,regul:empleado;
	posbaja:integer;
begin
	reset(empleados);
	writeln('lea el numero del empleado a dar de baja');
	readln(num);
	read(empleados,reg);
	while (not eof(empleados)) and (reg.num<>num) do
		read(empleados,reg);
	if (reg.num=num) then begin
		posbaja:= FilePos(empleados)-1;
		seek(empleados,FileSize(empleados)-1);
		read(empleados,regul);
		seek(empleados,posbaja);
		write(empleados,regul);
		seek(empleados,FileSize(empleados)-1);
		Truncate(empleados);
	end else begin
		writeln('no se encuentra ese empleado');
	end;
	close(empleados);
end;

procedure exportartxt(var empleados:archivos_empleados);
var
	reg:empleado;
	archivo: Text;
	ruta:string;
begin
	ruta:='C:\Users\bauti\OneDrive\Escritorio\todos_empleados.txt';
	reset(empleados);
	assign(archivo,	ruta);
	rewrite(archivo);
	while (not eof(empleados)) do begin
		read(empleados,reg);
		writeln(archivo, 'numero de empleado: ' , reg.num);
		writeln(archivo, 'apellido: ' , reg.apellido);
		writeln(archivo, 'nombre: ' , reg.nombre);
		writeln(archivo, 'edad: ' , reg.edad);
		writeln(archivo, 'dni: ' , reg.dni);
		writeln(archivo, '---------------');
	end;
	close(empleados);
	close(archivo);
	writeln('archivo exportado correctamente');
end;


var
	empleados:archivos_empleados;
	nom,ape:string;
	opcion,num6,edad6:integer;
begin
	repeat
		writeln('');
		writeln('MENU');
		writeln('Seleccione la opcion que corresponda');
		writeln('1. crear archivo y cargar empleados');
		writeln('2. listar en pantalla los empleados por nombre y apellido');
		writeln('3. listar empleados');
		writeln('4. listar empleados proximos a jubilarse');
		writeln('5. agregar empleado al archivo');
		writeln('6. modificar edad de empleado');
		writeln('7. exportar archivo empleados a txt');
		writeln('8. realizar una baja de un empleado');
		writeln('9. salir');
		readln(opcion);
		
		case opcion of 
			1: begin
				asignar(empleados);
				cargarempleados(empleados);
				end;
			2: begin
				asignar(empleados);
				writeln('lea nombre y apellido a imprimir');
				readln(nom);
				readln(ape);
				imprimirb(empleados,nom,ape);
				end;
			3: begin
				asignar(empleados);
				recorrerarc(empleados);
				end;
			4: begin
				asignar(empleados);
				recorrerard(empleados);
				end;
			5: begin
				asignar(empleados);
				agregare(empleados);	
				end;
			6: begin
				asignar(empleados);
				writeln('lea numero de empleado');
				readln(num6);
				writeln('lea edad a modificar');
				readln(edad6);
				modificarF(empleados,num6,edad6);
				end;
			7: begin
				asignar(empleados);
				exportartxt(empleados);
				end;
			8: begin
				asignar(empleados);
				bajaEmpleados(empleados);
				end;
		end;
	until (opcion=9);
end.
