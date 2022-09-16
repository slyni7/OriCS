--¸¶¹ý¸¶¿Õ¼Ò³à »çÅä³×
function c18452715.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c18452715.ffil1,2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(SUMMON_TYPE_LINK)
	e1:SetCondition(c18452715.con1)
	e1:SetTarget(c18452715.tar1)
	e1:SetOperation(c18452715.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCondition(c18452715.con2)
	e2:SetTarget(c18452715.tar2)
	e2:SetOperation(c18452715.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c18452715.con3)
	e3:SetOperation(c18452715.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetOperation(c18452715.op4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1)
	e6:SetCondition(c18452715.con6)
	e6:SetTarget(c18452715.tar6)
	e6:SetOperation(c18452715.op6)
	c:RegisterEffect(e6)
end
function c18452715.ffil1(c,fc,sub,mg,sg)
	if not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:IsExists(c18452715.ffun1,1,c,c) then
		return true
	end
	if SatoneFusionFilter and sg:IsExists(SatoneFusionFilter,1,nil,SatoneFusionEffect,SatoneFusionPlayer) then
		return true
	end
end
function c18452715.ffun1(fc,nc)
	return (fc:IsFusionAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WATER)
		and nc:IsFusionAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WATER))
		or (fc:IsFusionAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and nc:IsFusionAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK))
		or (fc:IsFusionAttribute(ATTRIBUTE_WIND+ATTRIBUTE_EARTH)
		and nc:IsFusionAttribute(ATTRIBUTE_WIND+ATTRIBUTE_EARTH))
		or (fc:IsFusionAttribute(ATTRIBUTE_DIVINE) and nc:IsFusionAttribute(ATTRIBUTE_DIVINE))
end
function c18452715.nfil11(c)
	return c:IsSetCard(0x46) and c:IsDiscardable()
end
function c18452715.nfil12(c,f,lc)
	return aux.LConditionFilter(c,f,lc) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c18452715.nfun11(g)
	if g:GetCount()~=2 then
		return false
	end
	local fc=g:GetFirst()
	local nc=g:GetNext()
	return c18452715.nfun12(fc,nc)
end
function c18452715.nfun12(fc,nc)
	return (fc:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WATER) and nc:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WATER))
		or (fc:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and nc:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK))
		or (fc:IsAttribute(ATTRIBUTE_WIND+ATTRIBUTE_EARTH) and nc:IsAttribute(ATTRIBUTE_WIND+ATTRIBUTE_EARTH))
		or (fc:IsAttribute(ATTRIBUTE_DIVINE) and nc:IsAttribute(ATTRIBUTE_DIVINE))
end
function c18452715.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local mg=aux.GetLinkMaterials(tp,nil,c)
	local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
	local exchk=Duel.IsExistingMatchingCard(c18452715.nfil11,tp,LOCATION_HAND,0,1,nil)
	local exg=Duel.GetMatchingGroup(c18452715.nfil12,tp,0,LOCATION_MZONE,nil,nil,c)
	if exchk then
		mg:Merge(exg)
	end
	if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then
		return false
	end
	Duel.SetSelectedCard(fg)
	return mg:CheckSubGroup(aux.LCheckGoal,2,2,tp,c,c18452715.nfun11)
end
function c18452715.tfil1(c,g)
	return g:IsContains(c)
end
function c18452715.tar1(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=aux.GetLinkMaterials(tp,nil,c)
	local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
	Duel.SetSelectedCard(fg)
	local exchk=Duel.IsExistingMatchingCard(c18452715.nfil11,tp,LOCATION_HAND,0,1,nil)
	local exg=Duel.GetMatchingGroup(c18452715.nfil12,tp,0,LOCATION_MZONE,nil,nil,c)
	local lg=mg:Clone()
	if exchk then
		mg:Merge(exg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local can=Duel.GetCurrentChain()<1
	local sg=mg:SelectSubGroup(tp,aux.LCheckGoal,can,2,2,tp,c,c18452715.nfun11)
	if sg then
		if sg:IsExists(c18452715.tfil1,1,lg,exg) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local dg=Duel.SelectMatchingCard(tp,c18452715.nfil11,tp,LOCATION_HAND,0,1,1,nil)
			Duel.SendtoGrave(dg,REASON_COST+REASON_DISCARD)
		end
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else
		return false
	end
end
function c18452715.op1(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
	g:DeleteGroup()
end
function c18452715.nfil2(c,tp)
	return c:IsType(TYPE_FUSION) and c:GetSummonPlayer()==tp
end
function c18452715.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18452715.nfil2,1,nil,tp)
end
function c18452715.tfil21(c,tp)
	local code=c:GetCode()
	local g=Duel.GetMatchingGroup(c18452715.tfil22,tp,LOCATION_DECK,0,nil,code)
	return c:IsSetCard(0x12d0) and c:IsAbleToHand() and g:GetClassCount(Card.GetCode)>1
end
function c18452715.tfil22(c,code)
	if c:IsCode(code) then
		return false
	end
	local ae=c:GetActivateEffect()
	return c:IsType(TYPE_SPELL) and ae and ae:IsHasCategory(CATEGORY_FUSION_SUMMON) and c:IsAbleToHand()
end
function c18452715.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c18452715.tfil21,tp,LOCATION_DECK,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18452715.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg1=Duel.SelectMatchingCard(tp,c18452715.tfil21,tp,LOCATION_DECK,0,1,1,nil,tp)
	if sg1:GetCount()>0 then
		local g=Duel.GetMatchingGroup(c18452715.tfil22,tp,LOCATION_DECK,0,nil,sg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg3=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg1:Select(1-tp,1,1,nil)
		local sg=sg1:Filter(Card.IsSetCard,nil,0x12d0)
		sg:Merge(tg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local ag=sg:Select(tp,1,1,nil)
		Duel.SendtoHand(ag,nil,REASON_EFFECT)
	end
end
function c18452715.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c18452715.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_MAIN1)
	e1:SetValue(c18452715.val31)
	c:RegisterEffect(e1)
end
function c18452715.val31(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c18452715.op4(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local atk=0
	if a and a:IsFaceup() and a:IsRelateToBattle() and a:GetAttack()>atk then
		atk=a:GetAttack()
	end
	if d and d:IsFaceup() and d:IsRelateToBattle() and d:GetAttack()>atk  then
		atk=d:GetAttack()
	end
	Duel.Recover(tp,atk,REASON_EFFECT)
end
function c18452715.con6(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c18452715.tfil6(c)
	return c:IsSetCard(0x12d0) and c:IsType(TYPE_SPELL) and c:IsAbleToDeck() and c:CheckActivateEffect(false,true,false)~=nil
end
function c18452715.tar6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c18452715.tfil6,tp,LOCATION_GRAVE,0,1,nil)
	end
	e:SetCategory(CATEGORY_TODECK)
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	local g=Duel.SelectTarget(tp,c18452715.tfil6,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetCategory())
	tc:CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then
		tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c18452715.op6(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then
		return
	end
	local tc=te:GetHandler()
	if not tc:IsRelateToEffect(e) then
		return
	end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then
		op(e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.BreakEffect()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end