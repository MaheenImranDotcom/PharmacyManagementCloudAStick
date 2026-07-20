global class CartItemResponseDTO_abc {

    global Id cartItemId;
    global String productName;
    global Integer quantity;
    global Decimal unitPrice;
    global Decimal totalPrice;

    global CartItemResponseDTO_abc(
        Shopping_Cart_Item_abc__c item,
        Product_abc__c product
    ){

        cartItemId = item.Id;
        productName = product.Name;
        quantity = Integer.valueOf(item.Quantity_abc__c);
        unitPrice = item.Unit_Price_abc__c;
        totalPrice = item.Quantity_abc__c * item.Unit_Price_abc__c;

    }

}