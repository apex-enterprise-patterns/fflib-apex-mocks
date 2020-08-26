import rs from "rs-cdk";
import hub from 'rs-cdk/accounts/hub';

const app = new rs.core.App({
    billing: rs.core.BillingTags.GLOBAL,
    name: 'salesforce-apex-mocks'
});

const stack = new rs.core.Stack(app, `${app.repo.name}-cicd`, {
  env: hub.cicd
})

new rs.cicd.PRBuild(stack, "PRBuild", { repo: app.repo });
