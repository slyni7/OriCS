--[Insomnia]
local m=99970485
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0xe0a))

	--불멸화
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(RACE_ZOMBIE)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=MakeEff(c,"Qo","S")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	
	--회수
	local e3=MakeEff(c,"I","G")
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(aux.exccon)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	
end

--특수 소환
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:GetControler()==c:GetEquipTarget():GetControler()
		and c:GetEquipTarget():IsAbleToGraveAsCost() end
	local g=Group.FromCards(c,c:GetEquipTarget())
	e:SetLabel(c:GetEquipTarget():GetLevel())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.filter(c,lv,e,tp)
	return c:IsSetCard(0xe0a) and not c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetEquipTarget():GetLevel(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--회수
function cm.tdfil(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToDeck()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfil,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfil,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
end
