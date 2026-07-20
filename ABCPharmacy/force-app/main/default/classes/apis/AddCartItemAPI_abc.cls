@RestResource(urlMapping='/abc/cart/items')
global with sharing class AddCartItemAPI_abc {

    @HttpPost
    global static void addProductToCart() {

        try {

            AddCartItemRequestDTO_abc request =
                (AddCartItemRequestDTO_abc)
                JSON.deserialize(
                    RestContext.request.requestBody.toString(),
                    AddCartItemRequestDTO_abc.class
                );

                CartResponseDTO_abc response =
                CartService_abc.addProductToCart(
                    request.customerCode,
                    request.productName,
                    request.quantity
                );

            ApiResponseUtil_abc.success(
                201,
                'Product added to cart successfully.',
                response
            );

        }
        catch(Exception ex) {

            ApiResponseUtil_abc.error(
                400,
                ex.getMessage()
            );

        }

    }

}