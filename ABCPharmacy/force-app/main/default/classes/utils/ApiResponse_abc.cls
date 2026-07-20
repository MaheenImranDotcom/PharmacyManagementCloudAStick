global class ApiResponse_abc {

    global Boolean success;
    global String message;
    global Object data;

    global ApiResponse_abc(Boolean success, String message, Object data) {
        this.success = success;
        this.message = message;
        this.data = data;
    }
}