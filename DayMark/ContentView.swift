//
//  ContentView.swift
//  DayMark
//
//  Created by wy on 2021/6/3.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var cardVM: CardViewModel = CardViewModel(list: readDataStore())
    @State var isPresented = false
    @State var editMode: Bool = false
    @State var selection: [Int] = []
 
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(cardVM.cardList) { item in
                        if !item.isDeleted {
                            CardItem(index: item.id, editMode: $editMode, selection: $selection)
                                .environmentObject(cardVM)
                                .padding()
                                .animation(.spring())
                                .transition(.slide)
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                            .foregroundColor(.blue)
                    })
                    .sheet(isPresented: $isPresented, content: {
                        EditCardView().environmentObject(cardVM)
                    })
                    .padding(.trailing)
                }
            }
            .navigationTitle("提醒事项")
            .navigationBarItems(trailing: EditButton(editMode: $editMode))
        }
    }
}

struct EditButton: View {
    @Binding var editMode: Bool
    
    var body: some View {
        Button(action: {
            editMode.toggle()
        }, label: {
            Image(systemName: "gear")
                .imageScale(.large)
        })
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().previewDevice("iPhone 11")
//    }
//}
