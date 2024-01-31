public class GeoLocationAPIRespWrapper {
    public class Address_components {
        public String long_name;
        public String short_name;
        public List<String> types;
    }
    
    public class Geometry {
        public Bounds bounds;
        @auraEnabled
        public Coordinates location { get; set; }
        public String location_type;
        public Bounds viewport;
    }
    
    public List<Results> results;
    public String status;
    
    public class Results {
        public List<Address_components> address_components;
        public String formatted_address;
        public Geometry geometry;
        public String place_id;
        public List<String> types;
    }
    
    public class Bounds {
        public Coordinates northeast;
        public Coordinates southwest;
    }
    
    public class Coordinates {
        @auraEnabled
        public Double lat { get; set; }
        @auraEnabled
        public Double lng { get; set; }
    }
       
    public static GeoLocationAPIRespWrapper parse(String json) {
        return (GeoLocationAPIRespWrapper) System.JSON.deserialize(json, GeoLocationAPIRespWrapper.class);
    }
}