public with sharing class CartService_abc {

    // Create Shopping Cart
    public static CartResponseDTO_abc createCart(String customerCode) {

        Customer_abc__c customer = getCustomerByCode(customerCode);

        Shopping_Cart_abc__c cart = getOrCreateActiveCart(customer);

        return buildCartResponse(cart);
    }

    // Add Product To Cart
    public static CartResponseDTO_abc addProductToCart(
        String customerCode,
        String productName,
        Integer quantity
    ) {

        // Request Validation
        if (String.isBlank(customerCode)) {
            throw new IllegalArgumentException('Customer Code is required.');
        }

        if (String.isBlank(productName)) {
            throw new IllegalArgumentException('Product Name is required.');
        }

        if (quantity == null || quantity <= 0) {
            throw new IllegalArgumentException('Quantity must be greater than zero.');
        }

        // Find Customer
        Customer_abc__c customer = getCustomerByCode(customerCode);

        // Get or Create Active Cart
        Shopping_Cart_abc__c cart = getOrCreateActiveCart(customer);

        // Find Product
        List<Product_abc__c> products = [
            SELECT Id,
                   Name,
                   Unit_Price_abc__c,
                   Stock_Quantity_abc__c,
                   Active_abc__c
            FROM Product_abc__c
            WHERE Name = :productName
            LIMIT 1
        ];

        if (products.isEmpty()) {
            throw new IllegalArgumentException('Product not found.');
        }

        Product_abc__c product = products[0];

        if (!product.Active_abc__c) {
            throw new IllegalArgumentException('Product is inactive.');
        }

        // Validate Requested Quantity
        if (product.Stock_Quantity_abc__c < quantity) {
            throw new IllegalArgumentException('Insufficient stock available.');
        }

        // Check Existing Cart Item
        List<Shopping_Cart_Item_abc__c> existingItems = [
            SELECT Id,
                   Quantity_abc__c,
                   Unit_Price_abc__c,
                   Product_abc__c
            FROM Shopping_Cart_Item_abc__c
            WHERE Shopping_Cart_abc__c = :cart.Id
            AND Product_abc__c = :product.Id
            LIMIT 1
        ];

        Shopping_Cart_Item_abc__c cartItem;

        if (!existingItems.isEmpty()) {

            cartItem = existingItems[0];

            Decimal newQuantity = cartItem.Quantity_abc__c + quantity;

            if (newQuantity > product.Stock_Quantity_abc__c) {
                throw new IllegalArgumentException(
                    'Requested quantity exceeds available stock.'
                );
            }

            cartItem.Quantity_abc__c = newQuantity;

            update cartItem;

        } else {

            cartItem = new Shopping_Cart_Item_abc__c(
                Shopping_Cart_abc__c = cart.Id,
                Product_abc__c = product.Id,
                Quantity_abc__c = quantity,
                Unit_Price_abc__c = product.Unit_Price_abc__c
            );

            insert cartItem;
        }

        return buildCartResponse(cart);
    }

    // ----------------------------
    // Private Helper Methods
    // ----------------------------

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

    private static Shopping_Cart_abc__c getOrCreateActiveCart(Customer_abc__c customer) {

        List<Shopping_Cart_abc__c> carts = [
            SELECT Id,
                   Name,
                   Status_abc__c
            FROM Shopping_Cart_abc__c
            WHERE Customer_abc__c = :customer.Id
            AND Status_abc__c = 'Active'
            LIMIT 1
        ];

        if (!carts.isEmpty()) {
            return carts[0];
        }

        return createCartRecord(customer);
    }

    private static Shopping_Cart_abc__c createCartRecord(Customer_abc__c customer) {

        Shopping_Cart_abc__c cart = new Shopping_Cart_abc__c(
            Customer_abc__c = customer.Id,
            Status_abc__c = 'Active'
        );

        insert cart;

        return cart;
    }

    private static CartResponseDTO_abc buildCartResponse(
        Shopping_Cart_abc__c cart
    ) {

        CartResponseDTO_abc response = new CartResponseDTO_abc(cart);

        List<Shopping_Cart_Item_abc__c> cartItems = [
            SELECT Id,
                Quantity_abc__c,
                Unit_Price_abc__c,
                Product_abc__c,
                Product_abc__r.Name
            FROM Shopping_Cart_Item_abc__c
            WHERE Shopping_Cart_abc__c = :cart.Id
        ];

        for (Shopping_Cart_Item_abc__c item : cartItems) {

            Product_abc__c product = new Product_abc__c(
                Id = item.Product_abc__c,
                Name = item.Product_abc__r.Name
            );

            response.items.add(
                new CartItemResponseDTO_abc(item, product)
            );

            response.totalItems += Integer.valueOf(item.Quantity_abc__c);

            response.grandTotal +=
                item.Quantity_abc__c * item.Unit_Price_abc__c;
        }

        return response;
    }
}