@isTest
public class CampaignLeadMapControllerTest {
	
	@testSetup 
    static void dataSetup() {
         
        Campaign c = new Campaign();
        c.Name = 'campaing';
        insert c;
             
        Lead l = new Lead();
        l.FirstName = 'firstname';
        l.LastName = 'lastname';
        l.Company = 'Haiti Now';
        insert l;
             
        CampaignMember cm = new CampaignMember();
        cm.LeadId = l.Id;
        cm.CampaignId = c.Id;  
        insert cm;
	}
    
    @isTest
    static void getCampaignLeadTest() {
                
        Test.startTest();
        	List<Lead> lead =  CampaignLeadMapController.getCampaignLead();
        	System.assertEquals(1, lead.size());
        Test.stopTest();
    }
}