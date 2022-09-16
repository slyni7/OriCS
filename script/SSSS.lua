SSSSGridmanCodes={}
SSSSGridmanCodes[18453503]=18453504
SSSSGridmanCodes[18453504]=18453503
SSSSGridmanCodes[18453496]=18453495
SSSSGridmanCodes[18453495]=18453496
SSSSGridmanCodes[18453502]=18453501
SSSSGridmanCodes[18453501]=18453502
SSSSGridmanCodes[18453507]=18453505
SSSSGridmanCodes[18453505]=18453507
SSSSGridmanCodes[18453493]=18453494
SSSSGridmanCodes[18453494]=18453493
SSSSGridmanCodes[18453497]=18453499
SSSSGridmanCodes[18453499]=18453497
SSSSGridmanCodes[18453506]=18453500
SSSSGridmanCodes[18453500]=18453506
SSSSGridmanCodes[18453510]=18453508
SSSSGridmanCodes[18453508]=18453510
SSSSGridmanCodes[18453512]=18453516
SSSSGridmanCodes[18453516]=18453512
SSSSGridmanCodes[18453513]=18453515
SSSSGridmanCodes[18453515]=18453513
SSSSGridmanCodes[18453509]=18453511
SSSSGridmanCodes[18453511]=18453509
SSSSGridmanCodes[18453517]=18453518
SSSSGridmanCodes[18453518]=18453517
SSSSGridmanCodes[18453514]=18453519
SSSSGridmanCodes[18453519]=18453514
function SSSSGridmanFilter(c)
	return SSSSGridmanCodes[c:GetOriginalCode()]~=nil
end
function SSSSGridmanCondition1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(SSSSGridmanFilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	return #g>0
end
function SSSSGridmanCondition2(e,c,og)
	if c==nil then
		return true
	end
	return SSSSGridmanFilter(c)
end
function SSSSGridmanOperation(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local sid=3
	if e:GetCode()==EVENT_CHAIN_SOLVING then
		sid=5
	end
	local g=Duel.GetMatchingGroup(SSSSGridmanFilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(18453493,sid))
		local sg=g:Select(tp,0,#g,nil)
		local tc=sg:GetFirst()
		while tc do
			local code=tc:GetOriginalCode()
			local gcode=SSSSGridmanCodes[code]
			local mt=_G["c"..code]
			local ct=0
			while true do
				if not mt.eff_ct[tc][ct] then
					break
				end
				mt.eff_ct[tc][ct]:Reset()
				ct=ct+1
			end
			mt.eff_ct[tc]=nil
			if YGOPRO_VERSION=="Percy/EDO" and IREDO_COMES_TRUE==nil then
				tc:Recreate(gcode)
				local nmt=_G["c"..gcode]
				if nmt==nil or nmt.initial_effect==nil then
					local token=Duel.CreateToken(tp,gcode)
				end
				tc:SetStatus(STATUS_INITIALIZING,true)
				nmt=_G["c"..gcode]
				nmt.initial_effect(tc)
				tc:SetStatus(STATUS_INITIALIZING,false)
			else
				Duel.DisableShuffleCheck()
				for i=1,12 do
					local info=Duel.ReadCard(gcode,i)
					tc:SetCardData(i,info)
				end
				local nmt=_G["c"..gcode]
				if nmt==nil or nmt.initial_effect==nil then
					local token=Duel.CreateToken(tp,gcode)
				end
				tc:SetStatus(STATUS_INITIALIZING,true)
				nmt=_G["c"..gcode]
				nmt.initial_effect(tc)
				tc:SetStatus(STATUS_INITIALIZING,false)
			end
			tc=sg:GetNext()
		end
	end
end
for p=0,1 do
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(SSSSGridmanOperation)
	Duel.RegisterEffect(e1,p)
	local e4=e1:Clone()
	e4:SetCode(EVENT_CHAIN_SOLVING)
	Duel.RegisterEffect(e4,p)
	if false then
		local e2=e1:Clone()
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCondition(SSSSGridmanCondition1)
		Duel.RegisterEffect(e2,p)
	else
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC_G)
		e2:SetRange(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCondition(SSSSGridmanCondition2)
		e2:SetOperation(SSSSGridmanOperation)
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e3:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0)
		e3:SetLabelObject(e2)
		Duel.RegisterEffect(e3,p)
	end
end