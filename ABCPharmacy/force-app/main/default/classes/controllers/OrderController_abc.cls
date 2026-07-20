public with sharing class OrderController_abc {

    public List<OrderWrapper> orders { get; set; }

    public OrderController_abc() {
        loadOrders();
    }

    public class OrderWrapper {

        public Order_abc__c order { get; set; }
        public List<Order_Item_abc__c> orderItems { get; set; }
        public Boolean expanded { get; set; }
        public String icon { get; set; }
    
        public OrderWrapper(Order_abc__c order) {
    
            this.order = order;
            this.orderItems = order.Order_Item__r;
            this.expanded = false;
    
            if (order.Status_abc__c == 'Delivered') {
                icon = '✅';
            } else if (order.Status_abc__c == 'In Delivery') {
                icon = '🚚';
            } else if (order.CreatedDate.date() == Date.today()) {
                icon = '⏳';
            } else {
                icon = '⌛';
            }
        }
    }

    private void loadOrders() {
        orders = new List<OrderWrapper>();

        for (Order_abc__c ord : [

            SELECT
                Id,
                Name,
                Status_abc__c,
                Effective_Date_abc__c,
                CreatedDate,
                Customer_abc__r.Name,

                (
                    SELECT
                        Id,
                        Quantity_abc__c,
                        Unit_Price_abc__c,
                        Product_abc__r.Name
                    FROM Order_Item__r
                )

            FROM Order_abc__c

            ORDER BY CreatedDate DESC

        ]){

            orders.add(
                new OrderWrapper(ord)
            );

        }
    }

    public PageReference toggleOrder() {

        String orderId =
            ApexPages.currentPage().getParameters().get('id');
    
        for (OrderWrapper wrapper : orders) {
    
            if (wrapper.order.Id == orderId) {
    
                wrapper.expanded = !wrapper.expanded;
    
                break;
    
            }
    
        }
    
        return null;
    
    }
}