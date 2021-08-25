import { LightningElement, wire, track } from 'lwc';
import searchLeads from '@salesforce/apex/CampaignLeadMapController.searchLeads';
import getCampaignLead from '@salesforce/apex/CampaignLeadMapController.getCampaignLead';




export default class SearchCampaignLeadMap extends LightningElement {
    searchTerm = '';
    source;
    searchResults;
    haitiLeads;
    wireData;
    error;
    mapVisible = false;
    @track mapMarkers;
    zoomLevel = 7;
    listview = 'visible' ;
    selectedMarkerValue = '';
    totalLeads;

    

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
        console.log('selected '+ this.selectedMarkerValue);
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

        console.log('Mapping ' + JSON.stringify(this.haitiLeads));
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
            

            prepLead.push(pLead);
        });

        console.log('Processed data ' + JSON.stringify( prepLead));

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
            console.log('Markers ' + JSON.stringify(this.mapMarkers));
        }
        catch(error){
            console.log('Map error ' + JSON.stringify(error));
        }
    }

    handleInput(e){
        this.searchTerm = e.detail.value;
        console.log('Received ' + this.searchTerm);
    }
    handleSearch(){     
        this.template.querySelector('lightning-input[data-name="input"]').value = null; 
        searchLeads({ searchTerm: this.searchTerm})
            .then((result) => {
                this.searchResults = result;
                this.error = undefined;                
                console.log('Got search results ' + JSON.stringify( this.searchResults));
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