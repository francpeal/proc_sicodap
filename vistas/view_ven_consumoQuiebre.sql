create or alter view rep.view_ven_consumoQuiebre
as 
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
    coalesce(vta.vta_und_6m,0)/6.0 as vta_prom_6m,
    vta.ult_fec_venta
from
    (
        select * from rep.view_ven_tasasVentas vta  where vta.vta_und_6m>0
    ) vta    
    full outer join 
    (
        select CDG_PROD as cod_articulo, sum(STK_ACT) as stock_actual from M_STOCK group by CDG_PROD having sum(STK_ACT)>0
    ) stock on stock.cod_articulo = vta.cod_articulo
) q  