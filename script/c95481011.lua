--아니마기아스 생텀
local m=95481011
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90351981,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,95481089)
	e3:SetCost(cm.thcost)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.tar4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetValue(SUMMON_TYPE_SYNCHRO)
	e5:SetCondition(cm.con5)
	e5:SetTarget(cm.tar5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_EXTRA,0)
	e6:SetTarget(cm.tar6)
	e4:SetLabelObject(e6)
	e5:SetLabelObject(e6)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()==e:GetHandlerPlayer()
end

function cm.filter(c)
	return c:IsSetCard(0xd5e) and c:IsAbleToHand() and not c:IsCode(m) 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
	Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end


function cm.tar4(e,c,sump,sumtype,sumpos,targetp,se)
	return sumtype&SUMMON_TYPE_SYNCHRO==SUMMON_TYPE_SYNCHRO and e:GetLabelObject()~=se:GetLabelObject() and se:GetCode()==EFFECT_SPSUMMON_PROC
end
function cm.nfil5(c)
	return c:IsSetCard(0xd5e) and c:IsFaceup()
end
function cm.nfun5(g,sc)
	local fc=g:GetFirst()
	local nc=g:GetNext()
	if fc:GetOriginalLevel()<nc:GetOriginalLevel() then
		fc,nc=nc,fc
	end
	return fc:GetOriginalLevel()-nc:GetOriginalLevel()==sc:GetLevel()
		and ((fc:IsType(TYPE_TUNER) and not nc:IsType(TYPE_TUNER)) or (not fc:IsType(TYPE_TUNER) and nc:IsType(TYPE_TUNER)))
end
function cm.con5(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.nfil5,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(cm.nfun5,2,2,c)
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.nfil5,tp,LOCATION_MZONE,0,nil)
	local cancel=Duel.IsSummonCancelable()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectSubGroup(tp,cm.nfun5,cancel,2,2,c)
	if sg then
		sg:KeepAlive()
		e:SetOperation(cm.op5(sg))
		return true
	else
		return false
	end
end
function cm.op5(g)
	return
		function(e,tp,eg,ep,ev,re,r,rp,c)
			c:SetMaterial(g)
			Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
			g:DeleteGroup()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetTarget(cm.splimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
end
function cm.tar6(e,c)
	return c:IsType(TYPE_SYNCHRO)
end
function cm.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_SYNCHRO) or (c:IsType(TYPE_LINK) and c:IsSetCard(0xd5e)))
end