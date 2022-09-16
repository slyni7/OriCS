--크로노이드 오퍼레이팅
local m=95481811
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.tfil11(c,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_UNION)
		and Duel.IsExistingMatchingCard(cm.tfil13,tp,LOCATION_MZONE,0,1,c,c)
end
function cm.tfil12(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_UNION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetEquipTarget()~=nil
end
function cm.tfil13(c,ec)
	return c:IsFaceup() and ec:CheckUnionTarget(c) and aux.CheckUnionEquip(ec,c)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingTarget(cm.tfil11,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
	local b2=Duel.IsExistingTarget(cm.tfil12,tp,LOCATION_SZONE,0,1,nil,e,tp)
	if chk==0 then
		return b1 or b2
	end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(opval[op])
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		e:SetCategory(CATEGORY_EQUIP+CATEGORY_DESTROY)
		Duel.SelectTarget(tp,cm.tfil11,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		e:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
		local g=Duel.SelectTarget(tp,cm.tfil12,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if op==1 then
		if tc:IsRelateToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=Duel.SelectMatchingCard(tp,cm.tfil13,tp,LOCATION_MZONE,0,1,1,nil,tc)
			local sc=sg:GetFirst()
			if sc and Duel.Equip(tp,tc,sc) then
				aux.SetUnionState(tc)
				local dg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
				if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
					local g=dg:Select(tp,1,1,nil)
					Duel.HintSelection(g)
					Duel.Destroy(g,REASON_EFFECT)
			end
				end
		end
	elseif op==2 then
		if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
			if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=dg:Select(tp,1,1,nil)
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end