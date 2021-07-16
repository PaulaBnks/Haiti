public class HaitiController2 {
    
    List<PieWedgeData> data {get; set;}
   
    public HaitiController2() {
    data = new List<PieWedgeData>();
    }
 
  public List<PieWedgeData> getPieData() { 
        data = new List<PieWedgeData>();
       
        List<Residential_School_Expenditure_Details__c> rsed = new List<Residential_School_Expenditure_Details__c>(); 
       
        rsed = [SELECT Name, Phase__c, Total_Expected_Expenditure__c, Dollars_Raised__c, Amount_To_Be_Raised__c FROM Residential_School_Expenditure_Details__c WHERE Phase__c = 'Phase 1'];
        for(Residential_School_Expenditure_Details__c rd: rsed)
        {          
            data.add(new PieWedgeData('Target Amount', rd.Total_Expected_Expenditure__c ));
            data.add(new PieWedgeData('Dollars Raised', rd.Dollars_Raised__c));
            data.add(new PieWedgeData('To Be Raised', rd.Amount_To_Be_Raised__c));
        }
        return data; 
    } 
    
     public string getColors(){
     
        String colorChart = '';
        for(PieWedgeData dt : data){
            colorChart += dt.colorChart + ',';
        }

        return colorChart;
    }
   
    // Wrapper class 
    public class PieWedgeData { 
    
        public String name { get; set; } 
        public Decimal data { get; set; }
        public String colorChart {get; set;}   
       
        public PieWedgeData(String name, Decimal data) { 
            this.name = name; 
            this.data = data; 
            this.colorChart = '#009345, #009345, #009345';
        } 
    } 
       
}