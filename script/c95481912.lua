--인챈트릭스 매니플레이션
local m=95481912
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	if EFFECT_FUSION_MAT_RESTRICTION then
		e1:SetTarget(cm.edotar1)
		e1:SetOperation(cm.edoop1)
	else
		e1:SetTarget(cm.coretar1)
		e1:SetOperation(cm.coreop1)
	end
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tar2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
function cm.edotfil1(c)
	return c:IsSetCard(0xd49) and c:IsLinkSummonable(nil)
end
function cm.edotar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(1,1)
		e1:SetValue(cm.edotval11)
		e1:SetOperation(cm.edotop11)
		Duel.RegisterEffect(e1,tp)
		local res=Duel.IsExistingMatchingCard(cm.edotfil1,tp,LOCATION_EXTRA,0,1,nil)
		e1:Reset()
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
cm.curgroup=nil
function cm.edotop11(c,e,tp,sg,mg,lc,og,chk)
	return not cm.curgroup or #(sg&cm.curgroup)<2
end
function cm.edotval11(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or not sc:IsSetCard(0xd49) then
			return Group.CreateGroup()
		else
			cm.curgroup=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			cm.curgroup:KeepAlive()
			return cm.curgroup
		end
	elseif chk==2 then
		if cm.curgroup then
			cm.curgroup:DeleteGroup()
		end
		cm.curgroup=nil
	end
end
function cm.edoop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.edotval11)
	e1:SetOperation(cm.edotop11)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.SelectMatchingCard(tp,cm.edotfil1,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	e1:Reset()
	if tc then
		local e2=e1:Clone()
		e2:SetRange(LOCATION_EXTRA)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		Duel.LinkSummon(tp,tc,nil)
	end
end
function cm.coretfil1(c)
	return c:IsSetCard(0xd49) and c:IsLinkSummonable(nil)
end
function cm.coretar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(cm.coretval11)
		Duel.RegisterEffect(e1,tp)
		local res=Duel.IsExistingMatchingCard(cm.coretfil1,tp,LOCATION_EXTRA,0,1,nil)
		e1:Reset()
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.coretval11(e,lc,mg,c,tp)
	if not lc:IsSetCard(0xd49) then
		return false
	end
	return true,not mg or not mg:IsExists(Card.IsControler,1,nil,1-tp)
end
function cm.coreop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cm.coretval11)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.coretfil1,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	e1:Reset()
	if tc then
		local e2=e1:Clone()
		e2:SetRange(LOCATION_EXTRA)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		Duel.LinkSummon(tp,tc,nil)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and r&REASON_EFFECT>0
end
function cm.tfil2(c)
	return c:IsSetCard(0xd49) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tfil2,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.ofil31(c,tp)
	local g=c:GetMaterial()
	return c:IsSetCard(0xd49) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and g and g:IsExists(cm.ofil32,1,nil,tp)
end
function cm.ofil32(c,tp)
	return c:GetOwner()==1-tp
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g<1 then
		return
	end
	local tg=g:Filter(cm.ofil31,nil,tp)
	if #tg>0 and c:IsAbleToRemove() and Duel.IsChainDisablable(ev) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		if Duel.NegateEffect(ev) then
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		end
	end
end