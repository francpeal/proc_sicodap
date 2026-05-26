CREATE or alter view  rep.view_inv_costoArticulo
as 

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
        -- where InvCantFin>0
        union 
        select InvArtCod as cod_articulo, InvFechaPeriodo as periodo, InvAlmacenCod as cod_almacen, InvCantFin as saldo, InvPrecioProm as costo from VW_Inventario
        -- where InvCantFin>0
    ) t ---where t.cod_articulo = '0000100011'
)
select 
    cod_articulo, case when sum(saldo)>0 then sum(saldo*costo)/sum(saldo) else max(costo) end as cup_dolares
from datos where nro=1
group by cod_articulo
-- having sum(saldo)>0