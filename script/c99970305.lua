--The Book of Truth: Integration & Connection
local m=99970305
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	YuL.Activate(c)

	--Truth: Integration
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(cm.truthop_int)
	c:RegisterEffect(e1)
	
	--Truth: Connection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.truthcon_con)
	e2:SetOperation(cm.truthop_con)
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

--Truth: Integration
function cm.truthfil_int(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsType(TYPE_FUSION)
		and c:IsAbleToRemove() and c:GetSequence()>4
end
function cm.truthop_int(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.truthfil_int,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end

--Truth: Connection
function cm.cfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function cm.truthcon_con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.truthfil_con(c)
	return c:IsType(TYPE_LINK) and c:IsAbleToRemove() and c:GetSequence()<5
end
function cm.truthop_con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.truthfil_con,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 then
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
