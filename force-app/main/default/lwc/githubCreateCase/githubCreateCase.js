import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createCase from '@salesforce/apex/GithubCommitsController.createCase';
import labels from './customLabels';

export default class GithubCreateCase extends LightningElement {
    @api detailsCommit;
    labels = labels;
    success = 'success';
    error = 'error';
    closeModalEvent = 'closemodal'

    handleCreateCase() {
        const commitData = {
            sha: this.detailsCommit.commitId
        };

        createCase({ commitDataJson: JSON.stringify(commitData) })
            .then(caseId => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: `${this.labels.success}`,
                        message: `${this.labels.caseCreatedSuccessfully} ${caseId}`,
                        variant: this.success,
                    })
                );
                this.closeModal();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: `${this.labels.error}`,
                        message: error.body.message,
                        variant: this.error
                    })
                );
            });
    }

    closeModal() {
        const closeEvent = new CustomEvent(this.closeModalEvent);
        this.dispatchEvent(closeEvent);
    }
}