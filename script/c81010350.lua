--혈조검

function c81010350.initial_effect(c)

	c:EnableReviveLimit()
	
	--xyz summon method
	aux.AddXyzProcedure(c,nil,9,4)
	
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c81010350.splm)
	c:RegisterEffect(e1)
	
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c81010350.alcn)
	e2:SetValue(c81010350.alvl)
	c:RegisterEffect(e2)
	
	--return to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1)
	e3:SetCondition(c81010350.rdcn)
	e3:SetCost(c81010350.rdco)
	e3:SetTarget(c81010350.rdtg)
	e3:SetOperation(c81010350.rdop)
	c:RegisterEffect(e3)
	
	--ATK update
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c81010350.auco)
	e4:SetOperation(c81010350.auop)
	c:RegisterEffect(e4)
	
end

--summon limit
function c81010350.splm(e,se,sp,st)
	return se:GetHandler():IsSetCard(0xca1)
end

--act limit
function c81010350.alcn(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

function c81010350.alvl(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

--return to deck
function c81010350.rdcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end

function c81010350.rdco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function c81010350.rdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end

function c81010350.rdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c81010350.rdvl)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c81010350.rdvl(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		 return dam/2
	else return dam end
end

--ATK update
function c81010350.auco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.CheckLPCost(tp,100)
		and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
		and c:GetFlagEffect(81010350)==0
	end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,2000)/100)
	local t={}
	for i=1,m do
		t[i]=i*100
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.PayLPCost(tp,ac)
	e:SetLabel(ac)
	e:GetHandler():RegisterFlagEffect(81010350,RESET_PHASE+PHASE_END,0,1)
end

function c81010350.auop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
