   
public with sharing class CTLocationController {
//push to github
    /** CTLocationController
     * Main controller class fort Location__c Object
     * @Auther Abraham
     */
    public static List<Location__c> getRecentStatusChanges(){
        /**
         * Get  100 location with recent status change
         */
        return [SELECT 	name, Status_Update_Date__c, Status__c  FROM Location__c ORDER BY Status_Update_Date__c NULLS LAST LIMIT 100];
    }
    public static List<Location__c> searchLocations(String searchTerm){
        /**
         * Search a location by name , zipcode or address
         * @return List of locations 
         */
        searchTerm = searchTerm + '%';
        List<Location__c> loc = [SELECT name, Status_Update_Date__c, Status__c,pincode__c, Address__c FROM Location__c
        WHERE name LIKE :searchTerm
            OR pincode__c LIKE : searchTerm
            OR Address__c LIKE : searchTerm];
        return loc;
    }
    public static Location__c getLocationById(String locationId){
        /**
         * Search location by Id
         * @return location
         */
        List<Location__c> loc= [SELECT Id,Name,Status__c,Status_Update_Date__c,pincode__c FROM Location__c WHERE Id =: locationId];
        if (loc !=null && loc.size()>0){
           return loc[0];
        }
        return null;
    }
    public static Map<String, Integer> getLocationCount() {
        // Create a new map to store the results
        Map<String, Integer> healthCountMap = new Map<String, Integer>();
    
        // Perform the SOQL query and iterate over the results
        for (AggregateResult result : [SELECT Status__c, COUNT(Id) total FROM Location__c GROUP BY Status__c]) {
            // Retrieve the status and count from the AggregateResult
            String NameLocation = (String) result.get('Status__c');
            Integer numberOfPatient = (Integer) result.get('total');
    
            // Add the retrieved values to the map
            healthCountMap.put(NameLocation, numberOfPatient);
        }
    
        // Return the populated map
        return healthCountMap;
    }
    
}