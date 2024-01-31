public class GoogleAPICallout {
    private static final String ENDPOINT_URL = 'https://maps.googleapis.com/maps/api/geocode/json?address=';
    private static final String API_KEY = Api_Key__c.getOrgDefaults()?.Value__c;
    public static GeoLocationAPIRespWrapper getGeoLocationFromZipCode(String zipCode){
        String requestUrl = ENDPOINT_URL + zipCode + '&key=' + API_KEY;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(requestUrl);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
		GeoLocationAPIRespWrapper geocodeResponse;
        if (response.getStatusCode() == 200) {
            geocodeResponse = GeoLocationAPIRespWrapper.parse(response.getBody());
        }
        return geocodeResponse;
    }
}