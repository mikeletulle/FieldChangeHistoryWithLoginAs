global class transXPolLoginAsChecker implements TxnSecurity.EventCondition, TxnSecurity.AsyncCondition {

    // Evaluate method triggered by the LoginAs event
    public boolean evaluate(SObject event) {
        System.debug('In transXPolLoginAsChecker');

        if (event instanceof LoginAsEvent) {
            System.debug('LoginAsEvent detected');
            LoginAsEvent liaEvent = (LoginAsEvent) event;
            System.debug('Login as detected for ' + liaEvent.DelegatedUsername + ' for ' + liaEvent.UserId);

            // Retrieve admin user details
            User adminUser = [SELECT Id FROM User WHERE Username = :liaEvent.DelegatedUsername LIMIT 1];

            // Call the @future method with raw field values
            LoginAsEventFutureHandler.insertLoginEvent(adminUser.Id, liaEvent.UserId, liaEvent.LoginKey, liaEvent.LoginHistoryId, liaEvent.EventIdentifier );
            System.debug('Future method called for Login_As_Event__c insert');
            return true;
        }

        System.debug('Not a LoginAsEvent');
        return false;
    }

    // Mandatory method from the AsyncCondition interface
    public boolean handlesAsync() {
        System.debug('handlesAsync method returning true');
        return true; // Indicates this policy supports asynchronous operations
    }
}
