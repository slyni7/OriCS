--[ Nosferatu ]
local m=99970708
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Nosferatu
	local e66=MakeEff(c,"A")
	e66:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e66:SetCode(EVENT_FREE_CHAIN)
	e66:SetCL(1,m+YuL.O)
	WriteEff(e66,66,"TO")
	c:RegisterEffect(e66)
	
	--회수
	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
end

--Nosferatu
function cm.tar66(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function cm.op66fil(c,e,tp)
	return c:IsSetCard(0xe1e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.op66(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,2000,REASON_EFFECT)
	Duel.Recover(p,2000,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(cm.op66fil,tp,LOCATION_HAND,0,nil,e,0,tp,false,false)
	if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	--●자신은 "노스페라투" 몬스터밖에 특수 소환할 수 없다.
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetD(m,1)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	--●자신 필드의 "노스페라투" 몬스터는 상대 효과의 대상이 되지 않는다.
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe1e))
	e0:SetValue(aux.tgoval)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	--●자신의 "노스페라투" 몬스터의 효과의 발동 및 그 발동한 효과는 무효화되지 않는다.
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(cm.effectfilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
end
function cm.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetHandler():IsSetCard(0xe1e) and te:GetHandler():IsType(TYPE_MONSTER)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xe1e)
end

--회수
function cm.tar2fil(c)
	return c:IsFaceup() and c:IsSetCard(0xe1e) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tar2fil(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(cm.tar2fil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tar2fil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
