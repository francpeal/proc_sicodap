create or alter function rep.fnc_ven_getVentas_per12m(    
    @filtro_linea varchar(100),
    @solo_pedido bit
)
RETURNS TABLE
AS
RETURN
(
    
select 
    v.cod_articulo,
    v.nom_articulo,
    v.tipo_articulo,
    v.nom_linea,
    v.icc,
    v.stock,
    v.cup_dolares,
    v.inventario_dolares,
    v.vta_prom_4m,
    v.vta_prom_12m,
    v.categoria,
    c.nro_meses as nro_meses_c_venta,
    c.vta_prom_mcv,
    case when ceiling(5*v.vta_prom_12m)>v.stock then 1 else 0 end as pedir,
    q.mes1, q.mes2, q.mes3, q.mes4, q.mes5, q.mes6, q.mes7, q.mes8, q.mes9, q.mes10, q.mes11, q.mes12
from 
    rep.view_ven_analisis_venta v 
    left join rep.view_ven_ventas_12m q on q.cod_articulo = v.cod_articulo
    left join 
    (
        select 
            cod_articulo, 
            count(distinct eomonth(periodo,0)) as nro_meses,
            avg(cantidad) as vta_prom_mcv
        FROM rep.view_ven_ventas_cantidad_12m
        where cantidad>0
        group by cod_articulo
    ) c on v.cod_articulo = c.cod_articulo
where 
    (v.vta_prom_12m > 0 OR v.stock > 0) 
    and lower(v.nom_linea) like '%'+lower(@filtro_linea)+'%'
    and (ceiling(5*v.vta_prom_12m)>v.stock or @solo_pedido = 0)
   
);