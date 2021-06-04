//
//  Mark.swift
//  DayMark
//
//  Created by wy on 2021/6/3.
//

import Foundation
import UserNotifications

let encoder = JSONEncoder()
let decoder = JSONDecoder()

func readDataStore() -> [Card] {
    var outPut: [Card] = []
    if let dataStored = UserDefaults.standard.value(forKey: "CardList") as? Data {
        let data = try! decoder.decode([Card].self, from: dataStored)
        for item in data {
            if !item.isDeleted {
                outPut.append(Card(id: outPut.count, title: item.title, date: item.date, isChecked: item.isChecked, isDeleted: item.isDeleted, isFavorited: item.isFavorited))
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
    var isFavorited = false
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
            cardList.append(Card(id: count, title: item.title, date: item.date, isChecked: item.isChecked, isFavorited: item.isFavorited))
            count += 1
        }
    }
    
    func check(id: Int) {
        cardList[id].isChecked.toggle()
        dataStore()
    }
    
    func favarite(id: Int) {
        cardList[id].isFavorited.toggle()
        dataStore()
    }
    
    func add(card: Card) {
        cardList.append(Card(id: count, title: card.title, date: card.date, isChecked: card.isChecked, isFavorited: card.isFavorited))
        count += 1
        self.sendNotification(id: count - 1)
        sort()
        dataStore()
    }
    
    func edit(id: Int, card: Card) {
        destroyNotification(id: id)
        cardList[id].title = card.title
        cardList[id].date = card.date
        cardList[id].isChecked = false
        cardList[id].isFavorited = card.isFavorited
        sort()
        dataStore()
        self.sendNotification(id: id)
    }
    
    func delete(id: Int) {
        destroyNotification(id: id)
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
    
    func sendNotification(id: Int) {
        if cardList[id].date.timeIntervalSinceNow < 0 {
            return
        }
        let content = UNMutableNotificationContent()
        content.title = cardList[id].title
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: cardList[id].date.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: cardList[id].title + cardList[id].date.description, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            print(error)
        }
    }
    
    func destroyNotification(id: Int) {
        let identifiers = [cardList[id].title + cardList[id].date.description]
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
}
