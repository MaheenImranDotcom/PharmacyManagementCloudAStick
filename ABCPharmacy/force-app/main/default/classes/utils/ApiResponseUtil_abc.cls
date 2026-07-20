public class ApiResponseUtil_abc {

    public static void success(Integer statusCode,
                               String message,
                               Object data) {

        ApiResponse_abc response =
            new ApiResponse_abc(
                true,
                message,
                data
            );

        RestContext.response.statusCode = statusCode;
        RestContext.response.addHeader(
            'Content-Type',
            'application/json'
        );

        RestContext.response.responseBody =
            Blob.valueOf(
                JSON.serialize(response)
            );
    }

    public static void error(Integer statusCode,
                             String message) {

        ApiResponse_abc response =
            new ApiResponse_abc(
                false,
                message,
                null
            );

        RestContext.response.statusCode = statusCode;
        RestContext.response.addHeader(
            'Content-Type',
            'application/json'
        );

        RestContext.response.responseBody =
            Blob.valueOf(
                JSON.serialize(response)
            );
    }

}