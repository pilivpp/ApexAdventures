import { LightningElement } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import labels from './customLabels';

const STAGES = {
    LIST_OF_COMMITS_STAGE_STAGE: 'listOfCommitsStage',
    COMMIT_DETAILS_STAGE: 'commitDetailsStage',
    CASE_STAGE: 'caseStage',
};

export default class GithubViewerContainer extends LightningElement {
    currentStage = STAGES.LIST_OF_COMMITS_STAGE;
    detailsCommit;
    labels = labels;

    get listOfCommitsStage() {
        return this.currentStage === STAGES.LIST_OF_COMMITS_STAGE;
    }

    get commitDetailsStage() {
        return this.currentStage === STAGES.COMMIT_DETAILS_STAGE;
    }

    get caseStage() {
        return this.currentStage === STAGES.CASE_STAGE;
    }

    handleNextButton() {
        const listComponent = this.template.querySelector('c-github-viewer-list-of-commits');

        if (this.currentStage === STAGES.LIST_OF_COMMITS_STAGE && listComponent.checkValidity()) {
            this.currentStage = STAGES.COMMIT_DETAILS_STAGE;
        } else if (this.currentStage === STAGES.COMMIT_DETAILS_STAGE) {
            this.currentStage = STAGES.CASE_STAGE;
        }
    }

    handlePreviousButton() {
        if (this.currentStage === STAGES.COMMIT_DETAILS_STAGE) {
            this.currentStage = STAGES.LIST_OF_COMMITS_STAGE;
        } else if (this.currentStage === STAGES.CASE_STAGE) {
            this.currentStage = STAGES.COMMIT_DETAILS_STAGE;
        }
    }

    handleDetailsCommit(event) {
        this.detailsCommit = event.detail;
    }

    handleCloseModal() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}
