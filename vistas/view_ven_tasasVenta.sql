create or alter view rep.view_ven_tasasVentas 
as 
select 
    CompDetArtCod as cod_articulo, 
    sum(case when convert(date, compFecha) < convert(date,datetrunc(month, getdate())) then CompDetCant else 0 end) as vta_und_12m,
    sum(case when convert(date, compFecha) < convert(date,datetrunc(month, getdate())) then CompDetMonto else 0 end) as vta_dol_12m,
    sum(case when convert(date, CompFecha) >= convert(date,DATETRUNC(month, DATEADD(month,-6,getdate()))) then CompDetCant else 0 end) as vta_und_6m,
    sum(case when convert(date, CompFecha) >= convert(date,DATETRUNC(month, DATEADD(month,-6,getdate()))) then CompDetMonto else 0 end) as vta_dol_6m,
    max(compFecha) as ult_fec_venta
from 
    VW_VentasDet
where 
    compestado = 'T'
    and convert(date, CompFecha) >= convert(date,DATETRUNC(month, DATEADD(month,-12,getdate()))) 
        -- and EOMONTH(DATETRUNC(MONTH, getdate()),0)
group by 
    CompDetArtCod
 