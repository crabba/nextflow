# nextflow-test
Test scripts for Nextflow on AWS

## nextflow-minimal-test.sh

This test runs the [demo-genomics-workflow-nextflow](https://github.com/wleepang/demo-genomics-workflow-nextflow) Nextflow job from GitHub.  The configuration is defined in the [main.nf](https://github.com/wleepang/demo-genomics-workflow-nextflow/blob/master/main.nf) file in that repo, and does not require any modification.  Data files are read from public sources.  

This test takes approximately 20 minutes to complete; progress and success are monitored in the Batch console.  The submitted job is named `nf-test-YYYYMMDD_HHMMSS`.  You will see one job submitted to the Batch high priority queue, which in turn will submit multiple jobs submitted to the default queue.  Success is defined as the successful completion of the job in the high priority queue.

Prerequisites:
* AWS CLI installed on your local machine
* A CLI named profile giving access to the account with the Nextflow stack.  If only one profile is defined, and is not named, use `default`.

Usage:
* `nextflow-minimal-test.sh <profile> <queue_name> <job_definition>` submits a test job to Batch, using the given named profile in the AWS CLI.  The queue and job names can come from the Batch console, or by running this script with just the profile name, as shown below.
* `nextflow-minimal-test.sh` shows help text
* `nextflow-minimal-test.sh <profile>` shows the available high priority job queue and job definitions for this profile