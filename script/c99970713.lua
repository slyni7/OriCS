--[ Lava Golem ]
local m=99970713
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--라바 골렘
	YuL.AddLavaGolemProcedure(c,cm.con0,m)
	
	--서치 + 번
	local e1=MakeEff(c,"FTf","M")
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCL(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--공수 감소
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.tar2)
	e2:SetValue(-1000)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	
	--특수 소환
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(spinel.delay)
	e3:SetCL(1,m)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)

end

--라바 골렘
function cm.con0fil(c)
	return c:IsFaceup() and c:IsLavaGolemCard()
end
function cm.con0(e,c)
	return Duel.IsExistingMatchingCard(cm.con0fil,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

--서치 + 번
function cm.tar1fil(c)
	return c:IsLavaGolemCard() and c:IsType(YuL.ST) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	--자신
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tar1fil,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else Duel.Damage(tp,1000,REASON_EFFECT) end
	--상대
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(1-tp,cm.tar1fil,1-tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,g)
	else Duel.Damage(1-tp,1000,REASON_EFFECT) end
end

--공수 감소
function cm.tar2(e,c)
	return not c:IsLavaGolemCard() and c:IsFaceup()
end

--특수 소환
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.tar3fil(c,e,tp)
	return c:IsLavaGolemCard() and c:IsType(TYPE_MONSTER)
		and (c:IsCanBeSpecialSummoned(e,0,tp,true,false) or c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,1-tp))
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0)
		and Duel.IsExistingMatchingCard(cm.tar3fil,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.tar3fil,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	local s1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,true,false)
	local s2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,1-tp)
	local opt=0
	if tc then
		if s1 and s2 then opt=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
		elseif s1 then opt=1 elseif s2 then opt=0 else return end
		if Duel.SpecialSummonStep(tc,0,tp,math.abs(tp-opt),true,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(-1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
