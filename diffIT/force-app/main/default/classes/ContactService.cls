public class ContactService {
  public static void createRecord(Contact contactRecord) {
    Boolean hasEmail = String.isNotBlank(contactRecord.Email);
    Contact c;

    if (hasEmail) {
      // get existing contact
      List<Contact> singleContact = [
        SELECT Id, Email
        FROM Contact
        WHERE Email = :contactRecord.Email
        LIMIT 1
      ];
      if(!singleContact.isEmpty()){
        c = singleContact[0];
      }
    }

    if (c != null) {
      // brand new contact
      contactRecord.Id = c.Id;
    }

    contactRecord.Quote_Request_Date__c = Date.today();
    upsert contactRecord;
  }
}
