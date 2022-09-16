--방랑자 안내서 초판
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsSetCard,0x3d6e),nil,s.fextra,nil,nil,s.stage2)
	c:RegisterEffect(e1)
	if not AshBlossomTable then AshBlossomTable={} end
	table.insert(AshBlossomTable,e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(s.spr)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(s.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(s.spop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function s.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function s.fextra(e,tp,mg)
	if not Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToGrave),tp,LOCATION_DECK,0,nil)
	end
	return nil
end

function s.filter2(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSSetable(true) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3d6e)
end
function s.stage2(e,tc,tp,sg,chk)
	if chk~=1 then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=sg:FilterSelect(tp,s.filter2,0,1,nil)
		if #g>0 then
			local tc=g:GetFirst()
			Duel.SSet(tp,tc)
		end
	end
end
function s.spr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousLocation(LOCATION_ONFIELD) then
		e:SetLabel(Duel.GetTurnCount()+1)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetLabelObject():GetLabel()==Duel.GetTurnCount() and c:GetFlagEffect(id)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0)
	e1:SetTarget(s.tgfilter)
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.tgfilter(e,c)
	return c:IsSetCard(0x3d6e) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end