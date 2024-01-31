@isTest
public class GoogleAPICalloutTest {
    
    @isTest
    public static void testGetGeoLocationFromZipCode(){
        Test.setMock(HttpCalloutMock.class, new GoogleAPIHttpCalloutMock());
        GeoLocationAPIRespWrapper response = GoogleAPICallout.getGeoLocationFromZipCode('90051');
        Assert.isTrue(response.results.size() > 0);
    }
    
    class GoogleAPIHttpCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"results":[{"address_components":[{"long_name":"90029","short_name":"90029","types":["postal_code"]},{"long_name":"LosAngeles","short_name":"LosAngeles","types":["locality","political"]},{"long_name":"LosAngelesCounty","short_name":"LosAngelesCounty","types":["administrative_area_level_2","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"UnitedStates","short_name":"US","types":["country","political"]}],"formatted_address":"LosAngeles,CA90029,USA","geometry":{"bounds":{"northeast":{"lat":34.096706,"lng":-118.2771619},"southwest":{"lat":34.083509,"lng":-118.31081}},"location":{"lat":34.0880507,"lng":-118.2965121},"location_type":"APPROXIMATE","viewport":{"northeast":{"lat":34.096706,"lng":-118.2771619},"southwest":{"lat":34.083509,"lng":-118.31081}}},"place_id":"ChIJ5xDBN1HHwoARfhknB-ompdQ","types":["postal_code"]}],"status":"OK"}');
            res.setStatusCode(200);
            return res;
        }
    }
}