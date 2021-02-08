-- DATABASE SEED
declare @customers table (id int, name varchar(20))
declare @orders table (id int, summa numeric(18, 2), customerId int)
declare @payments table (customerId int, payment numeric(18, 2))
insert @customers (id, name)
values (1, 'Первый'),
    (2, 'Второй'),
    (3, 'Третий'),
    (4, 'Четвертый')
insert @orders (id, summa, customerId)
values (1, 10, 1),
    (2, 15, 1),
    (3, 20, 1),
    (4, 25, 1),
    (5, 12, 2),
    (6, 14, 2),
    (7, 200, 2),
    (8, 100, 3),
    (9, 200, 3)
insert @payments (customerId, payment)
values (1, 30),
    (2, 500),
    (3, 100),
    (4, 20)

-- TASK
-- Declare table for result
DECLARE @paid_orders TABLE (id INT, summa NUMERIC(18, 2), customerId INT)

-- Iterate all customers
DECLARE @customerId INT
SET @customerId = 0
WHILE EXISTS(SELECT * FROM @customers WHERE id > @customerId)
BEGIN
	-- Incrementing
	SET @customerId =(SELECT TOP(1) id FROM @customers WHERE id > @customerId)

	-- Calculate total payment sum
	DECLARE @total_payment numeric(18, 2)
	SELECT @total_payment= SUM(payment) FROM @payments WHERE customerId=@customerId

	-- Iterate all orders and check if they can be paid
	DECLARE @orderId INT
	SET @orderId = 0
	WHILE EXISTS(SELECT * FROM @orders WHERE id > @orderId AND customerId=@customerId)
	BEGIN
		-- Incrementing
		SET @orderId =(SELECT TOP(1) id FROM @orders WHERE id > @orderId AND customerId=@customerId)
		DECLARE @order_summa numeric(18, 2)
		SELECT @order_summa = summa FROM @orders WHERE id = @orderId
				
		-- Update left money
		SET @total_payment = @total_payment - @order_summa;

		-- If there momey - will add order to paid orders table
		IF @total_payment >=0 
			INSERT @paid_orders
			SELECT * FROM @orders WHERE id = @orderId 
	END

END 

SELECT * FROM @paid_orders