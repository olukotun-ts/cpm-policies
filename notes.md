# Rego sandbox
convert config.yml to json
`yq '. | tojson' config.yml > config.json`

https://play.openpolicyagent.org/p/EBzD4sscXB

eval: check raw policy
circlecii policy eval . --input config.yml

decide: eval policy against cpm engine
pass $POLICY_PATH to evaluate locally or --owner-id to evaluate against rules pushed to cloud
circleci policy decide [$POLICY_PATH] | [--owner-id $CIRCLE_ORG_ID] --input $CONFIG_FILE

circleci policy decide . --input config.yml

circleci policy push . --owner-id $CIRCLE_ORG_ID --no-prompt

central logging/persist of violations and warnings
    - policy-service decision log
    - ? logs only capture decisions against cloud policies
naming conventions for policy
loading custom helpers and packages

# Orbs
- require latest minor/patch versions of orbs [hard_fail]
- warn/notify if not latest major version of orb [soft_fail]
- {name, namespace, alias, version}
- tier: certified | partner | community
- ? public/private registry api

# Jobs
- cap resource class by branch, executor type/os
    - no xls on feature branches
    - only medium macs allowed
- cap parallelism on feature branches

# Workflows
- branch-protected contexts / restrict list of context patterns to branch patterns {prod: ["deploy-*", "prod-*", "main-*"], stage: ["staging-*", "qa-*"]}
https://circleci.canny.io/cloud-feature-requests/p/context-permissions
- all workflows do (f(x), blocking=true|false)
    - the first job in all workflows is lint | scan | notify

circleci policy eval $PATH_TO_POLICY_FILE_OR_DIR --input $PATH_TO_CONFIG

# CI/CD for policies / policy management
- use GitOps
- no local pushes
- validate opa
- run tests on policies / validate logic
- show diff
    - policies to add
    - policies to remove
- require manual approval
- deploy / push
    - --no-prompt flag
- notify on successful push
    - add diff in body
    - add summary/changelog for policy consumers

# CPM for style guide enforcement
- all workflows start with blocking lint job
- job steps include name and command keys, not just run
- config uses v2.1
- workflows stanza doesn't include version
- no empty workflows
- all executors are defined in executor stanza
- no triggers stanza in workflows
- forbidden commands (printenv, scp)
- ensure timeouts for large resource classes
- enforce unique job names per workflow
- enforce no_unspecified_resource_class
    - enforce vs boilerplate gen
- casing for job, workflow names
- no anchors/aliases / enforce reusable commands, params, orbs
    - no inline orbs
- persist test results after test splitting
- use cache on installs
- warn_defined_but_unused orbs, executors, jobs
https://circleci.canny.io/images/p/be-able-to-set-the-default-resourceclass-in-circleci-enterprise
workflow_not_versioned = reason {
	input.workflows.version
    reason := "Workflow stanza should not include version"
}

https://en.wikipedia.org/wiki/De_Morgan%27s_laws
https://stackoverflow.com/a/58325979