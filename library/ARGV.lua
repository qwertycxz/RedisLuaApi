---@meta
---[The ARGV global variable](https://redis.io/docs/latest/develop/interact/programmability/lua-api#the-argv-global-variable)
---* Since version: 2.6.0
---* Available in scripts: yes
---* Available in functions: no
---
---The _ARGV_ global variable is available only in [ephemeral scripts](https://redis.io/docs/latest/develop/interact/programmability/eval-intro).
---It is pre-populated with all regular input arguments.
---@type string[]
ARGV = {}
