import { LightningElement, api } from 'lwc';
import fetchCommits from '@salesforce/apex/GitHubCommitsController.fetchCommits';
import labels from './customLabels';

export default class CommitsList extends LightningElement {
    commits;
    selectOptions = [];
    commitsData = [];
    choosenCommit;
    labels = labels;

    connectedCallback() {
        this.getCommits();
    }

    async getCommits() {
        try {
            const response = await fetchCommits();
            this.commits = JSON.parse(response);
            this.commits.forEach(commit => {
                const option = {
                    label: commit.commit.message,
                    value: commit.sha
                };
                this.selectOptions.push(option);
            });
            await this.buildCommitsInDetails();
        } catch (error) {
            console.log(error);
        }
    }

    async buildCommitsInDetails() {
        try {
            this.commits.forEach(commit => {
                const commitData = {
                    message: commit.commit.message,
                    author: commit.commit.author.name,
                    authorEmail: commit.commit.author.email,
                    createdDate: commit.commit.author.date,
                    commitId: commit.sha,
                    commitUrl: commit.url
                };
                this.commitsData.push(commitData);
            });
        } catch (error) {
            console.log(error);
        }
    }

    handleChangeCommit(event) {
        const selectedCommitId = event.target.value;
        this.choosenCommit = this.commitsData.find(commit => commit.commitId === selectedCommitId);
        const radioInput = this.template.querySelector('lightning-radio-group');
        radioInput.setCustomValidity('');
        radioInput.reportValidity();
        this.pushDetailsOfCommit();
    }

    @api
    checkValidity() {
        if (!this.choosenCommit) {
            const radioInput = this.template.querySelector('lightning-radio-group');
            radioInput.reportValidity();
            return false;
        }
        return true;
    }

    pushDetailsOfCommit() {
        const customEvent = new CustomEvent('detailscommit', {
            detail: this.choosenCommit ?? {}
        })
        this.dispatchEvent(customEvent);
    }
}
