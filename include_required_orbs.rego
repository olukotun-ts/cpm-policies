package org

import future.keywords
import data.circleci.config

policy_name["include_required_orbs"]

enable_rule["include_required_orbs"]

hard_fail["include_required_orbs"] 
# hard_fail["include_required_orbs"] {
#     include_required_orbs
# }

include_required_orbs = config.require_orbs(required_orbs)

required_orbs := ["circleci/node", "circleci/python"]
