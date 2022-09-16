--더미머미 ~워터베어~
local m=18453467
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.pfil1,1,1)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCost(cm.cost1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STf")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=true
		cm[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.pfil1(c,lc,sumtype,tp)
	return c:IsLevelAbove(5) and c:IsSetCard("더미머미")
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetSummonLocation()==LOCATION_EXTRA then
			cm[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=true
	cm[1]=true
end
function cm.cost1(e,c,tp)
	if c:IsLoc("E") and not cm[tp] then
		return false
	end
	return true
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLoc("E") then
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTR(1,0)
		e1:SetTarget(cm.otar11)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.otar11(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLoc("E") and c~=e:GetHandler()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
end
function cm.ofil2(c,tp)
	return c:IsCode(18453468) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.ofil2,tp,"DG",0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		aux.PlayFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
	end
end