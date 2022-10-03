--smilegirl(미소미소녀) ABC
local m=18453343
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,18453340,18453341,18453342,true,true)
	c:SetUniqueOnField(1,0,m)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FTo","M")
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_TODECK)
	e4:SetCL(1)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
end
function cm.tfil4(c,e,tp,code)
	if not c:IsCode(code) then
		return false
	end
	if c:IsLoc("O") then
		return c:IsFaceup() and Duel.IsPlayerCanDraw(tp,1)
	elseif c:IsLoc("H") then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	elseif c:IsLoc("DG") then
		return c:IsAbleToHand()
	end
	return false
end
function cm.tfun4(g,e,tp)
	if not g:IsExists(Card.IsCode,1,nil,18453340)
		or not g:IsExists(Card.IsCode,1,nil,18453341)
		or not g:IsExists(Card.IsCode,1,nil,18453342) then
		return false
	end
	local ct=g:FilterCount(Card.IsLoc,nil,"H")
	return ct==0 or Duel.GetLocCount(tp,"M")>=ct
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GMGroup(cm.tfil4,tp,"OHDG",0,nil,e,tp,18453340)
	local g2=Duel.GMGroup(cm.tfil4,tp,"OHDG",0,nil,e,tp,18453341)
	local g3=Duel.GMGroup(cm.tfil4,tp,"OHDG",0,nil,e,tp,18453342)
	if chk==0 then
		local res=#g1>0 and #g2>0 and #g3>0
		if res then
			g1:Merge(g2)
			g1:Merge(g3)
			res=g1:CheckSubGroup(cm.tfun4,3,3,e,tp)
		end
		return res
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,"H")
	Duel.SOI(0,CATEGORY_TOHAND,nil,0,tp,"DG")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GMGroup(cm.tfil4,tp,"OHDG",0,nil,e,tp,18453340)
	local g2=Duel.GMGroup(cm.tfil4,tp,"OHDG",0,nil,e,tp,18453341)
	local g3=Duel.GMGroup(cm.tfil4,tp,"OHDG",0,nil,e,tp,18453342)
	if #g1<1 or #g2<1 or #g3<1 then
		return
	end
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g1:SelectSubGroup(tp,cm.tfun4,false,3,3,e,tp)
	local tc=sg:GetFirst()
	local ct=0
	local b=false
	local tg=Group.CreateGroup()
	while tc do
		if tc:IsLoc("O") then
			Duel.HintSelection(Group.FromCards(tc))
			ct=ct+1
		elseif tc:IsLoc("H") then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif tc:IsLoc("DG") then
			if tc:IsLoc("D") then
				b=true
			end
			tg:AddCard(tc)
		end
		tc=sg:GetNext()
	end
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	if b then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
	end
	while ct>0 do
		if Duel.Draw(tp,1,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local dg=Duel.SMCard(tp,Card.IsAbleToDeck,tp,"H",0,1,1,nil)
			if #dg>0 then
				Duel.SendtoDeck(dg,nil,1,REASON_EFFECT)
			end
		end
		ct=ct-1
	end
end