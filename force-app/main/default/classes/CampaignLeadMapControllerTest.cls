@isTest
public class CampaignLeadMapControllerTest {
	
	@testSetup 
    static void dataSetup() {
         
        Campaign c = new Campaign();
        c.Name = 'Plan NGO Facilities Haiti';
        insert c;

        Campaign c1 = new Campaign();
        c1.Name = 'Batch 6 : NGOs-officially-registered-in-Haiti';
        insert c1;

        Campaign c2 = new Campaign();
        c2.Name = '2011apr13_ctc-list-haiti Address-2';
        insert c2;

        Campaign c3 = new Campaign();
        c3.Name = 'Plan Education Cluster batch-1';
        insert c3;
        
        Lead l = new Lead();
        l.FirstName = 'firstname';
        l.LastName = 'lastname';
        l.Company = 'Haiti Now';
        l.City = 'Port';
        l.MobilePhone = '5876678';
        l.Email = 'test@test.com';
        l.Department__c = 'Nord-Est';
        l.Domain_Types__c = 'Agriculture';
        insert l;

        Lead l2 = new Lead();
        l2.FirstName = 'firstname';
        l2.LastName = 'harry';
        l2.Company = 'Port';
        
        l2.MobilePhone = '5876678';
        l2.Email = 'testy@test.com';
        insert l2;
        
        
        CampaignMember cm = new CampaignMember();
        cm.LeadId = l.Id;
        cm.CampaignId = c.Id;  
        insert cm;

        CampaignMember cm1 = new CampaignMember();
        cm1.LeadId = l.Id;
        cm1.CampaignId = c1.Id;  
        insert cm1;

        CampaignMember cm2 = new CampaignMember();
        cm2.LeadId = l.Id;
        cm2.CampaignId = c2.Id;  
       
        insert cm2;

        CampaignMember cm3 = new CampaignMember();
        cm3.LeadId = l.Id;
        cm3.CampaignId = c3.Id;  
        insert cm3;

        CampaignMember cm4 = new CampaignMember();
        cm4.LeadId = l2.Id;
        cm4.CampaignId = c2.Id;  
       
        insert cm4;

        CampaignMember cm5 = new CampaignMember();
        cm5.LeadId = l2.Id;
        cm5.CampaignId = c3.Id;  
        insert cm5;


	}
    
    @isTest
    static void getCampaignLeadTest() {
        String term = 'Haiti Now';
        String termMiss = 'testcity';
        String dept = 'Nord-Est';
        String domain = 'Agriculture';
        Map<String,String> combval = new Map<String,String>();
        combval.put('Nord-Est', 'Agriculture');

       

        
        //List<Lead> leadLst = [SELECT Id FROM Lead  WHERE  Domain_Types__c != null or Department__c != null ];
       // System.debug('test size ' + leadLst.size());
     


        Test.startTest();
        	List<Lead> lead =  CampaignLeadMapController.getCampaignLead();
            System.debug('size ' + lead.size());
            List<Lead> results = CampaignLeadMapController.searchLeads(term);
            
            List<Lead> depresults = CampaignLeadMapController.filterDepts(dept);
            List<Lead> domresults = CampaignLeadMapController.filterDomains(domain);

            List<Lead> combresults = CampaignLeadMapController.combinedFilter(combval);
                     
           
        	System.assertEquals(2, lead.size());
           
        Test.stopTest();
    }
}