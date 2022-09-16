--A.I(A lost Is nowhere) 終焉
local m=112600064
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand
	kaos.AlostIsnowhere(c)
end

--Activate
function cm.filter(c,e,tp,lp)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0xe82) 
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) then return false end
	return lp>c:GetLevel()*300
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lp=Duel.GetLP(tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,lp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lp=Duel.GetLP(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,lp)
	local tc=tg:GetFirst()
	if tc then
		Duel.PayLPCost(tp,tc:GetLevel()*300)
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end