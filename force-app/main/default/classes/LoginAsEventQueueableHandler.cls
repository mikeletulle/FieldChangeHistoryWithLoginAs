public class LoginAsEventQueueableHandler implements Queueable {
    private String adminUserId;
    private String userId;
    private String loginKey;
    private String loginHistoryId;
    private String eventIdentifier;

    // Constructor to pass field values
    public LoginAsEventQueueableHandler(String adminUserId, String userId, String loginKey, 
                                        String loginHistoryId, String eventIdentifier) {
        System.debug('In Queueable constructor');
        this.adminUserId = adminUserId;
        this.userId = userId;
        this.loginKey = loginKey;
        this.loginHistoryId = loginHistoryId;
        this.eventIdentifier = eventIdentifier;
    }

    // Execute method for asynchronous processing
    public void execute(QueueableContext context) {
        System.debug('In execute method of LoginAsEventQueueableHandler');
        try {
            Login_As_Event__c liae = new Login_As_Event__c(
                Admin_User__c = adminUserId,
                User__c = userId,
                Login_Key__c = loginKey,
                Login_History_Id__c = loginHistoryId,
                Event_Identifier__c = eventIdentifier
            );
            System.debug('Attempting to insert Login_As_Event__c');
            insert liae;
            System.debug('Login_As_Event__c record inserted successfully.');
        } catch (DmlException e) {
            System.debug('DML Exception occurred: ' + e.getMessage() + ' - Stack Trace: ' + e.getStackTraceString());
        }
    }
}
