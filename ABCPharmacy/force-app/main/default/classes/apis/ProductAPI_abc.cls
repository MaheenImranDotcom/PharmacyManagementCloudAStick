@RestResource(urlMapping='/abc/products/*')
global with sharing class ProductAPI_abc {

    @HttpGet
    global static void getProducts() {

        try {

            ApiResponseUtil_abc.success(
                200,
                'Products retrieved successfully.',
                ProductService_abc.getProducts()
            );

        }
        catch(Exception ex) {

            ApiResponseUtil_abc.error(
                500,
                ex.getMessage()
            );

        }

    }

}