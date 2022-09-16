--사일런트 머조리티: 4
local m=18453078
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_DRAW)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
cm.square_mana={ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0
		and (Duel.GetFieldGroupCount(tp,LSTN("O"),0)==0 or #Duel.GMGroup(aux.TRUE,tp,"H",0,c)==0)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=0
	if Duel.GetFieldGroupCount(tp,LSTN("H"),0)==0 then
		ct=ct+1
	end
	if #Duel.GMGroup(aux.TRUE,tp,"O",0,c)==0 then
		ct=ct+1
	end
	if chk==0 then
		return ct>0 and Duel.IsPlayerCanDraw(tp)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local exc=c:IsRelateToEffect(e) and c or nil
	local ct=0
	if Duel.GetFieldGroupCount(tp,LSTN("H"),0)==0 then
		ct=ct+1
	end
	if #Duel.GMGroup(aux.TRUE,tp,"O",0,exc)==0 then
		ct=ct+1
	end
	if ct>0 then
		local e1=MakeEff(c,"FC")
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCL(1)
		e1:SetLabel(ct)
		e1:SetCondition(cm.ocon21)
		e1:SetOperation(cm.oop21)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.ocon21(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerCanDraw(tp)
end
function cm.oop21(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
end