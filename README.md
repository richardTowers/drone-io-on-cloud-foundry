drone-io-on-cloud-foundry
=========================

This is an experiment into getting [drone/drone](https://github.com/drone/drone) running on Cloud Foundry.

The rough idea is to run the Server as a cloud foundry app, and to run the
Agents in AWS ECS instances on EC2.

The reason we can't run the Agents directly on Cloud Foundry is drone (like
most modern CI tools) requires you to mount the docker socket so it can spin up
new containers - we don't want CF tenants to be able to do that, so we'll have to
give tenants separate VMs to run the Agents on.

