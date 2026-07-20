global class ProductDTO_abc {

    global Id id;
    global String name;
    global Decimal unitPrice;
    global Integer stockQuantity;

    global ProductDTO_abc(Product_abc__c product) {
        this.id = product.Id;
        this.name = product.Name;
        this.unitPrice = product.Unit_Price_abc__c;
        this.stockQuantity = Integer.valueOf(product.Stock_Quantity_abc__c);
    }

}