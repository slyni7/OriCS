--블루아카이브

kaos={}
Kaos=kaos



--Arcaea 코스트
function kaos.Arcaeacost(e,tp,eg,ep,ev,re,r,rp,chk)
   local g=Duel.GetDecktopGroup(1-tp,1)
   if chk==0 then return g:GetCount()>0 
   end
   Duel.DisableShuffleCheck()
   Duel.SendtoDeck(g,nil,-2,REASON_COST)
end


--융합 소환에 성공했을
function kaos.fusioncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

--의식 소환에 성공했을
function kaos.ritualcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end

--싱크로 소환에 성공했을
function kaos.synchrocon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

--엑시즈 소환에 성공했을
function kaos.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

--펜듈럼 소환에 성공했을
function kaos.pendulumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end

--링크 소환에 성공했을
function kaos.linkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end



--패의 이 카드를 버리고 발동할 수 있다.
function kaos.hdco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end



--패를 1장 버리고 발동할 수 있다.
function kaos.onecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

--이 카드의 엑시즈 소재를 1개 제거하고 발동할 수 있다.
function kaos.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end


--하이랜더
function kaos.highlandercon(location)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		local g=Duel.GetMatchingGroup(Card.IsType,tp,location,0,nil,nil)
		return g:GetCount()>=0 and g:GetClassCount(Card.GetCode)==g:GetCount()
	end
end



--발동 시 효과가 없는 영속마함
function kaos.spell(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
end

--덱에 편성할 수 없다
function kaos.cannoteditdeck(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_DECK+LOCATION_HAND)
	e0:SetCountLimit(1,c:GetOriginalCode()+EFFECT_COUNT_CODE_DUEL)
	e0:SetCondition(kaos.cannoteditdeckcon)
	e0:SetOperation(kaos.cannoteditdeckop)
	c:RegisterEffect(e0)
end
function kaos.cannoteditdeckcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==1
end
function kaos.cannoteditdeckop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_THE_DECK=0x71
	Duel.Win(1-tp,WIN_REASON_THE_DECK)
end


--ERiS
--BLiTz 초대형 비클 분리
function kaos.blitzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end



--매지컬 디폴트 이클립스
function kaos.mgdfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end



--Project Noël
--☆ 펜듈럼 리미트
function kaos.stelimit(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(kaos.stelight)
	c:RegisterEffect(e2)
end
function kaos.stelight(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xe80) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end



--A.I 의식 마법 묘지 제외
function kaos.AlostIsnowhere(c)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,c:GetOriginalCode()+EFFECT_COUNT_CODE_DUEL)
	e4:SetCost(kaos.aicost)
	e4:SetTarget(kaos.aitg)
	e4:SetOperation(kaos.aiop)
	c:RegisterEffect(e4)
end
function kaos.aifilter(c)
	return c:IsRace(RACE_THUNDER) and c:IsAbleToRemoveAsCost()
end
function kaos.aicost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(kaos.aifilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,kaos.aifilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function kaos.aitg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function kaos.aiop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end



--StarsisQ 소생
function kaos.starsisQ(c)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(c:GetOriginalCode(),2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(kaos.stqtg)
	e5:SetOperation(kaos.stqop)
	c:RegisterEffect(e5)
end
function kaos.stqfilter(c,e,tp)
	return c:IsSetCard(0xe81) and not c:IsCode(c:GetOriginalCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function kaos.stqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and kaos.stqfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(kaos.stqfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,kaos.stqfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function kaos.stqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end



--MiLK
--듀얼 개시 제외
function kaos.milkgamestart(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_DISABLE_CHAIN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(3,c:GetOriginalCode()+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetTarget(kaos.milktg)
	e1:SetOperation(kaos.milkop)
	c:RegisterEffect(e1)
end
function kaos.milktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function kaos.milkop(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
		if e:GetHandler():IsPreviousLocation(LOCATION_HAND) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end



--리미트
function kaos.milklimit(c)
	--limit
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetCode(EFFECT_CANNOT_SUMMON)
	ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	ea:SetRange(LOCATION_REMOVED)
	ea:SetTargetRange(1,0)
	ea:SetCondition(kaos.milkcon)
	ea:SetTarget(kaos.milklim)
	c:RegisterEffect(ea)
	--splimit
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_FIELD)
	eb:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	eb:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	eb:SetRange(LOCATION_REMOVED)
	eb:SetTargetRange(1,0)
	eb:SetCondition(kaos.milkcon)
	eb:SetTarget(kaos.milklim)
	c:RegisterEffect(eb)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(kaos.milkop2)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
end
function kaos.milkcon(e)
	return not e:GetHandler():IsForbidden()
end
function kaos.milklim(e,c)
	return not c:IsSetCard(0xe88)
end
function kaos.milkop2(e,c)
	return c:IsType(TYPE_EFFECT) and not c:IsSetCard(0xe88)
end


--Sin
--자체 특소
function kaos.sincon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

--서치류
function kaos.sincos(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT<1 then
		return false
	end
	local rc=re:GetHandler()
	return rc:IsSetCard(0xe86)
end



--cos
--Sin 회수
function kaos.Sinreturn(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,c:GetOriginalCode())
	e1:SetCost(kaos.coscost)
	e1:SetTarget(kaos.costg)
	e1:SetOperation(kaos.cosop)
	c:RegisterEffect(e1)
end
function kaos.coscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and c:GetFlagEffect(c:GetOriginalCode())==0 end
	c:RegisterFlagEffect(c:GetOriginalCode(),RESET_CHAIN,0,1)
end
function kaos.cosfilter(c)
	return c:IsSetCard(0xe85) and c:IsFaceup() and c:IsAbleToHand()
end
function kaos.costg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and kaos.cosfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(kaos.cosfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,kaos.cosfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function kaos.cosop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end



--특소 성공
function kaos.coscon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0xe86)
end



--tan sin 특소
function kaos.Sinsp(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_HAND)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(kaos.tancost)
	e0:SetTarget(kaos.tantg)
	e0:SetOperation(kaos.tanop)
	c:RegisterEffect(e0)
end
function kaos.tancost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function kaos.tanfilter(c,e,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsSetCard(0xe85) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function kaos.tantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(kaos.tanfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function kaos.tanop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(kaos.tanfilter),tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end



--아다만트
--마함 세트 가능
function kaos.adamant(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MONSTER_SSET)
	e0:SetValue(TYPE_SPELL)
	c:RegisterEffect(e0)
end



--묘지 세트
function kaos.admtgrave(c)
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(c:GetOriginalCode(),1))
	ea:SetRange(LOCATION_GRAVE)
	ea:SetType(EFFECT_TYPE_QUICK_O)
	ea:SetCode(EVENT_FREE_CHAIN)
	ea:SetCondition(aux.exccon)
	ea:SetCountLimit(1,c:GetOriginalCode())
	ea:SetValue(TYPE_SPELL)
	ea:SetCost(kaos.admtcost)
	ea:SetTarget(kaos.admttg)
	ea:SetOperation(kaos.admtop)
	c:RegisterEffect(ea)
end
function kaos.admtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function kaos.admttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function kaos.admtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end



--Neverwor!D
--네버월드 자괴
function kaos.neverworld(c)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(c:GetOriginalCode(),5))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(kaos.nvcon)
	e4:SetTarget(kaos.nvtg)
	e4:SetOperation(kaos.nvop)
	c:RegisterEffect(e4)
end
function kaos.nvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function kaos.nvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function kaos.nvop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end


--C1tYPop(나이트 스케이프)
--특소
--spsummon1
function kaos.C1tYPop(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(kaos.c1tyspcon1)
	e1:SetTarget(kaos.c1tysptg1)
	e1:SetOperation(kaos.c1tyspop1)
	c:RegisterEffect(e1)
end
function kaos.c1tycfilter1(c)
	return c:IsCode(112601198)
end
function kaos.c1tyspcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(kaos.c1tycfilter1,tp,0,LOCATION_ONFIELD,1,nil)
end
function kaos.c1tysptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function kaos.c1tyspop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end


--묘지로 보낸다
function kaos.UNEVER(c)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetDescription(aux.Stringid(c:GetOriginalCode(),1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(kaos.UNEVERcon)
	e4:SetTarget(kaos.UNEVERtg)
	e4:SetOperation(kaos.UNEVERop)
	c:RegisterEffect(e4)
end
function kaos.UNEVERcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function kaos.UNEVERtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function kaos.UNEVERop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end

-- 리미트
function kaos.EVERWORLD(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(kaos.sumlimit)
	c:RegisterEffect(e3)
end
function kaos.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA)
end


--　 효과 트리거
function kaos.ksrgcon1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 
	and e:GetHandler():IsPreviousLocation(LOCATION_MZONE) 
	and e:GetHandler():GetPreviousControler()==tp
	and not Duel.IsEnvironment(112603082)
end
function kaos.ksrgcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(112603082)
end




--Χάος & Αήρ
--P.S.
--메인 개시 제외
function kaos.paradigmestart(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_DISABLE_CHAIN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(kaos.limcon77)
	e1:SetTarget(kaos.paradigmtg)
	e1:SetOperation(kaos.paradigmop)
	c:RegisterEffect(e1)
end
function kaos.paradigmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function kaos.paradigmop(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
		if e:GetHandler():IsPreviousLocation(LOCATION_HAND) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
	local token=Duel.CreateToken(tp,112501006)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112501007)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112501008)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112501009)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112501010)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
end

function kaos.limcfilter77(c)
	return c:IsSetCard(0xe88)
end
function kaos.limcon77(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(kaos.limcfilter77,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil)
end

--엑스트라 개시 제외
function kaos.shiftgamestart(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_DISABLE_CHAIN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetCountLimit(1,c:GetOriginalCode()+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(kaos.limcon77)
	e1:SetTarget(kaos.shifttg)
	e1:SetOperation(kaos.shiftop)
	c:RegisterEffect(e1)
end
function kaos.shifttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function kaos.shiftop(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
		if e:GetHandler():IsPreviousLocation(LOCATION_HAND) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end

--엑스트라 소환
function kaos.pscostfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xe7b)
		and Duel.GetMZoneCount(tp,c,tp)>0
end
function kaos.pscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,kaos.pscostfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,kaos.pscostfilter,1,2,nil,tp)
	Duel.Release(g,REASON_COST)
end

--융합 소환
function kaos.spfilterFusion(c,e,tp,mc)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xe7b) and not c:IsCode(112501007) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function kaos.psopFusion(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,kaos.spfilterFusion,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp,nil):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

--의식 소환
function kaos.spfilterRitual(c,e,tp,mc)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0xe7b) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function kaos.psopRitual(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,kaos.spfilterRitual,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp,nil):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

--싱크로 소환
function kaos.spfilterSynchro(c,e,tp,mc)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xe7b) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,true)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function kaos.psopSynchro(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,kaos.spfilterSynchro,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp,nil):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

--엑시즈 소환
function kaos.spfilterXyz(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xe7b) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function kaos.psopXyz(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,kaos.spfilterXyz,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp,nil):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

--링크 소환
function kaos.spfilterLink(c,e,tp,mc)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xe7b) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,true)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function kaos.psopLink(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,kaos.spfilterLink,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp,nil):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

--LSD: Dream Emulator.
--놓는다
function kaos.LSD(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PREDRAW+EVENT_PHASE_START)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_OVERLAY)
	e1:SetOperation(kaos.LSDstartop)
	c:RegisterEffect(e1)
end
function kaos.LSDstartop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c then
		Duel.MoveToField(c,tp,tp,LOCATION_ONFIELD,POS_FACEUP,true)
	end
end

--immume
function kaos.chaosimmume(c)
local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_IMMUNE_EFFECT)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_ALL)
	e10:SetValue(kaos.chaosimmumefilter)
	c:RegisterEffect(e10)
end
function kaos.chaosimmumefilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end

--negate
function kaos.chaosnegate(c)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTargetRange(1,1)
	e1:SetValue(kaos.chaosactlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTargetRange(LOCATION_ALL,LOCATION_ALL)
	e2:SetTarget(kaos.chaosdistarget)
	c:RegisterEffect(e2)
	--Negate effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetOperation(kaos.chaosdisop)
	c:RegisterEffect(e3)
	--Disable trap monster
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(kaos.chaosdistarget)
	c:RegisterEffect(e4)
end
function kaos.chaosactlimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0xe71)
end
function kaos.chaosdistarget(e,c)
	return not c:IsSetCard(0xe71)
end
function kaos.chaosdisop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_ALL and re:GetHandler()~=e:GetHandler() and not re:GetHandler():IsSetCard(0xe71) then
		Duel.NegateEffect(ev)
	end
end

--making
function kaos.chaosmaking(c)
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_ALL)
	e3:SetCode(EVENT_PREDRAW+EVENT_PHASE_START)
	e3:SetCountLimit(1)
	e3:SetOperation(kaos.chaosmakeop)
	c:RegisterEffect(e3)
end

function kaos.chaosmakeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetTurnPlayer()
	local token=Duel.CreateToken(tp,c:GetOriginalCode())
		Duel.SendtoHand(token,nil,REASON_RULE)
		Duel.ConfirmCards(1-p,token)
end

--atk/def increase
function kaos.chaosatkdef(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_ALL)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe71))
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--DEF increase
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end

--none
--페이탈에러
--DATA : COMPLEX NUMBER
function kaos.fatalimit(c)
	--limit
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetCode(EFFECT_CANNOT_SUMMON)
	ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	ea:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	ea:SetTargetRange(1,0)
	ea:SetCondition(kaos.fatalcon)
	ea:SetTarget(kaos.fatallimit)
	c:RegisterEffect(ea)
	--splimit
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_FIELD)
	eb:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	eb:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	eb:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	eb:SetTargetRange(1,0)
	eb:SetCondition(kaos.fatalcon)
	eb:SetTarget(kaos.fatallimit)
	c:RegisterEffect(eb)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(kaos.fatalop)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
end
function kaos.fatalcon(e)
	return not e:GetHandler():IsForbidden()
end
function kaos.fatallimit(e,c)
	return not c:IsSetCard(0xe93)
end
function kaos.fatalop(e,c)
	return c:IsType(TYPE_EFFECT) and not c:IsSetCard(0xe93)
end



--자체 특소
function kaos.fatcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function kaos.fattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function kaos.fatop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end



--RSDlimit
function kaos.RSDlimit(c)
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetCode(EFFECT_CANNOT_SUMMON)
	ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	ea:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_OVERLAY)
	ea:SetTargetRange(1,0)
	ea:SetCondition(kaos.RSDcon)
	ea:SetTarget(kaos.RSDlim)
	c:RegisterEffect(ea)
	--RSDsplimit
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_FIELD)
	eb:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	eb:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	eb:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_OVERLAY)
	eb:SetTargetRange(1,0)
	eb:SetCondition(kaos.RSDcon)
	eb:SetTarget(kaos.RSDlim)
	c:RegisterEffect(eb)
	--RSDdisable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_OVERLAY)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(kaos.RSDop)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
end
function kaos.RSDcon(e)
	return not e:GetHandler():IsForbidden()
end
function kaos.RSDlim(e,c)
	return not c:IsSetCard(0xe9a)
end
function kaos.RSDop(e,c)
	return c:IsType(TYPE_EFFECT) and not c:IsSetCard(0xe9a)
end



--Re(리)： 카운터
function kaos.recounter(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCondition(kaos.recon)
	e0:SetOperation(kaos.reop)
	c:RegisterEffect(e0)
end
function kaos.recon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0xe9b) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function kaos.reop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xe9c,1)
end



--CHUNITHM 공격 제약
function kaos.chuxyz(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(kaos.chuxyzcon)
	c:RegisterEffect(e2)
end
	
function kaos.chuxyzcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end


--아트릭시아 패 마법 소멸 코스트
function kaos.atricostfilter(c,ec,tp)
	return c:IsType(TYPE_SPELL)
end
function kaos.atricost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(kaos.atricostfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,kaos.atricostfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,-2,REASON_COST)
end


--미술과 공통 효과
--특소
function kaos.doubizyu2(c)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(c:GetOriginalCode(),1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,c:GetOriginalCode())
	e3:SetCondition(kaos.dbspcon)
	e3:SetTarget(kaos.dbsptg)
	e3:SetOperation(kaos.dbspop)
	c:RegisterEffect(e3)
end
function kaos.dbspfilter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function kaos.dbspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function kaos.dbsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(kaos.dbspfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function kaos.dbspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,kaos.dbspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


--Exritual
	local type=Card.GetType
	Card.GetType=function(c)
	if c.CardType_Exritual then
		return bit.bor(type(c),TYPE_FUSION)-TYPE_FUSION
	end
	return type(c)
end
--
	local otype=Card.GetOriginalType
	Card.GetOriginalType=function(c)
	if c.CardType_Exritual then
		return bit.bor(otype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return otype(c)
end
--
	local ftype=Card.GetFusionType
	Card.GetFusionType=function(c)
	if c.CardType_Exritual then
		return bit.bor(ftype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ftype(c)
end
--
	local ptype=Card.GetPreviousTypeOnField
	Card.GetPreviousTypeOnField=function(c)
	if c.CardType_Exritual then
		return bit.bor(ptype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ptype(c)
end
--
	local itype=Card.IsType
	Card.IsType=function(c,t)
	if c.CardType_Exritual then
		if t==TYPE_FUSION then
			return false
		end
		return itype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return itype(c,t)
end
--
	local iftype=Card.IsFusionType
	Card.IsFusionType=function(c,t)
	if c.CardType_Exritual then
		if t==TYPE_FUSION then
			return false
		end
		return iftype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return iftype(c,t)
end

--ExRitual
	local type=Card.GetType
	Card.GetType=function(c)
	if c.CardType_ExRitual then
		return bit.bor(type(c),TYPE_FUSION)-TYPE_FUSION
	end
	return type(c)
end
--
	local otype=Card.GetOriginalType
	Card.GetOriginalType=function(c)
	if c.CardType_ExRitual then
		return bit.bor(otype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return otype(c)
end
--
	local ftype=Card.GetFusionType
	Card.GetFusionType=function(c)
	if c.CardType_ExRitual then
		return bit.bor(ftype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ftype(c)
end
--
	local ptype=Card.GetPreviousTypeOnField
	Card.GetPreviousTypeOnField=function(c)
	if c.CardType_ExRitual then
		return bit.bor(ptype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ptype(c)
end
--
	local itype=Card.IsType
	Card.IsType=function(c,t)
	if c.CardType_ExRitual then
		if t==TYPE_FUSION then
			return false
		end
		return itype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return itype(c,t)
end
--
	local iftype=Card.IsFusionType
	Card.IsFusionType=function(c,t)
	if c.CardType_ExRitual then
		if t==TYPE_FUSION then
			return false
		end
		return iftype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return iftype(c,t)
end

--"그거"
--this is not xyz monster
	local type=Card.GetType
	Card.GetType=function(c)
	if c.CardType_kiniro then
		return bit.bor(type(c),TYPE_XYZ)-TYPE_XYZ
	end
	return type(c)
end
--
	local otype=Card.GetOriginalType
	Card.GetOriginalType=function(c)
	if c.CardType_kiniro then
		return bit.bor(otype(c),TYPE_XYZ)-TYPE_XYZ
	end
	return otype(c)
end
--
	local ftype=Card.GetFusionType
	Card.GetFusionType=function(c)
	if c.CardType_kiniro then
		return bit.bor(ftype(c),TYPE_XYZ)-TYPE_XYZ
	end
	return ftype(c)
end
--
	local ptype=Card.GetPreviousTypeOnField
	Card.GetPreviousTypeOnField=function(c)
	if c.CardType_kiniro then
		return bit.bor(ptype(c),TYPE_XYZ)-TYPE_XYZ
	end
	return ptype(c)
end
--
	local itype=Card.IsType
	Card.IsType=function(c,t)
	if c.CardType_kiniro then
		if t==TYPE_XYZ then
			return false
		end
		return itype(c,bit.bor(t,TYPE_XYZ)-TYPE_XYZ)
	end
	return itype(c,t)
end
--
	local iftype=Card.IsFusionType
	Card.IsFusionType=function(c,t)
	if c.CardType_kiniro then
		if t==TYPE_XYZ then
			return false
		end
		return iftype(c,bit.bor(t,TYPE_XYZ)-TYPE_XYZ)
	end
	return iftype(c,t)
end