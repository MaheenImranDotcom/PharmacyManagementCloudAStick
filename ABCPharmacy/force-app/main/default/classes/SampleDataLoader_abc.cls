public with sharing class SampleDataLoader_abc {

    public static void loadData() {
        deleteExistingData();

        List<Customer_abc__c> customers = createCustomers();

        List<Product_abc__c> products = createProducts();

        List<Order_abc__c> orders = createOrders(customers);

        createOrderItems(orders, products);

        System.debug('Sample data created successfully.');
    }

    private static void deleteExistingData() {

        delete [SELECT Id FROM Order_Item_abc__c];
    
        delete [SELECT Id FROM Order_abc__c];
    
        delete [SELECT Id FROM Product_abc__c];
    
        delete [SELECT Id FROM Customer_abc__c];
    }

    private static List<Customer_abc__c> createCustomers() {

        List<Customer_abc__c> customers = new List<Customer_abc__c>();

        customers.add(new Customer_abc__c(
            Name = 'John Smith',
            Customer_Code_abc__c = 'CUST001',
            Email_abc__c = 'john@example.com',
            Phone_abc__c = '1111111111',
            Address_abc__c = 'New York'
        ));
    
        customers.add(new Customer_abc__c(
            Name = 'Sarah Johnson',
            Customer_Code_abc__c = 'CUST002',
            Email_abc__c = 'sarah@example.com',
            Phone_abc__c = '2222222222',
            Address_abc__c = 'California'
        ));
    
        customers.add(new Customer_abc__c(
            Name = 'Michael Brown',
            Customer_Code_abc__c = 'CUST003',
            Email_abc__c = 'michael@example.com',
            Phone_abc__c = '3333333333',
            Address_abc__c = 'Texas'
        ));
    
        customers.add(new Customer_abc__c(
            Name = 'Emily Davis',
            Customer_Code_abc__c = 'CUST004',
            Email_abc__c = 'emily@example.com',
            Phone_abc__c = '4444444444',
            Address_abc__c = 'Florida'
        ));
    
        customers.add(new Customer_abc__c(
            Name = 'David Wilson',
            Customer_Code_abc__c = 'CUST005',
            Email_abc__c = 'david@example.com',
            Phone_abc__c = '5555555555',
            Address_abc__c = 'Chicago'
        ));

        insert customers;

        return customers;
    }

    private static List<Product_abc__c> createProducts() {

        List<Product_abc__c> products = new List<Product_abc__c>();

        products.add(new Product_abc__c(
            Name = 'Paracetamol',
            Unit_Price_abc__c = 10,
            Stock_Quantity_abc__c = 200,
            Active_abc__c = true
        ));

        products.add(new Product_abc__c(
            Name = 'Ibuprofen',
            Unit_Price_abc__c = 15,
            Stock_Quantity_abc__c = 150,
            Active_abc__c = true
        ));

        products.add(new Product_abc__c(
            Name = 'Vitamin C',
            Unit_Price_abc__c = 8,
            Stock_Quantity_abc__c = 300,
            Active_abc__c = true
        ));

        products.add(new Product_abc__c(
            Name = 'Cough Syrup',
            Unit_Price_abc__c = 25,
            Stock_Quantity_abc__c = 100,
            Active_abc__c = true
        ));

        products.add(new Product_abc__c(
            Name = 'Bandage',
            Unit_Price_abc__c = 5,
            Stock_Quantity_abc__c = 500,
            Active_abc__c = true
        ));

        insert products;

        return products;
    }

    private static List<Order_abc__c> createOrders(List<Customer_abc__c> customers) {

        List<Order_abc__c> orders = new List<Order_abc__c>();

        orders.add(new Order_abc__c(
            Customer_abc__c = customers[0].Id,
            Status_abc__c = 'Pending',
            Order_Date_abc__c = Date.today(),
            Effective_Date_abc__c = Date.today()
        ));

        orders.add(new Order_abc__c(
            Customer_abc__c = customers[1].Id,
            Status_abc__c = 'In Delivery',
            Order_Date_abc__c = Date.today().addDays(-1),
            Effective_Date_abc__c = Date.today().addDays(-1)
        ));

        orders.add(new Order_abc__c(
            Customer_abc__c = customers[2].Id,
            Status_abc__c = 'Delivered',
            Order_Date_abc__c = Date.today().addDays(-5),
            Effective_Date_abc__c = Date.today().addDays(-5)
        ));

        // This record is older than one year.
        // We'll use it later in the Batch Apex assignment.
        orders.add(new Order_abc__c(
            Customer_abc__c = customers[3].Id,
            Status_abc__c = 'Delivered',
            Order_Date_abc__c = Date.today().addYears(-2),
            Effective_Date_abc__c = Date.today().addYears(-2)
        ));

        orders.add(new Order_abc__c(
            Customer_abc__c = customers[4].Id,
            Status_abc__c = 'Pending',
            Order_Date_abc__c = Date.today(),
            Effective_Date_abc__c = Date.today()
        ));

        insert orders;

        return orders;
    }

    private static void createOrderItems(
        List<Order_abc__c> orders,
        List<Product_abc__c> products
    ) {
        List<Order_Item_abc__c> orderItems = new List<Order_Item_abc__c>();

        orderItems.add(new Order_Item_abc__c(
            Order_abc__c = orders[0].Id,
            Product_abc__c = products[0].Id,
            Quantity_abc__c = 2,
            Unit_Price_abc__c = 10
        ));

        orderItems.add(new Order_Item_abc__c(
            Order_abc__c = orders[0].Id,
            Product_abc__c = products[2].Id,
            Quantity_abc__c = 1,
            Unit_Price_abc__c = 8
        ));

        orderItems.add(new Order_Item_abc__c(
            Order_abc__c = orders[1].Id,
            Product_abc__c = products[1].Id,
            Quantity_abc__c = 3,
            Unit_Price_abc__c = 15
        ));

        orderItems.add(new Order_Item_abc__c(
            Order_abc__c = orders[1].Id,
            Product_abc__c = products[3].Id,
            Quantity_abc__c = 1,
            Unit_Price_abc__c = 25
        ));

        orderItems.add(new Order_Item_abc__c(
            Order_abc__c = orders[2].Id,
            Product_abc__c = products[4].Id,
            Quantity_abc__c = 5,
            Unit_Price_abc__c = 5
        ));

        orderItems.add(new Order_Item_abc__c(
            Order_abc__c = orders[2].Id,
            Product_abc__c = products[0].Id,
            Quantity_abc__c = 2,
            Unit_Price_abc__c = 10
        ));

        orderItems.add(new Order_Item_abc__c(
            Order_abc__c = orders[3].Id,
            Product_abc__c = products[2].Id,
            Quantity_abc__c = 4,
            Unit_Price_abc__c = 8
        ));

        orderItems.add(new Order_Item_abc__c(
            Order_abc__c = orders[3].Id,
            Product_abc__c = products[1].Id,
            Quantity_abc__c = 1,
            Unit_Price_abc__c = 15
        ));

        orderItems.add(new Order_Item_abc__c(
            Order_abc__c = orders[4].Id,
            Product_abc__c = products[3].Id,
            Quantity_abc__c = 2,
            Unit_Price_abc__c = 25
        ));

        orderItems.add(new Order_Item_abc__c(
            Order_abc__c = orders[4].Id,
            Product_abc__c = products[4].Id,
            Quantity_abc__c = 6,
            Unit_Price_abc__c = 5
        ));

        insert orderItems;
    }
}