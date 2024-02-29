@IsTest
public class Flow_DupeContactHandlerTest {
	@TestSetup
    static void createTestData(){
        Account a = new Account(
        	Name = 'Test Account'
        );
        insert a;
        
        Contact c = new Contact(
        	FirstName = 'Test',
            LastName = 'Testcontact',
            Email = 'someemail@example.com',
            Phone = '5551231234',
            AccountId = a.Id
        );
        insert c;
    }
    
    @IsTest
    static void testMergeDupes(){
        Account a = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Contact c = new Contact(
        	FirstName = 'Test',
            LastName = 'Testcontact',
            Email = 'someemail@example.com',
            AccountId = a.Id
        );
        Database.DMLOptions opts = new Database.DMLOptions();
        opts.DuplicateRuleHeader.AllowSave = true;
        Test.startTest();
        Database.insert(c, opts);
        
        Flow_DupeContactHandler.findAndMergeDupes(new List<Contact>{c});
        Test.stopTest();
        
        List<Contact> queryCons = [SELECT Id FROM Contact WHERE AccountId = :a.Id];
        //there should only be one contact - the dupes should be merged
        System.assertEquals(1,queryCons.size());
    }
}