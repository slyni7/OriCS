--드바라팔라 아흐리만
function c95482208.initial_effect(c)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c95482208.val1)
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
	e3:SetOperation(c95482208.op3)
	c:RegisterEffect(e3)
	--send to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101106202,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,95482208)
	e4:SetTarget(c95482208.tg4)
	e4:SetOperation(c95482208.op4)
	c:RegisterEffect(e4)
end

function c95482208.val1(e,te)
	if te:GetOwner()==e:GetHandler() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end

function c95482208.op3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1)==0 then return end
	if ep==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then
		local dg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if dg:GetCount()==0 then return end
		if Duel.SelectYesNo(tp,aux.Stringid(95482208,0)) then
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
			if sg:GetCount()>0 then
				Duel.HintSelection(sg)
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end

function c95482208.fil41(c)
	return c:IsSetCard(0xd53) and c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function c95482208.fil42(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function c95482208.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.CheckReleaseGroupEx(tp,c95482208.fil41,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c95482208.op4(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.SelectReleaseGroupEx(tp,c95482208.fil41,1,1,nil)
	if g:GetCount()>0 then
		if ct>1 and Duel.SelectYesNo(tp,aux.Stringid(95482208,1)) then
			local sg=Duel.SelectReleaseGroupEx(tp,c95482208.fil42,1,1,nil)
			g:Merge(sg)
			Duel.HintSelection(g)
			local rct1=Duel.Release(g,REASON_EFFECT)
			Duel.Draw(tp,rct1,REASON_EFFECT)
		else
			Duel.HintSelection(g)
			local rct2=Duel.Release(g,REASON_EFFECT)
			Duel.Draw(tp,rct2,REASON_EFFECT)
		end
	end
end

