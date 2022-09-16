--영매술 - 「현현」
function c95480920.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c95480920.tar1)
	e1:SetOperation(c95480920.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1,95480920)
	e2:SetCost(c95480920.cost2)
	e2:SetTarget(c95480920.tar2)
	e2:SetOperation(c95480920.op2)
	c:RegisterEffect(e2)
end
function c95480920.tfil11(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xd42) and c:IsFaceup() and c:IsAbleToGrave()
end
function c95480920.tfil12(c,e,tp,mg)
	if c:GetType()&0x81~=0x81 or not c:IsSetCard(0xd42) then
		return false
	end
	local m=mg:Clone()
	m:RemoveCard(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,c:GetLevel(),"Equal")
	local res=m:CheckSubGroup(c95480920.tfun1,1,c:GetLevel(),e,tp,c)
	aux.GCheckAdditional=nil
	return res
end
function c95480920.tfun1(sg,e,tp,rc)
	return sg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),#sg,#sg,rc)
		and ((rc:IsLocation(LOCATION_EXTRA) and rc:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,sg,rc)>0) or (not rc:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp,sg)>0))
end
function c95480920.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp)
	local exg=Duel.GetMatchingGroup(c95480920.tfil11,tp,LOCATION_EXTRA,0,nil)
	mg:Merge(exg)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c95480920.tfil12,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c95480920.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	local exg=Duel.GetMatchingGroup(c95480920.tfil11,tp,LOCATION_EXTRA,0,nil)
	mg:Merge(exg)
	local g=Duel.SelectMatchingCard(tp,c95480920.tfil12,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local tc=g:GetFirst()
	if tc then
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,c95480920.tfun1,false,1,tc:GetLevel(),e,tp,tc)
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoGrave(mat2,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c95480920.cfil2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xd42) and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c95480920.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c95480920.cfil2,tp,LOCATION_EXTRA,0,1,nil)
	end
	local g=Duel.SelectMatchingCard(tp,c95480920.cfil2,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c95480920.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c95480920.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end