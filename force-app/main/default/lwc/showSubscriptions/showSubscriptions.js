import { LightningElement, track, api, wire } from 'lwc';
import uId from '@salesforce/user/Id';
import getAccounts from '@salesforce/apex/ShowSubscriptionsController.getAccounts';

const columns =[
    { 
        label: 'Name',
        fieldName: 'Url',
        type: 'url',
        typeAttributes: {label: { fieldName: 'Name' }, 
        target: '_blank'},
        sortable: true 
    }
];

export default class ShowSubscriptions extends LightningElement {
    @track data = [];
    columns = columns;

    @wire (getAccounts, {UserId: uId})
    getSubscriptionAccounts({data, error}){
        if(data){
            this.data = data;
        }

        console.log(this.data);
    }
}