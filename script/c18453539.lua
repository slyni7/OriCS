--환룡마녀 드래고위치
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,nil,2,nil,nil,nil,nil,false,s.pfun1)
	local e1=MakeEff(c,"F","E")
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTR(1,1)
	e1:SetOperation(s.op1)
	e1:SetValue(s.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCL(1,id)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","M")
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e3:SetCL(1,{id,1})
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
end
function s.pffil1(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_WYRM)
end
function s.pfun1(g,tp,xyz)
	if g:IsExists(s.pffil1,1,nil) then
		local g1=g:Filter(Card.IsXyzLevel,nil,xyz,4)
		local g2=g-g1
		if #g2>1 then
			return false
		end
		local tc=g2:GetFirst()
		return tc==nil or s.pffil1(tc)
	end
	return g:FilterCount(Card.IsLoc,nil,"M")==#g and g:FilterCount(Card.IsXyzLevel,nil,xyz,4)==#g
end
s.g1=nil
function s.op1(c,e,tp,sg,mg,lc,og,chk)
	return not s.g1 or #(sg&s.g1)>0
end
function s.val1(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_XYZ or sc~=e:GetHandler() then
			return Group.CreateGroup()
		else
			s.g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
			s.g1:KeepAlive()
			return s.g1
		end
	elseif chk==2 then
		if s.g1 then
			s.g1:DeleteGroup()
		end
		s.g1=nil
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end
function s.tfil2(c)
	return c:IsCode(18453527) and c:IsAbleToHand()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"DG",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"DG")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil2,tp,"DG",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.tfil31(c)
	return c:IsCode(18453527) and c:IsSummonable(true,nil)
end
function s.tfil32(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_WYRM) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and s.tfil32(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IEMCard(s.tfil31,tp,"HM",0,1,nil) and Duel.GetLocCount(tp,"M")>0
			and Duel.IETarget(s.tfil32,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,s.tfil32,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SMCard(tp,s.tfil31,tp,"HM",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
		local sc=Duel.GetFirstTarget()
		if sc:IsRelateToEffect(e) and Duel.GetLocCount(tp,"M")>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			local e1=MakeEff(c,"S")
			e1:SetDescription(3207)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1)
		end
	end
end