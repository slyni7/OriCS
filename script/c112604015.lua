--시간여행
local m=112604015
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetTarget(cm.tar2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.tfil1(c,e,tp,m1,m2)
	if c:GetType()&0x81~=0x81 or not c:IsSetCard(0xe7c) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then
		return false
	end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=c:GetLevel()
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,"Equal")
	local res=mg:CheckSubGroup(cm.tfun11,1,lv,tp,c,lv)
	aux.GCheckAdditional=nil
	return res
end
function cm.tfun11(g,tp,c,lv)
	return aux.RitualCheckEqual(g,c,lv) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not aux.RCheckAdditional or aux.RCheckAdditional(tp,g,c))
end
function cm.tfun12(chkg)
	return function(tp,g,c)
		local sg=g:Filter(Card.IsLocation,chkg,LOCATION_GRAVE)
		return #sg==0 or sg:IsExists(Card.IsCode,1,nil,112604000)
	end
end
function cm.tfun13(chkg)
	return function(g)
		local sg=g:Filter(Card.IsLocation,chkg,LOCATION_GRAVE)
		return #sg==0 or sg:IsExists(Card.IsCode,1,nil,112604000)
	end
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local exg=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,aux.TRUE)
		local chkg=mg:Clone()
		aux.RCheckAdditional=cm.tfun12(chkg)
		aux.RGCheckAdditional=cm.tfun13(chkg)
		local res=Duel.IsExistingMatchingCard(cm.tfil1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,exg)
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local exg=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,aux.TRUE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local chkg=mg:Clone()
	aux.RCheckAdditional=cm.tfun12(chkg)
	aux.RGCheckAdditional=cm.tfun13(chkg)
	local tg=Duel.SelectMatchingCard(tp,cm.tfil1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg,exg)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(exg)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local lv=tc:GetLevel()
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,lv,"Equal")
		local mat=mg:SelectSubGroup(tp,cm.tfun11,false,1,lv,tp,tc,lv)
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
function cm.tfil2(c)
	return c:IsCode(112604000) and c:IsFaceup() and c:IsAbleToDeck()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and cm.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil2,tp,LOCATION_REMOVED,0,1,nil) and c:IsAbleToDeck()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.tfil2,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 and c:IsLocation(LOCATION_DECK) and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end