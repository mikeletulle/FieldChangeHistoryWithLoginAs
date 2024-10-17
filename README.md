# FieldChangeHistoryWithLoginAs
 
This customization creates custom Field Change records associated to records whose field values are changed.


Unlike the OOTB Field History Tracking or the add on Field Audit Trail in Shield, it will indicate when a field value change was done by an admin logged in as another user.


It requires the Event Monitoring add-on as it relies on a transaction security policy to detect the LoginAs event and creates a custom Login As Event record associated to both the user doing the impersonation and the impersonated user.


There is then a trigger for the Opportunity object that lets one list api names of whichever fields one wants to track. If any of those fields are changed, it creates an associated Field Change record that shows the field changed with its old and new values along with the logged in user making the change and if applicable the admin user who logged in as them.


Logic wise, the trigger searches for Login As records that have a matching Login History Id to the current user's session Login History Id.


You would need a similar trigger on any other objects with fields you want to track.


To implement: 


Make sure Event Monitoring is enabled 
Create the 2 included custom objects: Field Change and Login As Event 
Add the Field Change related list to your opportunity page and the Login As Event related list to the User Profile page 
Create an Apex-based transaction security policy on LoginAs events that runs the class transXPolLoginAsChecker 
Add and enable the OpportunityFieldHistory trigger


To test: 


As admin login as another user that has write access to an opportunity Change one of the tracked fields on the opportunity as that user. You should see a Field Change record created that shows the field change info and the related users
