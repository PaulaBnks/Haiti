import { LightningElement, wire, track } from 'lwc';
import searchLeads from '@salesforce/apex/CampaignLeadMapController.searchLeads';
import getCampaignLead from '@salesforce/apex/CampaignLeadMapController.getCampaignLead';
import filterDepts from '@salesforce/apex/CampaignLeadMapController.filterDepts';
import filterDomains from '@salesforce/apex/CampaignLeadMapController.filterDomains';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';

import DOMAINS from '@salesforce/schema/Lead.Domain_Types__c';



export default class SearchCampaignLeadMap extends LightningElement {
    searchTerm = '';
    source;
    searchResults;
    haitiLeads;
    wireData;
    error;
    mapVisible = false;
    @track mapMarkers;
    zoomLevel = 9;
    listview = 'visible' ;
    selectedMarkerValue = '';
    totalLeads;
    value = '';
    domvalue = '';
    dOptions;
    error;
    domOptions;
    filtered;
    domainResults;
    deptResults;
    processArray;
    dom = false; 
    dep = false;
    
    

    @wire(getPicklistValues, { fieldApiName: DOMAINS, recordTypeId:'012000000000000AAA', })
    domains({error, data}){
        
        if(data){
            let vals = [];
            //let noselection = {label:'None', value: 'none'};
            let pOptions = data;
            error = undefined;
            
            pOptions.values.forEach((element) => {
               
                vals.push({label:element.value, value: element.value});
            });
            //vals.unshift(noselection);  
            this.dOptions = vals;
           // console.log('picklist vals after wire processing' + this.dOptions.length);
        }
        else if(error){
            this.error = error;
            this.dOptions = undefined;
            console.log('error ' + JSON.stringify(this.error));
        }
    }

    
    get options() {
        return [
            
            { label: 'Artibonite', value: 'artibonite' },
            { label: 'Centre', value: 'centre' },
            { label: 'Grand\'Anse', value: 'anse' },
            { label: 'Nippes', value: 'nippes' },
            { label: 'Nord', value: 'nord' },
            { label: 'Nord-Est', value: 'nord-Est' },
            { label: 'Nord-Ouest', value: 'nord-Ouest' },
            { label: 'Ouest', value: 'ouest' },
            { label: 'Sud-Est', value: 'sud-Est' },
            { label: 'Sud', value: 'sud' },
        ];
    }
    handleDept(event){
        let origin = 'depts';
        this.value = event.detail.value;
        if(this.value != 'none'){
            console.log('selected dept ' + this.value);
            filterDepts({category: this.value})
            .then((result) => {
                console.log('dept results ' + JSON.stringify(result));
                this.deptResults = result;
                this.mapLeads(origin);
            })
            .catch((error) =>{
                console.log('Error in filtering '+ error);
            });
        }
        
    }

   
    handleDomain(event){
        let origin = 'domains';
        this.domvalue = event.detail.value;
        if(this.domvalue != 'none'){
            console.log('selected domain ' + this.domvalue);
            filterDomains({category: this.domvalue})
            .then((result) => {
                console.log('domain results ' + JSON.stringify(result));
                this.domainResults = result;
                this.mapLeads(origin);
            })
            .catch((error) =>{
                console.log('Error in filtering '+ error);
            });
        }
        
    }

    @wire(getCampaignLead)
    wiredLeads({error, data}){
        if(data){
           
            this.error = undefined;
            this.wireData = data;
            this.source = 'wire';
            this.mapLeads(this.source);
           
           
        }
        else if(error){
            this.error = error;
            this.wireData = undefined;
            console.log('Error occured ' + JSON.stringify(error));
        }
    }

    handleMarkerSelect(event) {
        this.selectedMarkerValue = event.target.selectedMarkerValue;
        //console.log('selected '+ this.selectedMarkerValue);
    }
    mapLeads(datasource){
        
        let markers;
        let prepLead = [];
        

        if(datasource == 'wire')
        {
            this.haitiLeads = this.wireData;
            this.totalLeads = 'Campaign Leads: '+ this.haitiLeads.length;
        }
        else if(datasource == 'search'){
            this.haitiLeads = this.searchResults;
            this.totalLeads = 'Campaign Leads: '+ this.haitiLeads.length;
        }
        else if(datasource == 'depts')
        {   

           if(this.domainResults){
               this.processArray = this.haitiLeads;
               this.haitiLeads = this.deptResults;
               this.dom = true;
           }
           else{
               this.haitiLeads = this.deptResults;
           }
           
        }
        else if(datasource == 'domains')
        {
            if(this.deptResults){
                this.processArray = this.haitiLeads;
                this.haitiLeads = this.domainResults;
                this.dep = true;
            }
            else{
                this.haitiLeads = this.domainResults;
            }
        }

        //console.log('Mapping ' + JSON.stringify(this.haitiLeads));
        this.haitiLeads.forEach((element) =>{
            let pLead = {};
            pLead.latitude = element.Latitude__c;
            pLead.longitude = element.Longitude__c;
            pLead.name = element.Name;
            pLead.company = element.Company;
            pLead.city = element.City;
            if(element.MobilePhone){
                pLead.mobile = element.MobilePhone;
            }
            else{
                pLead.mobile = 'Unavailable';
            }
            if(element.Email){
                pLead.email = element.email;
            }
            else{
                pLead.email = 'Unavailable';
            }
            if(pLead.latitude && pLead.longitude){
                prepLead.push(pLead);
            }
        });

        //console.log('Processed data ' + JSON.stringify( prepLead));
         
       let resultset = [];
        if(this.dom == true){
           console.log('dom Process array '+ this.processArray.length);
            
            resultset.add(this.processArray);
            console.log('resultset after domain Process array '+ JSON.stringify(resultset));
            resultset.add(prepLead);
            console.log('Resultset after Preplead with dept ' + JSON.stringify(resultset));
            this.haitiLeads = Array.from(resultset);
            this.dom = false;
            this.processArray = [];
        }
        if(this.dep == true){
            console.log('dom Process array '+ this.processArray.length);
            this.processArray.forEach((element) => {
                //console.log('process array element '+ JSON.stringify(element));
                resultset.push(element);
            });            
        
           
            console.log('resultset with dept Process array '+ resultset.length);
            prepLead.forEach((element) => {
                resultset.push(element);
                //console.log('resultset Preplead with domains ' + JSON.stringify(resultset));
            });
            console.log('final resultset ' + resultset.length);
            this.haitiLeads = resultset;
            this.dep = false; 
            this.processArray = [];
        }

        this.haitiLeads = prepLead;
        try{
            if(this.haitiLeads != undefined){
                markers = this.haitiLeads.map(mapItem => {
                    return{
                        location: {
                            Latitude: mapItem.latitude,
                            Longitude: mapItem.longitude
                        },
                        title: 'Volunteer: '+ mapItem.name,
                        description: '<b>Company: </b> ' + mapItem.company + '<br/><b> City: </b>' + mapItem.city +'<br/><b> Mobile: </b>' + mapItem.mobile + '<br/> <b> Email: </b> ' + mapItem.email
                    }
                });
            }
            this.mapMarkers = markers;
           // console.log('Markers ' + JSON.stringify(this.mapMarkers));
        }
        catch(error){
            console.log('Map error ' + JSON.stringify(error));
        }
    }
    handleReset(){
        this.mapMarkers = [];
        this.mapLeads('wire');
        const combo = this.template.querySelector('.combo');
        const combo2 = this.template.querySelector('.combo2');
        combo.value = 'Select Department';
        combo2.value = 'Select Domain';
       
    }
    handleInput(e){
        this.searchTerm = e.detail.value;
        //console.log('Received ' + this.searchTerm);
    }
    handleSearch(){     
        this.template.querySelector('lightning-input[data-name="input"]').value = null; 
        searchLeads({ searchTerm: this.searchTerm})
            .then((result) => {
                this.searchResults = result;
                this.error = undefined;                
                //console.log('Got search results ' + JSON.stringify( this.searchResults));
                this.source = 'search';

                this.mapMarkers = undefined;
                this.mapLeads(this.source);
                
            })
            .catch((error) => {
                this.searchResults = undefined;
                this.error = error;
                console.log('Error occured ' + error);
            });

        
      
    }

}