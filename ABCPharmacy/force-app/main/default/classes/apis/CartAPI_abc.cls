@RestResource(urlMapping='/abc/cart')
global with sharing class CartAPI_abc {

    @HttpPost
    global static void createCart() {

        RestRequest req = RestContext.request;

        try {

            CreateCartRequestDTO_abc request =
                (CreateCartRequestDTO_abc) JSON.deserialize(
                    req.requestBody.toString(),
                    CreateCartRequestDTO_abc.class
                );

            CartResponseDTO_abc cart =
                CartService_abc.createCart(request.customerCode);

            ApiResponse_abc response =
                new ApiResponse_abc(
                    true,
                    'Shopping cart created successfully.',
                    cart
                );

            RestContext.response.statusCode = 201;
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody =
                Blob.valueOf(JSON.serialize(response));

        } catch (Exception ex) {

            ApiResponse_abc response =
                new ApiResponse_abc(
                    false,
                    ex.getMessage(),
                    null
                );

            RestContext.response.statusCode = 400;
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody =
                Blob.valueOf(JSON.serialize(response));
        }
    }
}