global with sharing class CloseAbandonedCartsBatch_abc
implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator([
            SELECT Id,
                   Name,
                   Status_abc__c,
                   CreatedDate
            FROM Shopping_Cart_abc__c
            WHERE Status_abc__c = 'Active'
            AND CreatedDate <= :System.now().addDays(-7)
        ]);

    }

    global void execute(
        Database.BatchableContext bc,
        List<Shopping_Cart_abc__c> scope
    ) {

        for (Shopping_Cart_abc__c cart : scope) {

            cart.Status_abc__c = 'Abandoned';

        }

        update scope;

    }

    global void finish(Database.BatchableContext bc) {

        System.debug('CloseAbandonedCartsBatch completed.');

    }

}