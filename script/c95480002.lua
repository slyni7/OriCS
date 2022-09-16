--외신 슈브라스
function c95480002.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95480002,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,95480002)
	e1:SetCost(c95480002.cost)
	e1:SetTarget(c95480002.target)
	e1:SetOperation(c95480002.operation)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c95480002.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
function c95480002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c95480002.filter(c)
	return c:IsCanOverlay() and ((c:IsSetCard(0xb8) and c:IsType(TYPE_SYNCHRO)) or (c:IsSetCard(0xb7) and c:IsType(TYPE_FUSION)))
end
function c95480002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c95480002.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95480002.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c95480002.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c95480002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
		if tc:IsType(TYPE_SYNCHRO) and tc:IsSetCard(0xb8) then
			local h1=Duel.Draw(tp,1,REASON_EFFECT)
			if h1>0 then
				Duel.ShuffleHand(tp)
				Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
			end
		end
		if tc:IsType(TYPE_FUSION) and tc:IsSetCard(0xb7) then
			Duel.DiscardDeck(tp,1,REASON_EFFECT)
		end
	end
end
function c95480002.atkval(e,c)
	return c:GetOverlayCount()*800
end
