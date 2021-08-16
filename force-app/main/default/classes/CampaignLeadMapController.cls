/*****

@ Description: This class is used for getting Campaing Releated Lead record for Campaing Lead Map 
@ Date: 4/27/2021
@ Author: Haiti Now (Mitesh Mangukiya)
@ Test Class: CampaignLeadMapControllerTest
@ Code Coverage: 100%
  
*****/

public class  CampaignLeadMapController {
    
    @AuraEnabled(cacheable=true)
    public static List<Lead> getCampaignLead(){           
 
       List<Lead> campaignLead = new List<Lead>();
       return campaignLead = [SELECT Id, Name, Company, City, Longitude__c, Latitude__c from Lead WHERE Id IN (SELECT LeadId FROM CampaignMember WHERE LeadId != Null)];
    }

    @AuraEnabled(cacheable=true)
    public static List<Lead> searchLeads(String searchTerm){
        String find = searchTerm;
        String msg = 'Success';
        
        List<Lead> results = new List<Lead>();

        try{
            List<Lead> leadsList = CampaignLeadMapController.getCampaignLead();
        
            for(Lead l : leadsList){
                String city = l.City;
                if(city.containsIgnoreCase(searchTerm)){
                    results.add(l);
                }
            }
         }
        catch(Exception e){
        System.debug('Error occured ' + e.getMessage());
    }
        return results; 
    }
}
