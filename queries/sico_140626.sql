-- 1. Ver todas las tablas del módulo de ventas
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME LIKE '%META%' 
--    OR TABLE_NAME LIKE '%DOCU%'
--    OR TABLE_NAME LIKE '%FACT%'
--    OR TABLE_NAME LIKE '%PEDI%'
ORDER BY TABLE_NAME


--ventas del mes

select top 100 * from VW_VentasDet_Extended

select top 100 * from M_PEDIDO
select * from vw_pedido;


select 
    convert(date,compfecha) as fecha,
    isnull(comppedvencod,'') as cod_vendedor,
    isnull(CompPedVenDesc, 'Sin Vendedor') as nom_vendedor, 
    sum(CompDetMonto) as  monto_venta,
    sum(-1*(CompDetCosto)) as costo_venta
from 
    VW_VentasDet_Extended 
where eomonth(compfecha,0)=eomonth(getdate(),0)
        and CompEstado = 'T'
group by convert(date,compfecha), CompPedVenCod, CompPedVenDesc


---******************************************************+

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
    -1*(CompDetCosto) as costo_dolares,
    ClienteCod as cod_cliente,
    ClienteDoc as ruc_cliente, 
    ClienteDesc as razon_social_cliente, 
    ClienteTipoDesc as tipo_cliente, 
    UbiDep as departamento, 
    UbiProv as provincia, 
    UbiDist as distrito,
    rtrim(ltrim(ArtLineaDesc)) as linea_articulo, 
    ArtTipoDesc as tipo_articulo, 
    ArtCodInt as nro_parte, 
    ArtNombre as nom_articulo,
    ArtCategoria as categoria_articulo
from VW_VentasDet_Extended 
where CompEstado = 'T'



----****************************************+

-- cotizaciones pendientes de facturar
-- c.id,
--     c.cliente_nombre,
--     c.monto_total,
--     c.moneda,           -- 'PEN' o 'USD'
--     c.estado,           -- 'borrador' | 'enviada' | 'caliente' | 'convertida' | 'perdida'
--     c.vendedor_id,
--     u.nombre_completo 

select top 100 * from M_CLIENT
select top 100 * from M_COTIZA

select top 100 * from D_COTIZA
select top 20 *  from M_PEDIDO

select top 3 
    ped.num_ped as id, 
    convert(date,ped.FEC_PED) as fecha,
    cli.des_cli as cliente_nombre, 
    CDG_ALT as cliente_ruc,
    CDG_MON as cod_moneda,
    case when CDG_MON = '001' then 'PEN' when CDG_MON = '002' then 'USD' end as nom_moneda,
    IMP_TTOT as monto_total,
    REF_PED as referencia_pedido,
    SWT_PED as estado,
    ped.CDG_VEND as cod_vendedor,
    vend.DES_VEND as nom_vendedor
from 
    M_PEDIDO ped 
    inner join m_client cli on cli.ruc_cli = ped.ruc_cli
    left join M_VENDED vend on vend.CDG_VEND = ped.CDG_VEND
order by ped.FEC_PED desc, ped.IMP_TTOT desc 

select top 100 * from M_PEDIDO order by FEC_PED desc





----------------------



SELECT TOP 3
    ped.NUM_PED AS id,
    CONVERT(DATE, ped.FEC_PED) AS fecha,
    cli.DES_CLI AS cliente_nombre,
    cli.CDG_ALT AS cliente_ruc,
    CASE WHEN ped.CDG_MON = '001' THEN 'PEN'
         WHEN ped.CDG_MON = '002' THEN 'USD'
    END AS moneda,
    ped.IMP_TTOT AS monto_total,
    ped.REF_PED AS referencia,
    ped.SWT_PED AS estado,
    ped.CDG_VEND AS cod_vendedor,
    vend.DES_VEND AS nom_vendedor
FROM M_PEDIDO ped
INNER JOIN M_CLIENT cli ON cli.RUC_CLI = ped.RUC_CLI
LEFT JOIN M_VENDED vend ON vend.CDG_VEND = ped.CDG_VEND
ORDER BY ped.FEC_PED DESC, ped.IMP_TTOT DESC



select * from vw_articulo

select distinct cdg_tprd from m_produc

select top 200 cdg_prod as cod_articulo, des_prod as nom_articulo --, tipo.DES_ITEM as tipo_producto 
from m_produc
    LEFT JOIN D_TABLAS tipo ON tipo.CDG_TAB = 'TPR'
	AND tipo.NUM_ITEM = M_PRODUC.CDG_TPRD
where tipo.DES_ITEM not like 'servicio%' and tipo.DES_ITEM not like 'gasto%' 
order by CDG_PROd


select top 20 * from D_TABLAS where CDG_TAB = 'TPR'