USE master;
GO


CREATE DATABASE DB_SistemaGastos;
GO

USE DB_SistemaGastos;
GO

CREATE TABLE Categorias (
    IdCategoria INT PRIMARY KEY IDENTITY(1,1),
    NombreCategoria NVARCHAR(100) NOT NULL UNIQUE,
    Descripcion NVARCHAR(255) NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    Activo BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE Transacciones (
    IdTransaccion INT PRIMARY KEY IDENTITY(1,1),
    Descripcion NVARCHAR(255) NOT NULL,
    Monto DECIMAL(18,2) NOT NULL CHECK (Monto > 0),
    TipoTransaccion NVARCHAR(20) NOT NULL CHECK (TipoTransaccion IN ('Gasto', 'Ingreso')),
    IdCategoria INT NOT NULL,
    FechaTransaccion DATE NOT NULL,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    Notas NVARCHAR(500) NULL,
    CONSTRAINT FK_Transacciones_Categorias FOREIGN KEY (IdCategoria) 
        REFERENCES Categorias(IdCategoria)
);
GO

INSERT INTO Categorias (NombreCategoria, Descripcion) VALUES
    ('Alimentación', 'Gastos en comida, restaurantes, supermercado'),
    ('Transporte', 'Buses, Uber, gasolina, mantenimiento de vehículo'),
    ('Entretenimiento', 'Cine, conciertos, salidas, suscripciones'),
    ('Educación', 'Libros, cursos, universidad, material escolar'),
    ('Salud', 'Medicinas, doctor, dentista, gimnasio'),
    ('Servicios', 'Luz, agua, internet, teléfono, streaming'),
    ('Vivienda', 'Alquiler, hipoteca, reparaciones'),
    ('Ropa y Accesorios', 'Vestuario, zapatos, accesorios'),
    ('Tecnología', 'Gadgets, software, hardware'),
    ('Otros', 'Gastos diversos no clasificados');
GO

CREATE PROCEDURE sp_InsertarTransaccion
    @Descripcion NVARCHAR(255),
    @Monto DECIMAL(18,2),
    @TipoTransaccion NVARCHAR(20),
    @IdCategoria INT,
    @FechaTransaccion DATE,
    @Notas NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Transacciones (Descripcion, Monto, TipoTransaccion, IdCategoria, FechaTransaccion, Notas)
        VALUES (@Descripcion, @Monto, @TipoTransaccion, @IdCategoria, @FechaTransaccion, @Notas);
        SELECT SCOPE_IDENTITY() AS IdNuevo;
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS MensajeError;
    END CATCH
END
GO

CREATE PROCEDURE sp_ActualizarTransaccion
    @IdTransaccion INT,
    @Descripcion NVARCHAR(255),
    @Monto DECIMAL(18,2),
    @TipoTransaccion NVARCHAR(20),
    @IdCategoria INT,
    @FechaTransaccion DATE,
    @Notas NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE Transacciones
        SET Descripcion = @Descripcion,
            Monto = @Monto,
            TipoTransaccion = @TipoTransaccion,
            IdCategoria = @IdCategoria,
            FechaTransaccion = @FechaTransaccion,
            Notas = @Notas
        WHERE IdTransaccion = @IdTransaccion;
        SELECT @@ROWCOUNT AS FilasActualizadas;
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS MensajeError;
    END CATCH
END
GO

CREATE PROCEDURE sp_EliminarTransaccion
    @IdTransaccion INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM Transacciones
        WHERE IdTransaccion = @IdTransaccion;
        SELECT @@ROWCOUNT AS FilasEliminadas;
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS MensajeError;
    END CATCH
END
GO

CREATE PROCEDURE sp_ObtenerTodasTransacciones
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        t.IdTransaccion,
        t.Descripcion,
        t.Monto,
        t.TipoTransaccion,
        t.IdCategoria,
        c.NombreCategoria,
        t.FechaTransaccion,
        t.FechaRegistro,
        t.Notas
    FROM Transacciones t
    INNER JOIN Categorias c ON t.IdCategoria = c.IdCategoria
    ORDER BY t.FechaTransaccion DESC, t.FechaRegistro DESC;
END
GO

CREATE PROCEDURE sp_ObtenerTransaccionPorId
    @IdTransaccion INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        t.IdTransaccion,
        t.Descripcion,
        t.Monto,
        t.TipoTransaccion,
        t.IdCategoria,
        c.NombreCategoria,
        t.FechaTransaccion,
        t.FechaRegistro,
        t.Notas
    FROM Transacciones t
    INNER JOIN Categorias c ON t.IdCategoria = c.IdCategoria
    WHERE t.IdTransaccion = @IdTransaccion;
END
GO

CREATE PROCEDURE sp_FiltrarTransaccionesPorFecha
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        t.IdTransaccion,
        t.Descripcion,
        t.Monto,
        t.TipoTransaccion,
        t.IdCategoria,
        c.NombreCategoria,
        t.FechaTransaccion,
        t.Notas
    FROM Transacciones t
    INNER JOIN Categorias c ON t.IdCategoria = c.IdCategoria
    WHERE t.FechaTransaccion BETWEEN @FechaInicio AND @FechaFin
    ORDER BY t.FechaTransaccion DESC;
END
GO

CREATE PROCEDURE sp_ObtenerTotalPorMes
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        MONTH(FechaTransaccion) AS Mes,
        DATENAME(MONTH, FechaTransaccion) AS NombreMes,
        SUM(CASE WHEN TipoTransaccion = 'Gasto' THEN Monto ELSE 0 END) AS TotalGastos,
        SUM(CASE WHEN TipoTransaccion = 'Ingreso' THEN Monto ELSE 0 END) AS TotalIngresos,
        SUM(CASE WHEN TipoTransaccion = 'Ingreso' THEN Monto ELSE -Monto END) AS Balance
    FROM Transacciones
    WHERE YEAR(FechaTransaccion) = @Anio
    GROUP BY MONTH(FechaTransaccion), DATENAME(MONTH, FechaTransaccion)
    ORDER BY MONTH(FechaTransaccion);
END
GO

CREATE PROCEDURE sp_ObtenerGastosPorCategoria
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @FechaInicio IS NULL
        SET @FechaInicio = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);
    IF @FechaFin IS NULL
        SET @FechaFin = GETDATE();
    SELECT 
        c.NombreCategoria,
        COUNT(t.IdTransaccion) AS CantidadTransacciones,
        SUM(t.Monto) AS TotalGastado,
        CAST(SUM(t.Monto) * 100.0 / (SELECT SUM(Monto) FROM Transacciones 
            WHERE TipoTransaccion = 'Gasto' 
            AND FechaTransaccion BETWEEN @FechaInicio AND @FechaFin) AS DECIMAL(5,2)) AS PorcentajeTotal
    FROM Transacciones t
    INNER JOIN Categorias c ON t.IdCategoria = c.IdCategoria
    WHERE t.TipoTransaccion = 'Gasto'
      AND t.FechaTransaccion BETWEEN @FechaInicio AND @FechaFin
    GROUP BY c.NombreCategoria
    ORDER BY TotalGastado DESC;
END
GO

CREATE PROCEDURE sp_ObtenerCategorias
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        IdCategoria,
        NombreCategoria,
        Descripcion
    FROM Categorias
    WHERE Activo = 1
    ORDER BY NombreCategoria;
END
GO

CREATE PROCEDURE sp_ObtenerResumenDashboard
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @FechaInicio IS NULL
        SET @FechaInicio = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);
    IF @FechaFin IS NULL
        SET @FechaFin = EOMONTH(GETDATE());
    SELECT 
        SUM(CASE WHEN TipoTransaccion = 'Gasto' THEN Monto ELSE 0 END) AS TotalGastos,
        SUM(CASE WHEN TipoTransaccion = 'Ingreso' THEN Monto ELSE 0 END) AS TotalIngresos,
        SUM(CASE WHEN TipoTransaccion = 'Ingreso' THEN Monto ELSE -Monto END) AS Balance,
        COUNT(*) AS TotalTransacciones
    FROM Transacciones
    WHERE FechaTransaccion BETWEEN @FechaInicio AND @FechaFin;
END
GO