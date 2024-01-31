@isTest
public class ContactFormControllerTest {
    public static string institution = Account.Institution__c.getDescribe().getPicklistValues()[0].getValue();
	@testSetup
    public static void createAccount(){
        Account acc = new Account(name='Test Account',Institution__c=institution,BillingCity='NY', BillingPostalCode='10012', BillingLatitude = 34.0522, BillingLongitude = -118.24368);
        insert acc;
    }
    @isTest
    public static void findRecordsTest(){
        GeoLocationAPIRespWrapper.Coordinates coordinatesWrap = new GeoLocationAPIRespWrapper.Coordinates();
        coordinatesWrap.lat = 34.0522;
        coordinatesWrap.lng = -118.24368;
        List<sobject> accList = ContactFormController.findRecords('Test','Account',new List<String>{institution}, coordinatesWrap);
        Assert.areEqual(1,accList.size());
    }
    @isTest
    public static void createRecordsTest(){
        Contact con = new Contact(LastName='Test');
        ContactFormController.createContactRecord(con);
        Integer count = [Select count() from contact];
        Assert.areEqual(1,count);
    }
}