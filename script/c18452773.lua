--인투 디 언논 월드
local m=18452773
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","S")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_BE_CUSTOM_MATERIAL)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	if r~=CUSTOMREASON_DELIGHT then
		return
	end
	local tc=eg:GetFirst()
	while tc do
		local rc=tc:GetReasonCard()
		if tc:IsPreviousLocation(LSTN("G")) then
			rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,0)
		elseif tc:IsPreviousLocation(LSTN("M")) then
			rc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,0)
		end
		tc=eg:GetNext()
	end
end
function cm.nfil2(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsCustomType(CUSTOMTYPE_DELIGHT) and c:IsLoc("M")
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local label=0
	local g=eg:Filter(cm.nfil2,nil,tp)
	local tc=g:GetFirst()
	while tc do
		local flag=0
		if tc:GetFlagEffect(m)>0 then
			flag=flag|1
		end
		if tc:GetFlagEffect(m+1)>0 then
			flag=flag|2
		end
		label=label|flag
		tc=g:GetNext()
	end
	e:SetLabel(label)
	return #g>0
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.nfil2,nil,tp)
	local att=0
	local tc=g:GetFirst()
	while tc do
		att=att|tc:GetAttribute()
		tc=g:GetNext()
	end
	local res=true
	for _,flag in ipairs({Duel.GetFlagEffectLabel(tp,m)}) do
		if (flag==0 and att==0) or flag&att>0 then
			res=false
			break
		end
	end
	if chk==0 then
		return res
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1,att)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_HANDES,nil,0,tp,0)
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,0)
end
function cm.ofil2(c)
	return c:IsSetCard(0x2e7) and c:IsCustomType(CUSTOMTYPE_DELIGHT) and c:IsAbleToGrave()
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local label=e:GetLabel()
	local g1=Duel.GMGroup(aux.TRUE,tp,"H",0,nil)
	if #g1>0 and Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg1,REASON_DISCARD+REASON_EFFECT)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	local g2=Duel.GMGroup(cm.ofil2,tp,"E",0,nil)
	if #g2>0 and label&1>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg2,REASON_EFFECT)
	end
	if label&2>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTR("M",0)
		e1:SetValue(400)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		Duel.RegisterEffect(e2,tp)
	end
end