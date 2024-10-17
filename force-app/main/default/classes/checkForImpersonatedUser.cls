public class checkForImpersonatedUser {
    
    // Bulkified method to get Admin IDs for multiple users
    public static Map<Id, String> getAdminIds(Set<Id> userIds) {
        Map<Id, String> adminIdMap = new Map<Id, String>();

        // Query all relevant AuthSessions in one call
        Map<Id, AuthSession> sessionMap = new Map<Id, AuthSession>(
            [SELECT Id, LoginHistoryId, UsersId
             FROM AuthSession
             WHERE UsersId IN :userIds AND IsCurrent = true]
        );

        // Collect all LoginHistoryIds from the AuthSessions for the next query
        Set<String> loginHistoryIds = new Set<String>();
        for (AuthSession session : sessionMap.values()) {
            loginHistoryIds.add(session.LoginHistoryId);
        }

        // Query all relevant Login_As_Event__c records in one call
        List<Login_As_Event__c> loginEvents = [
            SELECT Id, Admin_User__c, User__c, Login_History_Id__c
            FROM Login_As_Event__c
            WHERE Login_History_Id__c IN :loginHistoryIds
        ];

        // Map UserId to AdminId for quick lookups
        for (Login_As_Event__c event : loginEvents) {
            adminIdMap.put(event.User__c, event.Admin_User__c);
        }

        return adminIdMap;
    }
}
