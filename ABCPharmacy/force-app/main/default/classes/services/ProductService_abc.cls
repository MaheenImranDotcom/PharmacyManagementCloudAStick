public with sharing class ProductService_abc {
    public static List<ProductDTO_abc> getProducts() {

        List<ProductDTO_abc> response = new List<ProductDTO_abc>();

        List<Product_abc__c> products = [
            SELECT Id,
                   Name,
                   Unit_Price_abc__c,
                   Stock_Quantity_abc__c,
                   Active_abc__c
            FROM Product_abc__c
            WHERE Active_abc__c = true
            ORDER BY Name
        ];

        for(Product_abc__c product : products) {
            response.add(new ProductDTO_abc(product));
        }

        return response;
    }
}
