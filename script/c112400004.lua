--まげッピ
function c112400004.initial_effect(c)
	--re0(cannot be xyz material)
	local re0=Effect.CreateEffect(c)
	re0:SetType(EFFECT_TYPE_SINGLE)
	re0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	re0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	re0:SetValue(1)
	c:RegisterEffect(re0)
	--pendulum
	if Pendulum then Pendulum.AddProcedure(c) else aux.EnablePendulumAttribute(c) end
	--me1(def up)
	local me1=Effect.CreateEffect(c)
	me1:SetType(EFFECT_TYPE_FIELD)
	me1:SetCode(EFFECT_UPDATE_DEFENSE)
	me1:SetRange(LOCATION_MZONE)
	me1:SetTargetRange(LOCATION_ONFIELD,0)
	me1:SetTarget(aux.TargetBoolFunction(c112400004.me1filter))
	me1:SetValue(200)
	c:RegisterEffect(me1)
	--me2(def pos atk)
	local me2=Effect.CreateEffect(c)
	me2:SetType(EFFECT_TYPE_SINGLE)
	me2:SetCode(EFFECT_DEFENSE_ATTACK)
	me2:SetValue(1)
	c:RegisterEffect(me2)
	--pe1(double damage)
	local pe1=Effect.CreateEffect(c)
	if DOUBLE_DAMAGE then --Koishi or Core
		pe1:SetType(EFFECT_TYPE_FIELD)
		pe1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		pe1:SetRange(LOCATION_PZONE)
		pe1:SetTargetRange(LOCATION_MZONE,0)
		pe1:SetTarget(aux.TargetBoolFunction(c112400004.dfilter1))
		pe1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	else
		pe1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		pe1:SetRange(LOCATION_PZONE)
		pe1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		pe1:SetCondition(c112400004.dcon)
		pe1:SetOperation(c112400004.dop)
	end
	c:RegisterEffect(pe1)
	--pe2(dest toh)
	local pe2=Effect.CreateEffect(c)
	pe2:SetDescription(aux.Stringid(112400004,1))
	pe2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	pe2:SetType(EFFECT_TYPE_IGNITION)
	pe2:SetRange(LOCATION_PZONE)
	pe2:SetCountLimit(1,112400004)
	--pe2:SetCondition(c112400004.thcon)
	pe2:SetTarget(c112400004.thtg)
	pe2:SetOperation(c112400004.thop)
	c:RegisterEffect(pe2)
end
c112400004.listed_series={0x4ec1}
--me1(def up)
function c112400004.me1filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4ec1)
end
--pe1(double damage) (Koishi or Core)
function c112400004.dfilter1(c)
	return c:IsSetCard(0x4ec1) and c:IsDefensePos()
end
--pe1(double damage) (EDOPro or old Core)
function c112400004.dfilter2(c,e,tp)
	return c:IsSetCard(0x4ec1) and c:IsDefensePos() and c:IsControler(tp) --and not c:IsImmuneToEffect(e)
end
function c112400004.dcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and c112400004.dfilter2(eg:GetFirst(),e,tp)
end
function c112400004.dop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DoubleBattleDamage then --EDOPro
		Duel.DoubleBattleDamage(ep)
	else --old Core
		Duel.ChangeBattleDamage(ep,ev*2)
	end
end
--pe2(dest toh)
function c112400004.thfilter(c,code1,code2)
	return c:IsFaceup() and c:IsSetCard(0x4ec1) and bit.band(c:GetType(),0x1000001)==0x1000001
		and c:IsAbleToHand() and not c:IsCode(code1,code2)
end
function c112400004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local pc=Duel.GetFirstMatchingCard(aux.TRUE,tp,LOCATION_PZONE,0,c)
	if chk==0 then return pc and Duel.IsExistingMatchingCard(c112400004.thfilter,tp,LOCATION_EXTRA,0,2,nil,c:GetCode(),pc:GetCode()) end
	local g=Group.FromCards(c,pc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_EXTRA)
end
function c112400004.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pc=Duel.GetFirstMatchingCard(aux.TRUE,tp,LOCATION_PZONE,0,c)
	if not pc then return end
	local dg=Group.FromCards(c,pc)
	if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c112400004.thfilter,tp,LOCATION_EXTRA,0,2,2,nil,c:GetCode(),pc:GetCode())
	if #g==2 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
