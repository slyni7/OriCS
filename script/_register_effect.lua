--ver 1.00 by Kasane Ai
if not aux.RegisterEffect then
	aux.RegisterEffect = {}
	RegEff = aux.RegisterEffect
end
if not RegEff then
	RegEff = aux.RegisterEffect
end
--cregeff는 한 번이면 충분하잖아?
local cRegEff=Card.RegisterEffect
function RegEff.CRegEff(c,e,forced,...)
	cRegEff(c,e,forced,...)
end
--table[
local cRegTable={}
function RegEff.AddRegEffTable(code,f)
	
end
--Auxiliary.MetatableEffectCount=true
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	if c:IsStatus(STATUS_INITIALIZING) and Auxiliary.MetatableEffectCount then
		if not mt.eff_ct then
			mt.eff_ct={}
		end
		if not mt.eff_ct[c] then
			mt.eff_ct[c]={}
		end
		local ct=0
		while true do
			if mt.eff_ct[c][ct]==e then
				break
			end
			if not mt.eff_ct[c][ct] then
				mt.eff_ct[c][ct]=e
				break
			end
			ct=ct+1
		end
	end
	cRegEff(c,e,forced,...)
end
