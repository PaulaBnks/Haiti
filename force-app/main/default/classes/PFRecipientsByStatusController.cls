// Family__c is Guardian Status
public with sharing class PFRecipientsByStatusController {
    public List<PieWedgeData> getPieData() {
        List<PieWedgeData> data = new List<PieWedgeData>();
        /*List<Book_Recipient__c> brList = [SELECT Id, Family__c
                                         FROM Book_Recipient__c
                                         WHERE Recipient_DOB__c >= 1991-01-01
                                         AND Id IN(SELECT Book_Recipient__c FROM Book_Distribution__c)];*/
        List<Student__c> sList = [SELECT Id, Family_Members__c
                                         FROM Student__c
                                         ];
        Integer pitit = 0;
        Integer timoun = 0;
        Decimal pctPitit = 0;
        Decimal pctTimoun = 0;
        
        if(sList.size() > 0){
            for(Student__c s: sList) {
                if(!String.isEmpty(s.Family_Members__c) && s.Family_Members__c.endsWith('Pitit'))	{
                    pitit++;
                } else {
                    timoun++;
                }
            }
            pctPitit = ((Decimal)pitit/sList.size()) * 100;
           // pctTimoun = ((Decimal)timoun/sList.size()) * 100;
            pctTimoun = ((Decimal)timoun/sList.size()) * 100;
            
            // data.add(new PieWedgeData(
            //     'Non-Restavek ' + Math.round(pctPitit) + '% ',  pitit
            // ));
            data.add(new PieWedgeData(
                //'Restavek ' +  timoun, timoun
                'Restavek ' + Math.round(pctTimoun) + '% ', timoun
                
            ));
            return data;
        } else {
            System.debug('No Student by Status found');
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