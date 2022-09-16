--[ Lava Golem ]
local m=99970715
local cm=_G["c"..m]
function cm.initial_effect(c)

	--융합 소환
	RevLim(c)
	Fusion.AddProcMixRep(c,true,true,cm.matfilter,1,1,aux.FilterBoolFunctionEx(Card.IsLavaGolemCard))
	Fusion.AddContactProc(c,cm.contactfil,cm.contactop,cm.splimit)
	YuL.AddLavaGolemCost(c)
	
	--융합 제약
	YuL.NoMat(c,"F")
	
	--바운스
	local e1=MakeEff(c,"STo")
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(spinel.delay)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--공수 증가
	local e2=MakeEff(c,"Qo","M")
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1)
	WriteEff(e2,2,"CO")
	c:RegisterEffect(e2)
	
	--서치 / 샐비지
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(spinel.delay)
	e3:SetCL(1,m)
	e3:SetCondition(aux.PreOnfield)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	
end

cm.material_setcode={0xd6a}

--융합 소환
function cm.matfilter(c,fc,sumtype,tp)
	return c:IsLavaGolem() and c:IsLocation(LOCATION_MZONE) and (c:IsControler(tp) or c:IsFaceup())
end
function cm.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cm.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function cm.contactfil(tp)
	return Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
end
function cm.contactop(g,tp,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end

--바운스
function cm.tar1fil(c)
	return c:IsAbleToHand() and c:IsLavaGolemCard() and c:IsFaceup()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar1fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(cm.tar1fil,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tar1fil,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end

--공수 증가
function cm.cost2fil(c)
	return c:IsLavaGolem() and c:IsAbleToDeckAsCost()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cost2fil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cost2fil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(2000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end

--서치 + 샐비지
function cm.tar3fil(c)
	return ((c:IsLavaGolemCard() and c:IsType(YuL.ST)) or c:IsCode(m+1)) and c:IsAbleToHand()
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
