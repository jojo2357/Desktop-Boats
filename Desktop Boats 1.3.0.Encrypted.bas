'OPTION _EXPLICIT

_TITLE "Desktop Boats"

'Tunes&(1) = _SNDOPEN("OMAM\King&Lionheart.mp3")
'PRINT "1 song loaded"
'Tunes&(2) = _SNDOPEN("OMAM\DirtyPaws.mp3")
'PRINT "2 songs loaded"
'Tunes&(3) = _SNDOPEN("OMAM\YellowLight.mp3")
'PRINT "DONE"
'playing& = Tunes&(1)
'playercounter = 1
'SLEEP 1
'CLS

'IF _FILEEXISTS("Desktop Boats 1.1.0 to 1.2.0 Save File Converter.exe") THEN
'  _DELAY 1
'  KILL "Desktop Boats 1.1.0 to 1.2.0 Save File Converter.exe"
'END IF


DIM MinHeight
MinHeight = 600
DIM MaxHeight
IF _DESKTOPHEIGHT < 1400 THEN
    MaxHeight = _DESKTOPHEIGHT - 100
ELSE MaxHeight = 1300
END IF
DIM MinWidth
MinWidth = 800
DIM MaxWidth
IF _DESKTOPHEIGHT < 800 THEN
    MaxWidth = _DESKTOPWIDTH - 100
ELSE MaxWidth = 800
END IF

DIM fullScreen&
fullScreen& = _NEWIMAGE(MaxWidth, MaxHeight, 32)

DIM regularScreen&
regularScreen& = _NEWIMAGE(MinWidth, MinHeight, 32)

DIM killCommand
killCommand = _EXIT

ON _EXIT GOTO leaveAndSave

DIM timerOne
timerOne = _FREETIMER
DIM musicTimer
musicTimer = _FREETIMER

ON TIMER(timerOne, 1) GOSUB Timer.Trap

DIM OtherFile$
OtherFile$ = "MainSaveFile.bin"

OPEN "DebugOutput.txt" FOR OUTPUT AS #4

TYPE lifeTimeStats
    coinsIn AS _INTEGER64
    dist AS _INTEGER64
    fuel AS _INTEGER64
    time AS _INTEGER64
    delivered AS _INTEGER64
END TYPE

TYPE CargoType
    Value AS _UNSIGNED INTEGER
    Destination AS _UNSIGNED _BYTE
    Title AS STRING * 20
    Rarity AS _FLOAT
    TypingNumber AS _UNSIGNED _BYTE
    stat AS lifeTimeStats
END TYPE

TYPE loadedCargo
    vaLue AS _UNSIGNED INTEGER
    DestinaTion AS _UNSIGNED _BYTE
    hostBoat AS _UNSIGNED _BYTE
    spotFilled AS _UNSIGNED _BYTE
    Title AS STRING * 20
    typingNumber AS _BYTE
    Rarity AS _FLOAT
END TYPE

TYPE cargoNames
    Title AS STRING * 20
    Rarity AS _FLOAT
    a AS SINGLE
    b AS SINGLE
    c AS SINGLE
    d AS SINGLE
    e AS SINGLE
    f AS SINGLE
    g AS SINGLE
    h AS SINGLE
    picture AS _FLOAT
    stat AS lifeTimeStats
    REM FORMAT of value equation | multiplier = a +(b + cx^d)/(e(f + gx^h)
END TYPE

TYPE PortType
    level AS _UNSIGNED _BYTE
    name AS STRING * 13
    cagoincity AS _UNSIGNED _BYTE
    cost AS _UNSIGNED INTEGER
    stat AS lifeTimeStats
END TYPE

TYPE BoatPart
    boatPart AS _UNSIGNED _BYTE
    cost AS _UNSIGNED _INTEGER64
    form AS _UNSIGNED _BYTE
    tiTle AS STRING * 15
END TYPE

TYPE PartMaster
    cost AS _UNSIGNED _INTEGER64
END TYPE

numOfCities = 8

DIM port(numOfCities) AS PortType

DIM Xcooordinates(numOfCities)
Xcoordinates(1) = 949
Xcoordinates(2) = 940
Xcoordinates(3) = 914
Xcoordinates(4) = 759
Xcoordinates(5) = 406
Xcoordinates(6) = 357
Xcoordinates(7) = 467
Xcoordinates(8) = -1169

DIM Ycoordinates(numOfCities)
Ycoordinates(1) = 166
Ycoordinates(2) = 133
Ycoordinates(3) = 107
Ycoordinates(4) = -16
Ycoordinates(5) = 621
Ycoordinates(6) = 591
Ycoordinates(7) = -66
Ycoordinates(8) = 571

DIM distanceBetween(0 TO numOfCities, 0 TO numOfCities)
FOR firstCity = 1 TO numOfCities
    FOR secondcity = firstCity + 1 TO numOfCities
        distanceBetween(firstCity, secondcity) = cargocoinvalue(Xcoordinates(firstCity), Ycoordinates(firstCity), Xcoordinates(secondcity), Ycoordinates(secondcity))
        distanceBetween(secondcity, firstCity) = cargocoinvalue(Xcoordinates(firstCity), Ycoordinates(firstCity), Xcoordinates(secondcity), Ycoordinates(secondcity))
    NEXT
    distanceBetween(firstCity, firstCity) = 0
NEXT

DIM cargointheHull(100) AS loadedCargo
DIM cargo(1 TO 100, 1 TO numOfCities) AS CargoType
DIM cargoResorter(100) AS CargoType
DIM amountofCargo(1 TO numOfCities) AS _BYTE
DIM cargoToCIty(1 TO numOfCities) AS _BYTE

numOfBoatTypes = 4

DIM ownedParts(1 TO 3, 1 TO numOfBoatTypes)

DIM part(1 TO 11) AS BoatPart

DIM masterPart(1 TO numOfBoatTypes) AS PartMaster
masterPart(1).cost = 3000
masterPart(2).cost = 5000
masterPart(3).cost = 7500
masterPart(4).cost = 12500

DIM partName(1 TO 3) AS STRING * 10
partName(1) = "Hull"
partName(2) = "Engine"
partName(3) = "Controls"

DIM cargoTodestination(numOfCities) AS _UNSIGNED _BYTE

DIM coins(2)
coins(1) = 40000

port(1).level = 1
port(2).level = 1
port(3).level = 1

TYPE boat
    owned AS _UNSIGNED _BYTE
    boatType AS _UNSIGNED _BYTE
    Boatfuel AS INTEGER
    MaxBoatfuel AS _UNSIGNED INTEGER
    AvailibleCargosLot AS _UNSIGNED _BYTE
    MaxCargoSlot AS _UNSIGNED _BYTE
    Destination AS _UNSIGNED _BYTE
    timeToDestination AS INTEGER
    Speedmultiplier AS _FLOAT
    TickSent AS _FLOAT
    Origin AS _UNSIGNED _BYTE
    cityNumber AS _UNSIGNED _BYTE
    scheduled AS _BYTE
    stat AS lifeTimeStats
END TYPE

TYPE boatType
    MaxBoatfuel AS _UNSIGNED INTEGER
    MaxCargoSlot AS _UNSIGNED _BYTE
    Speedmultiplier AS _FLOAT
END TYPE

DIM boats(1 TO 25) AS boat
DIM boatsInCity(1 TO 25) AS _BYTE

pediaPosition = 1
statPage = 1

DIM clicked(1 TO 100, 1 TO numOfCities) AS _BYTE
DIM clickResorter(1 TO 100) AS _BYTE
DIM partClicked(1 TO 100) AS _BYTE

DIM fuelingPossible AS _UNSIGNED INTEGER

DIM listPositions(1 TO 25) AS _BYTE
FOR i = 1 TO 25
    listPositions(i) = i
NEXT

DIM boatsIncity AS _UNSIGNED _BYTE

DIM gameStartTime AS _INTEGER64

gameStartTime = INT(TIMER(1))

lastShopUpdate = gameStartTime - 600

_DEST scrn&

DIM cargoNames(1 TO 5) AS cargoNames
numOfNames = 5
FOR nameAssigner = 1 TO numOfNames
    REM FORMAT of value equation | multiplier = a +(b + cx^d)/(e(f + gx^h)
    cargoNames(nameAssigner).a = .6
    cargoNames(nameAssigner).b = 1
    cargoNames(nameAssigner).c = 0
    cargoNames(nameAssigner).d = 0
    cargoNames(nameAssigner).e = .5
    cargoNames(nameAssigner).f = 1
    cargoNames(nameAssigner).g = 2
    cargoNames(nameAssigner).h = 5
NEXT
cargoNames(1).Title = "Dynamite"
cargoNames(2).Title = "Matches"
cargoNames(3).Title = "Rocks"
cargoNames(4).Title = "Jewels"
cargoNames(5).Title = "Sea Water"

'cargoPicture(1) = _LOADIMAGE(CargoDirect$ + "Dynamite.jpg")
'cargoPicture(2) = _LOADIMAGE(CargoDirect$ + "Matches.jpg")
'cargoPicture(3) = _LOADIMAGE(CargoDirect$ + "Rock.jpg")
'cargoPicture(4) = _LOADIMAGE(CargoDirect$ + "Jewels.jpg")
'cargoPicture(5) = _LOADIMAGE(CargoDirect$ + "Water.jpg")

cargoNames(1).Rarity = 20
cargoNames(2).Rarity = 20
cargoNames(3).Rarity = 40
cargoNames(3).a = .8
cargoNames(3).b = 1
cargoNames(3).e = .5
cargoNames(3).f = 1.25
cargoNames(3).g = 2
cargoNames(3).h = 5
cargoNames(4).Rarity = 10
cargoNames(4).a = 2
cargoNames(4).b = 1
cargoNames(4).e = 1
cargoNames(4).f = 1
cargoNames(4).g = 1
cargoNames(4).h = 4
cargoNames(5).Rarity = 10
cargoNames(5).a = -0.1
cargoNames(5).b = 1
cargoNames(5).e = 1
cargoNames(5).f = 1
cargoNames(5).g = 1
cargoNames(5).h = 0.5
sumOfRarities = 100

baseDepriciator = 1

DIM DynamicRarities(1 TO numOfCities, 1 TO numOfNames) AS INTEGER
DIM eachCityRarity(1 TO numOfCities, 1 TO numOfNames)

SCREEN fullScreen&

_SCREENMOVE 0, 0

TYPE partPictures
    image AS _FLOAT
END TYPE

DIM E AS _FLOAT
DIM F AS _FLOAT

ImageDirect$ = "Images\"
BoatDirect$ = ImageDirect$ + "BoatImages\"
CargoDirect$ = ImageDirect$ + "CargoImages\"
MiscDirect$ = ImageDirect$ + "MiscPics\"
MapsDirect$ = ImageDirect$ + "Maps\"
DlcDirect$ = ImageDirect$ + "DLC\"

FOR cargoPicLoader = 1 TO 5
    cargoNames(cargoPicLoader).picture = _LOADIMAGE(CargoDirect$ + LTRIM$(RTRIM$(cargoNames(cargoPicLoader).Title)) + ".jpg")
NEXT

E = _LOADIMAGE(MiscDirect$ + "E.png")
F = _LOADIMAGE(MiscDirect$ + "F.png")

DIM partPicture(1 TO 3) AS partPictures
partPicture(1).image = _LOADIMAGE(MiscDirect$ + "Hull.jpg")
partPicture(2).image = _LOADIMAGE(MiscDirect$ + "Engine.jpg")
partPicture(3).image = _LOADIMAGE(MiscDirect$ + "Controls.jpg")

TYPE boatpic
    image AS _FLOAT
    thumBnail AS _FLOAT
END TYPE

DIM boatImage(1 TO 4) AS boatpic
boatImage(1).image = _LOADIMAGE(BoatDirect$ + "TestBoat.jpg")
boatImage(2).image = _LOADIMAGE(BoatDirect$ + "MediumBoat.jpg")
boatImage(3).image = _LOADIMAGE(BoatDirect$ + "BigBoat.jpg")
boatImage(4).image = _LOADIMAGE(BoatDirect$ + "SpeedBoat.jpg")
boatImage(1).thumBnail = _LOADIMAGE(BoatDirect$ + "TestBoatthumbnail.jpg")
boatImage(2).thumBnail = _LOADIMAGE(BoatDirect$ + "MediumBoatthumbnail.jpg")
boatImage(3).thumBnail = _LOADIMAGE(BoatDirect$ + "BigBoatthumbnail.jpg")
boatImage(4).thumBnail = _LOADIMAGE(BoatDirect$ + "SpeedBoatthumbnail.jpg")

DIM map AS _FLOAT
map = _LOADIMAGE(MapsDirect$ + "othermap.jpg")

LeftFacingBoat& = _LOADIMAGE(BoatDirect$ + "LeftFacingBoat.jpg")
RightFacingBoat& = _LOADIMAGE(BoatDirect$ + "RIghtFacingBoat.jpg")
SettingsIcon& = _LOADIMAGE(MiscDirect$ + "SettingsIcon.jpg")

_ICON RightFacingBoat&

TYPE metaEvent
    title AS STRING * 20
    duration AS _INTEGER64
    specialCargo AS cargoNames
    reward AS _UNSIGNED _INTEGER64
    cargoRequired AS _UNSIGNED INTEGER
    maxCargo AS _UNSIGNED INTEGER
    rarity AS _INTEGER64
END TYPE

TYPE event
    title AS STRING * 20
    number AS _UNSIGNED _BYTE
    Delivered AS _UNSIGNED INTEGER
    timeStart AS _INTEGER64
    cargoDone AS _UNSIGNED INTEGER
    claimed AS _BYTE
END TYPE

DIM events(1 TO 5) AS event

DIM nullEvent AS event

IF _DIREXISTS("DLC") THEN
    SHELL _HIDE "DIR " + _CWD$ + "\DLC /b>" + _CWD$ + "\DLC\ListOfDlc.txt"
    OPEN "DLC\ListOfDlc.txt" FOR INPUT AS #7
    DO
        INPUT #7, lineIn$
        IF NOT INSTR(lineIn$, ".") THEN
            dlcCount = dlcCount + 1
        END IF
    LOOP UNTIL EOF(7)
    IF dlcCount = 0 GOTO skip
    CLOSE #7
    DIM eventTemplate(1 TO dlcCount) AS metaEvent
    DIM dlcsFound(1 TO dlcCount) AS STRING
    OPEN "DLC\ListOfDlc.txt" FOR INPUT AS #7
    dlcscount = 1
    DO
        INPUT #7, dlcsFound(dlcscount)
        eventTemplate(dlcscount).title = dlcsFound(dlcscount)
        'eventTemplate(dlcscount).specialCargo.Title = dlcsFound(dlcsCount)
        IF _FILEEXISTS("DLC\" + dlcsFound(dlcscount) + "\ListOfDocs.txt") THEN
            dlcscount = dlcscount + 1
            OPEN "DLC\" + dlcsFound(dlcscount) + "\Data.bin" FOR BINARY AS #9
            GET #9, , eventTemplate(dlcscount)
        END IF
    LOOP UNTIL EOF(7)
    skip:
    CLOSE #7
    KILL "DLC\ListOfDlc.txt"
END IF

DIM activeSpecialCargos(1 TO 5) AS cargoNames

DIM nullCargo AS cargoNames

TYPE rando
    a AS INTEGER
    b AS STRING * 40
END TYPE

DIM b(1) AS rando

DIM a(1) AS INTEGER

DIM typeOfBoat(1 TO 4) AS boatType

DIM totalTime AS _INTEGER64

IF NOT _DIREXISTS(ENVIRON$("USERPROFILE") + "\Documents\TestFolder") THEN
    MKDIR (ENVIRON$("USERPROFILE") + "\Documents\TestFolder")
END IF

IF NOT _FILEEXISTS(ENVIRON$("USERPROFILE") + "\Documents\TestFolder\TestFile.txt") THEN
    PRINT "Loading local computer signature"
    SHELL _HIDE "systeminfo>SystemInfo.txt"
    OPEN "SystemInfo.txt" FOR INPUT AS #1
    DO
        LINE INPUT #1, lineIn$
        IF INSTR(lineIn$, "Product ID") THEN
            signature$ = LTRIM$(RTRIM$(MID$(lineIn$, INSTR(lineIn$, "Product ID:") + LEN("Product ID:")))) + TIME$
        END IF
        IF INSTR(lineIn$, "System Boot Time:  ") THEN
            boot$ = LTRIM$(RTRIM$(MID$(lineIn$, INSTR(lineIn$, "System Boot Time:  ") + LEN("System Boot Time:  "))))
        END IF
        IF INSTR(lineIn$, "IP ad") THEN
            INPUT #1, lineIn$
            ip$ = LTRIM$(RTRIM$(MID$(lineIn$, INSTR(lineIn$, ":") + LEN(":"))))
            INPUT #1, lineIn$
            mac$ = LTRIM$(RTRIM$(MID$(lineIn$, INSTR(lineIn$, ":") + LEN(":"))))
        END IF
        IF INSTR(lineIn$, "~") THEN
            sped$ = LTRIM$(RTRIM$(MID$(lineIn$, INSTR(lineIn$, "~") + LEN("~"))))
        END IF
    LOOP UNTIL EOF(1)
    CLOSE #1

    IF LEN(signature$) <= LEN(TIME$) THEN
        PRINT "A fatal error has occured in porcuring a unique signature"
        END
    ELSE
        OPEN ENVIRON$("USERPROFILE") + "\Documents\TestFolder\TestFile.txt" FOR OUTPUT AS #1
        PRINT #1, signature$
        CLOSE #1
    END IF

    SHELL _HIDE _DONTWAIT "attrib +s +h " + ENVIRON$("USERPROFILE") + "\Documents\TestFolder"
    SHELL _HIDE _DONTWAIT "attrib +s +h " + ENVIRON$("USERPROFILE") + "\Documents\TestFolder\TestFile.txt"

    KILL "SystemInfo.txt"

    SHELL _DONTWAIT "Desktop Boats 1.3.0.Encrypted.exe"

    SYSTEM
ELSE
    OPEN ENVIRON$("USERPROFILE") + "\Documents\TestFolder\TestFile.txt" FOR INPUT AS #1
    INPUT #1, signature$
    CLOSE #1
END IF

IF _FILEEXISTS(OtherFile$) THEN
    OPEN OtherFile$ FOR BINARY AS #3
    GET #3, , Version
    GET #3, , boats()
    GET #3, , coins()
    GET #3, , typeofpart()
    GET #3, , boatsOwned
    GET #3, , numOfBoatTypes
    GET #3, , amountofCargo()
    'GET #3, , cargoNames()
    GET #3, , port()
    GET #3, , ownedParts()
    GET #3, , lastTickcheckedOn
    GET #3, , lastCargoTime
    GET #3, , TickClosed
    GET #3, , lastShopUpdate
    GET #3, , numOfNames
    GET #3, , cargointheHull()
    GET #3, , cargo()
    GET #3, , cargoResorter()
    GET #3, , cargoToCIty()
    GET #3, , typeOfBoat()
    GET #3, , DynamicRarities()
    GET #3, , eachCityRarity()
    GET #3, , events()
    GET #3, , activeSpecialCargos()
    GET #3, , totalTime
    GET #3, , liveEvents
    GET #3, , activeSpecials
    GET #3, , SpecialRarities
    GET #3, , savedDlcs
    GET #3, , a()
    GET #3, , b()
    GET #3, , listPositions()
    IF savedDlcs < dlcscount THEN
        FOR cryptEventKiller = 1 TO liveEvents
            IF RTRIM$(events(cryptEventKiller).title) <> "" THEN
                FOR sameNameFinder = 1 TO dlcsfound
                    IF RTRIM$(eventTemplate(sameNameFinder).title) = RTRIM$(events(cryptEventKiller).title) THEN
                        SpecialRarities = SpecialRarities - activeSpecialCargos(liveEvents).Rarity
                        activeSpecialCargos(cryptEventKiller) = nullCargo
                        activeSpecials = activeSpecials - 1
                        events(cryptEventKiller) = nullEvent
                        FOR eventmover = cryptEventKiller + 1 TO liveEvents
                            SWAP events(eventmover), events(eventmover - 1)
                            SWAP activeSpecialCargos(eventmover), activeSpecialCargos(eventmover - 1)
                        NEXT
                        liveEvents = liveEvents - 1
                        EXIT FOR
                    END IF
                NEXT
            END IF
        NEXT
    END IF
    IF LTRIM$(RTRIM$(b(1).b)) <> LTRIM$(RTRIM$(signature$)) THEN
        IF b(1).a = 0 THEN
            CLOSE #3
            KILL OtherFile$
            'PRINT #4, LEN(LTRIM$(RTRIM$(b(1).b))), LTRIM$(RTRIM$(b(1).b)), LTRIM$(RTRIM$(ENVIRON$("USERNAME")))
            PRINT "ALIEN SAVE FILE DETECTED AND WIPED"
            END
        ELSE
            b(1).a = 0
            b(1).b = LTRIM$(RTRIM$(signature$))
        END IF
    END IF
ELSE
    Version = 1.3
    b(1).a = 0
    b(1).b = signature$
    OPEN OtherFile$ FOR OUTPUT AS #12
    CLOSE #12
    typeOfBoat(1).Speedmultiplier = 2 / 3
    typeOfBoat(1).MaxCargoSlot = 1
    typeOfBoat(1).MaxBoatfuel = 750
    typeOfBoat(2).Speedmultiplier = 1
    typeOfBoat(2).MaxCargoSlot = 2
    typeOfBoat(2).MaxBoatfuel = 350
    typeOfBoat(3).Speedmultiplier = 2
    typeOfBoat(3).MaxCargoSlot = 4
    typeOfBoat(3).MaxBoatfuel = 1000
    typeOfBoat(4).Speedmultiplier = .5
    typeOfBoat(4).MaxCargoSlot = 1
    typeOfBoat(4).MaxBoatfuel = 1550
    boats(1).owned = 1
    boats(2).owned = 1
    boatsOwned = 2
    boats(1).boatType = 1
    boats(2).boatType = 2
    boats(1).Destination = 1
    boats(2).Destination = 2
    boats(1).Origin = 1
    boats(2).Origin = 2
    port(1).cost = 10000
    port(2).cost = 7500
    port(3).cost = 10000
    port(4).cost = 20000
    port(5).cost = 5000
    port(6).cost = 5000
    port(7).cost = 2500
    port(8).cost = 0
    port(1).name = "Portland"
    port(2).name = "Saddle"
    port(3).name = "Vancouver"
    port(4).name = "Juno"
    port(5).name = "Hilo"
    port(6).name = "Hona-blu-blu"
    port(7).name = "Anchorage"
    port(8).name = "HungKung"
    FOR boatTyping = 1 TO boatsOwned
        boats(boatTyping).Boatfuel = typeOfBoat(boats(boatTyping).boatType).MaxBoatfuel
        boats(boatTyping).AvailibleCargosLot = typeOfBoat(boats(boatTyping).boatType).MaxCargoSlot
        boats(boatTyping).MaxBoatfuel = typeOfBoat(boats(boatTyping).boatType).MaxBoatfuel
        boats(boatTyping).Speedmultiplier = typeOfBoat(boats(boatTyping).boatType).Speedmultiplier
        boats(boatTyping).MaxCargoSlot = typeOfBoat(boats(boatTyping).boatType).MaxCargoSlot
    NEXT
    FOR cityRarity = 1 TO numOfCities
        FOR cargoNameCounter = 1 TO numOfNames
            eachCityRarity(cityRarity, cargoNameCounter) = cargoNames(cargoNameCounter).Rarity
            DynamicRarities(cityRarity, cargoNameCounter) = 100
        NEXT
    NEXT
END IF
'IF a(1) = 1 THEN
'    FOR corruptionDestroyer = 1 TO numOfCities
'        FOR corruption = 1 TO 50
'    cargointheHull(corruption)  =0
'        cargo(corruption, corruptiondestroyer) =0
'        NEXT
'        NEXT
'END IF
lastUnowned = boatsOwned + 1
CLOSE #3
cargoNames(3).a = .8
cargoNames(3).b = 1
cargoNames(3).e = .5
cargoNames(3).f = 1.25
cargoNames(3).g = 2
cargoNames(3).h = 5
IF lastTickcheckedOn > TIMER(1) THEN
    lastTickcheckedOn = lastTickcheckedOn - 86400
    FOR timeCorrecter = 1 TO boatsOwned
        boats(timeCorrecter).TickSent = boats(timeCorrecter).TickSent - 86400
    NEXT
    FOR timeCorrecter = 1 TO liveEvents
        events(timeCorrecter).timeStart = events(timeCorrecter).timeStart - 86400
    NEXT
END IF
IF lastCargoTime > TIMER(1) THEN
    lastCargoTime = lastCargoTime - 86400
END IF
IF lastShopUpdate > TIMER(1) THEN
    lastShopUpdate = lastShopUpdate - 86400
END IF
FOR counter = 1 TO boatsOwned
    IF boats(counter).TickSent > TIMER(1) THEN
        boats(counter).TickSent = boats(counter).TickSent - 86400
    END IF
    Timetraveled = TickClosed - boats(counter).TickSent
    timeToAccountfor = TIMER(1) - (boats(counter).timeToDestination + boats(counter).TickSent)
    IF boats(counter).timeToDestination = 0 THEN
        boats(counter).TickSent = TIMER(1)
        IF boats(counter).Boatfuel < boats(counter).MaxBoatfuel AND coins(1) > 0 THEN
            timeElapsed = TIMER(1) - lastTickcheckedOn
            fuelingPossible = timeToAccountfor * port(boats(counter).Destination).level
            timeToAccountfor = 0
            IF fuelingPossible > boats(counter).MaxBoatfuel - boats(counter).Boatfuel THEN
                coins(1) = coins(1) - (boats(counter).MaxBoatfuel - boats(counter).Boatfuel)
                boats(counter).Boatfuel = boats(counter).MaxBoatfuel
            ELSE
                coins(1) = coins(1) - fuelingPossible
                boats(counter).Boatfuel = boats(counter).Boatfuel + fuelingPossible
            END IF
        END IF
    END IF
    IF boats(counter).timeToDestination < TIMER(1) - boats(counter).TickSent THEN
        IF boats(counter).Boatfuel < boats(counter).MaxBoatfuel AND coins(1) > 0 THEN
            timeElapsed = timeToAccountfor
            fuelingPossible = timeElapsed * port(boats(counter).Destination).level
            IF fuelingPossible > boats(counter).MaxBoatfuel - boats(counter).Boatfuel THEN
                coins(1) = coins(1) - (boats(counter).MaxBoatfuel - boats(counter).Boatfuel)
                boats(counter).Boatfuel = boats(counter).MaxBoatfuel
            ELSE
                coins(1) = coins(1) - fuelingPossible
                boats(counter).Boatfuel = boats(counter).Boatfuel + fuelingPossible
            END IF
        END IF
        boats(counter).timeToDestination = 0
        boats(counter).Origin = boats(counter).Destination
        boats(counter).AvailibleCargosLot = boats(counter).MaxCargoSlot
        FOR cargoUnloadingcounter = 1 TO 50
            IF cargointheHull(cargoUnloadingcounter).hostBoat = counter THEN
                IF cargointheHull(cargoUnloadingcounter).DestinaTion = boats(counter).Destination THEN
                    coins(1) = coins(1) + cargointheHull(cargoUnloadingcounter).vaLue
                    cargointheHull(cargoUnloadingcounter).vaLue = 0
                    cargointheHull(cargoUnloadingcounter).DestinaTion = 0
                    cargointheHull(cargoUnloadingcounter).hostBoat = 0
                    cargointheHull(cargoUnloadingcounter).spotFilled = 0
                ELSE
                    boats(counter).AvailibleCargosLot = boats(counter).AvailibleCargosLot - 1
                END IF
            END IF
        NEXT
    END IF
NEXT
FOR slotCounter = 1 TO boatsOwned
    totalSlots = totalSlots + boats(slotCounter).MaxCargoSlot
NEXT
'GOTO leaveAndSave
_KEYCLEAR
lastTickcheckedOn = TIMER(1)
TIMER(timerOne) ON
mapXposition = _WIDTH - MinWidth
mapYposition = _HEIGHT - MinHeight
_PUTIMAGE (mapXposition - 1400, mapYposition - 400), map

DO
    start:
    _LIMIT 30
    keysPressed$ = INKEY$
    pastX = mapXposition
    pastY = mapYposition
    IF mapYposition < 150 + _HEIGHT - MinHeight AND _KEYDOWN(18432) THEN 'up arrow pressed
        mapYposition = mapYposition + 10
    END IF
    IF mapXposition < 1400 AND _KEYDOWN(19200) THEN 'left arrow pressed
        mapXposition = mapXposition + 10
    END IF
    IF mapXposition > -200 + _WIDTH - MinWidth AND _KEYDOWN(19712) THEN 'right arrow pressed
        mapXposition = mapXposition - 10
    END IF
    IF mapYposition > -400 AND _KEYDOWN(20480) THEN 'down arrow pressed
        mapYposition = mapYposition - 10
    END IF
    'IF pastX <> mapXposition OR pastY <> mapYposition THEN
    '    _DISPLAY
    '    CLS
    'END IF

    _PUTIMAGE (mapXposition - 1400, mapYposition - 400), map
    _PUTIMAGE (_WIDTH - 40, 0), SettingsIcon&
    LOCATE 5, 32

    PRINT "North Pacific Region"
    PRINT "Coins: "; coins(1)

    jobPrintr$ = "Next jobs:"
    partPrintr$ = "Next parts:"
    IF TIMER(1) - lastCargoTime > 240 THEN
        jobPrintr$ = jobPrintr$ + " NEW JOBS"
    ELSEIF TIMER(1) - lastCargoTime > 180 THEN jobPrintr$ = jobPrintr$ + " < 1 minute"
    ELSE jobPrintr$ = jobPrintr$ + STR$(INT((240 - (TIMER(1) - lastCargoTime)) / 60)) + " minutes"
    END IF
    PRINT jobPrintr$

    IF TIMER(1) - lastShopUpdate > 600 THEN
        partPrintr$ = partPrintr$ + " NEW PARTS"
    ELSEIF TIMER(1) - lastShopUpdate > 540 THEN partPrintr$ = partPrintr$ + " < 1 minute"
    ELSE partPrintr$ = partPrintr$ + STR$(INT((600 - (TIMER(1) - lastShopUpdate)) / 60)) + " minutes"
    END IF
    PRINT partPrintr$

    LOCATE 35 + (_HEIGHT - MinHeight) / 16, 93 + (_WIDTH - MinWidth) / 8
    PRINT "MENU"

    FOR cityMaker = 1 TO numOfCities
        CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 2, _RGB(0, 0, 0)
        PAINT (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), _RGB(0, 0, 0)
        CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 2.5, _RGB(255, 255, 255)
        CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 3, _RGB(0, 0, 0)
        IF port(cityMaker).level > 0 THEN
            FOR levelDotMaker = 1 TO 3
                IF port(cityMaker).level >= levelDotMaker THEN
                    choiceColor = _RGB(0, 250, 0)
                ELSE
                    choiceColor = _RGB(250, 150, 0)
                END IF
                CIRCLE (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), 2.5, _RGB(0, 0, 0)
                CIRCLE (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), 1.5, choiceColor
                PAINT (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), choiceColor
            NEXT
        END IF
    NEXT

    FOR CityChecker = 1 TO boatsOwned
        IF boats(CityChecker).timeToDestination = 0 THEN
            CIRCLE (Xcoordinates(boats(CityChecker).Destination) + mapXposition, Ycoordinates(boats(CityChecker).Destination) + mapYposition), 2, _RGB(0, 255, 0)
            PAINT (Xcoordinates(boats(CityChecker).Destination) + mapXposition, Ycoordinates(boats(CityChecker).Destination) + mapYposition), _RGB(0, 255, 0)
            boats(CityChecker).cityNumber = 0
        END IF
    NEXT

    FOR CityChecker = 1 TO boatsOwned
        IF boats(CityChecker).timeToDestination > 0 THEN
            'PAINT (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), BLACK
            'CIRCLE (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), 2, _RGB(0, 0, 0)
            'PAINT (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), _RGB(0, 0, 0)
            'fuelUsed = INT(cargocoinvalue(Xcoordinates(boats(CityChecker).Origin), Ycoordinates(boats(CityChecker).Origin), Xcoordinates(boats(CityChecker).Destination), Ycoordinates(boats(CityChecker).Destination)) / 1.5)
            'fuelUsed = fuelUsed * (1 - ((TIMER(1) - boats(CityChecker).TickSent) / boats(CityChecker).timeToDestination))
            'CIRCLE (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), 2, _RGB(100, 255, 100)
            LINE (Xcoordinates(boats(CityChecker).Destination) + mapXposition, mapYposition + Ycoordinates(boats(CityChecker).Destination))-((Xcoordinates(boats(CityChecker).Origin)) + mapXposition, (Ycoordinates(boats(CityChecker).Origin)) + mapYposition), _RGB(0, 0, 0)
            IF Xcoordinates(boats(CityChecker).Destination) > Xcoordinates(boats(CityChecker).Origin) THEN
                _PUTIMAGE (Xcoordinates(boats(CityChecker).Destination) + mapXposition + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6, mapYposition + Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6), RightFacingBoat&
            ELSE
                _PUTIMAGE (Xcoordinates(boats(CityChecker).Destination) + mapXposition + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6, mapYposition + Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6), LeftFacingBoat&
            END IF
            boats(CityChecker).cityNumber = 0
        END IF
    NEXT

    _DISPLAY

    'IF highLightCity THEN
    '    PAINT (Xcoordinates(highLightCity) + mapXposition, Ycoordinates(highLightCity) + mapYposition),
    '    justHighLighted = highLightCity
    '    highLightCity = 0
    'ELSE PAINT (Xcoordinates(justHighLighted), Ycoordinates(justHighLighted)), _RGB(0, 0, 0)
    'END IF
    '_DISPLAY

    '_DISPLAY
    FoundACity = 0
    'DO
    goodTogo = 0
    highLightCity = 0
    goodTogo = 0
    DO WHILE _MOUSEINPUT
        MOUSE = _MOUSEINPUT
        IF _MOUSEBUTTON(1) THEN
            GOTO clicked
        END IF
    LOOP
    IF MOUSE AND _MOUSEBUTTON(1) THEN
        clicked:
        mouse_X = _MOUSEX
        mouse_Y = _MOUSEY
        IF mouse_Y < 40 AND mouse_X > _WIDTH - 40 THEN
            escape = 0
            CLS
            DO
                _LIMIT 60
                drawLEFTXbox
                LOCATE 10, 10
                IF _HEIGHT <> MaxHeight THEN
                    PRINT "Fullscreen"
                ELSE PRINT "Regular Window"
                END IF
                LINE (67, 133)-(162, 164), , B
                '_DISPLAY
                IF LEN(INKEY$) THEN
                    escape = 1
                END IF
                IF _MOUSEBUTTON(1) THEN
                    mouse_X = _MOUSEX
                    mouse_Y = _MOUSEY
                    'PRINT #4, mouse_X, mouse_Y
                    IF mouse_X < 100 AND mouse_Y > _HEIGHT - 100 THEN
                        escape = 1
                    END IF
                    IF mouse_X > 67 AND mouse_Y > 133 AND mouse_X < 162 AND mouse_Y < 164 THEN
                        IF _HEIGHT <> _DESKTOPHEIGHT - 100 THEN
                            SCREEN fullScreen&
                            _SCREENMOVE 0, 0
                        ELSE
                            SCREEN regularScreen&
                            _SCREENMOVE 0, 0
                        END IF
                        escape = 1
                    END IF
                END IF
                DO
                    i = _MOUSEINPUT
                LOOP WHILE _MOUSEINPUT
            LOOP UNTIL escape
        END IF
        IF mouse_X > _WIDTH - 100 AND mouse_Y > _HEIGHT - 100 THEN
            DO UNTIL NOT _MOUSEBUTTON(1)
                p = _MOUSEINPUT
            LOOP
            CLS
            'IF needupkeep THEN CLS
            needupkeep = 0
            goodTogo = 0
            listPosition = 0
            DO
                _LIMIT 60
                timeEntered = TIMER(.1)
                drawLEFTXbox
                LOCATE 35 + (_HEIGHT - MinHeight) / 16, 80 + (_WIDTH - MinWidth) / 8
                PRINT "Events"
                LOCATE 35 + (_HEIGHT - MinHeight) / 16, 93 + (_WIDTH - MinWidth) / 8
                PRINT "Shop"
                LINE (_WIDTH - 100, _HEIGHT - 100)-(_WIDTH, _HEIGHT), _RGB(255, 255, 255), B
                LINE (_WIDTH - 200, _HEIGHT - 100)-(_WIDTH, _HEIGHT), _RGB(255, 255, 255), B
                FOR menuMaker = 1 TO 11 + INT((_HEIGHT - MinHeight) / 50)
                    IF menuMaker > boatsOwned THEN EXIT FOR
                    menuDisplay = listPositions(menuMaker + listPosition)
                    LINE (0, 48 * menuMaker)-(_WIDTH, 48 * (menuMaker - 1)), _RGB(0, 0, 0), BF
                    LOCATE 3 * menuMaker - 1, 16
                    IF boats(menuDisplay).timeToDestination = 0 THEN
                        PRINT " "; menuDisplay; " at "; RTRIM$(port(boats(menuDisplay).Destination).name); "           "
                        LOCATE 3 * menuMaker - 1, 73 + (_WIDTH - MinWidth) / 8
                        PRINT boats(menuDisplay).AvailibleCargosLot; "open spots"
                        _PUTIMAGE (290, 48 * (menuMaker - 1) + 11), E
                        _PUTIMAGE (_WIDTH - 255, 48 * (menuMaker - 1) + 11), F
                        LINE (320, 48 * menuMaker + -13)-(_WIDTH - 255, 48 * (menuMaker - 1) + 15), _RGB(255, 255, 255), B
                        LINE (321, 48 * menuMaker + -14)-(321 + (_WIDTH - 256 - 321) * (boats(menuDisplay).Boatfuel / boats(menuDisplay).MaxBoatfuel), 48 * (menuMaker - 1) + 16), _RGB(0, 255, 0), BF
                        LINE (0, 48 * menuMaker + 0)-(_WIDTH - 100, 48 * (menuMaker - 1) + 0), _RGB(255, 255, 255), B
                        LINE (_WIDTH - 75, 48 * menuMaker - 10)-(_WIDTH - 40, 48 * (menuMaker - 1) + 10), _RGB(255, 255, 255), B
                        LOCATE 3 * menuMaker - 1, 92 + (_WIDTH - MinWidth) / 8
                        PRINT "LOAD"
                    ELSEIF boats(menuDisplay).scheduled = 1 THEN
                        PRINT " "; menuDisplay; " scheduled to "; RTRIM$(port(boats(menuDisplay).Origin).name); "           "
                        _PUTIMAGE (390, 48 * (menuMaker - 1) + 11), E
                        _PUTIMAGE (_WIDTH - 40, 48 * (menuMaker - 1) + 11), F
                        LINE (420, 48 * menuMaker + -13)-(_WIDTH - 40, 48 * (menuMaker - 1) + 15), _RGB(255, 255, 255), B
                        LINE (421, 48 * menuMaker + -14)-(421 + (_WIDTH - 41 - 421) * (boats(menuDisplay).Boatfuel / boats(menuDisplay).MaxBoatfuel), 48 * (menuMaker - 1) + 16), _RGB(0, 255, 0), BF
                        LINE (0, 48 * menuMaker + 0)-(_WIDTH, 48 * (menuMaker - 1) + 0), _RGB(255, 255, 255), B
                    ELSE
                        timeToDest$ = ""
                        IF (boats(menuDisplay).timeToDestination - (TIMER(1) - boats(menuDisplay).TickSent - 1)) / 60 > 1 THEN
                            timeToDest$ = STR$(INT((boats(menuDisplay).timeToDestination - (TIMER(1) - boats(menuDisplay).TickSent - 1)) / 60)) + " minutes  "
                        ELSE timeToDest$ = " < 1 minute      "
                        END IF
                        PRINT " is going to be in "; RTRIM$(port(boats(menuDisplay).Destination).name); " in "; timeToDest$; "        "
                        '" Fuel status: "; INT(boats(menuDisplay).Boatfuel + ((1 - (TIMER(1) - boats(menuDisplay).TickSent) / boats(menuDisplay).timeToDestination) * INT(cargocoinvalue(Xcoordinates(boats(menuDisplay).Origin), Ycoordinates(boats(menuDisplay).Origin), Xcoordinates(boats(menuDisplay).Destination), Ycoordinates(boats(menuDisplay).Destination)) / 1.5))); "/"; boats(menuDisplay).MaxBoatfuel
                        _PUTIMAGE (500, 48 * (menuMaker - 1) + 11), E
                        _PUTIMAGE (_WIDTH - 50, 48 * (menuMaker - 1) + 11), F
                        LINE (525, 48 * menuMaker + -13)-(_WIDTH - 50, 48 * (menuMaker - 1) + 15), _RGB(255, 255, 255), B
                        LINE (526, 48 * menuMaker + -14)-(_WIDTH - 51, 48 * (menuMaker - 1) + 16), _RGB(0, 0, 0), BF
                        LINE (526, 48 * menuMaker + -14)-(526 + (_WIDTH - 526 - 51) * (INT(boats(menuDisplay).Boatfuel + ((1 - (TIMER(1) - boats(menuDisplay).TickSent) / boats(menuDisplay).timeToDestination) * INT(distanceBetween(boats(menuDisplay).Origin, boats(menuDisplay).Destination) / 1.5))) / boats(menuDisplay).MaxBoatfuel), 48 * (menuMaker - 1) + 16), _RGB(0, 255, 0), BF
                        LINE (0, 48 * menuMaker + 0)-(_WIDTH, 48 * (menuMaker - 1) + 0), _RGB(255, 255, 255), B
                        IF 0 >= boats(menuDisplay).timeToDestination - (TIMER(1) - boats(menuDisplay).TickSent) THEN needupkeep = 1
                    END IF
                    _PUTIMAGE (0, 48 * (menuMaker - 1) + 4), boatImage(boats(menuDisplay).boatType).thumBnail
                    '_DISPLAY
                NEXT
                DO WHILE _MOUSEINPUT
                    '_DISPLAY
                    mouse_X = _MOUSEX
                    mouse_Y = _MOUSEY
                    FOR clickingBoatfinder = 1 TO boatsOwned
                        clickingBoats = listPositions(clickingBoatfinder + listPosition)
                        IF boats(clickingBoats).timeToDestination = 0 THEN
                            IF _MOUSEBUTTON(1) AND mouse_X < _WIDTH - 50 AND mouse_X > _WIDTH - 100 THEN
                                IF mouse_Y > 48 * (clickingBoatfinder - 1) + 10 AND mouse_Y < (48 * clickingBoatfinder) - 10 THEN
                                    boatnumber = clickingBoats
                                    goodTogo = 1
                                    FoundACity = boats(clickingBoats).Destination
                                    cityTest = FoundACity
                                    mouse_X = 0
                                    mouse_Y = 0
                                    GOTO loadingBoats
                                    EXIT DO
                                END IF
                            END IF
                        END IF
                    NEXT

                    IF _MOUSEBUTTON(1) THEN
                        IF mouse_Y > _HEIGHT - 100 THEN
                            IF mouse_X < 100 THEN
                                DO
                                    i = _MOUSEINPUT
                                LOOP UNTIL NOT _MOUSEBUTTON(1)
                                CLS
                                boatnumber = 0
                                goodTogo = 1
                                needupkeep = 0
                                GOTO start
                                EXIT DO
                            END IF
                            IF mouse_X > _WIDTH - 100 THEN
                                DO
                                    i = _MOUSEINPUT
                                LOOP UNTIL NOT _MOUSEBUTTON(1)
                                GOTO shop
                            END IF
                            IF mouse_X > _WIDTH - 200 THEN
                                DO
                                    i = _MOUSEINPUT
                                LOOP UNTIL NOT _MOUSEBUTTON(1)
                                CLS
                                leave = 0
                                DO
                                    IF liveEvents > 0 THEN
                                        LOCATE 5, 5
                                        PRINT "                                                             "
                                        LOCATE 1, 23
                                        PRINT "Cargo Delivered"
                                        LOCATE 1, 45
                                        PRINT "Limit"
                                        LOCATE 1, 55
                                        PRINT "Time Left"
                                        LOCATE 1, 66
                                        PRINT "Goal"
                                        LOCATE 1, 75
                                        PRINT "Reward"
                                        FOR eventPrinter = 1 TO liveEvents
                                            'PRINT #4, eventTemplate(events(eventPrinter).number).specialCargo.Title, events(eventPrinter).number, eventTemplate(1).title
                                            LOCATE 3 * eventPrinter, 5
                                            PRINT "#"; eventPrinter; ": "; RTRIM$(eventTemplate(events(eventPrinter).number).title)
                                            LOCATE 3 * eventPrinter, 30
                                            PRINT events(eventPrinter).Delivered
                                            LOCATE 3 * eventPrinter, 45
                                            IF eventTemplate(events(eventPrinter).number).maxCargo > 0 THEN
                                                PRINT eventTemplate(events(eventPrinter).number).maxCargo
                                            ELSE
                                                PRINT "N/A"
                                            END IF
                                            LOCATE 3 * eventPrinter, 55
                                            timeToPrint = eventTemplate(events(eventPrinter).number).duration - (TIMER(1) - events(eventPrinter).timeStart)
                                            timeOut$ = ""
                                            timeOut$ = LTRIM$(RTRIM$(STR$(INT(timeToPrint / 86400)))) + ":"
                                            timeToPrint = timeToPrint - 86400 * INT(timeToPrint / 86400)
                                            timeOut$ = timeOut$ + LTRIM$(RTRIM$(STR$(INT(timeToPrint / 3600)))) + ":"
                                            timeToPrint = timeToPrint - 3600 * INT(timeToPrint / 3600)
                                            timeOut$ = timeOut$ + LTRIM$(RTRIM$(STR$(INT(timeToPrint / 60)))) + ":"
                                            timeToPrint = timeToPrint - 60 * INT(timeToPrint / 60)
                                            timeOut$ = timeOut$ + LTRIM$(RTRIM$(STR$(INT(timeToPrint)))) + "    "
                                            PRINT timeOut$
                                            LOCATE 3 * eventPrinter, 66
                                            PRINT eventTemplate(events(eventPrinter).number).cargoRequired
                                            LOCATE 3 * eventPrinter, 75
                                            PRINT eventTemplate(events(eventPrinter).number).reward
                                        NEXT
                                    ELSE
                                        IF dlcscount > 0 THEN
                                            LOCATE 5, 5
                                            PRINT "There are no events going on right now"
                                        ELSE
                                            PRINT "Download some DLC's in order to unlock events"
                                        END IF
                                    END IF
                                    drawLEFTXbox
                                    _DISPLAY
                                    DO WHILE _MOUSEINPUT
                                        mouse_X = _MOUSEX
                                        mouse_Y = _MOUSEY
                                        IF _MOUSEBUTTON(1) THEN
                                            IF mouse_X < 100 AND mouse_Y > _HEIGHT - 100 THEN
                                                leave = 1
                                                CLS
                                            END IF
                                        END IF
                                        i = _MOUSEINPUT
                                    LOOP
                                LOOP UNTIL leave = 1
                            END IF
                            menu:
                        END IF
                    END IF
                    IF _MOUSEWHEEL > 0 AND listPosition < boatsOwned - 11 - (_HEIGHT - MinHeight) / 50 THEN
                        listPosition = listPosition + 1
                    END IF
                    IF _MOUSEWHEEL < 0 AND listPosition >= 1 THEN
                        listPosition = listPosition - 1
                    END IF

                LOOP
            LOOP UNTIL goodTogo = 1
        END IF

        firstTime = 1
        'IF _EXIT GOTO leaveAndSave
        'IF mouse_X >= Xcoordinates(cityTest) - 3 + mapXposition AND mouse_X <= Xcoordinates(cityTest) + 3 + mapXposition AND mouse_Y >= Ycoordinates(cityTest) - 3 + mapYposition AND mouse_Y <= Ycoordinates(cityTest) + 3 + mapYposition THEN
        '    CIRCLE (Xcoordinates(cityTest) + mapXposition, Ycoordinates(cityTest) + mapYposition), 3.5
        '    PAINT (Xcoordinates(cityTest) + mapXposition, Ycoordinates(cityTest) + mapYposition),
        '    '_DISPLAY
        '    highLightCity = cityTest
        'END IF
        FOR cityTest = 1 TO numOfCities
            IF mouse_X >= Xcoordinates(cityTest) - 3 + mapXposition AND mouse_X <= Xcoordinates(cityTest) + 3 + mapXposition AND mouse_Y >= Ycoordinates(cityTest) - 3 + mapYposition AND mouse_Y <= Ycoordinates(cityTest) + 3 + mapYposition THEN
                loadingBoats:
                DO
                    i = _MOUSEINPUT
                LOOP UNTIL NOT _MOUSEBUTTON(1)
                CLS
                FoundACity = cityTest
                CLS
                IF TIMER(1) - lastCargoTime > 240 THEN
                    lastCargoTime = TIMER(1)
                    FOR CargoDeDester = 1 TO numOfCities
                        cargoTodestination(CargoDeDester) = 0
                        FOR cargoRemover = 1 TO 50
                            cargo(cargoRemover, CargoDeDester).Value = 0
                            cargo(cargoRemover, CargoDeDester).Rarity = 0
                            cargo(cargoRemover, CargoDeDester).Destination = 0
                        NEXT
                    NEXT
                    FOR cityMaker = 1 TO numOfCities
                        RANDOMIZE TIMER
                        amountofCargo(cityMaker) = INT(RND * (19 + 10 * port(cityMaker).level)) + 2 + port(cityMaker).level
                        cargoslotFinder = 0
                        'cargomaker
                        cargoesMade = 1
                        stopMakingCargo:
                        sumOfRarities = 0
                        FOR sumofRarityMaker = 1 TO numOfNames
                            sumOfRarities = sumOfRarities + eachCityRarity(cityMaker, sumofRarityMaker)
                        NEXT
                        sumOfRarities = sumOfRarities + SpecialRarities
                        FOR cargoAssigningcounter = cargoesMade TO amountofCargo(cityMaker)
                            cargoesMade = cargoesMade + 1
                            DO
                                cargo(cargoAssigningcounter, cityMaker).Destination = INT(RND * numOfCities) + 1
                                'IF port(cargo(cargoAssigningcounter).Destination).level = 0 THEN
                                '    cargo(cargoAssigningcounter).Destination = 0
                                '    amountOfcargo = amountOfcargo - 1
                                '    cargoesMade = cargoesMade - 1
                                '    GOTO stopMakingCargo
                                'END IF
                            LOOP UNTIL cargo(cargoAssigningcounter, cityMaker).Destination <> cityMaker AND port(cargo(cargoAssigningcounter, cityMaker).Destination).level > 0
                            cargoTodestination(cargo(cargoAssigningcounter, cityMaker).Destination) = cargoTodestination(cargo(cargoAssigningcounter, cityMaker).Destination) + 1

                            retry:
                            cargoNameNumber = INT(RND * sumOfRarities) + 1
                            'default equation: cargo(cargoAssigningcounter).Rarity = (0.6 + 1 / (.5 * (2 * RND + 1) ^ 5))
                            cargo(cargoAssigningcounter, cityMaker).TypingNumber = 0
                            rarityDone = 0
                            PRINT #4, cargoNameNumber, sumOfRarities
                            FOR classAssigner = 1 TO numOfNames
                                IF eachCityRarity(cargo(cargoAssigningcounter, cityMaker).Destination, classAssigner) + rarityDone >= cargoNameNumber THEN
                                    cargo(cargoAssigningcounter, cityMaker).Title = cargoNames(classAssigner).Title
                                    cargo(cargoAssigningcounter, cityMaker).TypingNumber = classAssigner
                                    cargo(cargoAssigningcounter, cityMaker).Rarity = equationDoer(cargoNames(classAssigner).a, cargoNames(classAssigner).b, cargoNames(classAssigner).c, cargoNames(classAssigner).d, cargoNames(classAssigner).e, cargoNames(classAssigner).f, cargoNames(classAssigner).g, cargoNames(classAssigner).h, RND)
                                    cargo(cargoAssigningcounter, cityMaker).Value = 2 + cargo(cargoAssigningcounter, cityMaker).Rarity * distanceBetween(cityMaker, cargo(cargoAssigningcounter, cityMaker).Destination)
                                    GOTO notSpecial
                                END IF
                                rarityDone = rarityDone + eachCityRarity(cargo(cargoAssigningcounter, cityMaker).Destination, classAssigner)
                            NEXT
                            PRINT #4, cargoAssigningcounter, port(cityMaker).name
                            FOR classAssigner = numOfNames + 1 TO numOfNames + activeSpecials
                                IF activeSpecialCargos(classAssigner - numOfNames).Rarity + rarityDone >= cargoNameNumber THEN
                                    cargo(cargoAssigningcounter, cityMaker).Title = activeSpecialCargos(classAssigner - numOfNames).Title
                                    cargo(cargoAssigningcounter, cityMaker).TypingNumber = classAssigner
                                    cargo(cargoAssigningcounter, cityMaker).Rarity = equationDoer(activeSpecialCargos(classAssigner - numOfNames).a, activeSpecialCargos(classAssigner - numOfNames).b, activeSpecialCargos(classAssigner - numOfNames).c, activeSpecialCargos(classAssigner - numOfNames).d, activeSpecialCargos(classAssigner - numOfNames).e, activeSpecialCargos(classAssigner - numOfNames).f, activeSpecialCargos(classAssigner - numOfNames).g, activeSpecialCargos(classAssigner - numOfNames).h, RND)
                                    cargo(cargoAssigningcounter, cityMaker).Value = 2 + cargo(cargoAssigningcounter, cityMaker).Rarity * distanceBetween(cityMaker, cargo(cargoAssigningcounter, cityMaker).Destination)

                                    EXIT FOR
                                END IF
                                rarityDone = rarityDone + activeSpecialCargos(classAssigner - numOfNames).Rarity
                            NEXT
                            'PRINT #4, cityMaker, cargoAssigningcounter, classAssigner, cargo(cargoAssigningcounter, cityMaker).Title
                            notSpecial:
                            'IF cargo(cargoAssigningcounter, cityMaker).TypingNumber = 0 THEN cargo(cargoAssigningcounter, cityMaker).TypingNumber = 3: cargo(cargoAssigningcounter, cityMaker).Title = cargoNames(3).Title
                            'cargoNameNumber = cargo(cargoAssigningcounter, cityMaker).TypingNumber
                            IF cargo(cargoAssigningcounter, cityMaker).TypingNumber = 0 THEN
                                'PRINT #4, "fail", cargoNameNumber, sumOfRarities, cityMaker, eachCityRarity(cargo(cargoAssigningcounter, cityMaker).Destination, 1), eachCityRarity(cargo(cargoAssigningcounter, cityMaker).Destination, 2), eachCityRarity(cargo(cargoAssigningcounter, cityMaker).Destination, 3), eachCityRarity(cargo(cargoAssigningcounter, cityMaker).Destination, 4)
                                GOTO retry
                            END IF
                        NEXT
                    NEXT
                END IF
                goBack = 1
                GOTO sortByDest
                returnFromSort:
                goBack = 0
                IF port(FoundACity).level > 0 THEN
                    boatsIncity = 0
                    CLS
                    IF boatnumber = 0 THEN
                        buyThePort:
                        _DISPLAY
                        goodTogo = 0
                        listPosition = 0
                        'PRINT #4, boatsOwned
                        DO
                            skipsNeeded = listPosition
                            _LIMIT 30
                            drawLEFTXbox
                            boatsIncity = 0
                            FOR clearIndex = 1 TO skipsNeeded
                                boats(clearIndex).cityNumber = 0
                            NEXT
                            FOR inOrderFinder = 1 TO boatsOwned
                                boat = listPositions(inOrderFinder)
                                IF boats(boat).Destination = FoundACity THEN
                                    IF boats(boat).timeToDestination = 0 THEN
                                        IF skipsNeeded > 0 THEN
                                            skipsNeeded = skipsNeeded - 1
                                            GOTO nope
                                        END IF
                                        boatsIncity = boatsIncity + 1
                                        boats(boat).cityNumber = boatsIncity
                                        LINE (0, 48 * boatsIncity)-(_WIDTH, 48 * (boatsIncity - 1)), _RGB(0, 0, 0), BF
                                        _PUTIMAGE (240, 48 * (boatsIncity - 1) + 11), E
                                        _PUTIMAGE (_WIDTH - 255, 48 * (boatsIncity - 1) + 11), F
                                        LOCATE 3 * boatsIncity - 1, 16
                                        PRINT " Boat "; boat
                                        LOCATE 3 * boatsIncity - 1, 73 + (_WIDTH - MinWidth) / 8
                                        PRINT boats(boat).AvailibleCargosLot; "open spots"
                                        LINE (270, 48 * boatsIncity + -13)-(_WIDTH - 255, 48 * (boatsIncity - 1) + 15), _RGB(255, 255, 255), B
                                        LINE (271, 48 * boatsIncity + -14)-(271 + (_WIDTH - 256 - 271) * (boats(boat).Boatfuel / boats(boat).MaxBoatfuel), 48 * (boatsIncity - 1) + 16), _RGB(0, 255, 0), BF
                                        LINE (0, 48 * boatsIncity)-(_WIDTH - 100, 48 * (boatsIncity - 1)), _RGB(255, 255, 255), B
                                        LINE (_WIDTH - 75, 48 * boatsIncity - 10)-(_WIDTH - 40, 48 * (boatsIncity - 1) + 10), _RGB(255, 255, 255), B
                                        LOCATE 3 * boatsIncity - 1, 92 + (_WIDTH - MinWidth) / 8
                                        PRINT "LOAD"
                                        _PUTIMAGE (0, 48 * boatsIncity - 40), boatImage(boats(boat).boatType).thumBnail
                                        IF boatsIncity >= 10 + INT((_HEIGHT - MinHeight) / 50) THEN EXIT FOR
                                    END IF
                                END IF
                                nope:
                            NEXT
                            boatsHere = 0
                            FOR boatHereFinder = 1 TO boatsOwned
                                IF boats(boatHereFinder).Destination = FoundACity AND boats(boatHereFinder).timeToDestination = 0 THEN
                                    boatsHere = boatsHere + 1
                                END IF
                            NEXT
                            IF port(FoundACity).level < 3 THEN
                                LINE (0, 48 * boatsIncity)-(450, 48 * (boatsIncity + 1)), _RGB(255, 255, 255), B
                                LINE (_WIDTH - 130, 48 * boatsIncity)-(_WIDTH - 20, 48 * (boatsIncity + 1)), _RGB(255, 255, 255), B
                                IF port(FoundACity).cost * (1 + port(FoundACity).level) > coins(1) THEN
                                    LINE (_WIDTH - 130, 48 * boatsIncity)-(_WIDTH - 20, 48 * (boatsIncity + 1)), _RGB(255, 0, 0), BF
                                END IF
                                LOCATE 3 * (boatsIncity + 1) - 1, 3
                                PRINT "Upgrade the "; RTRIM$(port(FoundACity).name); " port for "; port(FoundACity).cost * (port(FoundACity).level + 1); " coins"
                                LOCATE 3 * (boatsIncity + 1) - 1, 86 + (_WIDTH - MinWidth) / 8
                                PRINT "UPGRADE PORT"
                            ELSE
                                LOCATE 3 * (boatsIncity + 1) - 1, 3
                                PRINT RTRIM$(port(FoundACity).name); " is already max level"
                            END IF
                            _DISPLAY
                            'IF _EXIT GOTO leaveAndSave
                            IF _MOUSEINPUT THEN
                                mouse_X = _MOUSEX
                                mouse_Y = _MOUSEY
                                FOR clickingBoats = 1 TO boatsIncity
                                    IF mouse_X < _WIDTH - 50 AND mouse_X > _WIDTH - 100 THEN
                                        IF mouse_Y > 48 * (clickingBoats - 1) + 10 AND mouse_Y < (48 * clickingBoats) - 10 THEN
                                            IF _MOUSEBUTTON(1) = -1 THEN
                                                FOR findingBoat = 1 TO boatsOwned
                                                    IF boats((findingBoat)).cityNumber = clickingBoats THEN
                                                        boatnumber = (findingBoat)
                                                        EXIT FOR
                                                    END IF
                                                NEXT
                                                goodTogo = 1
                                                EXIT DO
                                            END IF
                                        END IF
                                    END IF
                                NEXT
                                IF _MOUSEBUTTON(1) = -1 THEN
                                    IF mouse_X < 100 AND mouse_Y > _HEIGHT - 100 THEN
                                        DO
                                            _LIMIT 30
                                            i = _MOUSEINPUT
                                        LOOP UNTIL NOT _MOUSEBUTTON(1)
                                        boatnumber = 0
                                        goodTogo = 1
                                        EXIT DO
                                    END IF
                                    IF mouse_X < _WIDTH - 25 AND mouse_X > _WIDTH - 125 THEN
                                        IF mouse_Y > 50 * boatsIncity AND mouse_Y < 50 * (boatsIncity) + 50 THEN
                                            IF port(FoundACity).cost * (1 + port(FoundACity).level) <= coins(1) THEN
                                                CLS
                                                coins(1) = coins(1) - port(FoundACity).cost * (1 + port(FoundACity).level)
                                                port(FoundACity).level = port(FoundACity).level + 1
                                                GOTO start
                                                goodTogo = 1
                                                EXIT DO
                                            END IF
                                        END IF
                                    END IF
                                END IF
                            END IF
                            IF _MOUSEWHEEL > 0 AND listPosition < boatsHere - (10 + INT((_HEIGHT - MinHeight) / 50)) THEN
                                listPosition = listPosition + 1
                            END IF
                            IF _MOUSEWHEEL < 0 AND listPosition >= 1 THEN
                                listPosition = listPosition - 1
                            END IF
                            DO
                                i = _MOUSEINPUT
                            LOOP UNTIL NOT _MOUSEINPUT
                        LOOP UNTIL goodTogo = 1
                        CLS
                    END IF
                    IF boatnumber = 0 THEN
                        mouse_Y = 1
                        mouse_X = 1
                        weRtryingToleave = 1
                        EXIT FOR
                    END IF

                    exitCondition = 0
                    CLS
                    spotsToload = boats(boatnumber).AvailibleCargosLot
                    FOR clickreset = 1 TO 50
                        clicked(clickreset, FoundACity) = 0
                    NEXT
                    backToCargoMenu:
                    cargoesAdded = 0
                    IF (boats(boatnumber).MaxCargoSlot - boats(boatnumber).AvailibleCargosLot) THEN
                        FOR appendingCounter = amountofCargo(FoundACity) + 1 TO amountofCargo(FoundACity) + (boats(boatnumber).MaxCargoSlot - boats(boatnumber).AvailibleCargosLot)
                            weGotOne = 0
                            FOR otherCounter = 1 TO 50
                                IF weGotOne = 0 AND cargointheHull(otherCounter).hostBoat = boatnumber THEN
                                    cargo(appendingCounter, FoundACity).Destination = cargointheHull(otherCounter).DestinaTion
                                    cargo(appendingCounter, FoundACity).Value = cargointheHull(otherCounter).vaLue
                                    cargo(appendingCounter, FoundACity).Title = cargointheHull(otherCounter).Title
                                    cargo(appendingCounter, FoundACity).Rarity = cargointheHull(otherCounter).Rarity
                                    cargo(appendingCounter, FoundACity).TypingNumber = cargointheHull(otherCounter).typingNumber
                                    cargointheHull(otherCounter).DestinaTion = 0
                                    cargointheHull(otherCounter).vaLue = 0
                                    cargointheHull(otherCounter).hostBoat = 0
                                    cargointheHull(otherCounter).spotFilled = 0
                                    weGotOne = 1
                                    clicked(appendingCounter, FoundACity) = 1
                                    cargoesAdded = cargoesAdded + 1
                                    'IF cargoNames(cargo(appendingCounter, FoundACity).TypingNumber).Title <> cargo(appendingCounter, FoundACity).Title THEN
                                    '    fiXed = 0
                                    '    FOR typeRepairer = 1 TO numOfNames
                                    '        IF cargoNames(typeRepairer).Title <> cargo(appendingCounter, FoundACity).Title THEN
                                    '            cargo(appendingCounter, FoundACity).TypingNumber = typeRepairer
                                    '            fiXed = 1
                                    '        END IF
                                    '    NEXT
                                    'END IF
                                    'spotstoLoad = spotstoLoad - 1
                                END IF
                            NEXT
                        NEXT
                    END IF
                    amountofCargo(FoundACity) = amountofCargo(FoundACity) + cargoesAdded
                    listPosition = 0
                    DO
                        _LIMIT 100
                        'IF _EXIT GOTO leaveAndSave
                        DO WHILE _MOUSEINPUT
                            mouse_X = _MOUSEX
                            mouse_Y = _MOUSEY
                            IF boats(boatnumber).AvailibleCargosLot > boats(boatnumber).MaxCargoSlot THEN
                                boats(boatnumber).AvailibleCargosLot = boats(boatnumber).MaxCargoSlot
                            END IF
                            IF _MOUSEWHEEL > 0 AND listPosition < amountofCargo(FoundACity) - 10 - (_HEIGHT - MinHeight) / 50 THEN
                                listPosition = listPosition + 1
                            END IF
                            IF _MOUSEWHEEL < 0 AND listPosition >= 1 THEN
                                listPosition = listPosition - 1
                            END IF
                            IF _MOUSEBUTTON(1) THEN
                                FOR cargoClickCheck = 1 TO 11 + (_HEIGHT - MinHeight) / 50
                                    IF cargoClickCheck <= amountofCargo(FoundACity) AND cargoClickCheck + listPosition <= amountofCargo(FoundACity) THEN
                                        IF clicked(cargoClickCheck + listPosition, FoundACity) = 0 AND spotsToload > 0 THEN
                                            IF mouse_Y < (cargoClickCheck * 48) + 5 AND mouse_Y > ((cargoClickCheck - 1) * 48) + 25 AND mouse_X < 750 + _WIDTH - MinWidth AND mouse_X > 700 + _WIDTH - MinWidth THEN
                                                clicked(cargoClickCheck + listPosition, FoundACity) = 1
                                                spotsToload = spotsToload - 1
                                            END IF
                                        ELSEIF clicked(cargoClickCheck + listPosition, FoundACity) = 1 THEN
                                            IF mouse_Y < (cargoClickCheck * 48) + 5 AND mouse_Y > ((cargoClickCheck - 1) * 48) + 25 AND mouse_X < 775 + _WIDTH - MinWidth AND mouse_X > 675 + _WIDTH - MinWidth THEN
                                                clicked(cargoClickCheck + listPosition, FoundACity) = 0
                                                spotsToload = spotsToload + 1
                                            END IF
                                        END IF
                                    END IF
                                NEXT
                                IF mouse_X < 100 AND mouse_Y > _HEIGHT - 100 THEN
                                    exitCondition = 1
                                    DO
                                        _LIMIT 30
                                        i = _MOUSEINPUT
                                    LOOP UNTIL NOT _MOUSEBUTTON(1)
                                    CLS
                                    needupkeep = 0

                                    boats(boatnumber).AvailibleCargosLot = boats(boatnumber).MaxCargoSlot
                                    FOR cargoFinder = 1 TO 50
                                        IF clicked(cargoFinder, FoundACity) = 1 THEN
                                            weGotOne = 0
                                            'clicked(cargoFinder, FoundACity) = 0
                                            FOR cargoslotFinder = 1 TO 50
                                                IF cargointheHull(cargoslotFinder).spotFilled = 0 AND weGotOne = 0 THEN
                                                    cargointheHull(cargoslotFinder).vaLue = cargo(cargoFinder, FoundACity).Value
                                                    cargointheHull(cargoslotFinder).DestinaTion = cargo(cargoFinder, FoundACity).Destination
                                                    cargointheHull(cargoslotFinder).hostBoat = boatnumber
                                                    cargointheHull(cargoslotFinder).Title = cargo(cargoFinder, FoundACity).Title
                                                    cargointheHull(cargoslotFinder).spotFilled = 1
                                                    cargointheHull(cargoslotFinder).Rarity = cargo(cargoFinder, FoundACity).Rarity
                                                    cargointheHull(cargoslotFinder).typingNumber = cargo(cargoFinder, FoundACity).TypingNumber
                                                    weGotOne = 1
                                                    boats(boatnumber).AvailibleCargosLot = boats(boatnumber).AvailibleCargosLot - 1
                                                END IF
                                            NEXT
                                            FOR cargoShiftDown = cargoFinder TO amountofCargo(FoundACity)
                                                cargo(cargoShiftDown, FoundACity).Value = cargo(cargoShiftDown + 1, FoundACity).Value
                                                cargo(cargoShiftDown, FoundACity).Destination = cargo(cargoShiftDown + 1, FoundACity).Destination
                                                cargo(cargoShiftDown, FoundACity).Title = cargo(cargoShiftDown + 1, FoundACity).Title
                                                cargo(cargoShiftDown, FoundACity).TypingNumber = cargo(cargoShiftDown + 1, FoundACity).TypingNumber
                                                cargo(cargoShiftDown, FoundACity).Rarity = cargo(cargoShiftDown + 1, FoundACity).Rarity
                                                clicked(cargoShiftDown, FoundACity) = clicked(cargoShiftDown + 1, FoundACity)
                                            NEXT
                                            cargoFinder = cargoFinder - 1
                                            cargo(amountofCargo(FoundACity), FoundACity).Value = 0
                                            cargo(amountofCargo(FoundACity), FoundACity).Destination = 0
                                            cargo(amountofCargo(FoundACity), FoundACity).Title = ""
                                            clicked(amountofCargo(FoundACity), FoundACity) = 0
                                            cargo(amountofCargo(FoundACity), FoundACity).Rarity = 0
                                            amountofCargo(FoundACity) = amountofCargo(FoundACity) - 1
                                            'clicked(cargoFinder, FoundACity) = 0
                                        END IF
                                    NEXT
                                    GOTO start
                                END IF
                                IF mouse_X > _WIDTH - 100 AND mouse_Y > _HEIGHT - 100 THEN
                                    exitCondition = 1
                                    boatsending = 0
                                    DO
                                        _LIMIT 30
                                        i = _MOUSEINPUT
                                    LOOP UNTIL NOT _MOUSEBUTTON(1)

                                    GOTO someThing
                                END IF
                                IF mouse_Y < 10 THEN
                                    IF mouse_X > 125 AND mouse_X < 200 THEN
                                        sortByDest:
                                        lastDone = 0
                                        spotsTaken = 0
                                        FOR destTest = 1 TO numOfCities
                                            cargoToCIty(destTest) = 0
                                            record = 0
                                            FOR distanceFinder = 1 TO numOfCities
                                                distTest = distanceBetween(FoundACity, distanceFinder)
                                                IF (lastDone = 0 AND distTest > record) OR (distTest > record AND distTest < distanceBetween(FoundACity, lastDone)) THEN
                                                    record = distTest
                                                    recordCity = distanceFinder
                                                END IF
                                            NEXT
                                            lastDone = recordCity
                                            FOR cargoResorter = 1 TO amountofCargo(FoundACity)
                                                IF cargo(cargoResorter, FoundACity).Destination = recordCity THEN
                                                    cargoToCIty(destTest) = cargoToCIty(destTest) + 1
                                                    spotsTaken = spotsTaken + 1
                                                    clickResorter(spotsTaken) = clicked(cargoResorter, FoundACity)
                                                    cargoResorter(spotsTaken).Destination = cargo(cargoResorter, FoundACity).Destination
                                                    cargoResorter(spotsTaken).Value = cargo(cargoResorter, FoundACity).Value
                                                    cargoResorter(spotsTaken).Rarity = cargo(cargoResorter, FoundACity).Rarity
                                                    cargoResorter(spotsTaken).Title = cargo(cargoResorter, FoundACity).Title
                                                    cargoResorter(spotsTaken).TypingNumber = cargo(cargoResorter, FoundACity).TypingNumber
                                                END IF
                                            NEXT
                                        NEXT
                                        cargoesSorted = 0
                                        FOR coinResorter = 1 TO numOfCities
                                            FOR goUntildone = 1 TO cargoToCIty(coinResorter)
                                                FOR coinSwapper = 1 TO cargoToCIty(coinResorter) - 1
                                                    IF cargoResorter(cargoesSorted + coinSwapper).Value < cargoResorter(cargoesSorted + coinSwapper + 1).Value AND cargoResorter(cargoesSorted + coinSwapper).Destination = cargoResorter(cargoesSorted + coinSwapper + 1).Destination THEN
                                                        SWAP cargoResorter(cargoesSorted + coinSwapper), cargoResorter(cargoesSorted + coinSwapper + 1)
                                                        SWAP clickResorter(cargoesSorted + coinSwapper), clickResorter(cargoesSorted + coinSwapper + 1)
                                                    END IF
                                                NEXT
                                            NEXT
                                            cargoesSorted = cargoesSorted + cargoToCIty(coinResorter)
                                        NEXT
                                        FOR cargoRestorer = 1 TO amountofCargo(FoundACity)
                                            clicked(cargoRestorer, FoundACity) = clickResorter(cargoRestorer)
                                            cargo(cargoRestorer, FoundACity).Destination = cargoResorter(cargoRestorer).Destination
                                            cargo(cargoRestorer, FoundACity).Value = cargoResorter(cargoRestorer).Value
                                            cargo(cargoRestorer, FoundACity).Rarity = cargoResorter(cargoRestorer).Rarity
                                            cargo(cargoRestorer, FoundACity).Title = cargoResorter(cargoRestorer).Title
                                            cargo(cargoRestorer, FoundACity).TypingNumber = cargoResorter(cargoRestorer).TypingNumber
                                        NEXT
                                        IF goBack = 1 GOTO returnFromSort
                                    END IF
                                    IF mouse_X > 325 AND mouse_X < 400 THEN
                                        sortByValue:
                                        spotsTaken = 0
                                        FOR tryEveryOne = 1 TO amountofCargo(FoundACity)
                                            record = 0
                                            FOR cargoResorter = 1 TO amountofCargo(FoundACity)
                                                IF cargo(cargoResorter, FoundACity).Value > record THEN
                                                    recordNumber = cargoResorter
                                                    record = cargo(cargoResorter, FoundACity).Value
                                                END IF
                                            NEXT
                                            spotsTaken = spotsTaken + 1
                                            clickResorter(spotsTaken) = clicked(recordNumber, FoundACity)
                                            cargoResorter(spotsTaken).Destination = cargo(recordNumber, FoundACity).Destination
                                            cargoResorter(spotsTaken).Value = cargo(recordNumber, FoundACity).Value
                                            cargoResorter(spotsTaken).Rarity = cargo(recordNumber, FoundACity).Rarity
                                            cargoResorter(spotsTaken).Title = cargo(recordNumber, FoundACity).Title
                                            cargoResorter(spotsTaken).TypingNumber = cargo(recordNumber, FoundACity).TypingNumber
                                            cargo(recordNumber, FoundACity).Value = 0

                                        NEXT
                                        FOR cargoRestorer = 1 TO amountofCargo(FoundACity)
                                            clicked(cargoRestorer, FoundACity) = clickResorter(cargoRestorer)
                                            cargo(cargoRestorer, FoundACity).Destination = cargoResorter(cargoRestorer).Destination
                                            cargo(cargoRestorer, FoundACity).Value = cargoResorter(cargoRestorer).Value
                                            cargo(cargoRestorer, FoundACity).Rarity = cargoResorter(cargoRestorer).Rarity
                                            cargo(cargoRestorer, FoundACity).Title = cargoResorter(cargoRestorer).Title
                                            cargo(cargoRestorer, FoundACity).TypingNumber = cargoResorter(cargoRestorer).TypingNumber
                                        NEXT
                                        IF goBack = 1 GOTO returnFromSort
                                    END IF
                                END IF
                            END IF
                        LOOP
                        CLS
                        PRINT coins(1)
                        LOCATE 1, 17
                        PRINT port(FoundACity).name
                        LOCATE 1, 44
                        IF firstTime THEN
                            firstTime = 0
                        END IF
                        PRINT "Value       "; spotsToload; " open spots / "; boats(boatnumber).MaxCargoSlot; " max "
                        IF amountofCargo(FoundACity) = 0 THEN
                            PRINT "There is no cargo to a port you own at the moment. Please check back later"
                        END IF
                        LINE (0, 15)-(_WIDTH, 15)
                        LINE (325, 0)-(400, 10)
                        LINE (200, 0)-(125, 10)
                        IF spotsToload = 0 THEN
                            colorchoice = _RGB(255, 0, 0)
                        ELSE colorchoice = _RGB(255, 255, 255)
                        END IF
                        IF amountofCargo(FoundACity) >= 11 + INT((_HEIGHT - MinHeight) / 50) THEN 'cargo loading menu
                            FOR burn = 1 TO 11 + INT((_HEIGHT - MinHeight) / 50)
                                LINE (0, (burn * 48) + 15)-(_WIDTH, (burn * 48) + 15)
                                IF cargo(burn + listPosition, FoundACity).Rarity > 1 THEN
                                    LINE (1, (burn * 48) + 16)-(_WIDTH - 1, ((burn - 1) * 48) + 14), _RGB(255, 215, 0), BF
                                END IF
                                IF cargo(burn + listPosition, FoundACity).TypingNumber > numOfNames THEN
                                    LINE (1, (burn * 48) + 16)-(_WIDTH - 1, ((burn - 1) * 48) + 14), _RGB(0, 78, 172), BF
                                END IF
                                IF burn + listPosition <= amountofCargo(FoundACity) THEN
                                    LOCATE burn * 3, 10
                                    PRINT "#"; burn + listPosition; ": "; RTRIM$(port(cargo(burn + listPosition, FoundACity).Destination).name)
                                    LOCATE 3 * burn, 40
                                    PRINT cargo(burn + listPosition, FoundACity).Value
                                    LOCATE 3 * burn, 46
                                    PRINT RTRIM$(cargo(burn + listPosition, FoundACity).Title)
                                    IF cargo(burn + listPosition, FoundACity).TypingNumber <= numOfNames THEN
                                        _PUTIMAGE (550, ((burn - 1) * 48) + 20), cargoNames(cargo(burn + listPosition, FoundACity).TypingNumber).picture
                                    ELSE
                                        _PUTIMAGE (550, ((burn - 1) * 48) + 20), activeSpecialCargos(cargo(burn + listPosition, FoundACity).TypingNumber - numOfNames).picture
                                    END IF
                                    IF port(cargo(burn + listPosition, FoundACity).Destination).level > 0 THEN
                                        FOR levelDotMaker = 1 TO 3
                                            IF port(cargo(burn + listPosition, FoundACity).Destination).level >= levelDotMaker THEN
                                                choiceColor = _RGB(0, 250, 0)
                                            ELSE
                                                choiceColor = _RGB(250, 150, 0)
                                            END IF
                                            CIRCLE (250 - 10 + (5 * levelDotMaker), (burn * 48) - 9), 3, choiceColor
                                            PAINT (250 - 10 + (5 * levelDotMaker), (burn * 48) - 9), choiceColor
                                        NEXT
                                    END IF
                                    IF clicked(burn + listPosition, FoundACity) = 1 THEN
                                        LINE (_WIDTH - 125, ((burn - 1) * 48) + 25)-(_WIDTH - 25, (burn * 48) + 5), _RGB(255, 0, 0), BF
                                        LOCATE (burn * 3), 88 + (_WIDTH - MinWidth) / 8
                                        PRINT "UNLOAD"
                                    ELSE
                                        LINE (_WIDTH - 100, ((burn - 1) * 48) + 25)-(_WIDTH - 50, (burn * 48) + 5), _RGB(0, 255, 0), BF
                                        LINE (_WIDTH - 101, ((burn - 1) * 48) + 24)-(_WIDTH - 49, (burn * 48) + 6), colorchoice, B
                                        LOCATE (burn * 3), 90 + (_WIDTH - MinWidth) / 8
                                        PRINT "LOAD"
                                    END IF
                                END IF
                            NEXT
                        ELSE
                            FOR burn = 1 TO amountofCargo(FoundACity)
                                IF cargo(burn + listPosition, FoundACity).Rarity > 1 THEN
                                    LINE (1, (burn * 48) + 16)-(_WIDTH - 1, ((burn - 1) * 48) + 14), _RGB(255, 215, 0), BF
                                END IF
                                IF cargo(burn, FoundACity).TypingNumber > numOfNames THEN
                                    LINE (1, (burn * 48) + 16)-(_WIDTH - 1, ((burn - 1) * 48) + 14), _RGB(0, 78, 172), BF
                                END IF
                                IF clicked(burn + listPosition, FoundACity) = 1 THEN
                                    LINE (_WIDTH - 125, ((burn - 1) * 48) + 25)-(_WIDTH - 25, (burn * 48) + 5), _RGB(255, 0, 0), BF
                                    LOCATE (burn * 3), 88 + (_WIDTH - MinWidth) / 8
                                    PRINT "UNLOAD"
                                ELSE
                                    LINE (_WIDTH - 100, ((burn - 1) * 48) + 25)-(_WIDTH - 50, (burn * 48) + 5), _RGB(0, 255, 0), BF
                                    LINE (_WIDTH - 101, ((burn - 1) * 48) + 24)-(_WIDTH - 49, (burn * 48) + 6), colorchoice, B
                                    LOCATE (burn * 3), 90 + (_WIDTH - MinWidth) / 8
                                    PRINT "LOAD"
                                END IF
                                LOCATE burn * 3, 10
                                PRINT "#"; burn + listPosition; ": "; RTRIM$(port(cargo(burn + listPosition, FoundACity).Destination).name)
                                LOCATE 3 * burn, 40
                                PRINT cargo(burn + listPosition, FoundACity).Value
                                LOCATE 3 * burn, 46
                                PRINT RTRIM$(cargo(burn + listPosition, FoundACity).Title)
                                IF cargo(burn + listPosition, FoundACity).TypingNumber <= numOfNames THEN
                                    _PUTIMAGE (550, ((burn - 1) * 48) + 20), cargoNames(cargo(burn + listPosition, FoundACity).TypingNumber).picture
                                ELSE _PUTIMAGE (550, ((burn - 1) * 48) + 20), activeSpecialCargos(cargo(burn + listPosition, FoundACity).TypingNumber - numOfNames).picture
                                END IF
                                IF port(cargo(burn + listPosition, FoundACity).Destination).level > 0 THEN
                                    FOR levelDotMaker = 1 TO 3
                                        IF port(cargo(burn + listPosition, FoundACity).Destination).level >= levelDotMaker THEN
                                            choiceColor = _RGB(0, 250, 0)
                                        ELSE
                                            choiceColor = _RGB(250, 150, 0)
                                        END IF
                                        CIRCLE (250 - 10 + (5 * levelDotMaker), (burn * 48) - 9), 3, choiceColor
                                        PAINT (250 - 10 + (5 * levelDotMaker), (burn * 48) - 9), choiceColor
                                    NEXT
                                END IF
                                LINE (0, (burn * 48) + 15)-(_WIDTH, (burn * 48) + 15)
                            NEXT
                        END IF
                        LOCATE 2, 1
                        LINE (_WIDTH, _HEIGHT - 100)-(_WIDTH - 100, _HEIGHT), _RGB(30, 255, 30), BF
                        LOCATE 35 + (_HEIGHT - MinHeight) / 16, 93 + (_WIDTH - MinWidth) / 8
                        PRINT "SEND"
                        drawLEFTXbox
                        _DISPLAY
                        'SLEEP
                        _LIMIT 30
                    LOOP UNTIL exitCondition = 1
                    someThing:
                    boats(boatnumber).AvailibleCargosLot = boats(boatnumber).MaxCargoSlot
                    FOR cargoFinder = 1 TO 50
                        IF clicked(cargoFinder, FoundACity) = 1 THEN
                            weGotOne = 0
                            FOR cargoslotFinder = 1 TO 50
                                IF cargointheHull(cargoslotFinder).spotFilled = 0 AND weGotOne = 0 THEN
                                    cargointheHull(cargoslotFinder).vaLue = cargo(cargoFinder, FoundACity).Value
                                    cargointheHull(cargoslotFinder).DestinaTion = cargo(cargoFinder, FoundACity).Destination
                                    cargointheHull(cargoslotFinder).hostBoat = boatnumber
                                    cargointheHull(cargoslotFinder).Rarity = cargo(cargoFinder, FoundACity).Rarity
                                    cargointheHull(cargoslotFinder).Title = cargo(cargoFinder, FoundACity).Title
                                    cargointheHull(cargoslotFinder).typingNumber = cargo(cargoFinder, FoundACity).TypingNumber
                                    cargointheHull(cargoslotFinder).spotFilled = 1
                                    weGotOne = 1
                                    boats(boatnumber).AvailibleCargosLot = boats(boatnumber).AvailibleCargosLot - 1
                                END IF
                            NEXT
                            FOR cargoShiftDown = cargoFinder TO amountofCargo(FoundACity)
                                cargo(cargoShiftDown, FoundACity).Value = cargo(cargoShiftDown + 1, FoundACity).Value
                                cargo(cargoShiftDown, FoundACity).Rarity = cargo(cargoShiftDown + 1, FoundACity).Rarity
                                cargo(cargoShiftDown, FoundACity).Destination = cargo(cargoShiftDown + 1, FoundACity).Destination
                                cargo(cargoShiftDown, FoundACity).Title = cargo(cargoShiftDown + 1, FoundACity).Title
                                cargo(cargoShiftDown, FoundACity).TypingNumber = cargo(cargoShiftDown + 1, FoundACity).TypingNumber
                                clicked(cargoShiftDown, FoundACity) = clicked(cargoShiftDown + 1, FoundACity)
                                'PRINT #4, cargo(cargoShiftDown, FoundACity).TypingNumber, cargo(cargoShiftDown, FoundACity).Title
                                'FOR typeRepairer = 1 TO numOfNames
                                '    FOR help = 0 TO 1
                                '        IF cargoNames(typeRepairer).Title <> cargo(cargoShiftDown + help, FoundACity).Title THEN
                                '            cargo(cargoShiftDown + help, FoundACity).TypingNumber = typeRepairer
                                '            fiXed = 1
                                '        END IF
                                '    NEXT
                                'NEXT
                            NEXT
                            cargoFinder = cargoFinder - 1
                            amountofCargo(FoundACity) = amountofCargo(FoundACity) - 1
                        END IF
                    NEXT
                    mapXposition = -(Xcoordinates(FoundACity) - (_WIDTH / 2))
                    mapYposition = -(Ycoordinates(FoundACity) - (_HEIGHT / 2))
                    firSt = 1
                    GOTO boatSendingMap
                    CLS
                    boatsending = 0
                    _PUTIMAGE (mapXposition - 1400, mapYposition - 400), map
                    DO
                        _LIMIT 30
                        DO UNTIL NOT _MOUSEINPUT
                            mouse_X = _MOUSEX
                            mouse_Y = _MOUSEY
                        LOOP
                        keysPressed$ = INKEY$
                        pastX = mapXposition
                        pastY = mapYposition
                        IF _KEYDOWN(18432) THEN 'up arrow pressed
                            mapYposition = mapYposition + 10
                        END IF
                        IF _KEYDOWN(19200) THEN 'left arrow pressed
                            mapXposition = mapXposition + 10
                        END IF
                        IF _KEYDOWN(19712) THEN 'right arrow pressed
                            mapXposition = mapXposition - 10
                        END IF
                        IF _KEYDOWN(20480) THEN 'down arrow pressed
                            mapYposition = mapYposition - 10
                        END IF
                        IF mapYposition > 150 + _HEIGHT - MinHeight THEN 'up arrow pressed
                            mapYposition = 150
                        END IF
                        IF mapXposition > 1400 THEN 'left arrow pressed
                            mapXposition = 1400
                        END IF
                        IF mapXposition < -200 + _WIDTH - MinWidth THEN 'right arrow pressed
                            mapXposition = -200
                        END IF
                        IF mapYposition < -400 THEN 'down arrow pressed
                            mapYposition = -400
                        END IF
                        IF pastX <> mapXposition OR pastY <> mapYposition OR firSt OR oldFuel <> boats(boatnumber).Boatfuel GOTO boatSendingMap
                        IF _MOUSEBUTTON(1) THEN
                            FOR cityClick = 1 TO numOfCities
                                IF mouse_X <= Xcoordinates(cityClick) + 3 + mapXposition AND mouse_X >= Xcoordinates(cityClick) - 3 + mapXposition AND mouse_Y <= Ycoordinates(cityClick) + 3 + mapYposition AND mouse_Y >= Ycoordinates(cityClick) - 3 + mapYposition AND distanceBetween(FoundACity, cityClick) / 1.5 < boats(boatnumber).MaxBoatfuel THEN
                                    IF pendingDest <> cityClick THEN
                                        pendingDest = cityClick
                                        clearRequest = 1
                                        IF distanceBetween(FoundACity, cityClick) / 1.5 > boats(boatnumber).Boatfuel AND distanceBetween(FoundACity, cityClick) / 1.5 < boats(boatnumber).MaxBoatfuel THEN
                                            pendingSchedule = 1
                                        ELSE
                                            pendingSchedule = 0
                                        END IF
                                    ELSE pendingDest = 0
                                    END IF
                                END IF
                            NEXT
                            IF mouse_Y > _HEIGHT - 100 AND mouse_X > _WIDTH - 100 THEN
                                boatsending = 1
                                DO
                                    _LIMIT 30
                                    i = _MOUSEINPUT
                                LOOP UNTIL NOT _MOUSEBUTTON(1)
                            END IF
                            IF mouse_Y > _HEIGHT - 100 AND mouse_X < 100 THEN
                                DO
                                    _LIMIT 30
                                    i = _MOUSEINPUT
                                LOOP UNTIL NOT _MOUSEBUTTON(1)
                                exitCondition = 0
                                pendingDest = 0
                                GOTO backToCargoMenu
                                boatsending = 1
                            END IF
                            mouseYstart = mouse_Y
                            mouseXstart = mouse_X
                            mapYstart = mapYposition
                            mapXstart = mapXposition
                            firSt = 1
                            DO WHILE _MOUSEBUTTON(1)

                                _LIMIT 30
                                lastY = mouse_Y
                                lastX = mouse_X
                                DO
                                    i = _MOUSEINPUT
                                    mouse_Y = _MOUSEY
                                    mouse_X = _MOUSEX
                                LOOP UNTIL NOT _MOUSEINPUT
                                mapYposition = mapYstart + (mouse_Y - mouseYstart)
                                mapXposition = mapXstart + (mouse_X - mouseXstart)
                                boatSendingMap:
                                IF mapYposition > 150 + _HEIGHT - MinHeight THEN 'up arrow pressed
                                    mapYposition = 150 + _HEIGHT - MinHeight
                                END IF
                                IF mapXposition > 1400 THEN 'left arrow pressed
                                    mapXposition = 1400
                                END IF
                                IF mapXposition < -200 + _WIDTH - MinWidth THEN 'right arrow pressed
                                    mapXposition = -200 + _WIDTH - MinWidth
                                END IF
                                IF mapYposition < -400 THEN 'down arrow pressed
                                    mapYposition = -400
                                END IF
                                IF lastX <> mouse_X OR lastY <> mouse_Y OR firSt OR oldFuel <> boats(boatnumber).Boatfuel THEN
                                    firSt = 0
                                    _PUTIMAGE (mapXposition - 1400, mapYposition - 400), map
                                    oldFuel = boats(boatnumber).Boatfuel
                                    FOR cityMaker = 1 TO numOfCities
                                        CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 2, _RGB(0, 0, 0)
                                        PAINT (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), _RGB(0, 0, 0)
                                        CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 2.5, _RGB(255, 255, 255)
                                        CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 3, _RGB(0, 0, 0)
                                        IF port(cityMaker).level > 0 THEN
                                            FOR levelDotMaker = 1 TO 3
                                                IF port(cityMaker).level >= levelDotMaker THEN
                                                    choiceColor = _RGB(0, 250, 0)
                                                ELSE
                                                    choiceColor = _RGB(250, 150, 0)
                                                END IF
                                                CIRCLE (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), 2.5, _RGB(0, 0, 0)
                                                CIRCLE (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), 1.5, choiceColor
                                                PAINT (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), choiceColor
                                            NEXT
                                        END IF
                                    NEXT
                                    CIRCLE (Xcoordinates(FoundACity) + mapXposition, Ycoordinates(FoundACity) + mapYposition), 2, _RGB(0, 0, 255)
                                    PAINT (Xcoordinates(FoundACity) + mapXposition, Ycoordinates(FoundACity) + mapYposition), _RGB(0, 0, 0)
                                    CIRCLE (Xcoordinates(FoundACity) + mapXposition, Ycoordinates(FoundACity) + mapYposition), boats(boatnumber).Boatfuel, _RGB(0, 0, 0)
                                    IF pendingDest AND pendingDest <> FoundACity THEN
                                        LINE (Xcoordinates(FoundACity) + mapXposition, Ycoordinates(FoundACity) + mapYposition)-(Xcoordinates(pendingDest) + mapXposition, Ycoordinates(pendingDest) + mapYposition), _RGB(0, 0, 0)
                                        CIRCLE (Xcoordinates(pendingDest) + mapXposition, Ycoordinates(pendingDest) + mapYposition), 4.5, _RGB(0, 255, 0)
                                    ELSE
                                        CIRCLE (Xcoordinates(FoundACity) + mapXposition, Ycoordinates(FoundACity) + mapYposition), 4, _RGB(0, 255, 0)
                                    END IF
                                    FOR destFinder = 1 TO 50
                                        IF cargointheHull(destFinder).DestinaTion AND cargointheHull(destFinder).hostBoat = boatnumber THEN
                                            CIRCLE (Xcoordinates(cargointheHull(destFinder).DestinaTion) + mapXposition, Ycoordinates(cargointheHull(destFinder).DestinaTion) + mapYposition), 2, _RGB(225, 184, 125)
                                            PAINT (Xcoordinates(cargointheHull(destFinder).DestinaTion) + mapXposition, Ycoordinates(cargointheHull(destFinder).DestinaTion) + mapYposition), _RGB(225, 184, 125)
                                        END IF
                                    NEXT
                                    _DISPLAY
                                    WAIT &H3DA, 8
                                END IF
                            LOOP
                            LINE (_WIDTH, _HEIGHT - 100)-(_WIDTH - 100, _HEIGHT), _RGB(30, 255, 30), BF
                            LOCATE 35 + (_HEIGHT - MinHeight) / 16, 93 + (_WIDTH - MinWidth) / 8
                            IF pendingSchedule = 1 THEN
                                PRINT "SCHEDULE"
                            ELSE
                                PRINT "SEND"
                            END IF
                            drawLEFTXbox
                            _DISPLAY
                        END IF
                    LOOP UNTIL boatsending = 1
                    IF pendingDest <> FoundACity AND pendingDest THEN
                        IF pendingSchedule = 1 THEN
                            boats(boatnumber).timeToDestination = 1
                            boats(boatnumber).TickSent = 100000
                            boats(boatnumber).Origin = pendingDest
                            boats(boatnumber).Destination = FoundACity
                            boats(boatnumber).scheduled = 1
                        ELSE
                            boats(boatnumber).Destination = pendingDest
                            boats(boatnumber).Origin = FoundACity
                            boats(boatnumber).scheduled = 0
                            boats(boatnumber).timeToDestination = distanceBetween(FoundACity, pendingDest) * boats(boatnumber).Speedmultiplier / 1.5
                            boats(boatnumber).TickSent = TIMER(1)
                            boats(boatnumber).Boatfuel = boats(boatnumber).Boatfuel - INT(distanceBetween(FoundACity, pendingDest) / 1.5)
                            dFromTop = 1
                            FOR oldposFinder = 1 TO boatsOwned
                                IF listPositions(oldposFinder) = boatnumber THEN
                                    oldPos = oldposFinder
                                    EXIT FOR
                                END IF
                            NEXT
                            'PRINT #4, oldPos
                            FOR spotfInder = 1 TO boatsOwned
                                IF boats(spotfInder).TickSent + boats(spotfInder).timeToDestination < boats(boatnumber).TickSent + boats(boatnumber).timeToDestination THEN
                                    dFromTop = dFromTop + 1
                                END IF
                            NEXT
                            FOR listMover = oldPos + 1 TO dFromTop
                                listPositions(listMover - 1) = listPositions(listMover)
                            NEXT
                            listPositions(dFromTop) = boatnumber
                            'PRINT #4, listPositions(), dFromTop
                        END IF
                    END IF
                    CLS
                    pendingDest = 0
                    pendingSchedule = 0
                ELSE
                    CLS
                    drawLEFTXbox
                    LINE (0, 70)-(500, 0), _RGB(255, 255, 255), B
                    LINE (_WIDTH - 130, 0)-(_WIDTH - 20, 70), _RGB(255, 255, 255), B
                    IF port(FoundACity).cost * (1 + port(FoundACity).level) > coins(1) THEN
                        LINE (_WIDTH - 130, 0)-(_WIDTH - 20, 70), _RGB(255, 0, 0), BF
                    END IF
                    LOCATE 3, 3
                    PRINT "Purchase the "; port(FoundACity).name; "  port for "; port(FoundACity).cost * (port(FoundACity).level + 1); " coins"
                    LOCATE 3, 88 + (_WIDTH - MinWidth) / 8
                    PRINT "BUY PORT"
                    _DISPLAY
                    goodTogo = 0
                    DO
                        'IF _EXIT GOTO leaveAndSave
                        DO WHILE _MOUSEINPUT
                            mouse_X = _MOUSEX
                            mouse_Y = _MOUSEY
                            IF _MOUSEBUTTON(1) THEN
                                IF mouse_X < 100 THEN
                                    IF mouse_Y > _HEIGHT - 100 THEN
                                        boatnumber = 0
                                        goodTogo = 1
                                        CLS
                                        DO
                                            _LIMIT 30
                                            i = _MOUSEINPUT
                                        LOOP UNTIL NOT _MOUSEBUTTON(1)
                                        EXIT DO
                                    END IF
                                END IF
                                IF mouse_X < _WIDTH - 25 AND mouse_X > _WIDTH - 125 THEN
                                    IF mouse_Y > 0 AND mouse_Y < 50 THEN
                                        IF port(FoundACity).cost * (1 + port(FoundACity).level) <= coins(1) THEN
                                            CLS
                                            coins(1) = coins(1) - port(FoundACity).cost * (1 + port(FoundACity).level)
                                            port(FoundACity).level = port(FoundACity).level + 1
                                            goodTogo = 1
                                            GOTO start
                                            EXIT DO
                                        END IF
                                    END IF
                                END IF
                            END IF
                        LOOP
                    LOOP UNTIL goodTogo = 1
                END IF
            END IF
        NEXT
        mouseYstart = _MOUSEY
        mouseXstart = _MOUSEX
        mapYstart = mapYposition
        mapXstart = mapXposition
        DO WHILE _MOUSEBUTTON(1)
            _LIMIT 30
            lastY = mouse_Y
            lastX = mouse_X
            DO
                mouse_Y = _MOUSEY
                mouse_X = _MOUSEX
                i = _MOUSEINPUT
            LOOP UNTIL NOT _MOUSEINPUT
            mapYposition = mapYstart + (mouse_Y - mouseYstart)
            mapXposition = mapXstart + (mouse_X - mouseXstart)
            IF mapYposition > 150 + _HEIGHT - MinHeight THEN 'up arrow pressed
                mapYposition = 150 + _HEIGHT - MinHeight
            END IF
            IF mapXposition > 1400 THEN 'left arrow pressed
                mapXposition = 1400
            END IF
            IF mapXposition < -200 + _WIDTH - MinWidth THEN 'right arrow pressed
                mapXposition = -200 + _WIDTH - MinWidth
            END IF
            IF mapYposition < -400 THEN 'down arrow pressed
                mapYposition = -400
            END IF
            IF lastX <> mouse_X OR lastY <> mouse_Y THEN
                CLS
                _PUTIMAGE (mapXposition - 1400, mapYposition - 400), map
                FOR cityMaker = 1 TO numOfCities
                    CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 2, _RGB(0, 0, 0)
                    PAINT (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), _RGB(0, 0, 0)
                    CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 2.5, _RGB(255, 255, 255)
                    CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 3, _RGB(0, 0, 0)
                    IF port(cityMaker).level > 0 THEN
                        FOR levelDotMaker = 1 TO 3
                            IF port(cityMaker).level >= levelDotMaker THEN
                                choiceColor = _RGB(0, 250, 0)
                            ELSE
                                choiceColor = _RGB(250, 150, 0)
                            END IF
                            CIRCLE (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), 2.5, _RGB(0, 0, 0)
                            CIRCLE (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), 1.5, choiceColor
                            PAINT (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), choiceColor
                        NEXT
                    END IF
                NEXT

                FOR CityChecker = 1 TO boatsOwned
                    IF boats(CityChecker).timeToDestination = 0 THEN
                        CIRCLE (Xcoordinates(boats(CityChecker).Destination) + mapXposition, Ycoordinates(boats(CityChecker).Destination) + mapYposition), 2, _RGB(0, 255, 0)
                        PAINT (Xcoordinates(boats(CityChecker).Destination) + mapXposition, Ycoordinates(boats(CityChecker).Destination) + mapYposition), _RGB(0, 255, 0)
                        boats(CityChecker).cityNumber = 0
                    END IF
                NEXT

                FOR CityChecker = 1 TO boatsOwned
                    IF boats(CityChecker).timeToDestination = 0 THEN
                    ELSE
                        'PAINT (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), BLACK
                        'CIRCLE (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), 2, _RGB(0, 0, 0)
                        'PAINT (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), _RGB(0, 0, 0)
                        'fuelUsed = INT(cargocoinvalue(Xcoordinates(boats(CityChecker).Origin), Ycoordinates(boats(CityChecker).Origin), Xcoordinates(boats(CityChecker).Destination), Ycoordinates(boats(CityChecker).Destination)) / 1.5)
                        'fuelUsed = fuelUsed * (1 - ((TIMER(1) - boats(CityChecker).TickSent) / boats(CityChecker).timeToDestination))
                        'CIRCLE (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), 2, _RGB(100, 255, 100)
                        LINE (Xcoordinates(boats(CityChecker).Destination) + mapXposition, mapYposition + Ycoordinates(boats(CityChecker).Destination))-((Xcoordinates(boats(CityChecker).Origin)) + mapXposition, (Ycoordinates(boats(CityChecker).Origin)) + mapYposition), _RGB(0, 0, 0)
                        IF Xcoordinates(boats(CityChecker).Destination) > Xcoordinates(boats(CityChecker).Origin) THEN
                            _PUTIMAGE (Xcoordinates(boats(CityChecker).Destination) + mapXposition + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6, mapYposition + Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6), RightFacingBoat&
                        ELSE
                            _PUTIMAGE (Xcoordinates(boats(CityChecker).Destination) + mapXposition + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6, mapYposition + Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6), LeftFacingBoat&
                        END IF
                        boats(CityChecker).cityNumber = 0
                    END IF
                NEXT
                _DISPLAY
            END IF
        LOOP
    END IF

    boatnumber = 0
    'LOOP UNTIL FoundACity <> 0
LOOP UNTIL gameover = 1

IF impossible = 1 THEN
    shop:
    IF TIMER(1) - lastShopUpdate > 600 THEN 'make new parts if more than 10 mins since last check go by
        DO
            lastShopUpdate = lastShopUpdate + 600
        LOOP UNTIL TIMER(1) - lastShopUpdate < 600
        RANDOMIZE TIMER
        numPartsToMake = INT(RND * 11)
        FOR partMaker = 1 TO numPartsToMake
            part(partMaker).boatPart = INT(RND * numOfBoatTypes) + 1
            part(partMaker).form = INT(RND * 3) + 1
            part(partMaker).tiTle = partName(part(partMaker).form)
            part(partMaker).cost = masterPart(part(partMaker).boatPart).cost
        NEXT
    END IF
    reprint:
    gotten = 0
    CLS
    escape = 0
    LINE (0, 15)-(_WIDTH, 15)
    PRINT coins(1)
    LOCATE 35 + (_HEIGHT - MinHeight) / 16, 92 + (_WIDTH - MinWidth) / 8
    PRINT "Garage"
    LOCATE 35 + (_HEIGHT - MinHeight) / 16, 78 + (_WIDTH - MinWidth) / 8
    PRINT "Boat-Pedia"
    LOCATE 35 + (_HEIGHT - MinHeight) / 16, 68 + (_WIDTH - MinWidth) / 8
    PRINT "Stats"
    drawLEFTXbox
    LINE (_WIDTH - 300, _HEIGHT - 100)-(_WIDTH - 200, _HEIGHT), , B
    LINE -(_WIDTH - 100, _HEIGHT - 100), , B
    LINE -(_WIDTH, _HEIGHT), , B
    FOR partDisplayer = 1 TO numPartsToMake
        LINE (0, (partDisplayer * 48) + 15)-(_WIDTH, (partDisplayer * 48) + 15)
        LOCATE 3 * partDisplayer, 10
        PRINT "#"; partDisplayer; "  Boat type: "; part(partDisplayer).boatPart; " type: "; part(partDisplayer).tiTle; " cost: "; masterPart(part(partDisplayer).boatPart).cost; " owned: "; ownedParts(part(partDisplayer).form, part(partDisplayer).boatPart)
        _PUTIMAGE (370, (partDisplayer * 48) - 12), partPicture(part(partDisplayer).form).image
        LINE (_WIDTH - 100, _HEIGHT - 100)-(_WIDTH, _HEIGHT), , B
        IF part(partDisplayer).cost <= coins(1) THEN
            LINE (_WIDTH - 100, ((partDisplayer - 1) * 48) + 25)-(_WIDTH - 50, (partDisplayer * 48) + 5), _RGB(0, 255, 0), BF
        ELSE
            LINE (_WIDTH - 100, ((partDisplayer - 1) * 48) + 25)-(_WIDTH - 50, (partDisplayer * 48) + 5), _RGB(255, 0, 0), BF
        END IF
        LOCATE (partDisplayer * 3), 90 + (_WIDTH - MinWidth) / 8
        PRINT "BUY"
        _DISPLAY
    NEXT
    FOR unclicker = 1 TO 50
        partClicked(unclicker) = 0
    NEXT
    DO
        IF numPartsToMake = 0 THEN
            CLS
            PRINT "There are currently no parts in the shop. Please check back later"
            LOCATE 35 + (_HEIGHT - MinHeight) / 16, 92 + (_WIDTH - MinWidth) / 8
            PRINT "Garage"
            LOCATE 35 + (_HEIGHT - MinHeight) / 16, 78 + (_WIDTH - MinWidth) / 8
            PRINT "Boat-Pedia"
            LOCATE 35 + (_HEIGHT - MinHeight) / 16, 68 + (_WIDTH - MinWidth) / 8
            PRINT "Stats"
            drawLEFTXbox
            LINE (_WIDTH - 300, _HEIGHT - 100)-(_WIDTH - 200, _HEIGHT), , B
            LINE -(_WIDTH - 100, _HEIGHT - 100), , B
            LINE -(_WIDTH, _HEIGHT), , B
            _DISPLAY
            break = 0
            DO
                _LIMIT 100
                DO WHILE _MOUSEINPUT
                    mouse_X = _MOUSEX
                    mouse_Y = _MOUSEY
                    IF _MOUSEBUTTON(1) AND mouse_Y > _HEIGHT - 100 THEN
                        IF mouse_X < 100 THEN
                            break = 1
                            escape = 1
                            DO
                                i = _MOUSEINPUT
                            LOOP UNTIL NOT _MOUSEBUTTON(1)
                            CLS
                            GOTO menu
                        END IF
                        IF mouse_X > _WIDTH - 100 GOTO garage
                        IF mouse_X > _WIDTH - 200 GOTO boatPedia
                        IF mouse_X > _WIDTH - 300 GOTO statsSpot
                    END IF
                LOOP
                'IF _EXIT GOTO leaveAndSave
            LOOP UNTIL break = 1
        END IF
        _LIMIT 100
        DO WHILE _MOUSEINPUT
            mouse_X = _MOUSEX
            mouse_Y = _MOUSEY
            IF _MOUSEBUTTON(1) THEN
                IF mouse_X > _WIDTH - 100 AND mouse_X < _WIDTH - 50 THEN
                    FOR buyingChecker = 1 TO numPartsToMake
                        IF mouse_Y > ((buyingChecker - 1) * 48) + 25 AND mouse_Y < (buyingChecker * 48) + 5 THEN
                            partClicked(buyingChecker) = 1
                            DO
                                i = _MOUSEINPUT
                            LOOP UNTIL NOT _MOUSEBUTTON(1)
                        END IF
                    NEXT
                END IF
                IF mouse_Y > _HEIGHT - 100 THEN
                    IF mouse_X < 100 THEN CLS: GOTO menu
                    IF mouse_X > _WIDTH - 100 THEN
                        garage:
                        CLS
                        atLeastOne = 0
                        partsFound = 0
                        drawLEFTXbox
                        LOCATE 1, 1
                        PRINT "Your Garage     BoatNumber", "Part type", "Amount owned", "Cost"
                        LINE (_WIDTH - 100, 0)-(_WIDTH, 25), _RGB(255, 0, 0), BF
                        LOCATE 1, 90 + (_WIDTH - MinWidth) / 8
                        PRINT "Wipe Save"
                        LINE (0, 25)-(_WIDTH, 25)
                        FOR boatParts = 1 TO numOfBoatTypes
                            partsOfThisBoat = 0
                            FOR partType = 1 TO 3
                                IF ownedParts(partType, boatParts) > 0 THEN
                                    partsOfThisBoat = partsOfThisBoat + 1
                                    partsFound = partsFound + 1
                                    LINE (0, (partsFound * 48) + 15)-(_WIDTH, (partsFound * 48) + 15)
                                    LOCATE 3 * partsFound, 17
                                    PRINT boatParts, partName(partType), ownedParts(partType, boatParts), masterPart(boatParts).cost
                                    IF partsOfThisBoat = 3 THEN
                                        IF masterPart(boatParts).cost <= coins(1) THEN
                                            LINE (_WIDTH - 100, ((partsFound - 1) * 48) + 25)-(_WIDTH - 50, (partsFound * 48) + 5), _RGB(0, 255, 0), BF
                                        ELSE
                                            LINE (_WIDTH - 100, ((partsFound - 1) * 48) + 25)-(_WIDTH - 50, (partsFound * 48) + 5), _RGB(255, 0, 0), BF
                                        END IF
                                        LOCATE (partsFound * 3), 89 + (_WIDTH - MinWidth) / 8
                                        PRINT "BUILD"
                                    END IF
                                END IF
                            NEXT
                        NEXT
                        _DISPLAY
                        partsFound = 0
                        DO
                            'IF _EXIT GOTO leaveAndSave
                            DO WHILE _MOUSEINPUT
                                mouse_X = _MOUSEX
                                mouse_Y = _MOUSEY
                                IF _MOUSEBUTTON(1) THEN
                                    IF mouse_Y < 15 AND mouse_X > _WIDTH - 100 THEN
                                        CLS
                                        coDe$ = ""
                                        FOR codemaker = 1 TO 10
                                            coDe$ = coDe$ + LTRIM$(RTRIM$(STR$(INT(RND * 2))))
                                        NEXT
                                        PRINT "Are you sure that you want to delete your savegame? This cannot be undone"
                                        PRINT "For safety, please enter the following code: "; coDe$
                                        INPUT killConfirm$
                                        IF killConfirm$ = coDe$ THEN
                                            KILL OtherFile$
                                            SYSTEM
                                        ELSE GOTO leaveAndSave
                                        END IF
                                    END IF
                                    IF mouse_Y > _HEIGHT - 100 AND mouse_X < 100 THEN
                                        DO
                                            i = _MOUSEINPUT
                                        LOOP UNTIL NOT _MOUSEBUTTON(1)
                                        GOTO shop
                                    END IF
                                    IF mouse_X < _WIDTH - 50 AND mouse_X > _WIDTH - 100 THEN
                                        FOR boatParts = 1 TO numOfBoatTypes
                                            partsOfThisBoat = 0
                                            FOR partType = 1 TO 3
                                                IF ownedParts(partType, boatParts) > 0 THEN
                                                    partsFound = partsFound + 1
                                                    partsOfThisBoat = partsOfThisBoat + 1
                                                END IF
                                            NEXT
                                            IF partsOfThisBoat = 3 AND coins(1) >= masterPart(boatParts).cost THEN
                                                IF mouse_Y > ((partsFound - 1) * 48) + 25 AND mouse_Y < (partsFound * 48) + 5 THEN
                                                    CLS
                                                    selectionMade = 0
                                                    _PUTIMAGE (mapXposition - 1400, mapYposition - 400), map
                                                    _DISPLAY
                                                    needMap = 1
                                                    GOTO maPpls
                                                    DO
                                                        _LIMIT 60
                                                        LOCATE 1, 1
                                                        PRINT "Select a city to build your boat in"
                                                        FOR cityMaker = 1 TO numOfCities
                                                            CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 2, _RGB(0, 0, 0)
                                                            PAINT (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), _RGB(0, 0, 0)
                                                            CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 2.5, _RGB(255, 255, 255)
                                                            CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 3, _RGB(0, 0, 0)
                                                            IF port(cityMaker).level > 0 THEN
                                                                FOR levelDotMaker = 1 TO 3
                                                                    IF port(cityMaker).level >= levelDotMaker THEN
                                                                        choiceColor = _RGB(0, 250, 0)
                                                                    ELSE
                                                                        choiceColor = _RGB(250, 150, 0)
                                                                    END IF
                                                                    CIRCLE (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), 2.5, _RGB(0, 0, 0)
                                                                    CIRCLE (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), 1.5, choiceColor
                                                                    PAINT (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), choiceColor
                                                                NEXT
                                                            END IF
                                                        NEXT

                                                        FOR CityChecker = 1 TO boatsOwned
                                                            IF boats(CityChecker).timeToDestination = 0 THEN
                                                                CIRCLE (Xcoordinates(boats(CityChecker).Destination) + mapXposition, Ycoordinates(boats(CityChecker).Destination) + mapYposition), 2, _RGB(0, 255, 0)
                                                                PAINT (Xcoordinates(boats(CityChecker).Destination) + mapXposition, Ycoordinates(boats(CityChecker).Destination) + mapYposition), _RGB(0, 255, 0)
                                                                boats(CityChecker).cityNumber = 0
                                                            END IF
                                                        NEXT

                                                        FOR CityChecker = 1 TO boatsOwned
                                                            IF boats(CityChecker).timeToDestination = 0 THEN
                                                            ELSE
                                                                'PAINT (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), BLACK
                                                                'CIRCLE (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), 2, _RGB(0, 0, 0)
                                                                'PAINT (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), _RGB(0, 0, 0)
                                                                'fuelUsed = INT(cargocoinvalue(Xcoordinates(boats(CityChecker).Origin), Ycoordinates(boats(CityChecker).Origin), Xcoordinates(boats(CityChecker).Destination), Ycoordinates(boats(CityChecker).Destination)) / 1.5)
                                                                'fuelUsed = fuelUsed * (1 - ((TIMER(1) - boats(CityChecker).TickSent) / boats(CityChecker).timeToDestination))
                                                                'CIRCLE (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), 2, _RGB(100, 255, 100)
                                                                LINE (Xcoordinates(boats(CityChecker).Destination) + mapXposition, mapYposition + Ycoordinates(boats(CityChecker).Destination))-((Xcoordinates(boats(CityChecker).Origin)) + mapXposition, (Ycoordinates(boats(CityChecker).Origin)) + mapYposition), _RGB(0, 0, 0)
                                                                IF Xcoordinates(boats(CityChecker).Destination) > Xcoordinates(boats(CityChecker).Origin) THEN
                                                                    _PUTIMAGE (Xcoordinates(boats(CityChecker).Destination) + mapXposition + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6, mapYposition + Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6), RightFacingBoat&
                                                                ELSE
                                                                    _PUTIMAGE (Xcoordinates(boats(CityChecker).Destination) + mapXposition + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6, mapYposition + Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6), LeftFacingBoat&
                                                                END IF
                                                                boats(CityChecker).cityNumber = 0
                                                            END IF
                                                        NEXT
                                                        _DISPLAY
                                                        DO WHILE _MOUSEINPUT
                                                            mouse_X = _MOUSEX
                                                            mouse_Y = _MOUSEY
                                                            IF _MOUSEBUTTON(1) THEN
                                                                FOR cityCheck = 1 TO numOfCities
                                                                    IF mouse_X >= Xcoordinates(cityCheck) - 3 + mapXposition AND mouse_X <= Xcoordinates(cityCheck) + 3 + mapXposition AND mouse_Y >= Ycoordinates(cityCheck) - 3 + mapYposition AND mouse_Y <= Ycoordinates(cityCheck) + 3 + mapYposition THEN
                                                                        coins(1) = coins(1) - masterPart(boatParts).cost
                                                                        boats(lastUnowned).owned = 1
                                                                        boats(lastUnowned).boatType = boatParts
                                                                        boats(lastUnowned).Origin = cityCheck
                                                                        boats(lastUnowned).Destination = cityCheck
                                                                        boats(lastUnowned).Speedmultiplier = typeOfBoat(boatParts).Speedmultiplier
                                                                        boats(lastUnowned).MaxCargoSlot = typeOfBoat(boatParts).MaxCargoSlot
                                                                        boats(lastUnowned).AvailibleCargosLot = typeOfBoat(boatParts).MaxCargoSlot
                                                                        boats(lastUnowned).MaxBoatfuel = typeOfBoat(boatParts).MaxBoatfuel
                                                                        boats(lastUnowned).Boatfuel = 0
                                                                        totalSlots = totalSlots + typeOfBoat(boatParts).MaxCargoSlot
                                                                        FOR partDestroyer = 1 TO 3
                                                                            ownedParts(partDestroyer, boatParts) = ownedParts(partDestroyer, boatParts) - 1
                                                                        NEXT
                                                                        lastUnowned = lastUnowned + 1
                                                                        boatsOwned = boatsOwned + 1
                                                                        selectionMade = 1
                                                                        CLS
                                                                        GOTO menu
                                                                    END IF
                                                                NEXT
                                                                maPpls:
                                                                mouseYstart = _MOUSEY
                                                                mouseXstart = _MOUSEX
                                                                mapYstart = mapYposition
                                                                mapXstart = mapXposition
                                                                mouseYstart = _MOUSEY
                                                                mouseXstart = _MOUSEX
                                                                mapYstart = mapYposition
                                                                mapXstart = mapXposition
                                                                DO WHILE _MOUSEBUTTON(1) OR needMap
                                                                    needMap = 0
                                                                    _LIMIT 60
                                                                    lastY = mouse_Y
                                                                    lastX = mouse_X
                                                                    DO
                                                                        mouse_Y = _MOUSEY
                                                                        mouse_X = _MOUSEX
                                                                        i = _MOUSEINPUT
                                                                    LOOP UNTIL NOT _MOUSEINPUT
                                                                    mapYposition = mapYstart + (mouse_Y - mouseYstart)
                                                                    mapXposition = mapXstart + (mouse_X - mouseXstart)
                                                                    IF mapYposition > 150 + _HEIGHT - MinHeight THEN 'up arrow pressed
                                                                        mapYposition = 150 + _HEIGHT - MinHeight
                                                                    END IF
                                                                    IF mapXposition > 1400 THEN 'left arrow pressed
                                                                        mapXposition = 1400
                                                                    END IF
                                                                    IF mapXposition < -200 + _WIDTH - MinWidth THEN 'right arrow pressed
                                                                        mapXposition = -200 + _WIDTH - MinWidth
                                                                    END IF
                                                                    IF mapYposition < -400 THEN 'down arrow pressed
                                                                        mapYposition = -400
                                                                    END IF
                                                                    IF lastX <> mouse_X OR lastY <> mouse_Y THEN
                                                                        CLS
                                                                        _PUTIMAGE (mapXposition - 1400, mapYposition - 400), map
                                                                        FOR cityMaker = 1 TO numOfCities
                                                                            CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 2, _RGB(0, 0, 0)
                                                                            PAINT (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), _RGB(0, 0, 0)
                                                                            CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 2.5, _RGB(255, 255, 255)
                                                                            CIRCLE (Xcoordinates(cityMaker) + mapXposition, Ycoordinates(cityMaker) + mapYposition), 3, _RGB(0, 0, 0)
                                                                            IF port(cityMaker).level > 0 THEN
                                                                                FOR levelDotMaker = 1 TO 3
                                                                                    IF port(cityMaker).level >= levelDotMaker THEN
                                                                                        choiceColor = _RGB(0, 250, 0)
                                                                                    ELSE
                                                                                        choiceColor = _RGB(250, 150, 0)
                                                                                    END IF
                                                                                    CIRCLE (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), 2.5, _RGB(0, 0, 0)
                                                                                    CIRCLE (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), 1.5, choiceColor
                                                                                    PAINT (Xcoordinates(cityMaker) - 10 + (5 * levelDotMaker) + mapXposition, Ycoordinates(cityMaker) - 7 + mapYposition), choiceColor
                                                                                NEXT
                                                                            END IF
                                                                        NEXT

                                                                        FOR CityChecker = 1 TO boatsOwned
                                                                            IF boats(CityChecker).timeToDestination = 0 THEN
                                                                                CIRCLE (Xcoordinates(boats(CityChecker).Destination) + mapXposition, Ycoordinates(boats(CityChecker).Destination) + mapYposition), 2, _RGB(0, 255, 0)
                                                                                PAINT (Xcoordinates(boats(CityChecker).Destination) + mapXposition, Ycoordinates(boats(CityChecker).Destination) + mapYposition), _RGB(0, 255, 0)
                                                                                boats(CityChecker).cityNumber = 0
                                                                            END IF
                                                                        NEXT

                                                                        FOR CityChecker = 1 TO boatsOwned
                                                                            IF boats(CityChecker).timeToDestination = 0 THEN
                                                                            ELSE
                                                                                'PAINT (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), BLACK
                                                                                'CIRCLE (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), 2, _RGB(0, 0, 0)
                                                                                'PAINT (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - ((TIMER(1) - 1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), _RGB(0, 0, 0)
                                                                                'fuelUsed = INT(cargocoinvalue(Xcoordinates(boats(CityChecker).Origin), Ycoordinates(boats(CityChecker).Origin), Xcoordinates(boats(CityChecker).Destination), Ycoordinates(boats(CityChecker).Destination)) / 1.5)
                                                                                'fuelUsed = fuelUsed * (1 - ((TIMER(1) - boats(CityChecker).TickSent) / boats(CityChecker).timeToDestination))
                                                                                'CIRCLE (Xcoordinates(boats(CityChecker).Destination) + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination), Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination)), 2, _RGB(100, 255, 100)
                                                                                LINE (Xcoordinates(boats(CityChecker).Destination) + mapXposition, mapYposition + Ycoordinates(boats(CityChecker).Destination))-((Xcoordinates(boats(CityChecker).Origin)) + mapXposition, (Ycoordinates(boats(CityChecker).Origin)) + mapYposition), _RGB(0, 0, 0)
                                                                                IF Xcoordinates(boats(CityChecker).Destination) > Xcoordinates(boats(CityChecker).Origin) THEN
                                                                                    _PUTIMAGE (Xcoordinates(boats(CityChecker).Destination) + mapXposition + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6, mapYposition + Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6), RightFacingBoat&
                                                                                ELSE
                                                                                    _PUTIMAGE (Xcoordinates(boats(CityChecker).Destination) + mapXposition + ((Xcoordinates(boats(CityChecker).Origin) - Xcoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6, mapYposition + Ycoordinates(boats(CityChecker).Destination) + ((Ycoordinates(boats(CityChecker).Origin) - Ycoordinates(boats(CityChecker).Destination)) * (boats(CityChecker).timeToDestination - (TIMER(1) - boats(CityChecker).TickSent)) / boats(CityChecker).timeToDestination) - 6), LeftFacingBoat&
                                                                                END IF
                                                                                boats(CityChecker).cityNumber = 0
                                                                            END IF
                                                                        NEXT
                                                                        _DISPLAY
                                                                    END IF
                                                                LOOP
                                                            END IF
                                                        LOOP
                                                    LOOP UNTIL selectionMade = 1
                                                END IF
                                            END IF
                                        NEXT
                                    END IF
                                END IF
                            LOOP 'while _mouseinput(1)
                        LOOP UNTIL escape = 1
                    END IF
                    IF mouse_X > _WIDTH - 200 GOTO boatPedia
                    IF mouse_X > _WIDTH - 300 THEN GOTO statsSpot
                END IF
            END IF
        LOOP
        IF escape = 0 THEN
            FOR clickChecker = 1 TO numPartsToMake
                IF partClicked(clickChecker) = 1 AND coins(1) >= part(clickChecker).cost AND gotten = 0 THEN
                    coins(1) = coins(1) - part(clickChecker).cost
                    ownedParts(part(clickChecker).form, part(clickChecker).boatPart) = ownedParts(part(clickChecker).form, part(clickChecker).boatPart) + 1
                    gotten = 1
                    numPartsToMake = numPartsToMake - 1
                END IF
                IF gotten = 1 THEN
                    part(clickChecker).boatPart = part(clickChecker + 1).boatPart
                    part(clickChecker).form = part(clickChecker + 1).form
                    part(clickChecker).tiTle = part(clickChecker + 1).tiTle
                    part(clickChecker).cost = part(clickChecker + 1).cost
                END IF
            NEXT
        END IF
        IF gotten = 1 GOTO reprint
        'IF _EXIT THEN GOTO leaveAndSave
    LOOP UNTIL escape = 1
    GOTO menu
END IF

IF boatPedia = 1 THEN
    boatPedia:
    update = 1
    DO
        i = _MOUSEINPUT
    LOOP UNTIL NOT _MOUSEBUTTON(1)
    CLS
    leave = 0
    DO
        _LIMIT 30
        IF update = 1 THEN
            LINE (100, 75)-(_WIDTH - 100, 475), , B
            IF pediaPosition = 1 THEN
                leftcolorChoice = _RGB(150, 0, 0)
                rightcolorChoice = _RGB(0, 150, 0)
            ELSEIF pediaPosition = numOfBoatTypes THEN
                rightcolorChoice = _RGB(150, 0, 0)
                leftcolorChoice = _RGB(0, 150, 0)
            ELSE
                leftcolorChoice = _RGB(0, 150, 0)
                rightcolorChoice = _RGB(0, 150, 0)
            END IF
            LINE (50, 300)-(75, 275), leftcolorChoice, BF
            drawLEFTArrow
            LINE (_WIDTH - MinWidth + 750, 300)-(_WIDTH - MinWidth + 725, 275), rightcolorChoice, BF 'right arrow
            drawRIGHTArrow
            drawLEFTXbox
            _PUTIMAGE (100 + (_WIDTH - MinWidth) / 2, 75), boatImage(pediaPosition).image
            LOCATE 19, 15 + (_WIDTH - MinWidth) / 16
            PRINT "Boat Type: "
            LOCATE 19, 60 + (_WIDTH - MinWidth) / 16
            PRINT pediaPosition
            LOCATE 21, 15 + (_WIDTH - MinWidth) / 16
            PRINT "Maximum Boatfuel: "
            LOCATE 21, 60 + (_WIDTH - MinWidth) / 16
            PRINT typeOfBoat(pediaPosition).MaxBoatfuel
            LOCATE 22, 15 + (_WIDTH - MinWidth) / 16
            PRINT "Maximum Cargo Slots: "
            LOCATE 22, 60 + (_WIDTH - MinWidth) / 16
            PRINT typeOfBoat(pediaPosition).MaxCargoSlot
            LOCATE 23, 15 + (_WIDTH - MinWidth) / 16
            PRINT "Speed: "
            LOCATE 23, 60 + (_WIDTH - MinWidth) / 16
            PRINT MID$(STR$(1 / typeOfBoat(pediaPosition).Speedmultiplier), 0, INSTR(0, STR$(1 / typeOfBoat(pediaPosition).Speedmultiplier) + ".", ".") + 3)
            numOwned = 0
            FOR boatFinder = 1 TO boatsOwned
                IF boats(boatFinder).boatType = pediaPosition THEN
                    numOwned = numOwned + 1
                END IF
            NEXT
            LOCATE 24, 15 + (_WIDTH - MinWidth) / 16
            PRINT "Amount owned: "
            LOCATE 24, 60 + (_WIDTH - MinWidth) / 16
            PRINT numOwned
            LOCATE 25, 15 + (_WIDTH - MinWidth) / 16
            PRINT "Parts owned: "
            LOCATE 27, 20 + (_WIDTH - MinWidth) / 16
            PRINT "Hulls: "
            LOCATE 27, 60 + (_WIDTH - MinWidth) / 16
            PRINT ownedParts(1, pediaPosition)
            LOCATE 28, 20 + (_WIDTH - MinWidth) / 16
            PRINT "Engines: "
            LOCATE 28, 60 + (_WIDTH - MinWidth) / 16
            PRINT ownedParts(2, pediaPosition)
            LOCATE 29, 20 + (_WIDTH - MinWidth) / 16
            PRINT "Controls: "
            LOCATE 29, 60 + (_WIDTH - MinWidth) / 16
            PRINT ownedParts(3, pediaPosition)
            _PUTIMAGE (105 + (_WIDTH - MinWidth) / 2, 418), partPicture(1).image
            _PUTIMAGE (105 + (_WIDTH - MinWidth) / 2, 435), partPicture(2).image
            _PUTIMAGE (105 + (_WIDTH - MinWidth) / 2, 450), partPicture(3).image
            _DISPLAY
            update = 0
        END IF
        'IF _EXIT GOTO leaveAndSave
        DO WHILE _MOUSEINPUT
            mouse_X = _MOUSEX
            mouse_Y = _MOUSEY
            IF _MOUSEBUTTON(1) THEN
                IF mouse_X < 100 AND mouse_Y > _HEIGHT - 100 THEN
                    DO
                        i = _MOUSEINPUT
                    LOOP UNTIL NOT _MOUSEBUTTON(1)
                    CLS
                    GOTO shop
                END IF
                IF mouse_Y >= 275 AND mouse_Y <= 300 THEN
                    IF pediaPosition > 1 THEN
                        IF mouse_X >= 50 AND mouse_X <= 75 THEN
                            DO
                                i = _MOUSEINPUT
                            LOOP UNTIL NOT _MOUSEBUTTON(1)
                            pediaPosition = pediaPosition - 1
                            update = 1
                            CLS
                        END IF
                    END IF
                    IF pediaPosition < numOfBoatTypes THEN
                        IF mouse_X >= _WIDTH - 75 AND mouse_X <= _WIDTH - 50 THEN
                            DO
                                i = _MOUSEINPUT
                            LOOP UNTIL NOT _MOUSEBUTTON(1)
                            pediaPosition = pediaPosition + 1
                            update = 1
                            CLS
                        END IF
                    END IF
                END IF
            END IF
        LOOP
    LOOP UNTIL leave = 1
    'GOTO shop
END IF

IF statsSpot = 1 THEN
    statsSpot:
    LOCATE 1, 1
    CLS
    DO
        _LIMIT 15
        totalFuel = 0
        totalCoins = 0
        totalDelivered = 0
        SELECT CASE statPage
            CASE 1 'Display port stats
                LOCATE 1, 10 + (_WIDTH - MinWidth) / 16
                PRINT "Displaying Port Stats"
                LOCATE 1, 40 + (_WIDTH - MinWidth) / 16
                PRINT "Coins Earned"
                LOCATE 1, 55 + (_WIDTH - MinWidth) / 16
                PRINT "Fuel Refueled"
                LOCATE 1, 70 + (_WIDTH - MinWidth) / 16
                PRINT "Cargo Recieved"
                FOR portStats = 1 TO numOfCities
                    LOCATE 3 * portStats, 15 + (_WIDTH - MinWidth) / 16
                    PRINT "#"; portStats; ": "; RTRIM$(port(portStats).name)
                    LOCATE 3 * portStats, 40 + (_WIDTH - MinWidth) / 16
                    PRINT port(portStats).stat.coinsIn
                    LOCATE 3 * portStats, 55 + (_WIDTH - MinWidth) / 16
                    PRINT port(portStats).stat.fuel
                    LOCATE 3 * portStats, 70 + (_WIDTH - MinWidth) / 16
                    PRINT port(portStats).stat.delivered
                    totalFuel = totalFuel + port(portStats).stat.fuel
                    totalCoins = totalCoins + port(portStats).stat.coinsIn
                    totalDelivered = totalDelivered + port(portStats).stat.delivered
                NEXT
                LOCATE 3 * portStats, 15 + (_WIDTH - MinWidth) / 16
                PRINT "Totals:"
                LOCATE 3 * portStats, 40 + (_WIDTH - MinWidth) / 16
                PRINT totalCoins
                LOCATE 3 * portStats, 55 + (_WIDTH - MinWidth) / 16
                PRINT totalFuel
                LOCATE 3 * portStats, 70 + (_WIDTH - MinWidth) / 16
                PRINT totalDelivered
            CASE 2 'Display boat stats
                LOCATE 1, 10 + (_WIDTH - MinWidth) / 16
                PRINT "Displaying Boat Stats"
                LOCATE 1, 40 + (_WIDTH - MinWidth) / 16
                PRINT "Coins Earned"
                LOCATE 1, 55 + (_WIDTH - MinWidth) / 16
                PRINT "Refueling Done"
                LOCATE 1, 70 + (_WIDTH - MinWidth) / 16
                PRINT "Cargo Delivered"
                FOR boatStats = 1 TO boatsOwned
                    LOCATE 3 * boatStats, 15 + (_WIDTH - MinWidth) / 16
                    PRINT "#"; boatStats; ": "
                    _PUTIMAGE ((20 + (_WIDTH - MinWidth) / 16) * 8, boatStats * 48 - 16), boatImage(boats(boatStats).boatType).thumBnail
                    LOCATE 3 * boatStats, 40 + (_WIDTH - MinWidth) / 16
                    PRINT boats(boatStats).stat.coinsIn
                    LOCATE 3 * boatStats, 55 + (_WIDTH - MinWidth) / 16
                    PRINT boats(boatStats).stat.fuel
                    LOCATE 3 * boatStats, 70 + (_WIDTH - MinWidth) / 16
                    PRINT boats(boatStats).stat.delivered
                    totalFuel = totalFuel + boats(boatStats).stat.fuel
                    totalCoins = totalCoins + boats(boatStats).stat.coinsIn
                    totalDelivered = totalDelivered + boats(boatStats).stat.delivered
                NEXT
                LOCATE 3 * boatStats, 15 + (_WIDTH - MinWidth) / 16
                PRINT "Totals:"
                LOCATE 3 * boatStats, 40 + (_WIDTH - MinWidth) / 16
                PRINT totalCoins
                LOCATE 3 * boatStats, 55 + (_WIDTH - MinWidth) / 16
                PRINT totalFuel
                LOCATE 3 * boatStats, 70 + (_WIDTH - MinWidth) / 16
                PRINT totalDelivered
            CASE 3
                IF ip$ = "" THEN
                    CLS
                    PRINT "Loading local computer data"
                    _DISPLAY
                    SHELL _HIDE "systeminfo>" + _CWD$ + "\SystemInfo.txt"
                    OPEN "SystemInfo.txt" FOR INPUT AS #1
                    DO
                        LINE INPUT #1, lineIn$
                        IF INSTR(lineIn$, "System Boot Time:  ") THEN
                            boot$ = LTRIM$(RTRIM$(MID$(lineIn$, INSTR(lineIn$, "System Boot Time:  ") + LEN("System Boot Time:  "))))
                        END IF
                        IF INSTR(lineIn$, "IP ad") THEN
                            INPUT #1, lineIn$
                            ip$ = LTRIM$(RTRIM$(MID$(lineIn$, INSTR(lineIn$, ":") + LEN(":"))))
                            INPUT #1, lineIn$
                            mac$ = LTRIM$(RTRIM$(MID$(lineIn$, INSTR(lineIn$, ":") + LEN(":"))))
                        END IF
                        IF INSTR(lineIn$, "~") THEN
                            sped$ = LTRIM$(RTRIM$(MID$(lineIn$, INSTR(lineIn$, "~") + LEN("~"))))
                        END IF
                    LOOP UNTIL EOF(1)
                    CLOSE #1
                    KILL "SystemInfo.txt"
                    CLS
                END IF
                LOCATE 3, 15 + (_WIDTH - MinWidth) / 16
                PRINT "Force due to gravity ft/s^2: 32"
                timeToPrint = totalTime
                timeOut$ = ""
                timeOut$ = LTRIM$(RTRIM$(STR$(INT(timeToPrint / 86400)))) + ":"
                timeToPrint = timeToPrint - 86400 * INT(timeToPrint / 86400)
                timeOut$ = timeOut$ + LTRIM$(RTRIM$(STR$(INT(timeToPrint / 3600)))) + ":"
                timeToPrint = timeToPrint - 3600 * INT(timeToPrint / 3600)
                timeOut$ = timeOut$ + LTRIM$(RTRIM$(STR$(INT(timeToPrint / 60)))) + ":"
                timeToPrint = timeToPrint - 60 * INT(timeToPrint / 60)
                timeOut$ = timeOut$ + LTRIM$(RTRIM$(STR$(INT(timeToPrint)))) + "    "
                LOCATE 5, 15 + (_WIDTH - MinWidth) / 16
                PRINT "Time playing this game: "; timeOut$
                LOCATE 7, 15 + (_WIDTH - MinWidth) / 16
                PRINT "Distance from your monitor (ft) (experimental): "; 2 + (RND / 10)
                LOCATE 9, 15 + (_WIDTH - MinWidth) / 16
                PRINT "Maximum cpu on this device: 100%"
                LOCATE 11, 15 + (_WIDTH - MinWidth) / 16
                PRINT "Your local ip address: "; ip$
                LOCATE 13, 15 + (_WIDTH - MinWidth) / 16
                PRINT "Your MAC address: "; mac$
                LOCATE 15, 15 + (_WIDTH - MinWidth) / 16
                PRINT "Last Boot: "; boot$
                LOCATE 17, 15 + (_WIDTH - MinWidth) / 16
                PRINT "Rated processor speed: "; sped$
        END SELECT
        IF statPage = 1 THEN
            leftcolorChoice = _RGB(150, 0, 0)
            rightcolorChoice = _RGB(0, 150, 0)
        ELSEIF statPage = 3 THEN
            rightcolorChoice = _RGB(150, 0, 0)
            leftcolorChoice = _RGB(0, 150, 0)
        ELSE
            leftcolorChoice = _RGB(0, 150, 0)
            rightcolorChoice = _RGB(0, 150, 0)
        END IF
        LINE (50, 300)-(75, 275), leftcolorChoice, BF
        drawLEFTArrow
        LINE (_WIDTH - MinWidth + 750, 300)-(_WIDTH - MinWidth + 725, 275), rightcolorChoice, BF 'right arrow
        drawRIGHTArrow
        drawLEFTXbox
        _DISPLAY
        DO WHILE _MOUSEINPUT
            mouse_X = _MOUSEX
            mouse_Y = _MOUSEY
            IF _MOUSEBUTTON(1) THEN
                IF mouse_X < 100 AND mouse_Y > _HEIGHT - 100 THEN
                    DO
                        i = _MOUSEINPUT
                    LOOP UNTIL NOT _MOUSEBUTTON(1)
                    CLS
                    GOTO shop
                END IF
                IF mouse_Y >= 275 AND mouse_Y <= 300 THEN
                    IF statPage > 1 THEN
                        IF mouse_X >= 50 AND mouse_X <= 75 THEN
                            DO
                                i = _MOUSEINPUT
                            LOOP UNTIL NOT _MOUSEBUTTON(1)
                            statPage = statPage - 1
                            update = 1
                            CLS
                        END IF
                    END IF
                    IF statPage < 3 THEN
                        IF mouse_X >= _WIDTH - 75 AND mouse_X <= _WIDTH - 50 THEN
                            DO
                                i = _MOUSEINPUT
                            LOOP UNTIL NOT _MOUSEBUTTON(1)
                            statPage = statPage + 1
                            update = 1
                            CLS
                        END IF
                    END IF
                END IF
            END IF
        LOOP
    LOOP
END IF

'IF impossible THEN
'    ErrorReport:
'    PRINT #4, cargo(cargoAssigningcounter, cityMaker).Rarity, cargoAssigningcounter, cityMaker, cargo(cargoAssigningcounter, cityMaker).TypingNumber
'    GOTO errored:
'END IF

Timer.Trap:
IF TIMER(1) - lastTickcheckedOn > 0 THEN
    totalTime = totalTime + (TIMER(1) - lastTickcheckedOn)
END IF
dontLeave:
IF lastTickcheckedOn > TIMER(1) THEN
    lastCargoTime = lastCargoTime - 86400
    lastShopUpdate = lastShopUpdate - 86400
    lastTickcheckedOn = lastTickcheckedOn - 86400
    FOR timeCorrecter = 1 TO boatsOwned
        boats(timeCorrecter).TickSent = boats(timeCorrecter).TickSent - 86400
    NEXT
    FOR timeCorrecter = 1 TO liveEvents
        events(timeCorrecter).timeStart = events(timeCorrecter).timeStart - 86400
    NEXT
END IF
FOR eventEnder = 1 TO liveEvents
    IF events(eventEnder).Delivered >= eventTemplate(events(eventEnder).number).cargoRequired AND events(eventEnder).claimed = 0 THEN
        events(eventEnder).claimed = 1
        coins(1) = coins(1) + eventTemplate(events(eventEnder).number).reward
    END IF
    IF TIMER(1) - events(eventEnder).timeStart > eventTemplate(events(eventEnder).number).duration OR (events(eventEnder).Delivered >= eventTemplate(events(eventEnder).number).maxCargo AND eventTemplate(events(eventEnder).number).maxCargo > 0) THEN
        SpecialRarities = SpecialRarities - activeSpecialCargos(liveEvents).Rarity
        activeSpecialCargos(eventEnder) = nullCargo
        activeSpecials = activeSpecials - 1
        events(eventEnder) = nullEvent
        FOR eventmover = eventEnder + 1 TO liveEvents
            SWAP events(eventmover), events(eventmover - 1)
            SWAP activeSpecialCargos(eventmover), activeSpecialCargos(eventmover - 1)
        NEXT
        liveEvents = liveEvents - 1
    END IF
NEXT
IF TIMER(1) MOD 60 = 0 THEN
    FOR dlcActivator = 1 TO dlcscount
        FOR duplicateProtector = 1 TO liveEvents
            IF events(duplicateProtector).number = dlcActivator THEN
                GOTO Duplicate
            END IF
        NEXT
        IF RND * 8766 < eventTemplate(dlcActivator).rarity THEN
            liveEvents = liveEvents + 1
            events(liveEvents).number = dlcActivator
            activeSpecialCargos(liveEvents) = eventTemplate(dlcActivator).specialCargo
            SpecialRarities = SpecialRarities + activeSpecialCargos(liveEvents).Rarity
            activeSpecials = activeSpecials + 1
            events(liveEvents).title = eventTemplate(dlcActivator).title
            events(liveEvents).Delivered = 0
            events(liveEvents).timeStart = TIMER(1)
            events(liveEvents).cargoDone = 0
        END IF
        Duplicate:
    NEXT
END IF
'IF NOT _SNDPLAYING(playing&) THEN
'  _SNDPLAY (Tunes&(playercounter))
'  playing& = Tunes&(playercounter)
'  playercounter = playercounter + 1
'  IF playercounter > 3 THEN playercounter = 1
'END IF
IF _EXIT GOTO leaveAndSave
FOR boattimerworkings = 1 TO boatsOwned
    IF boats(boattimerworkings).AvailibleCargosLot > boats(boattimerworkings).MaxCargoSlot THEN
        boats(boattimerworkings).AvailibleCargosLot = boats(boattimerworkings).MaxCargoSlot
    END IF
    IF boats(boattimerworkings).timeToDestination = 0 THEN
        boats(boattimerworkings).TickSent = TIMER(1)
        IF boats(boattimerworkings).Boatfuel < boats(boattimerworkings).MaxBoatfuel AND coins(1) > 0 THEN
            timeElapsed = TIMER(1) - lastTickcheckedOn
            fuelingPossible = timeElapsed * port(boats(boattimerworkings).Destination).level
            IF fuelingPossible > boats(boattimerworkings).MaxBoatfuel - boats(boattimerworkings).Boatfuel THEN
                coins(1) = coins(1) - (boats(boattimerworkings).MaxBoatfuel - boats(boattimerworkings).Boatfuel)
                port(boats(boattimerworkings).Destination).stat.fuel = port(boats(boattimerworkings).Destination).stat.fuel + (boats(boattimerworkings).MaxBoatfuel - boats(boattimerworkings).Boatfuel)
                boats(boattimerworkings).stat.fuel = boats(boattimerworkings).stat.fuel + (boats(boattimerworkings).MaxBoatfuel - boats(boattimerworkings).Boatfuel)
                boats(boattimerworkings).Boatfuel = boats(boattimerworkings).MaxBoatfuel
            ELSE
                coins(1) = coins(1) - fuelingPossible
                boats(boattimerworkings).stat.fuel = boats(boattimerworkings).stat.fuel + fuelingPossible
                port(boats(boattimerworkings).Destination).stat.fuel = port(boats(boattimerworkings).Destination).stat.fuel + fuelingPossible
                boats(boattimerworkings).Boatfuel = boats(boattimerworkings).Boatfuel + fuelingPossible
            END IF
        END IF
    END IF

    IF boats(boattimerworkings).timeToDestination < TIMER(1) - boats(boattimerworkings).TickSent THEN
        boats(boattimerworkings).timeToDestination = 0
        boats(boattimerworkings).Origin = boats(boattimerworkings).Destination
        FOR cargoUnloadingcounter = 1 TO 50
            IF cargointheHull(cargoUnloadingcounter).hostBoat = boattimerworkings THEN
                IF cargointheHull(cargoUnloadingcounter).DestinaTion = boats(boattimerworkings).Destination THEN
                    IF cargointheHull(cargoUnloadingcounter).typingNumber <= numOfNames THEN
                        cargoNames(cargointheHull(cargoUnloadingcounter).typingNumber).stat.coinsIn = cargoNames(cargointheHull(cargoUnloadingcounter).typingNumber).stat.coinsIn + cargointheHull(cargoUnloadingcounter).vaLue
                        DynamicRarities(boats(boattimerworkings).Destination, cargointheHull(cargoUnloadingcounter).typingNumber) = DynamicRarities(boats(boattimerworkings).Destination, cargointheHull(cargoUnloadingcounter).typingNumber) - (baseDepriciator * (1 / totalSlots) * (numOfNames - 1) * numOfNames)
                        FOR rarityBooster = 1 TO numOfNames
                            IF rarityBooster <> cargointheHull(cargoUnloadingcounter).typingNumber THEN
                                DynamicRarities(boats(boattimerworkings).Destination, rarityBooster) = DynamicRarities(boats(boattimerworkings).Destination, rarityBooster) + baseDepriciator * (1 / totalSlots) * numOfNames
                            END IF
                            eachCityRarity(cargointheHull(cargoUnloadingcounter).DestinaTion, rarityBooster) = cargoNames(rarityBooster).Rarity * DynamicRarities(boats(boattimerworkings).Destination, rarityBooster) / 100
                        NEXT
                    ELSE
                        events(cargointheHull(cargoUnloadingcounter).typingNumber - numOfNames).Delivered = events(cargointheHull(cargoUnloadingcounter).typingNumber - numOfNames).Delivered + 1
                        events(cargointheHull(cargoUnloadingcounter).typingNumber - numOfNames).cargoDone = events(cargointheHull(cargoUnloadingcounter).typingNumber - numOfNames).cargoDone + 1
                    END IF
                    boats(boattimerworkings).stat.delivered = boats(boattimerworkings).stat.delivered + 1
                    boats(boattimerworkings).stat.coinsIn = boats(boattimerworkings).stat.coinsIn + cargointheHull(cargoUnloadingcounter).vaLue
                    port(boats(boattimerworkings).Destination).stat.delivered = port(boats(boattimerworkings).Destination).stat.delivered + 1
                    port(boats(boattimerworkings).Destination).stat.coinsIn = port(boats(boattimerworkings).Destination).stat.coinsIn + cargointheHull(cargoUnloadingcounter).vaLue
                    coins(1) = coins(1) + cargointheHull(cargoUnloadingcounter).vaLue
                    cargointheHull(cargoUnloadingcounter).vaLue = 0
                    cargointheHull(cargoUnloadingcounter).DestinaTion = 0
                    cargointheHull(cargoUnloadingcounter).hostBoat = 0
                    cargointheHull(cargoUnloadingcounter).spotFilled = 0
                    boats(boattimerworkings).AvailibleCargosLot = boats(boattimerworkings).AvailibleCargosLot + 1
                END IF
            END IF
        NEXT
    END IF

    IF boats(boattimerworkings).scheduled = 1 THEN
        IF boats(boattimerworkings).Boatfuel > distanceBetween(boats(boattimerworkings).Origin, boats(boattimerworkings).Destination) / 1.5 THEN
            SWAP boats(boattimerworkings).Destination, boats(boattimerworkings).Origin
            boats(boattimerworkings).timeToDestination = distanceBetween(boats(boattimerworkings).Origin, boats(boattimerworkings).Destination) * boats(boattimerworkings).Speedmultiplier / 1.5
            boats(boattimerworkings).TickSent = TIMER(1)
            boats(boattimerworkings).Boatfuel = boats(boattimerworkings).Boatfuel - INT(distanceBetween(boats(boattimerworkings).Origin, boats(boattimerworkings).Destination) / 1.5)
            dFromTop = 1
            FOR oldposFinder = 1 TO boatsOwned
                IF listPositions(oldposFinder) = boattimerworkings THEN
                    oldPos = oldposFinder
                    EXIT FOR
                END IF
            NEXT
            'PRINT #4, oldPos
            FOR spotfInder = 1 TO boatsOwned
                IF boats(spotfInder).TickSent + boats(spotfInder).timeToDestination < boats(boattimerworkings).TickSent + boats(boattimerworkings).timeToDestination THEN
                    dFromTop = dFromTop + 1
                END IF
            NEXT
            FOR listMover = oldPos + 1 TO dFromTop
                listPositions(listMover - 1) = listPositions(listMover)
            NEXT
            listPositions(dFromTop) = boattimerworkings
            boats(boattimerworkings).scheduled = 0
        ELSE
            timeElapsed = TIMER(1) - lastTickcheckedOn
            fuelingPossible = timeElapsed * port(boats(boattimerworkings).Destination).level
            IF fuelingPossible > boats(boattimerworkings).MaxBoatfuel - boats(boattimerworkings).Boatfuel THEN
                coins(1) = coins(1) - (boats(boattimerworkings).MaxBoatfuel - boats(boattimerworkings).Boatfuel)
                port(boats(boattimerworkings).Destination).stat.fuel = port(boats(boattimerworkings).Destination).stat.fuel + (boats(boattimerworkings).MaxBoatfuel - boats(boattimerworkings).Boatfuel)
                boats(boattimerworkings).stat.fuel = boats(boattimerworkings).stat.fuel + (boats(boattimerworkings).MaxBoatfuel - boats(boattimerworkings).Boatfuel)
                boats(boattimerworkings).Boatfuel = boats(boattimerworkings).MaxBoatfuel
            ELSE
                coins(1) = coins(1) - fuelingPossible
                boats(boattimerworkings).stat.fuel = boats(boattimerworkings).stat.fuel + fuelingPossible
                port(boats(boattimerworkings).Destination).stat.fuel = port(boats(boattimerworkings).Destination).stat.fuel + fuelingPossible
                boats(boattimerworkings).Boatfuel = boats(boattimerworkings).Boatfuel + fuelingPossible
            END IF
        END IF
    END IF
NEXT
lastTickcheckedOn = TIMER(1)
IF _SCREENICON THEN
    _DELAY 0.25
    GOTO dontLeave
END IF
RETURN

leaveAndSave:
IF FoundACity THEN
    FOR cargoFinder = 1 TO 50
        IF clicked(cargoFinder, FoundACity) = 1 THEN
            weGotOne = 0
            FOR cargoslotFinder = 1 TO 50
                IF cargointheHull(cargoslotFinder).spotFilled = 0 AND weGotOne = 0 THEN
                    cargointheHull(cargoslotFinder).vaLue = cargo(cargoFinder, FoundACity).Value
                    cargointheHull(cargoslotFinder).DestinaTion = cargo(cargoFinder, FoundACity).Destination
                    cargointheHull(cargoslotFinder).hostBoat = boatnumber
                    cargointheHull(cargoslotFinder).Rarity = cargo(cargoFinder, FoundACity).Rarity
                    cargointheHull(cargoslotFinder).Title = cargo(cargoFinder, FoundACity).Title
                    cargointheHull(cargoslotFinder).typingNumber = cargo(cargoFinder, FoundACity).TypingNumber
                    cargointheHull(cargoslotFinder).spotFilled = 1
                    weGotOne = 1
                    boats(boatnumber).AvailibleCargosLot = boats(boatnumber).AvailibleCargosLot - 1
                END IF
            NEXT
            FOR cargoShiftDown = cargoFinder TO amountofCargo(FoundACity)
                cargo(cargoShiftDown, FoundACity).Value = cargo(cargoShiftDown + 1, FoundACity).Value
                cargo(cargoShiftDown, FoundACity).Rarity = cargo(cargoShiftDown + 1, FoundACity).Rarity
                cargo(cargoShiftDown, FoundACity).Destination = cargo(cargoShiftDown + 1, FoundACity).Destination
                cargo(cargoShiftDown, FoundACity).Title = cargo(cargoShiftDown + 1, FoundACity).Title
                cargo(cargoShiftDown, FoundACity).TypingNumber = cargo(cargoShiftDown + 1, FoundACity).TypingNumber
                clicked(cargoShiftDown, FoundACity) = clicked(cargoShiftDown + 1, FoundACity)
            NEXT
            cargoFinder = cargoFinder - 1
            amountofCargo(FoundACity) = amountofCargo(FoundACity) - 1
        END IF
    NEXT
END IF
OPEN OtherFile$ FOR OUTPUT AS #11
CLOSE #11
OPEN OtherFile$ FOR BINARY AS #6

TickClosed = TIMER(1)

PUT #6, , Version
PUT #6, , boats()
PUT #6, , coins()
PUT #6, , typeofpart()
PUT #6, , boatsOwned
PUT #6, , numOfBoatTypes
PUT #6, , amountofCargo()
'PUT #6, , cargoNames()
PUT #6, , port()
PUT #6, , ownedParts()
PUT #6, , lastTickcheckedOn
PUT #6, , lastCargoTime
PUT #6, , TickClosed
PUT #6, , lastShopUpdate
PUT #6, , numOfNames
PUT #6, , cargointheHull()
PUT #6, , cargo()
PUT #6, , cargoResorter()
PUT #6, , cargoToCIty()
PUT #6, , typeOfBoat()
PUT #6, , DynamicRarities()
PUT #6, , eachCityRarity()
PUT #6, , events()
PUT #6, , activeSpecialCargos()
PUT #6, , totalTime
PUT #6, , liveEvents
PUT #6, , activeSpecials
PUT #6, , SpecialRarities
PUT #6, , dlcscount
PUT #6, , a()
PUT #6, , b()
PUT #6, , listPositions()
CLOSE #6
CLOSE #4
SYSTEM

END

SUB drawLEFTArrow
    LINE (50, 300)-(75, 275), , B
    LINE (51, 287)-(72, 277)
    LINE -(72, 298)
    LINE -(51, 287)
    PAINT (65, 285), _RGB(255, 255, 255)
END SUB

SUB drawRIGHTArrow
    LINE (_WIDTH - 800 + 750, 300)-(_WIDTH - 800 + 725, 275), , B
    LINE (_WIDTH - 800 + 749, 287)-(_WIDTH - 800 + 728, 277)
    LINE -(_WIDTH - 800 + 728, 298)
    LINE -(_WIDTH - 800 + 749, 287)
    PAINT (_WIDTH - 800 + 735, 285), _RGB(255, 255, 255)
END SUB

SUB drawLEFTXbox
    LINE (100, _HEIGHT)-(0, _HEIGHT - 100), _RGB(0, 0, 0), BF
    LINE (100, _HEIGHT)-(0, _HEIGHT - 100), _RGB(255, 255, 255), BF
    LINE (70, _HEIGHT - 10)-(90, _HEIGHT - 30), _RGB(255, 0, 0)
    LINE -(30, _HEIGHT - 90), _RGB(255, 0, 0)
    LINE -(10, _HEIGHT - 70), _RGB(255, 0, 0)
    LINE -(70, _HEIGHT - 10), _RGB(255, 0, 0)
    LINE (30, _HEIGHT - 10)-(10, _HEIGHT - 30), _RGB(255, 0, 0)
    LINE -(70, _HEIGHT - 90), _RGB(255, 0, 0)
    LINE -(90, _HEIGHT - 70), _RGB(255, 0, 0)
    LINE -(30, _HEIGHT - 10), _RGB(255, 0, 0)
    PAINT (50, _HEIGHT - 50), _RGB(255, 0, 0)
    PAINT (25, _HEIGHT - 25), _RGB(255, 0, 0)
    PAINT (75, _HEIGHT - 25), _RGB(255, 0, 0)
    PAINT (25, _HEIGHT - 75), _RGB(255, 0, 0)
    PAINT (75, _HEIGHT - 75), _RGB(255, 0, 0)
    _DISPLAY
END SUB

FUNCTION cargocoinvalue (x1, y1, x2, y2)
    a = x1 - x2
    b = y1 - y2
    c2 = a * a + b * b
    c = SQR(c2)
    cargocoinvalue = INT(c * 1.5)
END FUNCTION

FUNCTION equationDoer (a, b, c, d, e, f, g, h, x)
    REM FORMAT of value equation | multiplier = a +((b + cx)^d)/(e(f + gx)^h)
    equationDoer = a + ((b + c * (x ^ d)) / (e * ((f + g * x) ^ h)))
END FUNCTION
