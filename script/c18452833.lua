--스퀘어 소서러
local m=18452833
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.pfil1,2,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LSTN("MG"),0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_MATERIAL)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function cm.pfil1(c,fc,sub,mg,sg)
	if not c:IsCustomType(CUSTOMTYPE_SQUARE) then
		return false
	end
	if not sg or sg:FilterCount(aux.TRUE,c)==0 then
		return true
	end
	local g=sg:Clone()
	g:AddCard(c)
	local st=fc.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={ATTRIBUTE_LIGHT,0x0,0x0,0x0,ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.val1(e,se,sp,st)
	local c=e:GetHandler()
	return st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION or not c:IsLocation(LOCATION_EXTRA)
end
function cm.tfil2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("MG") and cm.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,"MG","MG",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.STarget(tp,cm.tfil2,tp,"MG","MG",1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end