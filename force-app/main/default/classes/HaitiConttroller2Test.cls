@isTest
public class HaitiConttroller2Test {
   
 @isTest static void testHaitiResSchool(){
      
      Residential_School_Expenditure_Details__c rs = new Residential_School_Expenditure_Details__c(Name= 'Phase 1 Expend', Phase__c='Phase 1',  
        Dollars_Raised__c= 250);
       insert rs;
       
     Test.StartTest();
 
     PageReference pageRef = Page.homepage_fundraising_chart;
       Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('id', String.valueOf(rs.Id));
      
    HaitiController2 controller = new HaitiController2();
       controller.getPieData() ;
 
       controller.getColors() ;    
   List<Residential_School_Expenditure_Details__c> r = [Select Name, Phase__c, Total_Expected_Expenditure__c FROM Residential_School_Expenditure_Details__c where Name = 'Phase 1 Expend'];
     System.assertEquals(1, r.size());
        Test.StopTest();
    }
}