-- Passive association between a live native FIELDWORK Job Episode and a
-- registered source-field polygon. Field-course detection seed != proof that
-- the resulting course or all physical assembly movement belongs to that field.
-- Specification Jurisdictions: `NATIVE_JOB_COMPLETION_OBSERVATION`
-- Read-only, engineering DIAGNOSTIC candidate evidence; never Control admission.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionSourceFieldObservation={}
local Observation=OuttaMyWay.CompletionSourceFieldObservation
local MAX_REGISTERED_FIELDS=512

local function finite(v)
    return type(v)=="number" and v==v
        and v~=math.huge and v~=-math.huge
end

local function activeJob(vehicle)
    if type(vehicle)~="table" then return nil end
    local spec=vehicle.spec_aiJobVehicle
    local field=vehicle.spec_aiFieldWorker
    return (type(spec)=="table" and spec.job)
        or (type(field)=="table" and field.fieldJob)
end

local function detectionSeed(vehicle)
    local spec=vehicle.spec_aiFieldWorker
    if type(spec)~="table" or spec.isActive~=true
        or type(spec.driveStrategies)~="table" then
        return nil,"ACTIVE_FIELD_COURSE_UNAVAILABLE"
    end
    local seed=nil
    local hasNativeFieldCourse=false
    for _,strategy in pairs(spec.driveStrategies) do
        if type(strategy)=="table" and strategy.aiFieldCourse~=nil then
            hasNativeFieldCourse=true
            local x,z=strategy.fieldDetectionX,strategy.fieldDetectionZ
            if finite(x) and finite(z) then
                if seed~=nil and (seed.x~=x or seed.z~=z) then
                    return nil,"MULTIPLE_FIELD_DETECTION_SEEDS"
                end
                seed={x=x,z=z}
            end
        end
    end
    if not hasNativeFieldCourse then return nil,"ACTIVE_FIELD_COURSE_OBJECT_UNAVAILABLE" end
    if seed==nil then return nil,"FIELD_DETECTION_SEED_UNAVAILABLE" end
    return seed
end

function Observation.observe(vehicle,job)
    if type(job)~="table" or activeJob(vehicle)~=job then
        return nil,"ACTIVE_JOB_IDENTITY_MISMATCH"
    end
    local seed,reason=detectionSeed(vehicle)
    if seed==nil then return nil,reason end
    local fields=g_fieldManager and g_fieldManager.fields
    if type(fields)~="table" then return nil,"FIELD_REGISTRY_UNAVAILABLE" end
    local geometry=OuttaMyWay.FarmEdgeGeometry
    if type(geometry)~="table"
        or type(geometry.polygonFor)~="function"
        or type(geometry.inside)~="function" then
        return nil,"REGISTERED_POLYGON_OBSERVER_UNAVAILABLE"
    end
    local count,matched=0,nil
    for index,field in pairs(fields) do
        count=count+1
        if count>MAX_REGISTERED_FIELDS then
            return nil,"REGISTERED_FIELD_CENSUS_LIMIT"
        end
        if type(field)=="table" then
            local poly=geometry.polygonFor(field)
            if poly~=nil and geometry.inside(poly,seed.x,seed.z) then
                local fieldId=field.fieldId or index
                if type(fieldId)~="number" or fieldId<1
                    or fieldId%1~=0 then
                    return nil,"REGISTERED_FIELD_ID_UNAVAILABLE"
                end
                if matched~=nil then
                    return nil,"FIELD_DETECTION_POLYGON_AMBIGUOUS"
                end
                matched={fieldId=fieldId,polygon=poly,
                    detectionX=seed.x,detectionZ=seed.z,
                    provenance="ACTIVE_NATIVE_FIELD_COURSE_DETECTION_SEED",
                    status="CANDIDATE_NOT_CONTROL_AUTHORITY"}
            end
        end
    end
    if matched==nil then return nil,"FIELD_DETECTION_POLYGON_UNMATCHED" end
    return matched
end
return Observation
