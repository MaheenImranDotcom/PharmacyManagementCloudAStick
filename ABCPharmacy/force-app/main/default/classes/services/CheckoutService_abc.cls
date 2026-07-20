public with sharing class CheckoutService_abc {

    public static OrderResponseDTO_abc checkout(String customerCode) {
        Savepoint sp = Database.setSavepoint();

        try {
            // 1. Get customer
            Customer_abc__c customer = getCustomerByCode(customerCode);

            // 2. Get active cart
            Shopping_Cart_abc__c cart = getActiveCart(customer);

            // 3. Get cart items
            List<Shopping_Cart_Item_abc__c> cartItems = getCartItems(cart);

            // 4. Validate cart
            validateCart(cartItems);

            // 5. Validate stock
            validateStock(cartItems);

            // 6. Create Order
            Order_abc__c order = createOrder(customer);

            // 7. Create Order Items
            createOrderItems(order, cartItems);

            // 8. Update Product Stock
            updateProductStock(cartItems);

            // 9. Mark Cart Checked Out
            markCartCheckedOut(cart);

            // 10. Return Response
            return buildOrderResponse(order, cartItems);
        } catch (Exception ex) {
            Database.rollback(sp);
            throw ex;
        }
    }

    //==========================================================================
    // Helper Methods
    //==========================================================================

    private static Customer_abc__c getCustomerByCode(String customerCode) {

        List<Customer_abc__c> customers = [
            SELECT Id,
                   Name,
                   Customer_Code_abc__c
            FROM Customer_abc__c
            WHERE Customer_Code_abc__c = :customerCode
            LIMIT 1
        ];
    
        if (customers.isEmpty()) {
            throw new IllegalArgumentException('Customer not found.');
        }
    
        return customers[0];
    }

    private static Shopping_Cart_abc__c getActiveCart(Customer_abc__c customer) {

        List<Shopping_Cart_abc__c> carts = [
            SELECT Id,
                   Name,
                   Status_abc__c
            FROM Shopping_Cart_abc__c
            WHERE Customer_abc__c = :customer.Id
            AND Status_abc__c = 'Active'
            LIMIT 1
        ];
    
        if (carts.isEmpty()) {
            throw new IllegalArgumentException(
                'No active shopping cart found.'
            );
        }
    
        return carts[0];
    }

    private static List<Shopping_Cart_Item_abc__c> getCartItems(
        Shopping_Cart_abc__c cart
    ) {

        return [

            SELECT Id,
                Quantity_abc__c,
                Unit_Price_abc__c,
                Product_abc__c,
                Product_abc__r.Name,
                Product_abc__r.Stock_Quantity_abc__c
            FROM Shopping_Cart_Item_abc__c
            WHERE Shopping_Cart_abc__c = :cart.Id

        ];

    }

    private static void validateCart(List<Shopping_Cart_Item_abc__c> cartItems) {
        if (cartItems.isEmpty()) {

            throw new IllegalArgumentException(
                'Shopping cart is empty.'
            );

        }
    }

    private static void validateStock(
        List<Shopping_Cart_Item_abc__c> cartItems
    ) {

        for (Shopping_Cart_Item_abc__c item : cartItems) {

            if (item.Product_abc__r.Stock_Quantity_abc__c < item.Quantity_abc__c) {

                throw new IllegalArgumentException(
                    item.Product_abc__r.Name +
                    ' does not have sufficient stock.'
                );

            }

        }

    }

    private static Order_abc__c createOrder(
        Customer_abc__c customer
    ) {

        Order_abc__c order = new Order_abc__c(

            Customer_abc__c = customer.Id,
            Status_abc__c = 'Pending',
            Order_Date_abc__c = Date.today(),
            Effective_Date_abc__c = Date.today()

        );

        insert order;

        order = [
            SELECT Id, Name, Status_abc__c
            FROM Order_abc__c
            WHERE Id = :order.Id
        ];

        return order;
    }

    private static void createOrderItems(
        Order_abc__c order,
        List<Shopping_Cart_Item_abc__c> cartItems
    ) {

        List<Order_Item_abc__c> orderItems =
            new List<Order_Item_abc__c>();

        for (Shopping_Cart_Item_abc__c item : cartItems) {

            orderItems.add(

                new Order_Item_abc__c(

                    Order_abc__c = order.Id,
                    Product_abc__c = item.Product_abc__c,
                    Quantity_abc__c = item.Quantity_abc__c,
                    Unit_Price_abc__c = item.Unit_Price_abc__c

                )

            );

        }

        insert orderItems;

    }

    private static void updateProductStock(
        List<Shopping_Cart_Item_abc__c> cartItems
    ) {

        List<Product_abc__c> productsToUpdate =
            new List<Product_abc__c>();

        for (Shopping_Cart_Item_abc__c item : cartItems) {

            Product_abc__c product = new Product_abc__c(

                Id = item.Product_abc__c,
                Stock_Quantity_abc__c =
                    item.Product_abc__r.Stock_Quantity_abc__c -
                    item.Quantity_abc__c

            );

            productsToUpdate.add(product);

        }

        update productsToUpdate;

    }

    private static void markCartCheckedOut(
        Shopping_Cart_abc__c cart
    ) {

        cart.Status_abc__c = 'Checked Out';

        update cart;

    }

    private static OrderResponseDTO_abc buildOrderResponse(
        Order_abc__c order,
        List<Shopping_Cart_Item_abc__c> cartItems
    ) {

        OrderResponseDTO_abc response =
            new OrderResponseDTO_abc();

        response.orderId = order.Id;
        response.orderNumber = order.Name;
        response.status = order.Status_abc__c;

        response.totalItems = 0;
        response.totalAmount = 0;

        for (Shopping_Cart_Item_abc__c item : cartItems) {

            response.totalItems += Integer.valueOf(item.Quantity_abc__c);

            response.totalAmount +=
                item.Quantity_abc__c *
                item.Unit_Price_abc__c;

        }

        return response;

    }
}