--네모의 꿈
local m=18452818
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","S")
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","S")
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(cm.tar3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e5)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then
		return
	end
	local sg=Group.CreateGroup()
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		local att=1
		while bit.band(0x7f,att)~=0 do
			local ag=g:Filter(Card.IsAttribute,nil,att)
			local ac=ag:GetCount()
			if ac>1 then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
				local dg=ag:Select(p,ac-1,ac-1,nil)
				sg:Merge(dg)
			end
			att=att*2
		end
	end
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_RULE)
		Duel.Readjust()
	end
end
function cm.tfil3(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function cm.tar3(e,c,sump,sumtype,sumpos,targetp)
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then
		return false
	end
	local tp=sump
	if targetp then
		tp=targetp
	end
	return Duel.IsExistingMatchingCard(cm.tfil3,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute())
end