import { LightningElement, wire, track } from 'lwc';
import searchLeads from '@salesforce/apex/CampaignLeadMapController.searchLeads';
import getCampaignLead from '@salesforce/apex/CampaignLeadMapController.getCampaignLead';
import filterDepts from '@salesforce/apex/CampaignLeadMapController.filterDepts';
import filterDomains from '@salesforce/apex/CampaignLeadMapController.filterDomains';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import combinedFilter from '@salesforce/apex/CampaignLeadMapController.combinedFilter';

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

        let dom = this.template.querySelector('.domcombo').value;
       
        if(dom != 'Select Domain'){
            let wrapper = {
                domain: dom,
                dept: this.value
            };
            combinedFilter({combinedVal: wrapper})
            .then((result) => {
                console.log('received combined results ' + JSON.stringify(result));
                this.deptResults = result;
                this.totalLeads = 'Campaign Leads ' + this.deptResults.length;
                this.mapLeads(origin);
                

            })
            .catch((error) => {
                console.log('error is '+ JSON.stringify(error));
            })
        }
        else{
            
                console.log('selected dept ' + this.value);
                filterDepts({category: this.value})
                .then((result) => {
                    console.log('dept results ' + result.length);
                    this.deptResults = result;
                    this.totalLeads = 'Campaign Leads ' + this.deptResults.length;
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
        
        let dep = this.template.querySelector('.depcombo').value;
       
        if(dep != 'Select Department'){
            let wrapper = {
                domain: this.domvalue,
                dept: dep
            };
            combinedFilter({combinedVal: wrapper})
            .then((result) => {
                console.log('received combined results ' + JSON.stringify(result));
                this.domainResults = result;
                this.totalLeads = 'Campaign Leads ' + this.domainResults.length;
                this.mapLeads(origin);
               
          
            })
            .catch((error) => {
                console.log('error is '+ JSON.stringify(error));
            })
        }
        else{
            
                console.log('selected domain ' + this.domvalue);
                filterDomains({category: this.domvalue})
                .then((result) => {
                    console.log('domain results ' + result.length);
                    this.domainResults = result;
                    this.totalLeads ='Campaign Leads ' + this.domainResults.length;
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
           console.log('wired data ' + this.wireData.length);
           
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
            prepLead = [];
            this.haitiLeads = [];
            this.haitiLeads = this.searchResults;
            this.totalLeads = 'Campaign Leads: '+ this.haitiLeads.length;
        }
        else if(datasource == 'depts')
        {   
            this.haitiLeads = this.deptResults;
            this.totalLeads = 'Campaign Leads: '+ this.haitiLeads.length;
           
        }
        else if(datasource == 'domains')
        {
            this.haitiLeads = this.domainResults;
            this.totalLeads = 'Campaign Leads: '+ this.haitiLeads.length;
        }

        console.log('Mapping ' + this.haitiLeads.length);
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
           console.log('Markers to map ' + this.mapMarkers.length);
        }
        catch(error){
            console.log('Map error ' + JSON.stringify(error));
        }
    }
    handleReset(){
        this.mapMarkers = [];
       
        
        const combo = this.template.querySelector('.depcombo');
        const combo2 = this.template.querySelector('.domcombo');
        combo.value = 'Select Department';
        combo2.value = 'Select Domain';
        this.mapLeads('wire');
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