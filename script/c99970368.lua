--[Aranea]
local m=99970368
local cm=_G["c"..m]
function cm.initial_effect(c)

	--융합 소환
	RevLim(c)
	aux.AddFusionProcFunFunRep(c,cm.fus1,cm.fus2,2,63,true)
	aux.AddContactFusionProcedure(c,cm.cfilter,LOCATION_MZONE,LOCATION_MZONE,Duel.SendtoGrave,REASON_COST)

	--공수 감소
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cm.val)
	c:RegisterEffect(e1)

	--샐비지 / 특수 소환
	local e2=MakeEff(c,"Qo","M")
	e2:SetD(m,0)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)

	--공수 증감
	local e5=MakeEff(c,"FTf","M")
	e5:SetD(m,2)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCL(1)
	e5:SetOperation(cm.atkop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e6)

end

--융합 소환
function cm.fus1(c)
	return c:IsSetCard(0xe14) and c:IsType(TYPE_TUNER)
end
function cm.fus2(c)
	return (math.abs(c:GetBaseAttack()-c:GetAttack())>=700 or math.abs(c:GetBaseDefense()-c:GetDefense())>=700)
end
function cm.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cm.cfilter(c,fc)
	return c:IsAbleToGraveAsCost() and (c:IsControler(fc:GetControler()) or c:IsFaceup())
end

--공수 감소
function cm.valfilter(c,att)
	return c:IsAttribute(att) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsRace(RACE_INSECT)
end
function cm.val(e,c)
	local atk=0
	if Duel.IsExistingMatchingCard(cm.valfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,c:GetAttribute()) then
		atk=-1000 end
	return atk
end

--샐비지 / 특수 소환
function cm.tar2fil(c)
	return c:IsSetCard(0xe14) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.tar2fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar2fil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.tar2fil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_GRAVE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not e:GetHandler():IsType(TYPE_TUNER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end

--공수 증감
function cm.aopfil(c,def)
	return c:IsFaceup() and (c:GetAttack()<def or c:GetDefense()<def)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	local g=Duel.GetMatchingGroup(cm.aopfil,tp,0,LOCATION_MZONE,nil,e:GetHandler():GetDefense())
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(0)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
		end
	end
end
