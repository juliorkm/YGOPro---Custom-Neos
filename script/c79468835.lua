--Neo Space Headquarters
function c79468835.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummonneos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79468835,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c79468835.sptg)
	e2:SetOperation(c79468835.spop)
	c:RegisterEffect(e2)
	--spsummonspacian
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79468835,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,79468835)
	e3:SetTarget(c79468835.sptg2)
	e3:SetOperation(c79468835.spop2)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCondition(c79468835.negcon)
	e4:SetTarget(c79468835.negtarget)
	e4:SetOperation(c79468835.negop)
	c:RegisterEffect(e4)
end
function c79468835.spfilter1(c,e,tp)
	return c:IsSetCard(0x9) and c:GetLevel()<=7 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79468835.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c79468835.spfilter1),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c79468835.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c79468835.spfilter1),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		tc:RegisterFlagEffect(79468835,RESET_EVENT+0x1fe0000,0,1,fid)
		tc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(79468835,2))
		Duel.SpecialSummonComplete()
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(c79468835.retcon)
		e1:SetOperation(c79468835.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c79468835.retfilter(c,fid)
	return c:GetFlagEffectLabel(79468835)==fid
end
function c79468835.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c79468835.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c79468835.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c79468835.retfilter,nil,e:GetLabel())
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
end
function c79468835.spfilter2(c)
	return c:IsSetCard(0x1f) and c:IsAbleToGraveAsCost() and c:IsAbleToHand()
end
function c79468835.filter(c,code)
	return c:IsSetCard(0x1f) and not c:IsCode(code) and c:IsAbleToHand()
end
function c79468835.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g1=Duel.GetMatchingGroup(c79468835.spfilter2,tp,LOCATION_DECK,0,nil)
		return g1:GetClassCount(Card.GetCode)>=2 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79468835.spfilter2,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
function c79468835.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c79468835.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c79468835.negfilter(c,p)
	return c:GetControler()==p and c:IsOnField() and c:IsFaceup() and (c:IsSetCard(0x9) or c:IsSetCard(0x1f))
end
function c79468835.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
	return ex and tg~=nil and tc+tg:FilterCount(c79468835.negfilter,nil,tp)-tg:GetCount()==1
end
function c79468835.negtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c79468835.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
