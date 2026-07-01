create or alter view dap.vw_dap_articulos 
as 

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