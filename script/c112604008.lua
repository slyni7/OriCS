--관성과 좌표의 마녀(아트릭시아) 익스텐션
local m=112604008
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	--extention
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCost(kaos.atricost)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end

cm.CardType_ExRitual=true

--extention
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>1 end
	local dis=Duel.SelectDisableField(tp,2,LOCATION_MZONE,LOCATION_MZONE,0xe000e0)
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetLabel()
	if tp==1 then
		zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
	end
	local c=e:GetHandler()
	--disable field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetValue(zone)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
