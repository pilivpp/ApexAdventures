import { LightningElement } from 'lwc';

export default class GithubViewerContainer extends LightningElement {
    currentStage = 'listOfCommitsStage';
    detailsCommit;

    get listOfCommitsStage() {
        return this.currentStage === 'listOfCommitsStage';
    }

    get commitDetailsStage() {
        return this.currentStage === 'commitDetailsStage';
    }

    handleNextButton() {
        const listComponent = this.template.querySelector('c-github-viewer-list-of-commits');
        listComponent.checkValidity();

        if (this.currentStage === 'listOfCommitsStage' && listComponent.checkValidity()) {
            this.currentStage = 'commitDetailsStage';
        } else {
            this.currentStage = 'listOfCommitsStage';
        }
    }

    handlePreviousButton() {
        if (this.currentStage === 'commitDetailsStage') {
            this.currentStage = 'listOfCommitsStage';
        } else {
            this.currentStage = 'commitDetailsStage';
        }
    }

    handleDetailsCommit(event) {
        this.detailsCommit = event.detail;
    }
}