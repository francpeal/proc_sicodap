select top 100 * from VW_Cliente;

select * from rep.view_ven_ventas_12m;

select * from m_vended;

SELECT * FROM INFORMATION_SCHEMA.TABLES
    WHERE 
        -- TABLE_NAME like '%conta%'
        -- AND 
        TABLE_TYPE = 'BASE TABLE'

    select * from D_CLIENT;
    select * from D_CNCPRS;
    select * from D_CTOVTA;

    select * from D_TABLAS;

    select * from M_ANALIT;


select * from M_CTECLI;
select * from M_CTEPRV;


SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'M_CTECLI'
ORDER BY ORDINAL_POSITION;

select * from M_respon;
select * from M_CNTEMP;
select * from D_CNCPRS;

select * from pc_clients;
select * from pc_users;


select sum(venta_dolares)
from 
(
select 
    comptipocod as id_tipo_doc, 
    convert(date, compfecha) as fecha, 
    compmoneda as moneda_transaccion, 
    CompDocSerie as serie, 
    CompPedVenDesc as vendedor, 
    CompDetArtCod as cod_articulo,
    CompDetCant as cantidad, 
    CompDetPrecio as precio, 
    CompDetDescuento as descuento, 
    CompDetMonto as venta_dolares,
    abs(CompDetCosto) as costo_dolares,
    ClienteCod as cod_cliente,
    ClienteDoc as ruc_cliente, 
    ClienteDesc as razon_social_cliente, 
    ClienteTipoDesc as tipo_cliente, 
    UbiDep as departamento, 
    UbiProv as provincia, 
    UbiDist as distrito,
    ArtLineaDesc as linea_articulo, 
    ArtTipoDesc as tipo_articulo, 
    ArtCodInt as nro_parte, 
    ArtNombre as nom_articulo,
    ArtCategoria as categoria_articulo
from VW_VentasDet
where year(CompFecha) = 2025
) q;


-- select distinct compestado from VW_VentasDet 
select sum(CompMonto) from VW_Ventas where year(CompFecha)=2025 --and CompEstado = 'T'
select sum(CompDetMonto) from VW_VentasDet where year(CompFecha)=2025 --and CompEstado = 'T'
select sum(CompDetMonto) from VW_VentasDocDet_Extended where year(CompFecha)=2025 --and CompEstado = 'T'

select CompEstado from VW_VentasDet group by CompEstado


select       
    comptipocod as id_tipo_doc, 
    convert(date, compfecha) as fecha, 
    compdocnumcompleto as folio,
    compmoneda as moneda_transaccion, 
    CompDocSerie as serie, 
    CompPedVenDesc as vendedor, 
    CompDetArtCod as cod_articulo,
    CompDetCant as cantidad, 
    CompDetPrecio as precio, 
    CompDetDescuento as descuento, 
    CompDetMonto as venta_dolares,
    abs(CompDetCosto) as costo_dolares,
    ClienteCod as cod_cliente,
    ClienteDoc as ruc_cliente, 
    ClienteDesc as razon_social_cliente, 
    ClienteTipoDesc as tipo_cliente, 
    UbiDep as departamento, 
    UbiProv as provincia, 
    UbiDist as distrito,
    ArtLineaDesc as linea_articulo, 
    ArtTipoDesc as tipo_articulo, 
    ArtCodInt as nro_parte, 
    ArtNombre as nom_articulo,
    ArtCategoria as categoria_articulo
from VW_VentasDet_Extended 
where CompEstado = 'T'

-- select min(CompFecha) from VW_VentasDocDet_Extended


select top 100 * from VW_VentasDet_Extended

select * from M_CUENTA

select * from vw