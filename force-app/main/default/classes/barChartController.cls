public with sharing class barChartController {
    public List<ChartData> getData() {

        Date todaysDate = System.today();
        Integer yr = todaysDate.year();
        System.debug('year ' + yr);
        List<ChartData> data = new List<ChartData>();
         Integer total = 0;
             List<AggregateResult> ars = [select Year_Taken__c school_year, COUNT_DISTINCT(Student__c) students_count from Student_GPA__c group by Year_Taken__c order by Year_Taken__c];
         for (AggregateResult ar : ars) {
         
              String year =  String.valueOf(ar.get('school_year') + ': '+ ar.get('students_count') );
              Integer student_count = Integer.valueOf(ar.get('students_count'));
              total= total + student_count;
             
         }
         data.add( new ChartData(yr , total));
         System.debug('called getdata' );
         return data;
         
     }
     public class ChartData {
         public Integer year { get; set; }
         public Integer data { get; set; }
 
         public ChartData(Integer year, Integer data) {
             this.year = year;
             this.data = data;
         }
     }
}
