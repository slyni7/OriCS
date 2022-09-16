--RUM(랭크 업 매직)-트렌센드 클라디스
function c95480826.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480826+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95480826.target)
	e1:SetOperation(c95480826.activate)
	c:RegisterEffect(e1)
end
function c95480826.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsSetCard(0xd52) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c95480826.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1)
end
function c95480826.filter2(c,e,tp,mc,rk)
	return c:GetRank()==rk and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsSetCard(0xd52)
end
function c95480826.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c95480826.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c95480826.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c95480826.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetChainLimit(aux.FALSE)
end
function c95480826.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95480826.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			sc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_INACTIVATE)
			e3:SetLabel(3)
			e3:SetValue(c95480826.effectfilter)
			Duel.RegisterEffect(e3,tp)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_CANNOT_DISEFFECT)
			e4:SetLabel(4)
			Duel.RegisterEffect(e4,tp)
			e3:SetLabelObject(e4)
			e4:SetLabelObject(sc)
			--chk
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_LEAVE_FIELD_P)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e0:SetLabelObject(e3)
			e0:SetOperation(c95480826.chk)
			sc:RegisterEffect(e0)
			if not sc:IsType(TYPE_EFFECT) then
				local e6=Effect.CreateEffect(c)
				e6:SetType(EFFECT_TYPE_SINGLE)
				e6:SetCode(EFFECT_ADD_TYPE)
				e6:SetValue(TYPE_EFFECT)
				e6:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e6)
			end
			sc:RegisterFlagEffect(95480826,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		sc:CompleteProcedure()
	end
end
function c95480826.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local label=e:GetLabel()
	local tc
	if label==3 then
		tc=e:GetLabelObject():GetLabelObject()
	else
		tc=e:GetLabelObject()
	end
	return tc and tc==te:GetHandler()
end
function c95480826.chk(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=e:GetLabelObject()
	local e4=e3:GetLabelObject()
	local te=c:GetReasonEffect()
	if c:GetFlagEffect(95480826)==0 or not te or not te:IsActivated() or te:GetHandler()~=c then
		e3:Reset()
		e4:Reset()
	else
		--reset
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_END)
		e0:SetLabelObject(e3)
		e0:SetOperation(c95480826.resetop)
		Duel.RegisterEffect(e0,tp)
	end
end
function c95480826.resetop(e,tp,eg,ep,ev,re,r,rp)
	local e3=e:GetLabelObject()
	local e4=e3:GetLabelObject()
	e3:Reset()
	e4:Reset()
	e:Reset()
end
