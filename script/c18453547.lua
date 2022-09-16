--이매진 드래곤스
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableReverseDualAttribute(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetD(id,0)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","M")
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCondition(s.con2)
	e2:SetValue(5)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetValue(1800)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_SET_BASE_DEFENSE)
	e4:SetValue(1500)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"STo")
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e5,5,"NTO")
	c:RegisterEffect(e5)
end
function s.con1(e,c,minc)
	if c==nil then
		return true
	end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.con2(e)
	local c=e:GetHandler()
	return not c:IsDualState() and not c:IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function s.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsDisabled() and not c:IsDualState()
end
function s.tfil5(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_WYRM) and c:IsAbleToHand()
end
function s.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil5,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil5,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end