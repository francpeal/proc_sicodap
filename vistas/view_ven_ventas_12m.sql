create view rep.view_ven_ventas_12m
as 
SELECT cod_articulo, 
    [12] AS mes1, [11] AS mes2,  [10]  AS mes3,
    [9] AS mes4, [8] AS mes5,  [7]  AS mes6,
    [6] AS mes7, [5] AS mes8,  [4]  AS mes9,
    [3] AS mes10, [2] AS mes11, [1] AS mes12
FROM (    
    select cod_articulo, mes_num, sum(cantidad) as cantidad
    from 
    (
    select 
        EOMONTH(CompFecha,0) as periodo,
        CompDetArtCod as cod_articulo,
        isnull(CompDetCant,0) as cantidad,
        DATEDIFF(MONTH, compfecha, DATEADD(DAY, 1, EOMONTH(GETDATE(), -1))) AS mes_num
    from 
        VW_VentasDet
    where 
        -- DATEDIFF(month, CompFecha, (select max(EOMONTH(compFecha,-1)) from vw_ventasdet))<=11
        convert(date,compfecha) >= dateadd(day,1, DATEADD(MONTH, -12, EOMONTH(GETDATE(), -1)))
        AND compfecha <  EOMONTH(GETDATE(), -1)
        and isnull(CompDetCant,0)<>0
    ) q 
    group by cod_articulo, mes_num

) base
PIVOT (
    SUM(cantidad) FOR mes_num IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) pvt