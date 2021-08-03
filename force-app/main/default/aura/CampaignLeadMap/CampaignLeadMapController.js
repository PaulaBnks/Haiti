({
    doInit: function(component, event, helper) {
       
        // Create the action
        var action = component.get("c.getCampaignLead");
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.pins", response.getReturnValue());
                console.log(response.getReturnValue());
                
                var CampaignLeadCount = "Campaign Lead: " + (response.getReturnValue()).length;
                console.log(CampaignLeadCount);
                component.set("v.CampaignLeadCount", CampaignLeadCount);
                
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    jsLoaded : function(component, event, helper) {
        function onMarkerClick(e){             
            component.set('v.singlePin',{});  //resets to {}
	
            var id = e.target.options.alt;
            var latLong = e.target.getLatLng();
         
            if(e.target['_preSpiderfyLatlng']){
                latLong = e.target['_preSpiderfyLatlng']
            }           
            
            map.setView(latLong);   	
            
            var pins = component.get('v.pins');
         
            for(var x=0; x<pins.length;x++){
                if(pins[x].Id == id){
                    component.set('v.singlePin',pins[x]);  			            
                }
			}  
        }
 
        function onlyUnique(value, index, self) { 
            return self.indexOf(value) === index;
        }
 
        function popupHtml(pinName){
            return '<strong>' + pinName + '</strong>';
        }
        

        var map = L.map( 'map', {
          center: [10.0, 5.0],
          minZoom: 2,
          zoom: 2
        });
        
        L.tileLayer(
            'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',{
                attribution: 'ArcGIS'
             }).addTo(map);
        
        component.set("v.map", map);
       	helper.callServer(component,'c.getCampaignLead', function(response){
        	component.set('v.pins',response);  
           
 	
        var myIcon = L.icon({
            iconUrl: $A.get('$Resource.pins') +'/pin24.png',
            iconRetinaUrl:  $A.get('$Resource.pins') +'/pin48.png',
            iconSize: [29, 24],
            iconAnchor: [9, 21],
            popupAnchor: [0, -14]
		});   
            
        	
        
        var markerClusters = L.markerClusterGroup();
             
		for ( var i = 0; i < response.length; ++i ){
            var popup =  response[i].Company + ',' + response[i].City;
			var m = L.marker( [response[i].Latitude__c,response[i].Longitude__c], {icon: myIcon} ).bindPopup( popup );
        	markerClusters.addLayer( m );
		}
             
        map.addLayer( markerClusters );
        component.set("v.map", map);   
        component.set('v.markers', markerClusters); 
                        
        var CampaignLeadCount = "Volunteer Count: " + response.length;
        //console.log(CampaignLeadCount);
        component.set("v.CampaignLeadCount", CampaignLeadCount);   
           
        },{});
    }
})