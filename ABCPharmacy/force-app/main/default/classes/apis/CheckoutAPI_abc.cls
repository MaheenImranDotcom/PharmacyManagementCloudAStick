@RestResource(urlMapping='/abc/cart/checkout/*')
global with sharing class CheckoutAPI_abc {

    @HttpPost
    global static void checkout() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {

            CheckoutRequestDTO_abc request =
                (CheckoutRequestDTO_abc) JSON.deserialize(
                    req.requestBody.toString(),
                    CheckoutRequestDTO_abc.class
                );

            OrderResponseDTO_abc response =
                CheckoutService_abc.checkout(
                    request.customerCode
                );

            res.statusCode = 200;
            res.addHeader('Content-Type', 'application/json');

            res.responseBody = Blob.valueOf(
                JSON.serialize(
                    new ApiResponse_abc(
                        true,
                        'Order created successfully.',
                        response
                    )
                )
            );

        } catch (Exception ex) {

            res.statusCode = 400;
            res.addHeader('Content-Type', 'application/json');

            res.responseBody = Blob.valueOf(
                JSON.serialize(
                    new ApiResponse_abc(
                        false,
                        ex.getMessage(),
                        null
                    )
                )
            );

        }

    }

}