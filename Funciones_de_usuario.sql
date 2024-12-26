-- Creamos la base de datos
create database tienda_online;

-- La usamos
use tienda_online;

-- Creamos la tabla clientes
create table clientes (
    id int auto_increment primary key,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    email varchar(100) not null unique,
    telefono varchar(15),
    fecha_registro date not null
);

-- Datos en la tabla clientes
insert into clientes (nombre, apellido, email, telefono, fecha_registro) values
('Diego', 'Mullo', 'diego.mullo@gmail.com', '0987654321', '2020-05-10'),
('Fernando', 'Imbaquingo', 'fernando.imba@gmail.com', '0998765432', '2021-07-15'),
('Johan', 'Perez', 'johan.perez@gmail.com', '0976543210', '2019-02-20');


-- Tabla productos
create table productos (
    id int auto_increment primary key,
    nombre varchar(100) not null unique,
    precio decimal(10, 2) not null check (precio > 0),
    stock int not null check (stock >= 0),
    descripcion text
);

insert into productos (nombre, precio, stock, descripcion) values
('Laptop HP', 750.00, 10, 'Laptop de 14 pulgadas.'),
('Smartphone Samsung', 500.00, 20, 'Smartphone Galaxy.'),
('Audífonos Sony', 80.00, 30, 'Audífonos inalámbricos.');


-- Tabla pedidos
create table pedidos (
    id int auto_increment primary key,
    cliente_id int not null,
    fecha_pedido date not null,
    total decimal(10, 2),
    foreign key (cliente_id) references clientes(id)
);

insert into pedidos (cliente_id, fecha_pedido, total) values
(1, '2023-12-01', null),
(2, '2023-12-02', null);


-- tabla detalles_pedido
create table detalles_pedido (
    id int auto_increment primary key,
    pedido_id int not null,
    producto_id int not null,
    cantidad int not null check (cantidad > 0),
    precio_unitario decimal(10, 2) not null check (precio_unitario > 0),
    foreign key (pedido_id) references pedidos(id),
    foreign key (producto_id) references productos(id)
);

insert into detalles_pedido (pedido_id, producto_id, cantidad, precio_unitario) values
(1, 1, 1, 750.00),
(1, 3, 2, 80.00),
(2, 2, 1, 500.00);

SET SQL_SAFE_UPDATES = 0;

-- Función para obtener el nombre completo de un cliente
DELIMITER //


create function nombre_completo(cliente_id int) 
returns varchar(100)
deterministic
begin
    declare nombre_com varchar(100);
    select concat(nombre, ' ', apellido) into nombre_com
    from clientes
    where id = cliente_id;
    return nombre_com;
end //

DELIMITER //

-- Función para calcular el descuento de un producto
DELIMITER //

create function calcular_descuento(precio decimal(10, 2), descuento decimal(5, 2))
returns decimal(10, 2)
deterministic
begin
    return precio - (precio * descuento / 100);
end //

DELIMITER //

-- Función para calcular el total de un pedido
DELIMITER //

create function total_pedido(pedido_id int) 
returns decimal(10, 2)
deterministic
begin
    declare total decimal(10, 2);
    select sum(cantidad * precio_unitario) into total
    from detalles_pedido
    where pedido_id = pedido_id;
    return total;
end //

DELIMITER //

-- Función para verificar la disponibilidad de stock
DELIMITER //

create function verificar_stock(producto_id int, cantidad int)
returns boolean
deterministic
begin
    declare stock_actual int;
    select stock into stock_actual
    from productos
    where id = producto_id;
    return stock_actual >= cantidad;
end //

DELIMITER //

-- función para calcular la antigüedad del cliente
DELIMITER //

create function calcular_antiguedad(cliente_id int)
returns int
deterministic
begin
    declare antiguedad int;
    select timestampdiff(year, fecha_registro, curdate()) into antiguedad
    from clientes
    where id = cliente_id;
    return antiguedad;
end //

DELIMITER //

-- consulta para obtener el nombre completo
select nombre_completo(1);

-- consulta para calcular el descuento
select calcular_descuento(100.00, 10.00);

-- consulta para calcular el total de un pedido
select total_pedido(1);

-- consulta para verificar stock
select verificar_stock(1, 5);


