# All deploy jobs on production branches require manual approval [from qa team]

package org

import future.keywords
import data.circleci.config

policy_name["require_manual_approval"]

enable_rule["require_manual_approval"] if data.meta.branch in production_branches

hard_fail["require_manual_approval"] {
    require_manual_approval
}

require_manual_approval = [reason] {
    some workflow, job in config.workflows.[workflow].jobs.[job]
    some context in job.contexts.[context]
    context in deploy_contexts
    job.requires.[_].type == "approval"
    reason := sprintf("%s job in %s workflow uses production context %s. Manual approval required."
        job.name, workflow.name, context)
}

# 

import future.keywords

workflows = {{"name": workflow_name, "jobs": jobs} |
	some workflow in input.workflows[workflow_name]
    jobs := {parsed_job | some job in workflow; parsed_job := parse_job(job)}
}
parse_job(job) = {"name": job} {
	type_name(job) == "string"
}
parse_job(job) = {"name": name, "body": body} {
	type_name(job) == "object"
    body := job[name]
}

# Convert value to aray if it isn't one
to_array(value) := [value] if { not is_array(value) } else := value

deploy_contexts := {"cloudSecrets"}
deploy_context_jobs := {job.name | 
    some job in workflows[_].jobs
    some context in to_array(job.body.context)
    context in deploy_contexts
}

approval_jobs := {{"name": job.name, "workflow": workflow.name} |
	some job in workflows[workflow].jobs
    job.body.type == "approval"
}

# todo:
# 	scope lookup sets to inside comprehension
# 	restrict matches to same workflow
#   add is_deploy_context(job.body.context)
compliant_jobs := {{"name": job.name, "workflow": workflow.name, "approver": approver} | 
	some job in workflows[workflow].jobs
	job.name in deploy_context_jobs
    job.body.requires[_] == approval_jobs[approver].name
}

non_compliant_jobs := {job | 
	cj_names := {job.name | some job in compliant_jobs}
    some job in deploy_context_jobs
    not job in cj_names
}