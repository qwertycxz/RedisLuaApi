local decode = require'cjson'.decode
io.input('../data/resp2_replies.json')
local resp2 = {}
for k, v in pairs(decode(io.read('a'))) do
	for i, w in ipairs(v) do
		local match = w:match('%[.*%]%(')
		if match then
			if resp2[match] then
				table.insert(resp2[match], k)
			else
				resp2[match] = {k}
			end
		end
	end
end
print(resp2)