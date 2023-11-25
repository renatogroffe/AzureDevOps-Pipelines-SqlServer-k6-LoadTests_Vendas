CREATE SCHEMA [demo]
GO

CREATE TABLE demo.Produtos (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
    Nome VARCHAR(50),
    Vl_Custo NUMERIC(18, 2),
    Vl_Venda numeric(18, 2)
)
GO

CREATE TABLE demo.Clientes (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
    Nome VARCHAR(50),
    Dt_Nascimento DATE
)
GO

CREATE TABLE demo.Vendas (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
    Dt_Venda DATETIME,
    Id_Cliente INT NOT NULL,
    Id_Produto INT NOT NULL,
    Quantidade INT NOT NULL,
    Vl_Unitario NUMERIC(18, 2) NOT NULL,
    [Status] CHAR(1) NOT NULL
)
GO


SET STATISTICS TIME, IO ON


-- Query 1
SELECT *
FROM demo.Vendas
WHERE Dt_Venda >= '2022-01-01'
AND [Status] = 'D'
AND Quantidade = 2


-- Corrigindo o problema
IF (EXISTS(SELECT TOP(1) NULL FROM sys.indexes WHERE [name] = 'SK01_Vendas'))
    DROP INDEX SK01_Vendas ON demo.Vendas
GO

CREATE INDEX SK01_Vendas ON demo.Vendas(Dt_Venda, [Status], Quantidade) WITH(DATA_COMPRESSION=PAGE)
GO