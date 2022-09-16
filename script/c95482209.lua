--드바라팔라 스라오샤
function c95482209.initial_effect(c)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c95482209.val1)
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
	e3:SetOperation(c95482209.op3)
	c:RegisterEffect(e3)
	--send to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101106202,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,95482209)
	e4:SetTarget(c95482209.tg4)
	e4:SetOperation(c95482209.op4)
	c:RegisterEffect(e4)
end

function c95482209.val1(e,te)
	if te:GetOwner()==e:GetHandler() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function c95482209.fil3(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c95482209.op3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1)==0 then return end
	if ep==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then
		local dg=Duel.GetMatchingGroup(c95482209.fil3,tp,0,LOCATION_EXTRA,nil)
		if dg:GetCount()==0 then return end
		if Duel.SelectYesNo(tp,aux.Stringid(95482209,0)) then
			local tc=dg:RandomSelect(tp,1):GetFirst()
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end

function c95482209.fil41(c,tp)
	return c:IsSetCard(0xd53) and c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect() and Duel.GetMZoneCount(tp,c)>0
end
function c95482209.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,95482200,0xd53,TYPES_TOKEN_MONSTER,2000,2000,6,RACE_ROCK,ATTRIBUTE_LIGHT)
		and Duel.CheckReleaseGroupEx(tp,c95482209.fil41,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c95482209.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectReleaseGroupEx(tp,c95482209.fil41,1,1,nil,tp)
	if #g==0 then return end
	Duel.HintSelection(g)
	if Duel.Release(g,REASON_EFFECT)~=0 and Duel.IsPlayerCanSpecialSummonMonster(tp,95482200,0xd53,TYPES_TOKEN_MONSTER,2000,2000,6,RACE_ROCK,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,95482200)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
