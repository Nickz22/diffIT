public class ContactService {
  public static void createRecord(Contact contactRecord) {
    contactRecord.Quote_Request_Date__c = Date.today();
    insert contactRecord;
  }
}
