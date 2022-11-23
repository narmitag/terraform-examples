package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	//"github.com/stretchr/testify/assert"
)

func TestNatsJetstream(t *testing.T) {

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../nats_jetstream",
	})

	// website::tag::5:: Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::3:: Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::4:: Run `terraform output` to get the values of output variables and check they have the expected values.
	//output := terraform.Output(t, terraformOptions, "hello_world")
	//assert.Equal(t, "Hello, World!", output)
}
