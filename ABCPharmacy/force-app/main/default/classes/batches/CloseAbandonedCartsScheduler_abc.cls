global with sharing class CloseAbandonedCartsScheduler_abc implements Schedulable {

    global void execute(SchedulableContext sc) {

        Database.executeBatch(
            new CloseAbandonedCartsBatch_abc(),
            200
        );

    }

}