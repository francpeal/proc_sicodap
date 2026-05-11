create view rep.view_ven_analisis_venta
as 

select 
    ArtCod as cod_articulo,     
    ArtNombre as nom_articulo, 
    artcategoria as categoria,
    ArtTipoDesc as tipo_articulo,
    ArtLineaDesc as nom_linea,
    isnull(icc.icc,'Z') as icc,
    isnull(inv.saldo_final,0) as stock, 
    -- inv.cup_dolares,
    rep.RepPrecioPromedio as cup_dolares,
    inv.valorizado_final as inventario_dolares,
    vtas.vta_prom_4m,
    vtas.vta_prom_12m   
from 
    vw_articulo arts 
    left join 
    (
        select 
            InvArtCod as cod_articulo, 
            invcantini as saldo_inicial,
            InvCantFin as saldo_final,
            InvMontoFin as valorizado_final,
            case when InvCantFin> 0 then InvMontoFin/InvCantFin end as cup_dolares
        from 
            BI_InventarioPeriodo
        where 
            InvFechaAno = year(dateadd(month,-1,getdate())) 
                and InvFechaMes = MONTH(dateadd(month,-1,getdate())) 
    ) inv on arts.ArtCod = inv.cod_articulo
    left join aux_calculo_icc_articulo icc on icc.cod_articulo = arts.ArtCod
    left join BI_InventarioReposicion rep on rep.RepArtCod = arts.ArtCod and RepPeriodo = '202401'
    left join 
    (
        select 
            cod_articulo, 
            (mes1+mes2+mes3+mes4+mes5+mes6
                    +mes7+mes8+mes9+mes10+mes11+mes12)/12.0 as vta_prom_12m,
            (mes9+mes10+mes11+mes12)/4.0 as vta_prom_4m
        from rep.view_ven_ventas_12m         
    ) as vtas on arts.ArtCod = vtas.cod_articulo
 
