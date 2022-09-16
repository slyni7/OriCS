--클라디스 메이든 헤븐즈 폴
function c95480823.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd52),2,2)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c95480823.disable)
	e1:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25586143,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c95480823.atkcon)
	e2:SetTarget(c95480823.atktg)
	e2:SetOperation(c95480823.atkop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c95480823.sptg)
	e3:SetOperation(c95480823.spop)
	c:RegisterEffect(e3)
end
function c95480823.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT)
	and c:GetSummonLocation()==LOCATION_EXTRA and c~=e:GetHandler() and not e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c95480823.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup()
end
function c95480823.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetLabelObject():CreateEffectRelation(e)
end
function c95480823.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(1-tp) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
	end
end
function c95480823.spfilter(c,e,tp)
	local rk=c:GetRank()
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xd52) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and rk>=8
end
function c95480823.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c95480823.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c95480823.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95480823.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c95480823.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		if c:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
			Duel.Overlay(tc,Group.FromCards(c))
		end
		Duel.SpecialSummonComplete()
	end
end
