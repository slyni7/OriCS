--[ Lava Golem ]
local m=99970711
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--라바 골렘
	YuL.AddLavaGolemProcedure(c,cm.con0,m)
	
	--덤핑 + 번
	local e1=MakeEff(c,"STf")
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--프로토타입
	local e2=MakeEff(c,"S","MG")
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(CARD_LAVA_GOLEM)
	c:RegisterEffect(e2)
	
	--서치 + 샐비지
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(spinel.delay)
	e3:SetCL(1,m)
	e3:SetCondition(aux.PreOnfield)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	
end

--라바 골렘
function cm.con0fil(c)
	return c:IsFaceup() and c:IsOriginalCodeRule(CARD_LAVA_GOLEM)
end
function cm.con0(e,c)
	return Duel.IsExistingMatchingCard(cm.con0fil,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

--덤핑 + 번
function cm.tar1fil(c)
	return c:IsLavaGolemCard() and c:IsAbleToGrave()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	--자신
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tar1fil,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	else Duel.Damage(tp,1000,REASON_EFFECT) end
	--상대
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(1-tp,cm.tar1fil,1-tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	else Duel.Damage(1-tp,1000,REASON_EFFECT) end
end

--서치 + 샐비지
function cm.tar3fil(c)
	return c:IsLavaGolem() and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar3fil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tar3fil),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
