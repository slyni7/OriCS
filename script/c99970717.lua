--[ Lava Golem ]
local m=99970717
local cm=_G["c"..m]
function cm.initial_effect(c)

	--샐비지 / 특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--바운스
	local e2=MakeEff(c,"Qo","G")
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1,m)
	e2:SetCost(aux.bfgcost)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)

end

--샐비지 / 특수 소환
function cm.ssfilter(c,ft,oft,e,tp)
	return c:IsLavaGolemCard() and c:IsType(TYPE_MONSTER)
	and ((ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP))
		or (oft>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,1-tp))
		or c:IsAbleToHand())
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local oft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.ssfilter(chkc,ft,oft,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.ssfilter,tp,LOCATION_GRAVE,0,1,nil,ft,oft,e,tp) end
	local g=Duel.GetMatchingGroup(cm.ssfilter,tp,LOCATION_GRAVE,0,nil,ft,oft,e,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local sg=g:Select(tp,1,1,nil)
		Duel.SetTargetCard(sg)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local oft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local sc=Duel.GetFirstTarget()
	local s1=ft>0 and sc:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
	local s2=oft>0 and sc:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,1-tp)
	if sc and sc:IsRelateToEffect(e) then
		aux.ToHandOrElse(sc,tp,function(c)
			return s1 or s2 end,
		function(c)
			local opt=0
			if s1 and s2 then opt=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
			elseif s1 then opt=1 elseif s2 then opt=0 else return end
			Duel.SpecialSummon(sc,0,tp,math.abs(tp-opt),false,false,POS_FACEUP) end,
		2)
	end
end

--바운스
function cm.tar2fil(c)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsLavaGolem()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.tar2fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar2fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.tar2fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
