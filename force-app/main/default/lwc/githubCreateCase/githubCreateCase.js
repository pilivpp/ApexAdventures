import { LightningElement, api } from 'lwc';
import createCase from '@salesforce/apex/GithubCommitsController.createCase';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GithubCreateCase extends LightningElement {
    @api detailsCommit;

    handleCreateCase() {
        const commitData = {
            sha: this.detailsCommit.sha
        };

        createCase({ commitDataJson: JSON.stringify(commitData) })
            .then(caseId => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: `Case created successfully with Id: ${caseId}`,
                        variant: 'success',
                    })
                );
                this.closeModal();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Creating case',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    closeModal() {
        const closeEvent = new CustomEvent('closemodal');
        this.dispatchEvent(closeEvent);
    }
}