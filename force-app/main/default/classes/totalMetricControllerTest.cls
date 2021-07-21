@isTest
public class totalMetricControllerTest{
    @isTest static void totalStudentTest() {  
        // Test data setup
        List<Student__c> students = new List<Student__c>();
        List<Student_GPA__c> gpas = new List<Student_GPA__c>();
        
        // insert 300 students
        for (Integer i = 0;i<300; i++) {
            students.add(new Student__c(Last_Name__c = 'Account'+ i, First_Name__c = 'Test', School_Year__c = '2010-11;2011-12', 
                                          GradeClass__c = '01', School_Orphanage_Org__c = 'AEMSA SM'));
        }
        insert students;
        
        // find the students just inserted. add gpas for each
        for (Student__c stud : [select id from Student__c where First_Name__c = 'Test']) {
            gpas.add(new Student_GPA__c(Year_Taken__c='2010-11', Student__c=stud.id));
        }
        insert gpas;
        
        Test.startTest();


        totalMetricController cntrl = new totalMetricController();
        cntrl.getTotalStudents();
        
         Test.stopTest();
        
         
         
        //       System.assertEquals(10, rows.size());
        //  System.assertEquals('2010-11: 1', rows[0].name);
         

       
       
   }

 
}