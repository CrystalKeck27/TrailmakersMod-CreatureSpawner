function update()
    playerList = tm.players.CurrentPlayers()
    for key, player in pairs(playerList) do
        pos = tm.players.GetPlayerPosition(player.playerId)
    end
    if autospawn then
        if os.time() - lasttime > 0 then
            spawnObject(spawnCallbackData)
            lasttime = os.time()
        end
    end
end

function addUiForPlayer(playerId)

    tm.playerUI.AddUIText(playerId, "setSpawnAmount", "1", onSetSpawnAmountTxt)

    tm.playerUI.AddUIText(playerId, "objectToSpawn", "Ball", onObjectToSpawnChanged);

    tm.playerUI.AddUIButton(playerId, "spawnObject", "Spawn Item", spawnObject, nil)

    tm.playerUI.AddUIButton(playerId, "cleanup", "Cleanup spawns ", onCleanupSpawns, nil)

    tm.playerUI.AddUIButton(playerId, "enableautospawn", "enable auto spawn", OnAutoSpawnEnable, nil)
    tm.playerUI.AddUIButton(playerId, "disableautospawn", "disable auto spawn", OnAutoSpawnDisable, nil)

    -- tm.playerUI.AddUIButton(playerId, "Spawnlist", "Spawnlist", Spawnlist, nil)

    -- tm.playerUI.AddUIButton(playerId, "PlayerLog", "PlayerLog", PlayerLog, nil)
end

spawnAmount = 1
autospawn = false
lasttime = 0
spawnCallbackData = nil
objectToSpawn = "PFB_MovePuzzleBall"
iscustomobject = false

function OnAutoSpawnEnable(callbackData)
    autospawn = true
    lasttime = os.time()
    spawnCallbackData = callbackData
end

function OnAutoSpawnDisable(callbackData)
    autospawn = false
end

function onObjectToSpawnChanged(callbackData)
    iscustomobject = false
    objectToSpawn = spawnTable[string.lower(callbackData.value)]
    if objectToSpawn == nil then
        iscustomobject = true
        objectToSpawn = customSpawnTable[string.lower(callbackData.value)]
    end
end

function onSetSpawnAmountTxt(callbackData)
    spawnAmount = tonumber(callbackData.value)
end

function spawn(name, callbackData)
    local pos = tm.players.GetPlayerPosition(callbackData.playerId)
    local counter = 0
    local j = 0
    while counter < spawnAmount do
        for i = 0, 9 do
            if counter >= spawnAmount then
                break
            end
            tm.physics.SpawnObject(tm.vector3.Create(pos.x + 10 + i * 2, pos.y + 2, pos.z + j * 2), name)
            counter = counter + 1
        end
        j = j + 1
    end
end

function spawnObject(callbackData)
    if iscustomobject then
        spawnCustom(objectToSpawn, callbackData)
    else
        spawn(objectToSpawn, callbackData)
    end
end

function spawnCustom(ctable, callbackData)
    local pos = tm.players.GetPlayerPosition(callbackData.playerId)
    local counter = 0
    local j = 0
    while counter < spawnAmount do
        for i = 0, 9 do
            if counter >= spawnAmount then
                break
            end
            tm.physics.SpawnCustomObject(tm.vector3.Create(pos.x + 10 + i * 2, pos.y + 2, pos.z + j * 2), ctable.mesh,
                                         ctable.tex, ctable.static, 1)
            counter = counter + 1
        end
        j = j + 1
    end
end

function onCleanupSpawns(callbackData)
    tm.physics.ClearAllSpawns()
end

function Spawnlist(callbackData)
    spawnList = tm.physics.SpawnableNames()
    for k, v in pairs(spawnList) do
        tm.os.Log(v)
    end
end

function onPlayerJoined(player)
    tm.os.Log("player joined")
    addUiForPlayer(player.playerId)
end

tm.players.OnPlayerJoined.add(onPlayerJoined)

spawnTable = {
    metalball = "PFB_MovePuzzleBall",
    ball = "pfb_Ball",
    runner = "PFB_Runner",
    monkey = "PFB_Runner-Monkey",
    ark = "PFB_ArkCollected",
    mine = "PFB_Mine",
    height = "PFB_Heightjump",
    ejs = "PFB_EpicJumpSequence",
    redcontainer = "PFB_Container_Red_Dynamic",
    orangecontainer = "PFB_Container_Orange_Dynamic",
    bluecontainer = "PFB_Container_Blue_Dynamic",
    barrel = "PFB_Barrel",
    redbarrel = "PFB_ExplosiveBarrel",
    wheelstack = "PFB_PropWheelStack",
    shipwreck = "PFB_ShipWreck",
    ring = "PFB_RacingCheckPoint",
    halfring = "PFB_RacingCheckPoint_Halfcircle",
    halfpipe = "PFB_Tube3-NoHoles2",
    spinner = "PFB_Spinner",
    grinder = "PFB_Grinderv2",
    hoop = "PFB_BasketBallHoop",
    pinetree = "PFB_BulkyPineTree_FBX",
    poison = "PFB_PoisonCloud_Explosion",
    salvageball = "PFB_SalvageItem_Ball",
    salvageballm = "PFB_SalvageItem_Ball_M",
    salvageballl = "PFB_SalvageItem_Ball_L",
    salvage = "PFB_SalvageItem",
    salvagem = "PFB_SalvageItem_M",
    salvagel = "PFB_SalvageItem_L",
    salvagexl = "PFB_SalvageItem_XL",
    rampwedge = "RampWedge",
    ringoffire = "PFB_RingofFire",
    no = "PFB_IronCrate",
    whale = "PFB_Whale"
}

tm.physics.AddMesh("capsule.obj", "capsule")
tm.physics.AddTexture("capsule0.jpg", "capsuleTex")
-- tm.physics.AddMesh("companioncube.obj", "portalcube")
-- tm.physics.AddTexture("companioncube.mtl", "companionCubeTex")
tm.physics.AddMesh("spike.obj", "spike")
tm.physics.AddTexture("spike.mtl", "spikeTex")

customSpawnTable = {
    capsule = {
        mesh = "capsule",
        tex = "capsuleTex",
        static = false
    },
    capsulestatic = {
        mesh = "capsule",
        tex = "capsuleTex",
        static = true
    },
    spike = {
        mesh = "spike",
        tex = "nil",
        static = false
    }
}
