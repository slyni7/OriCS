--절대영초 츠바키
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,id)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,1000)
	end
	Duel.PayLPCost(tp,1000)
end
function s.tfil1(c)
	return c:IsSSetable() and c:IsType(TYPE_TRAP) and not c:IsCode(id)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
end
function s.ofil1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard("절대영초") and not c:IsCode(id)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
		local b1=Duel.GetTurnPlayer()==tp
		local sg=Duel.GMGroup(s.ofil1,tp,"H",0,nil,e,tp)
		local b2=Duel.GetLocCount(tp,"M")>0 and #sg>0
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(id,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(id,1)
			opval[off-1]=2
			off=off+1
		end
		if off==1 then
			return
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			Duel.BreakEffect()
			local ph=Duel.GetCurrentPhase()
			Duel.SkipPhase(tp,ph,RESET_PHASE+ph,1)
		elseif opval[op]==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end