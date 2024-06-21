public with sharing class CTPersonController {
    /** CTPersonController
     * Main controller class fort People__c Object
     * @Auther Abraham
     */
    public static String getToken(String mobileNo) {
        /**
         * Generate a hash based on the phone number
         * @return the hash string
         */
        Blob value = Blob.valueOf(mobileNo);
        Blob hash = Crypto.generateDigest('MD5', value);
        String result = EncodingUtil.base64Encode(hash);
        return result;
    }
    public static List<Person__c> getRecentHealthChanges(){
        /**
         * Get  100 People with recent status change
         */
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c ORDER BY Status_Update_Date__c DESC NULLs LAST LIMIT 100];
    }
    public static List<Person__C> searchPeople(String searchTerm){
        searchTerm = searchTerm + '%';
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c 
        WHERE Name LIKE :searchTerm 
            OR Mobile__c LIKE :searchTerm 
            OR Token__c LIKE :searchTerm  
        ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }
    public static Person__c getPersonById(String personId){
        List<Person__c> people=  [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c 
        WHERE Id =: personId];
        if (people !=null && people.size()>0){
            return people[0];
        }
        return null;
    }
    public static Map<String, Integer> getHealthStatusCount(){
        // Create a new map to store the results
        Map<String, Integer> healthStatusCountMap = new Map<String, Integer>();

        for (AggregateResult result : [SELECT Health_Status__c , COUNT(Id) total FROM Person__c GROUP BY Health_Status__c]) {
            String healthStatus = (String) result.get('Health_Status__c');
            Integer count = (Integer) result.get('total');
            healthStatusCountMap.put(healthStatus, count);
        }
        return healthStatusCountMap;
    }
}