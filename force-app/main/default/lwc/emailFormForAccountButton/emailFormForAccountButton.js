import { LightningElement, track, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import sendEmail from '@salesforce/apex/EmailFormForAccountButtonController.sendEmail';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';

export default class EmailFormForAccountButton extends LightningElement {
    @api recordId;
    @track email = '';
    @api emailBody = '';
    @api subject = '';
    @api selectedEmails = [];
    @track bccEmails = [];
    @api contentdocs = [];
    @api
    send(){
        this.sendEmail();
    }

    @wire(getRecord, { recordId: '$recordId', fields })
    account;

    emailInputChange(event){
        this.email = event.target.value;
    }

    emailBodyChange(event){
        this.emailBody = event.target.value;
    }

    subjectInputChange(event){
        this.subject = event.target.value;
    }

    addEmail(event){
        this.selectedEmails.push(this.email);
        this.bccEmails.push(this.email);
        this.email = '';
    }

    removeBccEmail(event){
        event.preventDefault();
        let bccEmailToDelete = event.currentTarget.dataset.email;
        this.bccEmails.splice(this.bccEmails.findIndex(item => item === bccEmailToDelete), 1);
        this.selectedEmails.splice(this.selectedEmails.findIndex(item => item === bccEmailToDelete), 1);
    }

    sendEmail(){
        let contentDocumentsIds = [];
        let allEmails = [];
        for(let i in this.selectedEmails){
            allEmails.push(this.selectedEmails[i]);
        }
        for(let i in this.contentdocs){
            contentDocumentsIds.push(this.contentdocs[i].Id);
        }
        sendEmail({
            AccountId: this.account.Id,
            emailAdresses: allEmails,
            contentDocumentsIds: contentDocumentsIds,
            subject: this.subject,
            body: this.emailBody
        });
        this.subject = '';
        this.emailBody = '';
        this.selectedEmails = [];
        this.bccEmails = [];
        alert('Email was successfully sent');
    }
}