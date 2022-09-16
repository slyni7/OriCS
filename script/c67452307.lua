--사이플루이드 레이저
function c67452307.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c67452307.tar2)
	e2:SetValue(700)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetDescription(aux.Stringid(67452307,0))
	e3:SetCost(c67452307.cost3)
	e3:SetTarget(c67452307.tar3)
	e3:SetOperation(c67452307.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(67452307,1))
	e4:SetCondition(c67452307.con4)
	e4:SetCost(c67452307.cost4)
	e4:SetTarget(c67452307.tar4)
	e4:SetOperation(c67452307.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(c67452307.cost5)
	e5:SetOperation(c67452307.op5)
	c:RegisterEffect(e5)
end
function c67452307.tar2(e,c)
	return c:IsSetCard(0x2db)
end
function c67452307.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,700)
	else
		Duel.PayLPCost(tp,700)
	end
end
function c67452307.tfil31(c)
	return c:IsFaceup() and c:IsSetCard(0x2db)
end
function c67452307.tfil32(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x2db)
end
function c67452307.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67452307.tfil31(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c67452307.tfil31,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(c67452307.tfil32,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c67452307.tfil31,tp,LOCATION_MZONE,0,1,1,nil)
end
function c67452307.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c67452307.tfil32,tp,LOCATION_DECK,0,1,1,nil)
		local ec=g:GetFirst()
		if ec then
			Duel.Equip(tp,ec,tc)
		end
	end
end
function c67452307.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<1
end
function c67452307.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,RESAON_COST)
end
function c67452307.tfil4(c,e,tp)
	return c:IsSetCard(0x2db) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetAttack()>Duel.GetLP(tp)
end
function c67452307.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c67452307.tfil4,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c67452307.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67452307.tfil4,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c67452307.cfil5(c,tp)
	return c:IsSetCard(0x2db) and c:IsAbleToRemoveAsCost() and c:GetAttack()>Duel.GetLP(tp)
end
function c67452307.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c67452307.cfil5,tp,LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c67452307.cfil5,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetAttack())
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c67452307.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,e:GetLabel())
end