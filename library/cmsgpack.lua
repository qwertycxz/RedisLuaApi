---@meta
---@alias msgpack boolean | number | string | msgpack[] | {[string]: msgpack}
---[cmsgpack library](https://redis.io/docs/latest/develop/interact/programmability/lua-api#cmsgpack-library)
---* Since version: 2.6.0
---* Available in scripts: yes
---* Available in functions: yes
---
---The _cmsgpack_ library provides fast [MessagePack](https://msgpack.org/index.html) encoding and decoding from Lua.
---It provides these functions.
---@class cmsgpack
cmsgpack = {
	---@type string
	_COPYRIGHT = '',
	_DESCRIPTION = 'MessagePack C implementation for Lua',
	_NAME = 'cmsgpack',
	---@type string
	_VERSION = '',
	---[cmsgpack.pack](https://github.com/antirez/lua-cmsgpack#user-content-usage)
	---
	---Pack any number of lua objects into one msgpack stream.
	---@param ... any
	---@return string
	---@nodiscard
	pack = function(...) end,
	---[cmsgpack.unpack](https://github.com/antirez/lua-cmsgpack#user-content-usage)
	---
	---Unpack all objects in msgpack to individual return values.
	---@param msgpack string
	---@return msgpack ...
	---@nodiscard
	unpack = function(msgpack) end,
	---[cmsgpack.unpack_one](https://github.com/antirez/lua-cmsgpack#user-content-usage)
	---
	---Unpacks the first object after offset.
	---@param msgpack string
	---@param offset number? mush be unsigned
	---@return integer, msgpack?
	unpack_one = function(msgpack, offset) end,
	---[cmsgpack.unpack_limit](https://github.com/antirez/lua-cmsgpack#user-content-usage)
	---
	---Unpacks the first `limit` objects and returns: offset, object1, objet2, ..., objectN (up to limit, but may return fewer than limit if not that many objects remain to be unpacked)
	---@param msgpack string
	---@param limit number must be unsigned
	---@param offset number? mush be unsigned
	---@return integer, msgpack ...
	unpack_limit = function(msgpack, limit, offset) end,
}