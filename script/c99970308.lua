--The Book of Truth: Shine
local m=99970308
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--발동
	YuL.Activate(c)

	--덱 조작
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	
	--Truth: Shine
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetOperation(cm.truthop)
	c:RegisterEffect(e3)
	
	--To the Path of Truth
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(cm.Tsetcon)
	e4:SetTarget(cm.Tsettg)
	e4:SetOperation(cm.Tsetop)
	c:RegisterEffect(e4)
	
end

--덱 조작
function cm.filter(c)
	return c:IsSetCard(0xe07) and c:IsAbleToDeck() and c:IsType(YuL.ST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end

--Truth: Shine
function cm.truthop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if Duel.GetAttackTarget()~=nil then return end
	if Duel.Remove(a,POS_FACEDUP,REASON_EFFECT)~=0 then
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
