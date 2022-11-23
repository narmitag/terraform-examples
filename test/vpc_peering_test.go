package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	//"github.com/stretchr/testify/require"
)

func TestVpcPeering(t *testing.T) {

	vpcOwnerPrefix := "10.10"
	vpcAcceptorPrefix := "10.20"
	awsRegion := "us-east-1"
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../vpc_peering",
		Vars: map[string]interface{}{
			"cidr_prefix-a": vpcOwnerPrefix,
			"cidr_prefix-b": vpcAcceptorPrefix,
		},
	})

	// website::tag::5:: Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::3:: Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::4:: Run `terraform output` to get the values of output variables and check they have the expected values.
	//output := terraform.Output(t, terraformOptions, "hello_world")
	//assert.Equal(t, "Hello, World!", output)
	vpcIdOwner := terraform.Output(t, terraformOptions, "vpc-owner-id")
	vpcIdAccepter := terraform.Output(t, terraformOptions, "vpc-accepter-id")

	vpcOwner := aws.GetVpcById(t, vpcIdOwner, awsRegion)
	vpcAccepter := aws.GetVpcById(t, vpcIdAccepter, awsRegion)

	assert.NotEmpty(t, vpcOwner.Name)
	assert.NotEmpty(t, vpcAccepter.Name)
}
