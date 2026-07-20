global class CartResponseDTO_abc {

    global Id cartId;
    global String cartName;
    global String status;

    global Integer totalItems;
    global Decimal grandTotal;

    global List<CartItemResponseDTO_abc> items;

    global CartResponseDTO_abc(Shopping_Cart_abc__c cart){

        cartId = cart.Id;
        cartName = cart.Name;
        status = cart.Status_abc__c;

        totalItems = 0;
        grandTotal = 0;
        items = new List<CartItemResponseDTO_abc>();

    }

}