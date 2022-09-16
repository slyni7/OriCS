--강신
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_DRAW)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)	
end
function s.tfil1(c)
	return c:IsCode(18453527) and c:IsSummonable(true,nil)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"HM",0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SOI(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SMCard(tp,s.tfil1,tp,"HM",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END-RESET_TOFIELD,0,1,fid)
		local e1=MakeEff(c,"FC")
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetLabel(fid)
		e1:SetCondition(s.ocon11)
		e1:SetOperation(s.oop11)
		Duel.RegisterEffect(e1,tp)
		Duel.Summon(tp,tc,true,nil)
	end
end
function s.ocon11(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	return eg:GetFirst()==tc and tc:GetFlagEffectLabel(id)==fid
end
function s.oop11(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(tp,2,REASON_EFFECT)
	e:Reset()
end