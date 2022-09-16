--The Book of Truth: Conviction
local m=99970307
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동 + 특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	--Truth: Conviction
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetOperation(cm.truthop)
	c:RegisterEffect(e2)
	
	--To the Path of Truth
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(cm.Tsetcon)
	e3:SetTarget(cm.Tsettg)
	e3:SetOperation(cm.Tsetop)
	c:RegisterEffect(e3)
	
end

--발동 + 특수 소환
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.filter(c,e,sp)
	return c:IsCode(99970301) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local cg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	if cg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=cg:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			Duel.SpecialSummonComplete()
		end
	end
end

--Truth: Conviction
function cm.truthop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ph=Duel.GetCurrentPhase()
	if ph<PHASE_BATTLE_START or ph>PHASE_BATTLE then return end
	if rp~=tp and Duel.NegateActivation(ev)~=0 and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end

--To the Path of Truth
function cm.Tsetcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return e:GetHandler():IsReason(REASON_EFFECT) and rc==e:GetHandler()
end
function cm.Tsettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4
		and Duel.GetDecktopGroup(tp,4):FilterCount(Card.IsSSetable,nil)>0 end
	Duel.SetTargetPlayer(tp)
end
function cm.Tsetfil(c)
	return c:IsSetCard(0xe07) and c:IsType(YuL.ST) and c:IsSSetable()
end
function cm.Tsetop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,4)
	local g=Duel.GetDecktopGroup(p,4)
	if g:GetCount()>0 and g:IsExists(cm.Tsetfil,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:FilterSelect(p,cm.Tsetfil,1,1,nil)
		Duel.SSet(tp,sg)
		Duel.ConfirmCards(1-tp,sg)
		tc=sg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	Duel.ShuffleDeck(p)
end
