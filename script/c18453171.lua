--줄라이 세인트리
local m=18453171
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"X")
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsDiscardable,tp,"H",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,Card.IsDiscardable,tp,"H",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tfil1(c,e,tp)
	return c:IsSetCard(0x2e5) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsCode(m)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(10000)
	return true
end
function cm.tfil2(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x12e5) and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=10000 then
			return false
		end
		e:SetLabel(0)
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,false)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then
		return
	end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then
		op(e,tp,eg,ep,ev,re,r,rp)
	end
end