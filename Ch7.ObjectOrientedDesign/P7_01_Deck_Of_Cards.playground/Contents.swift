import UIKit

//  Deck of Cards: Design the data structures for a generic deck of cards. Explain how you would subclass the data structures to implement blackjack.
enum Suit: Int {
    case club = 0, diamond, heart, spade
}

class Card {
    
    private var available = true
    
    var faceValue: Int
    var suit: Suit
    
    init(faceValue: Int, suit: Suit) {
        self.faceValue = faceValue
        self.suit = suit
    }
    
    func markUnavailable() {
        available = false
    }
    
    func printCard() {
        var result = ""
        let facesValues = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
        result += facesValues[faceValue - 1]
        switch suit {
        case .club:
            result += "c"
        case .heart:
            result += "h"
        case .diamond:
            result += "d"
        case .spade:
            result += "s"
        }
        print("\(result)")
    }
}


class BlackJackCard: Card {
    
    func isAce() -> Bool {
        return faceValue == 1
    }
    
    var value: Int {
        if isAce() {
            return 1
        } else if faceValue >= 11 {
            return 10
        } else {
            return faceValue
        }
    }
    
    func minValue() -> Int {
        if isAce() {
            return 1
        } else {
            return value
        }
    }
    
    func maxValue() -> Int {
        if isAce() {
            return 11
        } else {
            return value
        }
    }
    
    func isFaceCard() -> Bool {
        return faceValue >= 10
    }
    
}

class Deck<T>: Card {
    var cards = [T]()
    private var dealtIndex = 0
    
    init() {
        super.init(faceValue: 1, suit: .club)
    }
    
    func setDeckOfCards(deckOfCards: [T]) {
        cards = deckOfCards
    }
    
    func shuffle() {
        for i in 0 ..< cards.count {
            let random = Int(arc4random_uniform((UInt32(cards.count - 1))))
            (cards[i], cards[random]) = (cards[random], cards[i])
        }
    }
    
    func remainingCards() -> Int {
        return cards.count - dealtIndex
    }
    
    func dealCard() -> T? {
        if remainingCards() == 0 {
            return nil
        }
        let card = cards[dealtIndex]
        (card as! Card).markUnavailable()
        dealtIndex += 1
        return card
    }
    
}

class Hand<T>: Card {
    var cards = [T]()
    
    func score() -> Int {
        var score = 0
        for card in cards {
            score += (card as! Card).faceValue
        }
        return score
    }
    
    func addCard(card: T) {
        cards.append(card)
    }
    
    func printHand() {
        for card in cards {
            (card as! Card).printCard() // CHECK, THIS SEEMS WEIRD.
        }
    }
    
}

class BlackJackHand: Hand<BlackJackCard> {
    
    init() {
        super.init(faceValue: 1, suit: .heart) // CHECK THIS
    }
    
    private func addCardToScoreList(card: BlackJackCard, scores: inout [Int]) {
        if scores.count == 0 {
            scores.append(0)
        }
        let length = scores.count
        for i in 0 ..< length {
            let score = scores[i]
            scores[i] = score + card.minValue()
            if card.minValue() != card.maxValue() {
                scores.append(score + card.maxValue())
            }
        }
    }
    
    private func possibleScores() -> [Int] {
        var scores = [Int]()
        if cards.count == 0 {
            return scores
        }
        for card in cards {
            addCardToScoreList(card: card, scores: &scores)
        }
        return scores
    }
    
    override func score() -> Int {
        let scores = possibleScores()
        var maxUnder = Int.min
        var minOver = Int.max
        for score in scores {
            if score > 21 && score < minOver {
                minOver = score
            } else if score <= 21 && score > maxUnder {
                maxUnder = score
            }
        }
        
        return maxUnder == Int.min ? minOver : maxUnder
    }
    
    func busted() -> Bool {
        return score() > 21
    }
    
    
    func isBlackJack() -> Bool {
        if cards.count != 2 { return false }
        let first = cards[0]
        let second = cards[1]
        return (first.isAce() && second.isFaceCard()) || (first.isFaceCard() && second.isAce())
    }
    
}

class BlacKJackGameAutomator {
    private let deck = Deck<BlackJackCard>()
    private var hands = [BlackJackHand]()
    private let hitUntil = 16
    
    init(numPlayers: Int) {
        for _ in 0 ..< numPlayers {
            hands.append(BlackJackHand())
        }
    }
    
    func dealInitial() -> Bool {
        for hand in hands {
            let card1 = deck.dealCard()
            let card2 = deck.dealCard()
            if card1 == nil || card2 == nil { return false }
            hand.addCard(card: card1!)
            hand.addCard(card: card2!)
        }
        return true
    }
    
    func getBlackJacks() -> [Int] {
        var winners = [Int]()
        for i in 0 ..< hands.count {
            if hands[i].isBlackJack() {
                winners.append(i)
            }
        }
        return winners
    }
    
    func playHand(hand: BlackJackHand) -> Bool {
        while hand.score() < hitUntil {
            let card = deck.dealCard()
            if card == nil { return false }
            hand.addCard(card: card!)
        }
        return true
    }
    
    func playAllHands() -> Bool {
        for hand in hands {
            if !playHand(hand: hand) {
                return false
            }
        }
        return true
    }
    
    func getWinners() -> [Int] {
        var winners = [Int]()
        var winningScore = 0
        for i in 0 ..< hands.count {
            let hand = hands[i]
            if !hand.busted() {
                if hand.score() > winningScore {
                    winningScore = hand.score()
                    winners = []
                    winners.append(i)
                } else if hand.score() == winningScore {
                    winners.append(i)
                }
            }
        }
        return winners
    }
    
    func initializeDeck() {
        var cards = [BlackJackCard]()
        for i in 1 ... 13 {
            for j in 0 ... 3 {
                let suit = Suit(rawValue: j)
                let card = BlackJackCard(faceValue: i, suit: suit!)
                cards.append(card)
            }
        }
        
        deck.setDeckOfCards(deckOfCards: cards)
        deck.shuffle()
    }
    
    func printHandsAndScore() {
        for i in 0 ..< hands.count {
            print("Hand \(i + 1): Total Score: \(hands[i].score()) ")
            hands[i].printHand()
            print("")
        }
    }
    
}

class StartGame {
    
    func startGame() {
        let numberOfPlayers = 6
        let automator = BlacKJackGameAutomator(numPlayers: numberOfPlayers)
        automator.initializeDeck()
        var success = automator.dealInitial()
        if !success {
            print("Not enough cards to deal!")
        } else {
            print("--- Initial ---")
            automator.printHandsAndScore()
            let blackjacks = automator.getBlackJacks()
            if blackjacks.count > 0 {
                print("Blackjack for hands: ")
                for i in blackjacks {
                    print("Hand: \(i + 1)")
                }
                print("")
            } else {
                success = automator.playAllHands()
                if !success {
                    print("Out of cards!")
                } else {
                    print("\n -- Completed Game --")
                    automator.printHandsAndScore()
                    let winners = automator.getWinners()
                    if winners.count > 0 {
                        print("Winners are: ")
                        for i in winners {
                            print("Hand \(i + 1) ")
                        }
                        print("")
                    } else {
                        print("Draw. All players have busted")
                    }
                }
            }
        }
    }
    
}

let game = StartGame()
game.startGame()



































