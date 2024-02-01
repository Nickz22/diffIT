public class ContactService {
  public static void createRecord(Contact contactRecord) {
    Boolean hasEmail = String.isBlank(contactRecord.Email);
    Contact c;

    if (hasEmail) {
      // get existing contact
      Contact c = [
        SELECT Id, Email
        FROM Contact
        WHERE Email = :contactRecord.Email
      ];
    }

    if (c != null) {
      // brand new contact
      contactRecord.Id = c.Id;
    }

    contactRecord.Quote_Request_Date__c = Date.today();
    upsert contactRecord;
  }
}
