--사일런트 무브먼트
local m=18453099
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","F")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,0,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=SilentMajorityGroups[tp]:Filter(function(c) return c:GetOriginalCode()==18453100 and c:IsAbleToHand() end,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,0,1,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.tfil21(c,e,tp)
	return c:IsSetCard(0x2e0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tfil22(c,m)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x2e0) and c:CheckFusionMaterial(m,nil,PLAYER_NONE)
end
function cm.fcheck(tp,sg,fc)
	return #sg<3 and sg:FilterCount(Card.IsLoc,nil,"H")<2 and sg:FilterCount(Card.IsLoc,nil,"D")<2
end
function cm.gcheck(sg)
	return #sg<3 and sg:FilterCount(Card.IsLoc,nil,"H")<2 and sg:FilterCount(Card.IsLoc,nil,"D")<2
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GMGroup(cm.tfil21,tp,"HD",0,nil,e,tp)
		Auxiliary.FCheckAdditional=cm.fcheck
		if Fusion then
			Fusion.CheckAdditional=cm.fcheck
		end
		Auxiliary.GCheckAdditional=cm.gcheck
		local res=SilentMajorityGroups[tp]:IsExists(cm.tfil22,1,nil,mg)
		Auxiliary.FCheckAdditional=nil
		if Fusion then
			Fusion.CheckAdditional=nil
		end
		Auxiliary.GCheckAdditional=nil
		return res and Duel.GetLocCount(tp,"M")>1
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<2 then
		return
	end
	local mg=Duel.GMGroup(cm.tfil21,tp,"HD",0,nil,e,tp)
	Auxiliary.FCheckAdditional=cm.fcheck
	if Fusion then
		Fusion.CheckAdditional=cm.fcheck
	end
	Auxiliary.GCheckAdditional=cm.gcheck
	local sg=SilentMajorityGroups[tp]:Filter(cm.tfil22,nil,mg)
	if #sg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,PLAYER_NONE)
		Duel.SpecialSummon(mat,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	Auxiliary.FCheckAdditional=nil
	if Fusion then
		Fusion.CheckAdditional=nil
	end
	Auxiliary.GCheckAdditional=nil
end