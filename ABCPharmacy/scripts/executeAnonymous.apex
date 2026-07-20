String cronExp = '0 0 2 * * ?';

System.schedule(
    'Close Abandoned Shopping Carts',
    cronExp,
    new CloseAbandonedCartsScheduler_abc()
);