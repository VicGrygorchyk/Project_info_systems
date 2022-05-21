import { LightningElement, api, track, wire } from 'lwc';
import getEvents from '@salesforce/apex/SelectEventController.getEvents';

export default class SelectEvent extends LightningElement {
    @api AccountId;
    @api ContactId;
    @api EventId;

    @track options = []; 

    @wire(getEvents, {
        ContactId: '$ContactId', 
        AccountId: '$AccountId'
    })
    setOptions({data, error}){
        if (data) {
            for(var i in data){
                this.options.push({ label: data[i].Subject, value: data[i].Id});
            }
            error = undefined;
        } else if (error) {
            console.log(error);
        }
    }

    handleChange(e) {
        this.EventId = e.detail.value;
    }
}