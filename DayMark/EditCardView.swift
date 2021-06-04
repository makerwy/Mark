//
//  EditCardView.swift
//  DayMark
//
//  Created by wy on 2021/6/3.
//

import SwiftUI

struct EditCardView: View {
    
    @EnvironmentObject var cardVM: CardViewModel
    @State var title: String = ""
    @State var date: Date = Date()
    @Environment(\.presentationMode) var presentationMode
    
    var id: Int?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("事项")) {
                    TextField("事项内容", text: $title)
                    DatePicker(selection: $date) {
                        Text("截止时间")
                    }
                }
                Section {
                    Button(action: {
                        if id == nil {
                            cardVM.add(card: Card(title: title, date: date))
                        }else {
                            cardVM.edit(id: id!, card: Card(title: title, date: date))
                        }
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("确认")
                    })
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("取消")
                    })
                }
            }
            .navigationTitle(id == nil ? "添加" : "编辑")
        }
    }
}

//struct EditCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditCardView().previewDevice("iPhone 11")
//    }
//}
