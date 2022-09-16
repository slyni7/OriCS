--드바라팔라 오르마즈드
function c95482207.initial_effect(c)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c95482207.val1)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetOperation(c95482207.op3)
	c:RegisterEffect(e3)
	--send to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101106202,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,95482207)
	e4:SetTarget(c95482207.tg4)
	e4:SetOperation(c95482207.op4)
	c:RegisterEffect(e4)
end

function c95482207.val1(e,te)
	if te:GetOwner()==e:GetHandler() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end

function c95482207.op3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1)==0 then return end
	if ep==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then
		local dg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		if dg:GetCount()==0 then return end
		if Duel.SelectYesNo(tp,aux.Stringid(95482207,0)) then
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
			if sg:GetCount()>0 then
				Duel.HintSelection(sg)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end

function c95482207.fil41(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd53) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c95482207.fil42(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingTarget(c95482207.fil41,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c95482207.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c95482207.fil41(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c95482207.fil41,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp)
		and Duel.CheckReleaseGroupEx(tp,c95482207.fil42,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95482207.fil41,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c95482207.fil43(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect() and Duel.GetMZoneCount(tp,c)>0
end
function c95482207.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectReleaseGroupEx(tp,c95482207.fil43,1,1,nil,tp)
	if #g==0 then return end
	Duel.HintSelection(g)
	if Duel.Release(g,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
