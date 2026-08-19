OuttaMyWay.AuthorityRegistry = {}
local Registry = OuttaMyWay.AuthorityRegistry
Registry.__index = Registry

local Token = OuttaMyWay.ValueRecord.register(
    "AuthorityToken",
    OuttaMyWay.ValueRecord.define("AuthorityToken", {"identity","assemblyId","commitmentId","authorityClass","epoch","generation"}, {})
)

local PROGRESS="PROGRESS_ACTUATION"
local POST_JOB="POST_JOB_ACTUATION"

function Registry.new(identityRegistry, epochSequence, commitmentRegistry)
    return setmetatable({identities=identityRegistry,epochs=epochSequence,commitments=commitmentRegistry,byAssembly={},generations={}},Registry)
end

function Registry:_acquire(assemblyId,commitmentId,authorityClass)
    if type(assemblyId)~="string" or assemblyId=="" then error("assembly identity required",2) end
    if authorityClass~=PROGRESS and authorityClass~=POST_JOB then error("unsupported authority class",2) end
    local commitment=self.commitments:get(commitmentId)
    if commitment==nil or commitment.state~="ACTIVE" then error("only an ACTIVE Commitment may own actuation authority",2) end
    if self.byAssembly[assemblyId]~=nil then error("assembly already has an OuttaMyWay actuation owner",2) end
    local generation=(self.generations[assemblyId] or 0)+1; self.generations[assemblyId]=generation
    local token=Token.new({identity=self.identities:issue("AUTHORITY"),assemblyId=assemblyId,commitmentId=commitmentId,authorityClass=authorityClass,epoch=self.epochs:next(),generation=generation})
    self.byAssembly[assemblyId]=token
    return token
end
function Registry:acquireProgress(assemblyId,commitmentId) return self:_acquire(assemblyId,commitmentId,PROGRESS) end
function Registry:acquirePostJob(assemblyId,commitmentId) return self:_acquire(assemblyId,commitmentId,POST_JOB) end
function Registry:ownerOf(assemblyId) local token=self.byAssembly[assemblyId]; return token and token.commitmentId or nil end
function Registry:classOf(assemblyId) local token=self.byAssembly[assemblyId]; return token and token.authorityClass or nil end
function Registry:validate(token) OuttaMyWay.ValueRecord.assertType(token,"AuthorityToken"); return self.byAssembly[token.assemblyId]==token and self.generations[token.assemblyId]==token.generation end
function Registry:release(token) if not self:validate(token) then error("stale or foreign authority token",2) end; self.byAssembly[token.assemblyId]=nil; return true end
function Registry:tokensForCommitment(commitmentId)
    local result={}
    for _,token in OuttaMyWay.ValueRecord.pairs(self.byAssembly) do if token.commitmentId==commitmentId then result[#result+1]=token end end
    table.sort(result,function(a,b) return a.identity<b.identity end); return result
end
local function hasClass(self,commitmentId,class)
    for _,token in OuttaMyWay.ValueRecord.ipairs(self:tokensForCommitment(commitmentId)) do if token.authorityClass==class then return true end end
    return false
end
function Registry:hasProgressAuthority(commitmentId) return hasClass(self,commitmentId,PROGRESS) end
function Registry:hasPostJobAuthority(commitmentId) return hasClass(self,commitmentId,POST_JOB) end
function Registry:hasAnyAuthority(commitmentId) return #self:tokensForCommitment(commitmentId)>0 end
function Registry:releaseForCommitment(commitmentId)
    local tokens=self:tokensForCommitment(commitmentId); local released={}
    for _,token in OuttaMyWay.ValueRecord.ipairs(tokens) do self:release(token); released[#released+1]=token.identity end
    return released
end
