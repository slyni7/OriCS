--금의 연금생물학자 사이카
local m=18452946
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.pfil1,cm.pfun1,2,2)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(m,0))
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCountLimit(1,m+1)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.pfil1(c,xc)
	return c:IsXyzLevel(xc,8)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={0x0,0x0,0x0,0x0,ATTRIBUTE_FIRE,ATTRIBUTE_EARTH,ATTRIBUTE_WIND,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.nfil1(c)
	return c:IsType(TYPE_XYZ) and c:IsCustomType(CUSTOMTYPE_SQUARE)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	return c:IsSummonType(SUMMON_TYPE_XYZ) and og:IsExists(cm.nfil1,1,nil)
end
function cm.tfil1(c,e,tp)
	return c:IsSetCard("연금생물") and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	local ft=Duel.GetLocCount(tp,"M")
	local g=Duel.GMGroup(cm.tfil1,tp,"G",0,nil,e,tp)
	if chk==0 then
		return ft>0 and #g>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	Duel.SetTargetCard(sg)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocCount(tp,"M")
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if ft<1 or #g<1 then
		return
	end
	if #g>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.cfil2(c,tp)
	return c:IsRace(RACE_ALCHEMIST) and not c:IsAttribute(cm[tp])
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,cm.cfil2,1,c,tp)
	end
	local g=Duel.SelectReleaseGroup(tp,cm.cfil2,1,1,c,tp)
	local tc=g:GetFirst()
	cm[tp]=cm[tp]|tc:GetAttribute()
	Duel.Release(g,REASON_COST)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsAbleToRemove,tp,0,"O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.STarget(tp,Card.IsAbleToRemove,tp,0,"O",1,1,nil)
	Duel.SOI(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if chk==0 then
		return #og>0 and Duel.IsPlayerCanDraw(tp,#og) and c:IsReleasable()
	end
	e:SetLabel(#og)
	Duel.Release(c,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
end