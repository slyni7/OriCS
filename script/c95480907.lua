--영매후 아야카시
function c95480907.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--scale change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32787239,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c95480907.pcon)
	e1:SetTarget(c95480907.sctg1)
	e1:SetOperation(c95480907.scop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTarget(c95480907.sctg2)
	e2:SetOperation(c95480907.scop2)
	c:RegisterEffect(e2)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.ritlimit)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c95480907.efilter)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c95480907.tgcon)
	e5:SetTarget(c95480907.tgtg)
	e5:SetOperation(c95480907.tgop)
	c:RegisterEffect(e5)
	--material check
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(c95480907.matcon)
	e6:SetOperation(c95480907.matop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_MATERIAL_CHECK)
	e7:SetValue(c95480907.valcheck)
	e7:SetLabelObject(e6)
	c:RegisterEffect(e7)
end
function c95480907.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function c95480907.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(95480907,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c95480907.mfilter(c)
	return not c:IsType(TYPE_RITUAL)
end
function c95480907.valcheck(e,c)
	local g=c:GetMaterial()
	if g:GetCount()>0 and not g:IsExists(c95480907.mfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c95480907.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xd42)
end
function c95480907.sctg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLeftScale()<13 end
end
function c95480907.scop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetLeftScale()>=13 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
end
function c95480907.sctg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLeftScale()<0 end
end
function c95480907.scop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetLeftScale()>=0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(-1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
end
function c95480907.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c95480907.tgcon(e)
	return e:GetHandler():GetFlagEffect(95480907)>0
end
function c95480907.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE)
end
function c95480907.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=tg:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_RULE)
		else Duel.SendtoGrave(tg,REASON_RULE) end
	end
end