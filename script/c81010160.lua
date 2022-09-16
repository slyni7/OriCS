--MMJ : Oni-tengu
function c81010160.initial_effect(c)
	
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEASTWARRIOR),6,3,c81010160.ovfilter,aux.Stringid(81010160,0),3,c81010160.xyzop)
	c:EnableReviveLimit()
	
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c81010160.alvl)
	e1:SetCondition(c81010160.alcon)
	c:RegisterEffect(e1)
	
	--to remove + damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010160,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c81010160.rmco)
	e2:SetTarget(c81010160.rmtg)
	e2:SetOperation(c81010160.rmop)
	c:RegisterEffect(e2)
	
	--ATK update + disable activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81010160,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c81010160.atkcn)
	e3:SetTarget(c81010160.atktg)
	e3:SetOperation(c81010160.atkop)
	c:RegisterEffect(e3)
	
end

--xyz summon
function c81010160.xyzcofilter(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsType(TYPE_MONSTER)
		and c:IsDiscardable()
end
function c81010160.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (c:GetRank()==4 or c:GetRank()==5) 
		and c:IsRace(RACE_BEASTWARRIOR) and c:IsCanBeXyzMaterial(xyzc)
end
function c81010160.xyzop(e,tp,chk)
	if chk==0 then 
		return Duel.GetFlagEffect(tp,81010160)==0
		and Duel.IsExistingMatchingCard(c81010160.xyzcofilter,tp,LOCATION_HAND,0,1,nil) 
	end
	Duel.DiscardHand(tp,c81010160.xyzcofilter,1,1,REASON_COST,nil)
	Duel.RegisterFlagEffect(tp,81010160,RESET_PHASE+PHASE_END,0,1)
	return true
end


--act limit (e1)
function c81010160.alvl(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c81010160.alcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end


--remove + damage (e2)
function c81010160.rmco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

function c81010160.rmtgfilter(c)
	return c:IsAbleToRemove()
end
function c81010160.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return e:GetHandler():GetFlagEffect(81010160)==0 
		and chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD)
		and c81010160.rmtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81010160.rmtgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c81010160.rmtgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end

function c81010160.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,600,REASON_EFFECT)
	end
end


--ATK update + disable activate
function c81010160.atkcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xca1)
end
function c81010160.atktgfilter(c)
   return c:IsSetCard(0xca1) and c:IsAbleToRemove()
end
function c81010160.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) 
		and c81010160.atktgfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c81010160.atktgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c81010160.atktgfilter,tp,LOCATION_GRAVE,0,nil) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c81010160.chlimit)
end
function c81010160.chlimit(e,ep,tp)
	return tp==ep
end

function c81010160.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81010160.atktgfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()<1 then return end
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local c=e:GetHandler()
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(ct*500)
		c:RegisterEffect(e1)
	end
end

