-- DATABASE SEED
IF Object_id('tempdb..#test_table') IS NOT NULL
	DROP TABLE #test_table
CREATE TABLE #test_table (id INT)
GO

INSERT INTO #test_table
	VALUES (1), (2), (8), (4), (9), (7), (3), (10) 
GO

-- TASK
-- Create temp table for result
IF Object_id('tempdb..#numbers_table') IS NOT NULL
	DROP TABLE #numbers_table
CREATE TABLE #numbers_table (id INT)
GO

-- Procedure to fill table with range
IF Object_id('tempdb..#FillTableWithNumbers') IS NOT NULL
	DROP PROC #FillTableWithNumbers
GO
CREATE PROC #FillTableWithNumbers
    @from INT,
    @to INT
AS
BEGIN
	DECLARE @index int
	SET @index = @from
	WHILE @index<= @to
	BEGIN
		-- Faster fill table with values
		-- Crunch optimisation
		INSERT #numbers_table(id) VALUES (@index), (@index +1 ),(@index +2 ),(@index +3 ),(@index +4 ),(@index +5 ),(@index +6 ),(@index +7 ),(@index +8 ),(@index +9 )
		SET @index = @index + 10
	END
	
	-- Remove unnecessary
	DELETE #numbers_table WHERE id > @to
END
GO

-- Procedure to fill and remove unnecessary
IF Object_id('tempdb..#FindNotExisting') IS NOT NULL
	DROP PROC #FindNotExisting
GO
CREATE PROC #FindNotExisting
    @min INT,
    @max INT
AS
BEGIN	
	EXEC #FillTableWithNumbers @min, @max
	SELECT * FROM #numbers_table WHERE id NOT IN (SELECT * FROM #test_table)
	RETURN
END
GO

-- Tests
EXEC #FindNotExisting -5, 11
EXEC #FindNotExisting -500000, 500000
