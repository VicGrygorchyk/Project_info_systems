import { LightningElement,api,track,wire } from 'lwc';
import getResults from '@salesforce/apex/FindRecordsController.getResults';

export default class FindRecords extends LightningElement {
    @api AccountId;
    @api Label;
    @track searchRecords = [];
    @track selectedRecords = [];
    @api required = false;
    @api LoadingText = false;
    @track txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    @track sldsDopdownClass = 'slds-dropdown_length-with-icon-7 slds-dropdown_fluid'
    @track messageFlag = false;
    @api selectedOtherContactsIds = [];
    @api selectedOtherLeadsIds = [];
 
    searchField(event) {
        this.sldsDopdownClass = 'slds-dropdown_length-with-icon-7 slds-dropdown_fluid'
        var currentText = event.target.value;
        var selectedRecIds = [];
        for(let i = 0; i < this.selectedRecords.length; i++){
            selectedRecIds.push(this.selectedRecords[i].recId);
        }
        this.LoadingText = true;
        getResults({value: currentText, selectedRecIds : selectedRecIds, AccountId: this.AccountId })
        .then(result => {
            this.searchRecords= result;
            this.LoadingText = false;
            
            this.txtclassname =  result.length > 0 ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
            if(currentText.length > 0 && result.length == 0) {
                this.messageFlag = true;
            }
            else {
                this.messageFlag = false;
            }

            if(this.selectRecordId != null && this.selectRecordId.length > 0) {
                this.iconFlag = false;
                this.clearIconFlag = true;
            }
            else {
                this.iconFlag = true;
                this.clearIconFlag = false;
            }
        });
        
    }
    
   setSelectedRecord(event) {
        this.sldsDopdownClass = 'slds-dropdown slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click'
        var recId = event.currentTarget.dataset.id;
        var selectName = event.currentTarget.dataset.name;
        var recEmail = event.currentTarget.dataset.email;
        var icon = event.currentTarget.dataset.icon;
        var type = event.currentTarget.dataset.type;
        let newsObject = { 'recId' : recId ,'recName' : selectName, 'recEmail' : recEmail, 'iconName' : icon, 'type' : type };
        if(newsObject.type === 'Lead'){
            this.selectedOtherLeadsIds.push(newsObject.recId);
        } else {
            this.selectedOtherContactsIds.push(newsObject.recId);
        }
        this.selectedRecords.push(newsObject);
        this.txtclassname =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    }

    removeRecord (event){
        let selectRecId = [];
        for(let i = 0; i < this.selectedRecords.length; i++){
            if(event.detail.name !== this.selectedRecords[i].recId)
                selectRecId.push(this.selectedRecords[i]);
        }
        this.selectedRecords = [...selectRecId];
    }
}