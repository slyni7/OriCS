--[Insomnia]
local m=99970481
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
	
	--파괴
	local e1=MakeEff(c,"Qo","M")
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+YuL.dif)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)

	--불멸화
	local e2=MakeEff(c,"Qo","G")
	e2:SetD(m,3)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetCode(EVENT_CHAINING)
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

--파괴
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable()
		or not c:IsRace(RACE_SPELLCASTER) end
	if not c:IsRace(RACE_SPELLCASTER) and 
		(not c:IsReleasable() or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_SPELLCASTER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	elseif c:IsReleasable() then
		Duel.Release(c,REASON_COST)
	else return false
	end
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		else Duel.Destroy(tg,REASON_EFFECT) end
	end
end

--불멸화
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return rp==1-tp and loc==LOCATION_GRAVE
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
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end
end
