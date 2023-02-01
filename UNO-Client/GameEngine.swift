////  GameEngine.swift//  UNO-Experience////  Created by Paul Cornelissen on 21.01.23.////Benjamin wenn du das liest, ruf mich mal animport Foundationimport MultipeerConnectivityimport osclass GameEngine: ObservableObject {    //Variable für Zugriff auf den Session-Vermittler    private var sessionHandler: MP_Session    //Spielstatus    @Published var gameState: GameStates = .noGame    //Logger für Konsole    let log = Logger()    //Initializer    init(sessionHandler: MP_Session) {        self.sessionHandler = sessionHandler    }    //Der gesamte Datenverkehr läuft über diese Funktion    func trafficHandler(data: Data) {        //Logging        log.info("Datenpaket: \(String(data: data, encoding: .isoLatin1)!) empfangen.")        //Enkodierung zu String und Auswahl Vorgang        switch String(data: data, encoding: .isoLatin1) {        case GameTraffic.startGame.rawValue:            startGame()        case GameTraffic.stopGame.rawValue:            cancelGame()        case GameTraffic.win.rawValue:            looseHandler()        case GameTraffic.skip.rawValue:            skipHandler()                //Wenn eine Spielaktion empfangen wird        case .some(_):            gameActionHandler(data: data)                //Wenn Paket nicht identifiziert werden kann        case .none:            log.info("Nicht identifizierbares Datenpacket empfangen")        }    }    //Verarbeitung der Spielzüge    func gameActionHandler(data: Data) {        switch String(data: data, encoding: .isoLatin1) {        case Cards.RED_ZERO.rawValue:            changeCard(card: Cards.RED_ZERO)        case Cards.RED_ONE.rawValue:            changeCard(card: Cards.RED_ONE)        case Cards.RED_TWO.rawValue:            changeCard(card: Cards.RED_TWO)        case Cards.RED_THREE.rawValue:            changeCard(card: Cards.RED_THREE)        case Cards.RED_FOUR.rawValue:            changeCard(card: Cards.RED_FOUR)        case Cards.RED_FIVE.rawValue:            changeCard(card: Cards.RED_FIVE)        case Cards.RED_SIX.rawValue:            changeCard(card: Cards.RED_SIX)        case Cards.RED_SEVEN.rawValue:            changeCard(card: Cards.RED_SEVEN)        case Cards.RED_EIGHT.rawValue:            changeCard(card: Cards.RED_EIGHT)        case Cards.RED_NINE.rawValue:            changeCard(card: Cards.RED_NINE)        case Cards.BLUE_ZERO.rawValue:            changeCard(card: Cards.BLUE_ZERO)        case Cards.BLUE_ONE.rawValue:            changeCard(card: Cards.BLUE_ONE)        case Cards.BLUE_TWO.rawValue:            changeCard(card: Cards.BLUE_TWO)        case Cards.BLUE_THREE.rawValue:            changeCard(card: Cards.BLUE_THREE)        case Cards.BLUE_FOUR.rawValue:            changeCard(card: Cards.BLUE_FOUR)        case Cards.BLUE_FIVE.rawValue:            changeCard(card: Cards.BLUE_FIVE)        case Cards.BLUE_SIX.rawValue:            changeCard(card: Cards.BLUE_SIX)        case Cards.BLUE_SEVEN.rawValue:            changeCard(card: Cards.BLUE_SEVEN)        case Cards.BLUE_EIGHT.rawValue:            changeCard(card: Cards.BLUE_EIGHT)        case Cards.BLUE_NINE.rawValue:            changeCard(card: Cards.BLUE_NINE)        case Cards.YELLOW_ZERO.rawValue:            changeCard(card: Cards.YELLOW_ZERO)        case Cards.YELLOW_ONE.rawValue:            changeCard(card: Cards.YELLOW_ONE)        case Cards.YELLOW_TWO.rawValue:            changeCard(card: Cards.YELLOW_TWO)        case Cards.YELLOW_THREE.rawValue:            changeCard(card: Cards.YELLOW_THREE)        case Cards.YELLOW_FOUR.rawValue:            changeCard(card: Cards.YELLOW_FOUR)        case Cards.YELLOW_FIVE.rawValue:            changeCard(card: Cards.YELLOW_FIVE)        case Cards.YELLOW_SIX.rawValue:            changeCard(card: Cards.YELLOW_SIX)        case Cards.YELLOW_SEVEN.rawValue:            changeCard(card: Cards.YELLOW_SEVEN)        case Cards.YELLOW_EIGHT.rawValue:            changeCard(card: Cards.YELLOW_EIGHT)        case Cards.YELLOW_NINE.rawValue:            changeCard(card: Cards.YELLOW_NINE)        case Cards.GREEN_ZERO.rawValue:            changeCard(card: Cards.GREEN_ZERO)        case Cards.GREEN_ONE.rawValue:            changeCard(card: Cards.GREEN_ONE)        case Cards.GREEN_TWO.rawValue:            changeCard(card: Cards.GREEN_TWO)        case Cards.GREEN_THREE.rawValue:            changeCard(card: Cards.GREEN_THREE)        case Cards.GREEN_FOUR.rawValue:            changeCard(card: Cards.GREEN_FOUR)        case Cards.GREEN_FIVE.rawValue:            changeCard(card: Cards.GREEN_FIVE)        case Cards.GREEN_SIX.rawValue:            changeCard(card: Cards.GREEN_SIX)        case Cards.GREEN_SEVEN.rawValue:            changeCard(card: Cards.GREEN_SEVEN)        case Cards.GREEN_EIGHT.rawValue:            changeCard(card: Cards.GREEN_EIGHT)        case Cards.GREEN_NINE.rawValue:            changeCard(card: Cards.GREEN_NINE)        case Cards.CHOOSE.rawValue:            changeCard(card: Cards.CHOOSE)        case Cards.Y_CHOOSE.rawValue:            changeCard(card: Cards.Y_CHOOSE)        case Cards.G_CHOOSE.rawValue:            changeCard(card: Cards.G_CHOOSE)        case Cards.B_CHOOSE.rawValue:            changeCard(card: Cards.B_CHOOSE)        case Cards.R_CHOOSE.rawValue:            changeCard(card: Cards.R_CHOOSE)        case .none:            log.error("Keine Daten!")        case .some(_):            log.error("Irgendwelche Daten nicht zuordnebar!")        }    }    //Wechseln der Anzeigemodi auf den Endgeräten    func changeViewState(viewState: ViewStates) {        sessionHandler.viewState = viewState    }    func startGame() {        DispatchQueue.main.async {            self.sessionHandler.viewState = .inGame        }    }    func startGameEverywhere() {        log.info("Der Host hat das Spiel gestartet!")        DispatchQueue.main.async {            self.sessionHandler.viewState = .inGame        }        sessionHandler.sendTraffic(data: GameTraffic.startGame.rawValue.data(using: .isoLatin1)!)    }    //TO-DO Spielabbruch bei Verbindungsverlust    func cancelGame() {        log.info("Das Spiel wurde abgebrochen!")        DispatchQueue.main.async {            self.sessionHandler.viewState = .mainMenu        }    }    func changeCard(card: Cards) {        log.info("Die Karte wurde auf \(card.description) geändert!")        DispatchQueue.main.async {            self.sessionHandler.activeCard = card            self.sessionHandler.hasPlayed = false        }    }    func winHandler() {        log.info("Gewonnen")        sessionHandler.sendTraffic(data: GameTraffic.win.rawValue.data(using: .isoLatin1)!)        DispatchQueue.main.async {            self.sessionHandler.viewState = .win        }    }    func looseHandler() {        log.info("Der Gegenspieler hat gewonnen.")        DispatchQueue.main.async {            self.sessionHandler.viewState = .loose        }    }    func skipHandler() {        log.info("Gegenspieler hat ausgesetzt. Fahre mit Zug fort!")        DispatchQueue.main.async {            self.sessionHandler.hasPlayed = false        }    }}