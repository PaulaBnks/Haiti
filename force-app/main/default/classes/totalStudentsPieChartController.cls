public with sharing class totalStudentsPieChartController {
    public List<ChartData> getData() {

        Date todaysDate = System.today();
        Integer yr = todaysDate.year();
        String toStringYr = 'Year ' + String.valueOf(yr);
        System.debug('year ' + toStringYr);
        List<ChartData> data = new List<ChartData>();
         Integer total = 0;
             List<AggregateResult> ars = [select Year_Taken__c school_year, COUNT_DISTINCT(Student__c) students_count from Student_GPA__c group by Year_Taken__c order by Year_Taken__c];
         for (AggregateResult ar : ars) {
         
              String year =  String.valueOf(ar.get('school_year') + ': '+ ar.get('students_count') );
              Integer student_count = Integer.valueOf(ar.get('students_count'));
              total= total + student_count;
             
         }
        // data.add( new ChartData(toStringYr, total));
         data.add(new ChartData(
                'Total Students ' + total ,  total
            ));
         System.debug('called getdata' );

         return data;
         
     }
     public class ChartData {
         public String name { get; set; }
         public Integer data { get; set; }
 
         public ChartData(String toStringYr, Integer data) {
             this.name = toStringYr;
             this.data = data;
             System.debug('received ' + this.name);
         }
     }
}
