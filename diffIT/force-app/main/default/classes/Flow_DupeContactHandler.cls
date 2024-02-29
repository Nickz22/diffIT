public class Flow_DupeContactHandler {
	@InvocableMethod(label='Find and Merge Duplicate Contacts')
    public static void findAndMergeDupes(List<Contact> contactsToProcess){
        Set<String> contactEmails = new Set<String>();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> originalContactIds = new Set<Id>();
        for(Contact con : contactsToProcess){
            contactEmails.add(con.Email);
            accountIds.add(con.AccountId);
            originalContactIds.add(con.Id);
        }
        //we need to dynamically query ALL fields on the contact so we can see if they are blank on the master and not blank on the dupe
        Map<String, sObjectField> contactFields = sobjectType.Contact.fields.getMap();
        String dupeQuery = 'SELECT ' + String.join(contactFields.keySet(),',');
        dupeQuery += ' FROM Contact WHERE Email IN :contactEmails AND AccountId IN :accountIds AND ID NOT IN :originalContactIds';
        List<Contact> potentialDupes = Database.query(dupeQuery);
        
        //map of email to list of potential dupes
        Map<String,List<Contact>> emailToDupeMap = new Map<String,List<Contact>>();
        for(Contact c : potentialDupes){
            List<Contact> thisDupeList = emailToDupeMap.containsKey(c.Email) ? emailToDupeMap.get(c.Email) : new List<Contact>();
            thisDupeList.add(c);
            emailToDupeMap.put(c.Email,thisDupeList);
        }
        
        //check all original contacts to see if there is a matching dupe - if there is, merge them
        //newer contact should be the master record
        //however, we only want to copy values from the master record if they aren't blank
        //we need to loop through all contact fields and copy them from the merged contact if they are blank on the master
        
        for(Contact con : contactsToProcess){
            if(emailToDupeMap.containsKey(con.Email)){
                List<Contact> dupes = emailToDupeMap.get(con.Email);
                for(Contact dupe : dupes){
                    Contact mergeCon = new Contact(Id = con.Id);
                    if(dupe.Email == con.Email && con.Email != null && dupe.AccountId == con.AccountId && dupe.Id != con.Id){
                        Map<String, Object> mergedContactValues = dupe.getPopulatedFieldsAsMap();
                        for(String field: mergedContactValues.keySet()) {
                            if(con.get(field) == null && contactFields.get(field).getDescribe().isUpdateable()) {
                                mergeCon.put(field, dupe.get(field));
                            }
                        }
                        merge mergeCon dupe;
                    }
                }
            }
        }
    }
}