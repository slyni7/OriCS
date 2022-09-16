--Flu:g3L(플뤼겔) BLAST(레이)
local s,id=GetID()
function s.initial_effect(c)
	--Fusion summon procedure
	c:EnableReviveLimit()
	Fusion.AddProcMixRep(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,MACHINE),1,1,aux.FilterBoolFunctionEx(Card.IsRace,RACE_FAIRY))
	--Special Summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--Aternative Special Summon procedure
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.hspcon)
	e2:SetTarget(s.hsptg)
	e2:SetOperation(s.hspop)
	c:RegisterEffect(e2)
	aux.AddUnionProcedure(c,s.unfilter)
	s.eff_ct[c][3]:SetRange(LOCATION_GRAVE+LOCATION_MZONE)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target1)
	e2:SetOperation(s.operation1)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(112604200)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(s.recon)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	--Name becomes "Cyber Dragon" while on the field or in GY
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(112604200)
	c:RegisterEffect(e3)
end
function s.recon(e)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_SZONE)
end

function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if ec==nil or not ec.blast_not_lyrical then
		Duel.Hint(HINT_CARD,0,id)
		Duel.SendtoGrave(c,REASON_RULE)
	end
end

function s.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_THUNDER)
		and (Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND))
end
function s.hspfilter(c,tp,sc)
	return c:IsSetCard(0xe79) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(c:GetControler(),s.hspfilter,1,false,1,true,c,c:GetControler(),nil,false,nil,tp,c)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectReleaseGroup(tp,s.hspfilter,1,1,false,true,true,c,nil,nil,false,nil,tp,c)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
	c:SetMaterial(g)
	g:DeleteGroup()
end
function s.unfilter(c)
	return c:IsSetCard(0xe79) and not c:IsSetCard(0x1e79)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.filter1(c)
	return ((c:IsSetCard(0xe79) and not c:IsSetCard(0x1e79)) or (c:IsCode(112604200))) and c:IsAbleToHand()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end