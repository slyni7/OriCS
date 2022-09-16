--운명의 좌 「암전」
local m=99970443
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환 장착
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

	--가챠는 나쁜 문명!
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	--레벨 감소
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(-4)
	c:RegisterEffect(e3)
	
	--모듈 소재 불가
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_MODULE_MATERIAL)
	e4:SetValue(1)
	e4:SetCondition(cm.con4)
	c:RegisterEffect(e4)
	
	--전투 내성 부여
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	e5:SetCondition(cm.con5)
	c:RegisterEffect(e5)
	
end

--특수 소환 장착
function cm.filter(c,e,tp)
	return c:IsSetCard(0xd3b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSummonableCard()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(cm.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end

--가챠는 좋은 문명!
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	return c:GetFlagEffect(m)==0 and tc~=nil
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
	Duel.Hint(HINT_CARD,0,m)
	local atk=YuL.random(-2000,2000)
	Duel.Hint(HINT_NUMBER,tp,atk)
	Duel.Hint(HINT_NUMBER,1-tp,atk)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(atk)
	c:RegisterEffect(e1)
end

--모듈 소재 불가
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	return tc~=nil and tc:GetAttack()<=0
end

--전투 내성 부여
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	return tc~=nil and tc:GetAttack()>0
end
