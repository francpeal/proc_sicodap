create or alter view rep.view_ven_ventas_cantidad_12m
as 
-- declare @fecha_cierre date = (select max(CompFecha) from vw_ventasdet);

select 
    EOMONTH(CompFecha,0) as periodo,
    CompDetArtCod as cod_articulo,
    sum(isnull(CompDetCant,0)) as cantidad,
    sum(isnull(CompDetMonto,0)) as monto
    -- count(distinct(EOMONTH(CompFecha,0))) as nro_meses_c_venta
from 
    VW_VentasDet
where 
    -- DATEDIFF(month, CompFecha, (select max(EOMONTH(compFecha,-1)) from vw_ventasdet))<=11
    convert(date,compfecha) >= dateadd(day,1, DATEADD(MONTH, -12, EOMONTH(GETDATE(), -1)))
    AND compfecha <  EOMONTH(GETDATE(), -1)
group by 
    EOMONTH(CompFecha,0),
    CompDetArtCod
