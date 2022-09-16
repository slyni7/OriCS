--MMJ : Bakuen no Denrei
function c81010130.initial_effect(c)

	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c81010130.mat,2,false)
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c81010130.lim)
	c:RegisterEffect(e0)
	
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c81010130.srcn)
	e1:SetOperation(c81010130.srop)
	c:RegisterEffect(e1)
	
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c81010130.alvl)
	e2:SetCondition(c81010130.alcon)
	c:RegisterEffect(e2)

	--ATK / DEF update
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81010130,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCountLimit(1)
	e3:SetCondition(c81010130.adcn)
	e3:SetCost(c81010130.adco)
	e3:SetTarget(c81010130.adtg)
	e3:SetOperation(c81010130.adop)
	c:RegisterEffect(e3)
	
	--sendto hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81010130,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetTarget(c81010130.thtg)
	e5:SetOperation(c81010130.thop)
	c:RegisterEffect(e5)
	
end

--fusion summon
function c81010130.mat(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsType(TYPE_SYNCHRO)
end
function c81010130.lim(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function c81010130.sfilter1(c,fc)
	return c81010130.mat(c) and c:IsCanBeFusionMaterial(fc)
end
function c81010130.sfilter2(c,tp,g)
	return g:IsExists(c81010130.sfilter3,1,c,tp,c)
end
function c81010130.sfilter3(c,tp,mc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c81010130.srcn(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp):Filter(c81010130.sfilter1,nil,c)
	return g:IsExists(c81010130.sfilter2,1,nil,tp,g)
end
function c81010130.srop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp):Filter(c81010130.sfilter1,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:FilterSelect(tp,c81010130.sfilter2,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=g:FilterSelect(tp,c81010130.sfilter3,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end

--act limit (e3)
function c81010130.alvl(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c81010130.alcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end


--ATK / DEF update (e4)
function c81010130.adcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end

function c81010130.adcofilter(c)
	return c:IsSetCard(0xca1) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() 
	and c:GetLevel()>0
end
function c81010130.adco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010130.adcofilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81010130.adcofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c81010130.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function c81010130.adop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local tc1=Duel.GetFirstTarget()
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(lv*300)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e1)
		local e2=e1:Clone(e:GetHandler())
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc1:RegisterEffect(e2)
	end
end



--sendto hand (e5)
function c81010130.thfilter(c)
	return c:IsSetCard(0xca1) and c:IsAbleToHand()
end
function c81010130.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c81010130.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81010130.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81010130.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81010130.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
