@isTest
public class PFTotStudentsPerYear_Test {
   @testSetup static void testLoadData() {  
       List<Student__c> student=new List<Student__c>();
       List<Student_GPA__c> gpa=new List<Student_GPA__c>();
       String defaultSchool;
      Schema.DescribeFieldResult F = Student__c.School_name__c.getDescribe();
      List <Schema.PicklistEntry> pickVals = F.getPicklistValues();        
      for (Schema.PicklistEntry pv: pickVals) {
         if (pv.isDefaultValue()) {
            defaultSchool = pv.getValue();
       }    
      }
      String defaultOrphanage;
       F = Student__c.School_Orphanage_org__c.getDescribe();
       pickVals = F.getPicklistValues();        
      for (Schema.PicklistEntry pv: pickVals) {
         if (pv.isDefaultValue()) {
            defaultOrphanage = pv.getValue();
       }    
      }
       
student.add(New Student__c(First_name__c = 'Test 1', Last_name__c='Student 1', 
                           GradeClass__c='unk', school_name__c = defaultSchool,
                           School_Orphanage_org__c = defaultOrphanage
                          ));
student.add(New Student__c(First_name__c = 'Test 2', Last_name__c='Student 2', 
                           GradeClass__c='unk', school_name__c = defaultSchool,
                           School_Orphanage_org__c = defaultOrphanage
                          ));

student.add(New Student__c(First_name__c = 'Test 3', Last_name__c='Student 3',
                           GradeClass__c='unk',  school_name__c = defaultSchool,
                           School_Orphanage_org__c = defaultOrphanage));
insert student;
       
       
    for (Student__c s: student){
        if (s.First_name__c == 'Test 1') {
               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='01', year_taken__c='2010-11'));  
               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='02', year_taken__c='2011-12'));
     
               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='03', year_taken__c='2012-13')); 
               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='04', year_taken__c='2013-14'));  

               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='05', year_taken__c='2014-15')); 


               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='06', year_taken__c='2015-16'));  
         }
         if (s.First_name__c == 'Test 2') {
               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='01', year_taken__c='2014-15'));  
               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='02', year_taken__c='2015-16')); 
               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='03', year_taken__c='2016-17')); 
               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='04', year_taken__c='2017-18')); 

               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='05', year_taken__c='2018-19')); 


               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='06', year_taken__c='2019-20')); 
         }
        if (s.First_name__c == 'Test 3') {
               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='01', year_taken__c='2012-13'));  
               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='02', year_taken__c='2013-14')); 
               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='03', year_taken__c='2014-15')); 
               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='04', year_taken__c='2015-16'));

               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='05', year_taken__c='2016-17')); 


               gpa.add(new Student_GPA__c(student__c= s.id, grade_class__c='06', year_taken__c='2017-18')); 
         }
        
        
        }
 insert gpa;


       
       
   }
 static testMethod void validate_PFTotStudentsPerYear() {
     
 Test.startTest();


PFTotStudentsPerYear cntrl = new PFTotStudentsPerYear();
PFTotStudentsPerYear.chartData data = cntrl.getPieData();
List<PFTotStudentsPerYear.PieWedgeData> rows = data.pie;
  //system.debug(rows2.size());    
 Test.stopTest();

 
 
      System.assertEquals(10, rows.size());
 System.assertEquals('2010-11: 1', rows[0].name);
 
 }
 
}