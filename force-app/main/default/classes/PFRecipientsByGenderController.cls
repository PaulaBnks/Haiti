public with sharing class PFRecipientsByGenderController {
    public List<PieWedgeData> getPieData() {
        List<PieWedgeData> data = new List<PieWedgeData>();
        /*List<Book_Recipient__c> brList = [SELECT Id, Recipient_Gender__c
                                         FROM Book_Recipient__c
                                         WHERE Recipient_DOB__c >= 1991-01-01
                                         AND Id IN(SELECT Book_Recipient__c FROM Book_Distribution__c)];*/
        
        // Use Student__c instead of Book_Recipient__c
        List<Student__c> brList = [SELECT Id, Gender__c FROM Student__c];
        
        Integer males = 0;
        Integer females = 0;
        Decimal pctMale = 0;
        Decimal pctFemale = 0;
        
        if(brList.size() > 0){
            for(Student__c b: brList) {
                if(b.Gender__c == 'Male')	{
                    males++;
                } else {
                    females++;
                }
            }
            pctMale = ((Decimal)males/brList.size()) * 100;
            pctFemale = ((Decimal)females/brList.size()) * 100;
            // data.add(new PieWedgeData(
            //     'Male ' + Math.round(pctMale) + '% ', males
            // ));
            data.add(new PieWedgeData(
                'Female ' + Math.round(pctFemale) + '% ',  females
            ));
            
            return data;
        } else {
            System.debug('No Student by Gender found');
            return null;
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