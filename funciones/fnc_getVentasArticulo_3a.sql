CREATE or ALTER FUNCTION rep.fnc_getVentasArticulo_3a
(
    @cod_articulo varchar(50)
)
RETURNS TABLE
AS
RETURN
(
    WITH periodos AS (
        SELECT 0 AS n
        UNION ALL
        SELECT n + 1 FROM periodos WHERE n < 35
    )
    select 
        p.*,
        isnull(vtas.venta_cantidad,0) as venta_cantidad,
        isnull(vtas.venta_dolares,0) as venta_dolares,
        isnull(vtas.costo_dolares,0) as costo_dolares,
        vtas.nro_clientes,
        case when isnull(vtas.venta_dolares,0)>0 then (vtas.venta_dolares-costo_dolares)/venta_dolares end as margen
    from 
    (
        SELECT
            DATEADD(MONTH, n, '2024-01-01')                    AS fecha,
            YEAR(DATEADD(MONTH, n, '2024-01-01'))               AS anio,
            MONTH(DATEADD(MONTH, n, '2024-01-01'))              AS mes,
            FORMAT(DATEADD(MONTH, n, '2024-01-01'), 'MMM-yy', 'es-PE') AS nom_periodo
        FROM periodos
     ) p  
    left join (
        select 
            year(CompFecha) as anio, 
            month(CompFecha) as mes, 
            sum(CompDetCant) as venta_cantidad,
            sum(CompDetMonto) as venta_dolares,
            abs(sum(CompDetCosto)) as costo_dolares,
            count(distinct ClienteCod) as nro_clientes
        from 
            VW_VentasDet
        where 
            CompDetArtCod = @cod_articulo   --'KN08400011'
            and year(CompFecha)>year(DATEADD(YEAR,-3,GETDATE()))
        group by 
            year(CompFecha),
            month(CompFecha)
    ) vtas on p.anio = vtas.anio and p.mes = vtas.mes

);