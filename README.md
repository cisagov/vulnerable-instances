# Vulnerable Instances 🐞 #

## About ##

This project allows you to create intentionally-vulnerable virtual
machines for testing purposes.

## Requirements ##

* [AWS CLI access
  configured](
  https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
  on your system
* [Terraform installed](
  https://learn.hashicorp.com/terraform/getting-started/install.html)
  on your system
* Access to an Amazon Machine Image (AMI) that will be used for your
  vulnerable instance (if you don't have one, see below for instructions on how
  to create one)

## Getting Started ##

Follow the steps below to get your vulnerable instance(s) up and running.

### Building A Vulnerable AMI ###

If you don't already have one, you will need to create an Amazon Machine Image
(AMI) to be used by your vulnerable instance.  You can create vulnerable Ubuntu
AMI using [our fork](https://github.com/cisagov/metasploitable3) of the
[metasploitable3](https://github.com/rapid7/metasploitable3) repository and
`packer`.  To install `packer` on your system, refer to [these instructions](
https://www.packer.io/intro/getting-started/install.html).

Before building the AMI, ensure that the `region`, `ami_name`, `ami_regions`,
and `tags` are correct in `packer/templates/aws/ubuntu_1404.json`.

To build the AMI, run this command from the root directory of your clone of
[cisagov/metasploitable3](https://github.com/cisagov/metasploitable3):

```bash
packer build packer/templates/aws/ubuntu_1404.json
```

Once that command completes successfully, you should have an AMI available in
your AWS account with a name based on the `ami_name` parameter in
`packer/templates/aws/ubuntu_1404.json`.

### Customizing Your Environment ###

All of the steps below refer to the [cisagov/vulnerable-instances](
https://github.com/cisagov/vulnerable-instances) repository (as opposed to the
[cisagov/metasploitable3](https://github.com/cisagov/metasploitable3)
repository referenced above).

* If you are using a different AMI than the one mentioned above (or if you
  changed its name), update the name `filter` in `terraform/ubuntu1404_ec2.tf`.
* To allow trusted users to SSH to your vulnerable instance, update
  `terraform/scripts/user_ssh_setup.yml` with the usernames and public SSH keys
  of your trusted users.
* Create a terraform variables file to be used for your environment (e.g.
  `production.yml`), based on the variables listed in `terraform/variables.tf`.
  Here is a sample of what that file might look like:

```yaml
aws_region = "us-east-1"

aws_availability_zone = "a"

tags = {
  Team = "CISA Development Team"
  Application = "Vulnerable Instances"
  Workspace = "production"
}

# List the networks that are allowed inbound access to your
# vulnerable instance(s)
# 192.168.1.0/24   Trusted IPv4 network 1
# 192.168.2.0/24   Trusted IPv4 network 2
trusted_ingress_networks_ipv4 = [
  "192.168.1.0/24",
  "192.168.2.0/24"
]

trusted_ingress_networks_ipv6 = [
]
```

### Building Your Environment ###

To create the environment containing the vulnerable instance(s), run the
following terraform commands (replace `<your_workspace>` with a name like
your username or "production"):

```bash
cd terraform

# If you have not created your terraform workspace:
terraform workspace create <your_workspace>

# If you have previously created your terraform workspace:
terraform workspace select <your_workspace>

terraform init
terraform apply -var-file=<your_workspace>.yml
```

### Destroying Your Environment ###

To destroy the environment containing the vulnerable instance(s), run the
following terraform commands:

```bash
cd terraform
terraform workspace select <your_workspace>
terraform destroy -var-file=<your_workspace>.yml
```

## License ##

This project is in the worldwide [public domain](LICENSE.md).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
