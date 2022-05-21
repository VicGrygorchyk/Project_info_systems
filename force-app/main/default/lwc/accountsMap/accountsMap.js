import { api, LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountsMapController.getAccounts';
import getSports from '@salesforce/apex/AccountsMapController.getSports';
import uId from '@salesforce/user/Id';

export default class AccountsMap extends LightningElement {
    userId = uId;
    @api recordId;
    @api objectApiName;
    @track range = 5;
    @track mapItems = [];
    @track selectedSport = [];
    @track options = [];

    @wire(getSports, {})
    getSportsPicklistValues({data, error}){
        if (data) {
            for(var i in data){
                const option = {
                    label: data[i],
                    value: data[i]
                };
                this.options = [...this.options, option];
            }

            error = undefined;
        } else if (error) {
            console.log(error);
        }
    };

    handleChange(event) {
        console.log(uId);
        this.selectedSport = event.detail.value;
        this.updateMap();
    }

    openComponent(){
        if(this.mapItems.length === 0){
            this.updateMap();
        }
    }

    rangeChange(event){
        this.range = event.detail.value;
        this.updateMap();   
    }

    updateMap(){
        let newMapItems = [];
        let range;
        if(this.range === ''){
            range = 0;
        } else range = this.range;
        getAccounts({
            // recordId: this.recordId,
            userId: uId,
            maxDistance: range,
            // objectName: this.objectApiName,
            types: this.selectedSport
        }).then(result => {
            for(let i in result){
                newMapItems.push({
                    location: {
                        Street: result[i].ShippingStreet,
                        City: result[i].ShippingCity,
                        Country: result[i].ShippingCountry
                    },
                
                    title: result[i].Name,
                    icon: 'standard:account'
                })
            }
            this.mapItems = newMapItems;
        })
    }


}