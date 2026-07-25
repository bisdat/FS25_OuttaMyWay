-- FS25_OuttaMyWay v4.6.10
-- Prototype 08 model-derived collision-node catalogue for the purchased 36 m
-- Agrifac Condor Endurance II geometry family. Mesh local bounds remain unresolved.

OuttaMyWay.ModelCollisionCatalogues = OuttaMyWay.ModelCollisionCatalogues or {}

OuttaMyWay.ModelCollisionCatalogues.condorEndurance2_36m = {
    schemaVersion = 1,
    prototype = "08B",
    assetSuffix = "data/vehicles/agrifac/condorEndurance2/condorEndurance2.xml",
    foldingConfigurationId = 1,
    workingWidthM = 36.0,
    animationName = "foldingAnim36",
    animationDurationS = 15.8,
    deployedFoldAnimTime = 0.0,
    foldedFoldAnimTime = 1.0,
    physicalCompoundChildCount = 29,
    activeBoomCollisionCount = 8,
    meshExtentStatus = "UNRESOLVED_BINARY_I3D_SHAPES",
    catalogueCompleteness = "IDENTITY_HIERARCHY_POSE_ONLY",
    authoritativeEnvelope = false,
    workingWidthSubstitution = false,
    predictedOriginSpans = {
        deployed = {minX=-15.120165, maxX=15.120166, minZ=-4.564740, maxZ=-3.751126, spanX=30.240331, spanZ=0.813614},
        folded = {minX=-1.411875, maxX=1.411832, minZ=-2.114229, maxZ=5.856771, spanX=2.823707, spanZ=7.971000}
    },
    activeCollisionNodes = {
        {name="boom01ArmLeftCol01", mappingPath="0>0|4|2|0|0|0|0|0|0|0|0|0|0|0|0|0|7", shapeId=88, i3dNodeId=404,
            predictedDeployed={3.457294,2.217354,-3.840936}, predictedFolded={0.948300,3.409755,-1.639409}, meshLocalBounds=nil},
        {name="boom01ArmLeftCol02", mappingPath="0>0|4|2|0|0|0|0|0|0|0|0|0|0|0|0|0|1|8", shapeId=82, i3dNodeId=375,
            predictedDeployed={9.018374,2.140584,-3.799254}, predictedFolded={1.232967,3.322400,-2.114229}, meshLocalBounds=nil},
        {name="boom01ArmLeftCol03", mappingPath="0>0|4|2|0|0|0|0|0|0|0|0|0|0|0|0|0|1|1|5", shapeId=76, i3dNodeId=344,
            predictedDeployed={15.120166,2.051944,-3.751126}, predictedFolded={1.411832,3.221537,-2.045133}, meshLocalBounds=nil},
        {name="boom01ArmLeftCol04", mappingPath="0>0|4|2|0|0|0|0|0|0|0|0|0|0|0|0|0|1|0|0", shapeId=72, i3dNodeId=337,
            predictedDeployed={1.045584,1.396965,-4.564740}, predictedFolded={0.191507,3.034153,5.856755}, meshLocalBounds=nil},
        {name="boom01ArmRightCol01", mappingPath="0>0|4|2|0|0|0|0|0|0|0|0|1|0|0|0|0|7", shapeId=150, i3dNodeId=710,
            predictedDeployed={-3.457295,2.217354,-3.840936}, predictedFolded={-0.948315,3.409755,-1.639393}, meshLocalBounds=nil},
        {name="boom01ArmRightCol02", mappingPath="0>0|4|2|0|0|0|0|0|0|0|0|1|0|0|0|0|1|8", shapeId=144, i3dNodeId=681,
            predictedDeployed={-9.018373,2.140585,-3.799254}, predictedFolded={-1.232982,3.322400,-2.114213}, meshLocalBounds=nil},
        {name="boom01ArmRightCol03", mappingPath="0>0|4|2|0|0|0|0|0|0|0|0|1|0|0|0|0|1|1|5", shapeId=138, i3dNodeId=650,
            predictedDeployed={-15.120165,2.051945,-3.751127}, predictedFolded={-1.411875,3.221537,-2.045119}, meshLocalBounds=nil},
        {name="boom01ArmRightCol04", mappingPath="0>0|4|2|0|0|0|0|0|0|0|0|1|0|0|0|0|1|0|0", shapeId=134, i3dNodeId=643,
            predictedDeployed={-1.045584,1.396966,-4.564739}, predictedFolded={-0.191523,3.034153,5.856771}, meshLocalBounds=nil}
    }
}
