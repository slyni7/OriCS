EFFECT_CANNOT_LEAVE_FIELD_RULE=9990007
function Auxiliary.LeaveFieldRuleFilter(c)
	return not c:IsHasEffect(EFFECT_CANNOT_LEAVE_FIELD_RULE)
end
local dstg=Duel.SendtoGrave
function Duel.SendtoGrave(g,r)
	if r&REASON_RULE>0 then
		local tg=nil
		if Auxiliary.GetValueType(g)=="Card" then
			tg=Group.FromCards(g)
		else
			tg=g:Clone()
		end
		local sg=tg:Filter(Auxiliary.LeaveFieldRuleFilter,nil)
		return dstg(sg,r)
	else
		return dstg(g,r)
	end
end
local drmv=Duel.Remove
function Duel.Remove(g,pos,r)
	if r&REASON_RULE>0 then
		local tg=nil
		if Auxiliary.GetValueType(g)=="Card" then
			tg=Group.FromCards(g)
		else
			tg=g:Clone()
		end
		local sg=tg:Filter(Auxiliary.LeaveFieldRuleFilter,nil)
		return drmv(sg,pos,r)
	else
		return drmv(g,pos,r)
	end
end