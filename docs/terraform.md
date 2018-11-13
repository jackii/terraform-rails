# Terraform by HashiCorp

You would have thought that having a docker image for production, you are ready to deploy the docker for production.
But there is no straight forward way to deploy docker image to the server. Even with container service like AWS EC2
Container Service (ECS) or Fargate, you still need to learn a fair bit (and possibly have to learn other technologies,
such as CloudFormation, CodePipeline etc) to really deploy to AWS.

As quoted by [Phillip Shipley](https://blog.codeship.com/terraforming-your-docker-environment-on-aws/):
"The complexity of the AWS system leads to two problems: The first is that a lot of experience and understanding are
required to properly configure everything, which results in information silos and unhealthy dependency on subject
matter experts. The second problem is that with the cloud, things change at a rapid pace, and attempts to document
processes can be a wasted effort."

This is where Terraform come in handy.3

## Terraform

Terraform is a infrastructure-as-a-code tool to declare your infrastructure with easy to read and write DSL. A tool to
provision and deploy infrastructure.

You can use Terraform CLI to create or update your environment to match what you want it to be, and Terraform will
figure out how to make it so. This is the declarative nature of Terraform.

### Terms

- __variable__ - hold values, it can be strings, lists or maps.
- __provider__ - service provider, such as AWS, Google Cloud, Digital Ocean, Azure
- __state__ - the state of your infrastructure, saved in `xxx.tfstate` file
- __backend__ - used to store `.tfstate` file remotely, e.g. S3 and DynamoDB
- __resource__ - a resource is a piece of infrastructure
- __date resource__ - used to retrieve or generate data, queries only
- __module__ - any folder with `.tf` files, bundle common infrastructure into a module
- __output__ - used to display information or export information from module
- __environment__ - an environment is represented by a state file


References:

- https://blog.codeship.com/terraforming-your-docker-environment-on-aws/
- https://blog.codeship.com/shared-resources-for-your-terraformed-docker-environment-on-aws/
- https://blog.codeship.com/service-resources-for-your-terraformed-docker-environment/

