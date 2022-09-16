--[ Lava Golem ]
local m=99970716
local cm=_G["c"..m]
function cm.initial_effect(c)

	--서치 / 통상 소환 제약
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e0,0,"NO")
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e3)
	
	--공수 증가
	local e1=MakeEff(c,"F","F")
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(cm.tar1)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	
	--특수 소환
	local e5=MakeEff(c,"Qo","F")
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCL(1)
	WriteEff(e5,5,"CTO")
	c:RegisterEffect(e5)
	
end

--서치 / 통상 소환 제약
function cm.con0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
end
function cm.op0fil(c)
	return c:IsLavaGolemCard() and c:IsAbleToHand()
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.op0fil,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

--공수 증가
function cm.tar1(e,c)
	return c:IsLavaGolem() and c:IsFaceup()
end

--특수 소환
function cm.cost5fil(c,ft,tp)
	return c:IsReleasable() and (ft>0 or c:IsInMainMZone(1-tp))
end
function cm.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(cm.cost5fil,tp,0,LOCATION_MZONE,1,nil,ft,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cost5fil,tp,0,LOCATION_MZONE,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function cm.tar5fil(c,e,tp)
	return c:IsLavaGolemCard() and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,1-tp)
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(cm.tar5fil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tar5fil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,1-tp,true,false,POS_FACEUP)
	end
end
