[![Codefresh build status]( https://g.codefresh.io/api/badges/pipeline/otter-networks/mooperd%2Fequal-experts%2Fequal-experts?type=cf-2)]( https://g.codefresh.io/public/accounts/otter-networks/pipelines/mooperd/equal-experts/equal-experts)

## Equal Experts Homework

# Overview

This demonstration is intended to show off the CI/CD possibilities of Kubernetes; specifically Review Apps. Review Apps are 'per branch' deployments which are then accessible via their own URL. They are useful as they allow a developer to show their work at any stage to anyone who might be interested. 

As a CI/CD system I chose Codefresh. Mainly because its what I'm playing with at the moment but it does have some cool Kubernetes specific features such as Helm support and the ability to deploy templated YAML without any need for external tooling such as bash. 

# App

The application is a Hello world application with a little extra. If the environment variables `BRANCH` or `THIS_SERVICE` are present in the environment they will be returned when the application are called. This 'branch awareness' can be very useful when orchestrating a fleet of microservices for example.

# Codefresh

The steps in the `codefresh.yaml` should be self explanatory. As a final step the pipeline calls back to Github with the URL where the app is deployed. This URL is then shown in the pull request checks under the 'details' link in the 'Pull Request Environment'

<img width="776" alt="pr-env" src="https://user-images.githubusercontent.com/3006149/49045847-887b2c80-f1d2-11e8-9f02-7fc79f330b81.png">

# Review Apps

Review Apps are created by the CI/CD when new branches are pushed to Github. Review Apps are deployed into their own namespaces which allows easy cleanup with `kubectl delete namespace {{ namespace }}`. This cleanup process is not implemented in this demo but would be fairly trivial to achieve by various methods.

Two pull requests have already been created in homage to 1960's rock bands:

[Jethro Tull](https://github.com/mooperd/equal-experts/pull/3)

[Led Zeppelin](https://github.com/mooperd/equal-experts/pull/4)

The Review Apps for these PRs can be inspected as described in the section above.

'Staging', or at least a deployment of the master branch can be found here:

[http://master.equal-experts.otternetwork.info](http://master.equal-experts.otternetwork.info)

# Kubernetes

Currently, this application is deployed to a Google Cloud GKE cluster. The standard NGINX ingress controller is being used. A wildcard DNS record for `otternetworks.info` is pointing to the ingress controller TCP loadbalancer meaning that no DNS changes are required for spinning up new Review Apps.

Currently there is no provision for a production deploy but one could easily be added. My preferred method would be an simple extra step which is activated by a git tag.




