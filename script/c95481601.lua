--로타이니 스트레지아
function c95481601.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0xd4f),aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),2,2,true)
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c95481601.matcheck)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95481601,0))
	e2:SetCountLimit(1,95481601)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(c95481601.condition)
	e2:SetTarget(c95481601.target)
	e2:SetOperation(c95481601.operation)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--position change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95481601,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,95481699)
	e3:SetTarget(c95481601.postg)
	e3:SetOperation(c95481601.posop)
	c:RegisterEffect(e3)
end

function c95481601.matcheck(e,c)
	local ct=c:GetMaterial():Filter(Card.IsRace,nil,RACE_SPELLCASTER):GetClassCount(Card.GetCode)
	e:SetLabel(ct)
end
function c95481601.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c95481601.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() end
	local ct=e:GetLabelObject():GetLabel()
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) and ct>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c95481601.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then 
		Duel.SendtoGrave(rg,REASON_EFFECT)
	end
end

function c95481601.posfilter(c)
	return c:IsFacedown()
end
function c95481601.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c95481601.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c95481601.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c95481601.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95481601.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c95481601.posfilter(c)
	return c:IsFacedown() and c:IsSetCard(0xd4f)
end
function c95481601.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		local tg=Duel.GetMatchingGroup(c95481601.posfilter,tp,LOCATION_MZONE,0,nil)
		if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95481601,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local sg=tg:Select(tp,1,7,nil)
			Duel.ChangePosition(sg,POS_FACEUP_DEFENSE)
		end
	end
end

