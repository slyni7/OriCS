--무한의 비전술
function c95482013.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:SetCounterLimit(0x1,3)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95482013+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c95482013.activate)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c95482013.ctcon)
	e3:SetOperation(c95482013.ctop)
	c:RegisterEffect(e3)
	--infinity
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26866984,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c95482013.spcost)
	e4:SetTarget(c95482013.sptg)
	e4:SetOperation(c95482013.spop)
	c:RegisterEffect(e4)
end
function c95482013.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	e:GetHandler():AddCounter(0x1,1)
end


function c95482013.ctcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	local tpe=re:GetActiveType()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and (tpe==TYPE_SPELL or tpe==TYPE_QUICKPLAY+TYPE_SPELL) and rc:IsSetCard(0xd40) and e:GetHandler():GetFlagEffect(1)>0
end
function c95482013.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1,1)
end


function c95482013.cfilter(c,tp)
	return c:IsRace(RACE_FAIRY) and (c:IsControler(tp) or c:IsFaceup())
end
function c95482013.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1)>0 and e:GetHandler():IsAbleToGraveAsCost() end
	local ct=e:GetHandler():GetCounter(0x1)
	e:SetLabel(ct)
	e:GetHandler():RemoveCounter(tp,0x1,ct,REASON_COST)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c95482013.setfilter(c)
	return c:IsSetCard(0xd40)and (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_QUICKPLAY+TYPE_SPELL) and c:IsSSetable()
end
function c95482013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return true end
	local cat=CATEGORY_RECOVER
	if ct==3 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,LOCATION_GRAVE)
	end
end
function c95482013.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.Recover(tp,ct*500,REASON_EFFECT)>0 then
		local g2=Duel.GetMatchingGroup(c95482013.setfilter,tp,LOCATION_GRAVE,0,nil)
		if ct>=2 or (ct==3 and g2:GetCount()>0) then
			if ct>=2 and g2:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
				local dg=g2:Select(tp,1,1,nil)
				Duel.HintSelection(dg)
				Duel.SSet(tp,dg)
				Duel.BreakEffect()
			end
			if ct==3 then
				local cc=Duel.Draw(tp,1,REASON_EFFECT)
				if cc==0 then return end
				local dc=Duel.GetOperatedGroup():GetFirst()
				if dc:IsType(TYPE_SPELL) and dc:IsSetCard(0xd40) and dc:IsSSetable()
					and Duel.SelectYesNo(tp,aux.Stringid(95482013,1)) then
					Duel.BreakEffect()
					Duel.ConfirmCards(1-tp,dc)
					Duel.SSet(tp,dc)
					Duel.ShuffleHand(tp)
				end
			end
		end
	end
end
