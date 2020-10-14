#! /bin/bash

HIGH_PRIORITY_QUEUE_NAME='highpriority'
COMMAND='wleepang/demo-genomics-workflow-nextflow'

usage() {
    echo "Usage:" `basename "$0"` " <profile> <queue-name> <job-definition>"
    echo "      " `basename "$0"` " <profile> to display available queues and job definitions for this profile"
}

display_high_priority_queues() {
    echo "----  High priority queue names matching '${HIGH_PRIORITY_QUEUE_NAME}' for profile ${1}:  ----"
    aws --profile $1 batch describe-job-queues | grep jobQueueName | grep $HIGH_PRIORITY_QUEUE_NAME | awk -F \" '{print $4}'
    echo "--------------------------------------------------------------"    
}

display_job_definitions() {
    echo "----  Active job definition names for profile ${1}:  ----"
    aws --profile $1 batch describe-job-definitions  --status ACTIVE | grep jobDefinitionName | grep -i nextflow  | awk -F \" '{print $4}'
    echo "--------------------------------------------------------------"    
}

check_high_priority_queue() {
    num_queues=`aws --profile $1 batch describe-job-queues --job-queues $2 | grep ENABLED | wc -l`
    if [[ num_queues -ne 1 ]]
    then
        echo "ERROR: No single enabled queue named ${2} for profile ${1}"
        usage
        exit 1
    fi
}

check_job_definition() {
    num_job_definitions=`aws --profile $1 batch describe-job-definitions --job-definition-name $2 | grep jobDefinitionArn | wc -l`
    if [[ num_job_definitions -ne 1 ]]
    then
        echo "ERROR: No single job definition named ${2} for profile ${1}"
        usage
        exit 1
    fi
}

if [[ $# == 1 ]]
then
    usage
    display_high_priority_queues $1
    display_job_definitions $1
    exit 1
fi

if [[ $# == 3 ]]
then
    check_high_priority_queue $1 $2
    check_job_definition $1 $3
    job_name='nf-test-'`date +%Y%m%d_%H%M%S`
    cmd="aws --profile $1 batch submit-job --job-name ${job_name} --job-queue ${2} --job-definition ${3} --container-overrides command=${COMMAND}"
    echo $cmd
    echo "Submitting job name: ${job_name}"
    $cmd
else
    usage
    exit 1
fi
