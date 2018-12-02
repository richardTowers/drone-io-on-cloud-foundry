drone-io-on-cloud-foundry
=========================

This is an experiment into getting [drone/drone](https://github.com/drone/drone) running on Cloud Foundry.

The rough idea is to run the Server as a cloud foundry app, and to run the
Agents in AWS ECS instances on EC2.

The reason we can't run the Agents directly on Cloud Foundry is drone (like
most modern CI tools) requires you to mount the docker socket so it can spin up
new containers - we don't want CF tenants to be able to do that, so we'll have to
give tenants separate VMs to run the Agents on.

Running the code
----------------

This is still very much a proof of concept, so it's probably not a good idea to
run any of the code. For completeness though:

There are three components that you need to run:

* The database (which you can run on GOV.UK PaaS using the RDS backing service)
* The server (which you can run on PaaS using a docker container)
* The agents (which can't run on PaaS because they need access to the docker socket, in this case we're running the agents on AWS EC2)

Each component has a script in the `scripts` directory which will deploy the
component. You should definitely read the scripts before you run them because
they depend on external state (like being logged into CF, and having secrets
files on disk).

