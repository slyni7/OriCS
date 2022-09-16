FLAG_EFFECT_SCRIPTED=18452823
TYPE_SCRIPTED=0x80000000

function Auxiliary.ScriptedFilter(c)
	local code
	if YGOPRO_VERSION=="Percy/Edo" then
		code=c:Code()
	elseif YGOPRO_VERSION=="Koishi" then
		code=Duel.ReadCard(c,CARDDATA_CODE)
	else
		code=c:GetOriginalCode()
	end
	return c:IsType(TYPE_SCRIPTED) and c:GetFlagEffect(FLAG_EFFECT_SCRIPTED)<1
end

function Auxiliary.ScriptedOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Auxiliary.ScriptedFilter,0,0x7f,0x7f,nil)
	local tc=g:GetFirst()
	while tc do
		local cm=getmetatable(tc)
		cm.initial_effect(tc)
		tc:RegisterFlagEffect(FLAG_EFFECT_SCRIPTED,0,0,0)
		tc=g:GetNext()
	end
end

if YGOPRO_VERSION~="Core" then
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(Auxiliary.ScriptedOperation)
	Duel.RegisterEffect(e1,0)
end