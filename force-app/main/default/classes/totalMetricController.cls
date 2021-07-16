public  class totalMetricController {
    public Integer Students;
   
   
    public Integer getTotalStudents(){

        Integer total = 0;
        List<AggregateResult> ars = [select Year_Taken__c school_year, COUNT_DISTINCT(Student__c) students_count from Student_GPA__c group by Year_Taken__c order by Year_Taken__c];
        for (AggregateResult ar : ars) {
    
            String year =  String.valueOf(ar.get('school_year') + ': '+ ar.get('students_count') );
            Integer student_count = Integer.valueOf(ar.get('students_count'));
            total= total + student_count;
           
           }

           Students = total;

        System.debug('Total students ' + Students);
        return Students;
    }
    
}