public class PFTotStudentsPerYear {
    public chartData getPieData() {
        List<PieWedgeData> data1 = new List<PieWedgeData>();
        Integer total = 0;
            List<AggregateResult> ars = [select Year_Taken__c school_year, COUNT_DISTINCT(Student__c) students_count from Student_GPA__c group by Year_Taken__c order by Year_Taken__c];
        for (AggregateResult ar : ars) {
        
             String year =  String.valueOf(ar.get('school_year') + ': '+ ar.get('students_count') );
             Integer student_count = Integer.valueOf(ar.get('students_count'));
             total= total + student_count;
            data1.add(new PieWedgeData(
                year, student_count 
            ));
        }
        chartData  data = new chartData(total, data1);    
        return data;
        
    }
    public class chartData {
        public Integer total {get; set;}
        public List<PieWedgeData> pie {get; set;}
        
       /* public chartData() {
            total =0;
           pie= new List<PieWedgeData>();
        }*/
        public chartData(Integer inTotal,List<PieWedgeData> inPie ){
            total = inTotal;
            pie = inPie;
            System.debug('total ' + total);
        }
    }
    public class PieWedgeData {
        public String name {get; set;}
        public Integer data {get; set;}
        public PieWedgeData(String name, Integer data) {
            this.name = name;
            this.data = data;
        }
    }


}