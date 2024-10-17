trigger OpportunityFieldHistoryTrigger on Opportunity (after update) {
    // List of Opportunity fields to monitor for changes
    List<String> fieldsToCheck = new List<String>{ 'StageName', 'Amount', 'CloseDate', 'Description' };

    List<Field_Change__c> changes = new List<Field_Change__c>();
    Set<Id> userIds = new Set<Id>();

    // Collect the logged-in user ID (current session) for impersonation checks
    userIds.add(UserInfo.getUserId());

    // Iterate through each Opportunity to detect changes
    for (Opportunity opp : Trigger.new) {
        Opportunity oldOpp = Trigger.oldMap.get(opp.Id);

        // Check each field from the dynamic field list
        for (String fieldName : fieldsToCheck) {
            Object oldValue = oldOpp.get(fieldName);
            Object newValue = opp.get(fieldName);

            // If the field value changed, create a Field_Change__c record
            if (oldValue != newValue) {
                Field_Change__c change = new Field_Change__c(
                    Opportunity__c = opp.Id,
                    Field_Name__c = fieldName,
                    Previous_Value__c = String.valueOf(oldValue),
                    New_Value__c = String.valueOf(newValue),
                    Actual_User__c = null,  // Will be set after impersonation check
                    Logged_In_User__c = UserInfo.getUserId()
                );
                changes.add(change);
            }
        }
    }

    // Perform impersonation checks in bulk
    Map<Id, String> impersonatedAdmins = checkForImpersonatedUser.getAdminIds(userIds);

    // Set the Actual_User__c field in collected changes if impersonation is detected
    for (Field_Change__c change : changes) {
        String adminId = impersonatedAdmins.get(UserInfo.getUserId());
        if (adminId != null) {
            change.Actual_User__c = adminId;
        }
    }

    // Insert the changes if any are collected
    if (!changes.isEmpty()) {
        insert changes;
    }
}
