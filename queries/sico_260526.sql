--- reporte de quiebre de stock
--- tasa de venta 6M, stcok actual, 

select convert(date,DATETRUNC(month, DATEADD(month,-6,getdate()))) ,  EOMONTH(DATETRUNC(MONTH, getdate()),0)

select 
    CompDetArtCod as cod_articulo, 
    sum(CompDetCant) as vta_und_6m,
    sum(CompDetMonto) as vta_dol_6m
from 
    VW_VentasDet
where 
    compestado = 'T'
    and convert(date, CompFecha) BETWEEN convert(date,DATETRUNC(month, DATEADD(month,-6,getdate()))) 
        and EOMONTH(DATETRUNC(MONTH, getdate()),0)
        and CompDetArtCod = '0000300006'
group by 
    CompDetArtCod;
 

select * from rep.view_ven_tasasVentas where vta_und_6m > 0 and cod_articulo = '0000300006'

select top 100 * from VW_Inventario

select top 100 * from VW_BI_InventarioReposicion

----*************************************************************************
---- datos de stock y ritmo de consumo

select 
    q.*,
    case when q.vta_prom_6m > 0 then stock_actual/vta_prom_6m 
            when q.vta_prom_6m = 0 and stock_actual > 0 then 999 
            when vta_prom_6m = 0 and stock_actual = 0 then null end as meses_venta
from 
(
select 
    coalesce(vta.cod_articulo,stock.cod_articulo) as cod_articulo, 
    coalesce(vta.vta_und_6m,0) as vta_und_6m,
    coalesce(stock.stock_actual,0) as stock_actual, 
    coalesce(vta.vta_und_6m,0)/6.0 as vta_prom_6m
from
    (
        select * from rep.view_ven_tasasVentas vta  where vta.vta_und_6m>0
    ) vta    
    full outer join 
    (
        select CDG_PROD as cod_articulo, sum(STK_ACT) as stock_actual from M_STOCK group by CDG_PROD having sum(STK_ACT)>0
    ) stock on stock.cod_articulo = vta.cod_articulo
) q 


----*************************************************************************

-- Ver tablas disponibles con "alm" o "stock" o "inv"
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%ALM%'
   OR TABLE_NAME LIKE '%STOCK%'
   OR TABLE_NAME LIKE '%INV%'
   OR TABLE_NAME LIKE '%MOV%'
ORDER BY TABLE_NAME


select * from M_STOCK where CDG_PROD = '0000100003';
select top 100 * from VW_Articulo;
select top 100 * from VW_Inventario where InvFechaPeriodo = '202605'

select InvPrecioProm, InvFechaPeriodo, InvAlmacenCod from BI_InventarioPeriodo where InvArtCod = '0000100011' order by InvFechaPeriodo desc

select InvPrecioProm, InvFechaPeriodo from VW_Inventario where ArtCod = '0000100011' order by InvFechaPeriodo desc

select convert(date, '20260501')


select InvFechaPeriodo as periodo, InvArtCod as cod_articulo, sum(InvCantFin*InvPrecioProm)/sum(InvCantFin) as cup 
from VW_Inventario
group by InvFechaPeriodo, InvArtCod
having sum(InvCantFin)>0



with datos as 
(
    select 
        ROW_NUMBER() over(partition by cod_articulo order by periodo desc ) as nro,
        cod_almacen,
        periodo,
        cod_articulo, 
        saldo, 
        costo
    from 
    (
        select InvArtCod as cod_articulo, InvFechaPeriodo as periodo, InvAlmacenCod as cod_almacen, InvCantFin as saldo, InvPrecioProm as costo from BI_InventarioPeriodo
        where InvCantFin>0
        union 
        select InvArtCod as cod_articulo, InvFechaPeriodo as periodo, InvAlmacenCod as cod_almacen, InvCantFin as saldo, InvPrecioProm as costo from VW_Inventario
        where InvCantFin>0
    ) t ---where t.cod_articulo = '0000100011'
)
select 
    cod_articulo, sum(saldo*costo)/sum(saldo) as cup_dolares
from datos where nro=1
group by cod_articulo
having sum(saldo)>0

select top 100 *  from VW_Articulo

---consulta final

select
    a.ArtLineaDesc as nom_linea, 
    a.ArtSistRepDesc as sistrep,
    a.ArtTipoDesc as tipo_articulo, 
    ArtCodInt as nro_parte,
    ArtNombre as nom_articulo,
    arts.*, inv.cup_dolares
from 
    rep.view_ven_consumoQuiebre arts 
    inner join VW_Articulo a on arts.cod_articulo = a.ArtCod
    left join rep.view_inv_costoArticulo inv on arts.cod_articulo = inv.cod_articulo
where meses_venta <= 1


select 
    cod_articulo, 
    ar.ArtLineaDesc as nom_linea, 
    ar.ArtSistRepDesc as sistrep,
    ar.ArtTipoDesc as tipo_articulo, 
    ar.ArtCodInt as nro_parte,
    ar.ArtNombre as nom_articulo,
    vta_prom_6m, stock_actual, case when stock_actual>vta_prom_6m then 1 else 0 end as dispo_1m
from rep.view_ven_consumoQuiebre ac 
            inner join VW_Articulo ar on ac.cod_articulo = ar.ArtCod
            where ArtTipoDesc not like '%servicio%'


select distinct ArtTipoDesc from VW_Articulo
    

    select * from vw_inventario where artcod = 'KR22500002'
    select top 100 * from vw_articulo where artcod = 'KR22500002'

    select top 100 * from vw_inventario where invartcod = 'KR22500002'
    select top 100 * from BI_InventarioPeriodo where InvArtCod = 'KR22500002'

    select * from rep.view_inv_costoArticulo where cod_articulo = 'EL05900002'

    
