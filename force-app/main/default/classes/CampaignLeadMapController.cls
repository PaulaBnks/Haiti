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
       //return campaignLead = [SELECT Id, Name, Email,MobilePhone,Domain_Types__c,Department__c, Company, City, Longitude__c, Latitude__c from Lead WHERE Id IN (SELECT LeadId FROM CampaignMember WHERE Campaign.name IN ('Plan NGO Facilities Haiti', 'Batch 6 : NGOs-officially-registered-in-Haiti', '2011apr13_ctc-list-haiti Address-2', 'Plan Education Cluster batch-1'))];
       return campaignLead = [SELECT Id, Name, Email,MobilePhone,Domain_Types__c,Department__c, Company, City, Longitude__c, Latitude__c from Lead WHERE  Domain_Types__c != null or Department__c != null];
    }
@AuraEnabled(cacheable=true)
    public static List<Lead> filterDomains(String category){
    List<Lead> filtered = new List<Lead>();
    try{
       List<Lead> leadList = CampaignLeadMapController.getCampaignLead();
       System.debug('List ' + leadList);
        for(Lead l: leadList){
           
            if(l.Domain_Types__c != null){
                String domain = l.Domain_Types__c;
                if(domain.containsIgnoreCase(category)) {
                filtered.add(l) ;
                }
            }
        }

    }
    catch(Exception e)
    {
        System.debug('Error occured ' + e.getMessage());
    }
    return filtered;
}
@AuraEnabled(cacheable=true)
    public static List<Lead> filterDepts(String category){
    List<Lead> filtered = new List<Lead>();
    try{
       List<Lead> leadList = CampaignLeadMapController.getCampaignLead();
        for(Lead l: leadList){
            if(l.Department__c != null){
                System.debug('Dept ' + l.Department__c);
            String dept = l.Department__c;
            if(dept.containsIgnoreCase(category)){
                filtered.add(l);
                }
            }
           
        }
       
    }
    catch(Exception e)
    {
        System.debug('Error occured ' + e.getMessage());
    }
    return filtered;
}
    @AuraEnabled(cacheable=true)
    public static List<Lead> searchLeads(String searchTerm){
       
        
        List<Lead> results = new List<Lead>();

        try{
            List<Lead> leadsList = CampaignLeadMapController.getCampaignLead();
            System.debug('Leadlist '+ leadsList.size());
        
            for(Lead l : leadsList){
                if(l.City != null){
                    String city = l.City;
                    if(city.containsIgnoreCase(searchTerm)){
                        results.add(l);
                        System.debug('Found city ' + searchTerm);
                    }
                }
               if(l.Company != null){
                    String employer = l.Company;
                    if(employer.containsIgnoreCase(searchTerm))
                    {
                        results.add(l);
                        System.debug('Found company ' + searchTerm);
                    }
               }
               
                 
            }
         }
        catch(Exception e){
        System.debug('Error occured ' + e.getMessage());
    }
        return results; 
    }
}
