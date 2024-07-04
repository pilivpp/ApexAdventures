import { LightningElement, api } from 'lwc';
import fetchCommits from '@salesforce/apex/GitHubCommitsController.fetchCommits';
import labels from './customLabels';

export default class CommitsList extends LightningElement {
    commits;
    selectOptions = [];
    commitsData = [];
    choosenCommit;
    labels = labels;
    detailCommitEvent = 'detailscommit';

    connectedCallback() {
        this.getCommits();
    }

    async getCommits() {
        try {
            const response = await fetchCommits();
            const commits = JSON.parse(response);
            this.commits = commits.map(this.commitWrapper);
            this.selectOptions = this.commits.map(commit => ({
                label: commit.message,
                value: commit.sha
            }));
            await this.buildCommitsInDetails();
        } catch (error) {
            console.log(error);
        }
    }

    commitWrapper(commit) {
        return {
            message: commit.commit.message,
            author: commit.commit.author.name,
            authorEmail: commit.commit.author.email,
            createdDate: commit.commit.author.date,
            sha: commit.sha,
            url: commit.url
        };
    }

    async buildCommitsInDetails() {
        try {
            this.commitsData = this.commits.map(commit => ({
                message: commit.message,
                author: commit.author,
                authorEmail: commit.authorEmail,
                createdDate: commit.createdDate,
                commitId: commit.sha,
                commitUrl: commit.url
            }));
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
        const customEvent = new CustomEvent(this.detailCommitEvent, {
            detail: this.choosenCommit ?? {}
        });
        this.dispatchEvent(customEvent);
    }
}
