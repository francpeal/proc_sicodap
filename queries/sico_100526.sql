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

select * from m_client

select * from vw_articulo

select * from M_LINTIP
select * from T_LINEAS

select * from M_PRODUC

select * from M_TABLAS where DES_TAB like '%medid%'
select * from M_TABLAS where CDG_TAB = 'UNM'

select * from D_TABLAS where CDG_TAB = 'UNM'
select distinct CDG_UMED from M_PRODUC 

select * from stock_producto

select CDG_PROD from M_STOCK group by CDG_PROD HAVING count(*)>1

select 
    ArtCod as cod_articulo, 
    ArtNombre as descripcion, 
    ArtTipoDesc as tipo_articulo, 
    ArtLineaDesc as linea,
    um.ABR_ITEM as unidad_medida,
    isnull(s.stock_actual,0) as stock_actual,
    p.PRE_DOL as precio_inc_igv
from 
    VW_Articulo art 
    inner join M_PRODUC a on a.CDG_PROD = ArtCod
    left join D_TABLAS um on um.CDG_TAB = 'UNM' and a.CDG_UMED = um.NUM_ITEM
    -- left join M_STOCK s on s.CDG_PROD = art.ArtCod
    left join 
    (
        select CDG_PROD as cod_articulo, sum(STK_ACT) as stock_actual from M_STOCK group by CDG_PROD having sum(STK_ACT)>0
    ) s on s.cod_articulo = art.ArtCod
    left join M_PRECIO p on p.CDG_LPRC = '001' and art.ArtCod = p.CDG_PROD
where ArtVenta = 'S'


select * from D_TABLAS where DES_ITEM like '%precio%'

select * from M_TABLAS where DES_TAB like '%precio%'

select * from D_TABLAS where CDG_TAB = 'PRC'

select CDG_PROD from M_PRECIO where cdg_lprc = '001' group by CDG_PROD having count(*)>1

select * from dap.vw_dap_articulos where descripcion like '%wabco%'

select * from m_vendedor