--크로노이드 하이어라키
local m=95481808
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95481892)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(cm.tar2)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.tar4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
function cm.filter(c,tp)
	return c:IsSetCard(0xd54) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.tar2(e,c)
	return c:IsType(TYPE_EQUIP) or c:GetEquipTarget()~=nil
end
function cm.tfil41(c,e,tp)
	local b1=cm.tfil42(c,e,tp)
	local b2=cm.tfil43(c,tp)
	return c:IsSetCard(0xd54) and c:IsType(TYPE_UNION) and (b1 or b2)
end
function cm.tfil42(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tfil43(c,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.tfil44,tp,LOCATION_MZONE,0,1,nil,c)
end
function cm.tfil44(c,ec)
	return c:IsFaceup() and ec:CheckUnionTarget(c) and aux.CheckUnionEquip(ec,c)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil41,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tfil41,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if cm.tfil42(tc,e,tp) and (not cm.tfil43(tc,tp) or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=Duel.SelectMatchingCard(tp,cm.tfil44,tp,LOCATION_MZONE,0,1,1,nil,tc)
			local sc=sg:GetFirst()
			Duel.Equip(tp,tc,sc)
			aux.SetUnionState(tc)
		end
	end
end