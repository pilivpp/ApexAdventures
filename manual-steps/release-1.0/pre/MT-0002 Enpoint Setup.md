# Pre-Deployment Step: Configure APISettings GitHubEndpoint Metadata

## Description
This step involves configuring the GitHubEndpoint custom metadata in Salesforce. This configuration is essential to set up the endpoint for GitHub API interactions.

## Steps
1. Open the Salesforce Setup.
2. Navigate to **Custom Metadata Types**.
3. Select **Manage Records** next to `APISettings`.
4. If `GitHubEndpoint` does not exist, create a new custom metadata record:
   - Click on **New**.
   - Set the **Label** to `GitHubEndpoint`.
   - Ensure **Protected Component** is set to `false`.
   - Add a new value with:
     - **Field**: `Endpoint__c`
     - **Value**: `repos/pilivpp/ApexAdventures/commits?sha=MT-0001`
5. If `GitHubEndpoint` already exists, update the record with the following value:
   - **Field**: `Endpoint__c`
   - **Value**: `repos/pilivpp/ApexAdventures/commits?sha=MT-0001`
6. Save the changes.

## Notes
- Ensure you have the necessary permissions to create or update custom metadata records.
- Verify the accuracy of the endpoint URL, especially the repository name and branch/commit reference.
- Double-check that no other dependencies rely on a different configuration of the `GitHubEndpoint`.
