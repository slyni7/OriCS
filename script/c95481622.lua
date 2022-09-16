--아이타이니 퓨전
function c95481622.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95481622,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95481622)
	e1:SetCost(c95481622.cost)
	e1:SetTarget(c95481622.target)
	e1:SetOperation(c95481622.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95481622,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,95481622)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(c95481622.cost)
	e2:SetTarget(c95481622.target2)
	e2:SetOperation(c95481622.activate2)
	c:RegisterEffect(e2)
end


function c95481622.costfilter(c,ft)
	return c:IsSetCard(0xd4f) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost() 
		and (ft>0 or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5))
end
function c95481622.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:CheckWithSumEqual(Card.GetLevel,8,sg:GetCount(),sg:GetCount())
end
function c95481622.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c95481622.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c95481622.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),ft)
	Duel.SendtoGrave(g,REASON_COST)
end


function c95481622.spfilter(c,e,tp)
	return c:IsSetCard(0xd4f) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEDOWN_DEFENSE)
end
function c95481622.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then
		local g=Duel.GetMatchingGroup(c95481622.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c95481622.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),3)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(c95481622.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95481622,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		g1:Merge(g2)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95481622,2)) then
			g2=g:Select(tp,1,1,nil)
			g1:Merge(g2)
		end
	end
	if Duel.SpecialSummon(g1,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,g1)
	end
end


function c95481622.ffilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c95481622.ffilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xd4f) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c95481622.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c95481622.ffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c95481622.ffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c95481622.activate2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c95481622.ffilter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c95481622.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c95481622.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UNRELEASABLE_SUM)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(1)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(1)
		tc:RegisterEffect(e3,true)
	end
end
