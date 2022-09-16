EFFECT_ADD_CUSTOM_TYPE				=0x1000
EFFECT_REMOVE_CUSTOM_TYPE			=0x1001

Card.auxCustomType=true

function Card.GetOriginalCustomType(c)
	if c.GetOriginalCustomType ~= Card.GetOriginalCustomType then return c.GetOriginalCustomType(c) end
	if c.custom_type then return c.custom_type end
	return 0
end
function Card.IsOriginalCustomType(c,val)
	return c:GetOriginalCustomType() & val == val
end
function Card.GetCustomType(c)
	if ASSUME_CUSTOMTYPE and Card.GetAssumeProperty and c:GetAssumeProperty(ASSUME_CUSTOMTYPE)~=nil then
		return c:GetAssumeProperty(ASSUME_CUSTOMTYPE)
	end
	local t = c:GetOriginalCustomType()
	local eset = {}
	for _,te in ipairs({c:IsHasEffect(EFFECT_CHANGE_TYPE)}) do
		table.insert(eset,te)
	end
	if EFFECT_ADD_CUSTOM_TYPE then for _,te in ipairs({c:IsHasEffect(EFFECT_ADD_CUSTOM_TYPE)}) do
		table.insert(eset,te)
	end end
	if EFFECT_REMOVE_CUSTOM_TYPE then for _,te in ipairs({c:IsHasEffect(EFFECT_REMOVE_CUSTOM_TYPE)}) do
		table.insert(eset,te)
	end end
	table.sort(eset,function(e1,e2) return e1:GetFieldID()<e2:GetFieldID() end)
	local ChangeCustomType = {
		[EFFECT_CHANGE_TYPE] = function(t,v) return 0 end
	}
	if EFFECT_ADD_CUSTOM_TYPE then ChangeCustomType[EFFECT_ADD_CUSTOM_TYPE] = function(t,v) return t | v end end
	if EFFECT_REMOVE_CUSTOM_TYPE then ChangeCustomType[EFFECT_REMOVE_CUSTOM_TYPE] = function(t,v) return t & ~v end end
	for _,te in ipairs(eset) do
		local v = te:GetValue()
		if type(v)=="function" then v = v(te,c) end
		t = ChangeCustomType[te:GetCode()](t,v)
	end
	return t
end
function Card.IsCustomType(c,val)
	return c:GetCustomType() & val == val
end