--[Insomnia]
local m=99970480
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Insomnia
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,1))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(cm.ntcon)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetCode(EFFECT_SUMMON_COST)
	e01:SetOperation(cm.insomnia)
	c:RegisterEffect(e01)
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_SINGLE)
	e02:SetCode(EFFECT_SPSUMMON_COST)
	e02:SetOperation(cm.insomnia2)
	c:RegisterEffect(e02)
	
	--소생
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m+YuL.dif)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--불멸화
	local e2=Effect.CreateEffect(c)
	e2:SetD(m,3)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(spinel.delay)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

--Insomnia
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.insomniacon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_NORMAL+1
end
function cm.insomniacon2(e)
	return e:GetHandler():GetSummonLocation()~=LOCATION_GRAVE
end
function cm.insomnia(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.insomniacon)
	e1:SetValue(1500)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
end
function cm.insomnia2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.insomniacon2)
	e1:SetValue(1500)
	e1:SetReset(RESET_EVENT+0x7f0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
end

--소생
function cm.cfilter(c,e,tp)
	return c:IsSetCard(0xe0a) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() 
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xe0a) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		or not c:IsRace(RACE_SPELLCASTER) end
	if not c:IsRace(RACE_SPELLCASTER) and 
		(not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_SPELLCASTER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	elseif Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	else return false
	end
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_ZOMBIE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end

--불멸화
function cm.rmcfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LSTN("HOG"))
end
function cm.filter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.rmcfilter,1,nil,1-tp)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(RACE_ZOMBIE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
