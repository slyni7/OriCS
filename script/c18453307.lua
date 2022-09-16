--딜라이트 드래곤
local m=18453307
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"F","R")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_REMOVE)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FTf","M")
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetCL(1)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
end
cm.delightsworn=true
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return c:IsFacedown() and Duel.CheckLPCost(tp,1000) and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LSTN("R"),0,20,nil)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,1000)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(Card.IsAbleToRemove,tp,"O","O",nil,tp,POS_FACEDOWN)
	if chk==0 then
		return #g>0
	end
	Duel.SOI(0,CATEGORY_REMOVE,g,#g,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GMGroup(Card.IsAbleToRemove,tp,"O","O",nil,tp,POS_FACEDOWN)
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_REMOVE,nil,4,tp,"D")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GetDecktopGroup(tp,4)
	if #g>0 then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
