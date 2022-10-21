--샤프트밀리 노아
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tar1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tar2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	if s.shaft_effect==nil then
		s.shaft_effect={}
	end
	table.insert(s.shaft_effect,e2)
end
s.listed_series={0x106e}
function s.cfil1(c)
	return c:IsSetCard(0x106e) and c:IsAbleToGraveAsCost()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(s.cfil1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfil1,tp,LOCATION_DECK,0,1,1,nil)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.tfil1(c)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)==2 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
		if g:IsExists(Card.IsSetCard,2,nil,0x106e) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			local sg=g:FilterSelect(tp,Card.IsSetCard,2,2,nil,0x106e)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		else
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard(0x106e) and rp==tp
end
function s.tfil2(c,e,tp)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.tfil2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.tfil2,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then
		return
	end
	aux.ToHandOrElse(tc,tp,
		function(sc) return sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end,
		function(sc) Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) end,
		aux.Stringid(id,0)
	)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.oval21)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)	
end
function s.oval21(e,re,tp)
	for _,te in pairs(s.shaft_effect) do
		if te==re then
			return true
		end
	end
	return false
end