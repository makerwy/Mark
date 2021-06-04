//
//  Mark.swift
//  DayMark
//
//  Created by wy on 2021/6/3.
//

import Foundation

let encoder = JSONEncoder()
let decoder = JSONDecoder()

func readDataStore() -> [Card] {
    var outPut: [Card] = []
    if let dataStored = UserDefaults.standard.value(forKey: "CardList") as? Data {
        let data = try! decoder.decode([Card].self, from: dataStored)
        for item in data {
            if !item.isDeleted {
                outPut.append(Card(id: outPut.count, title: item.title, date: item.date, isChecked: item.isChecked, isDeleted: item.isDeleted))
            }
        }
    }
    return outPut
}

struct Card: Identifiable, Codable {
    var id: Int = 0
    var title: String = ""
    var date: Date = Date()
    var isChecked: Bool = false
    
    var isDeleted = false
}

class CardViewModel: ObservableObject {
    @Published var cardList: [Card]
    var count = 0
    
    init() {
        cardList = []
    }
    init(list: [Card]) {
        cardList = []
        for item in list {
            cardList.append(Card(id: count, title: item.title, date: item.date, isChecked: item.isChecked))
            count += 1
        }
    }
    
    func check(id: Int) {
        cardList[id].isChecked.toggle()
        dataStore()
    }
    
    func add(card: Card) {
        cardList.append(Card(id: count, title: card.title, date: card.date, isChecked: card.isChecked))
        count += 1
        sort()
        dataStore()
    }
    
    func edit(id: Int, card: Card) {
        cardList[id].title = card.title
        cardList[id].date = card.date
        cardList[id].isChecked = false
        sort()
        dataStore()
    }
    
    func delete(id: Int) {
        cardList[id].isDeleted = true
        dataStore()
    }
    
    func sort() {
        cardList.sort(by: {$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970})
        for index in 0..<cardList.count {
            cardList[index].id = index
        }
    }
    
    func dataStore() {
        let dataStored = try! encoder.encode(cardList)
        UserDefaults.standard.setValue(dataStored, forKey: "CardList")
    }
    
}
