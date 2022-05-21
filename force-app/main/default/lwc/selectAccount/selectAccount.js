import { LightningElement, api, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/SelectAccountController.getAccounts';

export default class SelectAccount extends LightningElement {
    @api AccountId;
    @api ContactId;
    @track options = [];

    @wire(getAccounts, {ContactId: '$ContactId'})
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
    // 00309000008a2bIAAQ
    
    handleChange(e) {
        console.log(this.AccountId);
        this.AccountId = e.detail.value;
    }
}