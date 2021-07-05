public with sharing class GaugeController {
    public List<gaugeData> getData() {

       List<gaugeData> data = new List<gaugeData>();
        Integer total = 0;
            List<AggregateResult> ars = [select Year_Taken__c school_year, COUNT_DISTINCT(Student__c) students_count from Student_GPA__c group by Year_Taken__c order by Year_Taken__c];
        for (AggregateResult ar : ars) {
        
             String year =  String.valueOf(ar.get('school_year') + ': '+ ar.get('students_count') );
             Integer student_count = Integer.valueOf(ar.get('students_count'));
             total= total + student_count;
            
        }
        data.add( new gaugeData('Total' , total));

        return data;
        
    }
    public class gaugeData {
        public String name { get; set; }
        public Integer size { get; set; }

        public gaugeData(String name, Integer data) {
            this.name = name;
            this.size = data;
        }
    }
   
}
