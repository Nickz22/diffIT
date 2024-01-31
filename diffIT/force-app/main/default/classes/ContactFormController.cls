public class ContactFormController { 
    @AuraEnabled(cacheable=false)  
    public static List<sobject> findRecords(String searchKey, String objectName, List<String> institutions, GeoLocationAPIRespWrapper.Coordinates coordinates ) {  
        String searchText = '\'%' + String.escapeSingleQuotes(searchKey) + '%\'';  
        String query = 'SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText + ' AND Institution__c IN :institutions';
        if(coordinates!=null && coordinates.lat != null && coordinates.lng != null){
            query = query + ' AND DISTANCE(BillingAddress, GEOLOCATION('+coordinates.lat+', '+coordinates.lng+'), \'mi\') < 60';
        }  
        query = query + ' LIMIT 6';
        return Database.query(query);  
    }
    @AuraEnabled(cacheable=false)
    public static GeoLocationAPIRespWrapper.Coordinates getZipCodeCoordinates(String zipCode) {  
        GeoLocationAPIRespWrapper geoLocationRes = GoogleAPICallout.getGeoLocationFromZipCode(zipCode);
        GeoLocationAPIRespWrapper.Coordinates coordinates;
        if(geoLocationRes != null && !geoLocationRes.results.isEmpty()){
            coordinates = geoLocationRes.results[0].geometry.location; 
        }
        return coordinates;
    }
    @AuraEnabled(cacheable=false)  
    public static void createContactRecord(Contact contactRecord) {  
        ContactService.createRecord(contactRecord);
    }
}