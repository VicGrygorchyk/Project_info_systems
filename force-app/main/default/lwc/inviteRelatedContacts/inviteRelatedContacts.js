import { LightningElement, api, wire, track } from 'lwc';
import getRelatedContacts from '@salesforce/apex/InviteRelatedContactsController.getRelatedContacts';

export default class InviteRelatedContacts extends LightningElement {
    @api AccountId;
    @api selectedContactsIds = [];
    @track options = [];

    @wire(getRelatedContacts, {AccountId: '$AccountId'})
    setOptions({data, error}){
        if (data) {
            for(var i in data){
                this.options.push({ label: data[i].Name, value: data[i].Id});
            }
            error = undefined;
        } else if (error) {
            console.log(error);
        }
    }
    // 0010900000D0yTfAAJ
    
    handleChange(e) {
        this.selectedContactsIds = e.detail.value;
    }

}