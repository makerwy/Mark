//
//  CardItem.swift
//  DayMark
//
//  Created by wy on 2021/6/3.
//

import SwiftUI

struct CardItem: View {
    
    @EnvironmentObject var cardVM: CardViewModel
    @State var isPresented = false
    
    var index: Int
    @Binding var editMode: Bool
    @Binding var selection: [Int]
    
    
    var dateFormatter: DateFormatter {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       return dateFormatter
    }
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 6)
                .foregroundColor(.blue)
            
            if editMode {
                Button(action: {
                    cardVM.delete(id: index)
                    selection.removeAll()
                }, label: {
                    Image(systemName: "trash")
                        .imageScale(.large)
                        .padding(.leading)
                })
            }
            
            Button(action: {
                if editMode {
                    return
                }
                isPresented.toggle()
            }, label: {
                Group {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(cardVM.cardList[index].title)
                            .font(.headline)
                            .foregroundColor(.black)
                            .fontWeight(.heavy)
                        Text(cardVM.cardList[index].date, formatter: dateFormatter)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading)
                    Spacer()
                }
            })
            .sheet(isPresented: $isPresented, content: {
                EditCardView(title: cardVM.cardList[index].title,
                             date: cardVM.cardList[index].date,
                             id: index)
                    .environmentObject(cardVM)
            })
            
//            if !editMode {
//                Image(systemName: cardVM.cardList[index].isChecked ? "checkmark.square.fill" : "square")
//                    .imageScale(.large)
//                    .padding(.trailing)
//                    .onTapGesture {
//                        cardVM.check(id: index)
//                    }
//            }else {
//                Image(systemName: selection.firstIndex(where: {$0 == index}) != nil ? "checkmark.circle.fill" : "circle")
//                    .imageScale(.large)
//                    .padding(.trailing)
//                    .onTapGesture {
//                        if selection.firstIndex(where: {$0 == index}) == nil {
//                            selection.append(index)
//                        }else {
//                            selection.remove(at: selection.firstIndex(where: {$0 == index})!)
//                        }
//                    }
//            }
            
            if !editMode {
                Image(systemName: cardVM.cardList[index].isFavorited ? "star.fill" : "star" )
                    .imageScale(.large)
                    .foregroundColor(.yellow)
                    .padding(.trailing)
                    .onTapGesture {
                        cardVM.favarite(id: index)
                    }
            }else {
                Image(systemName: selection.firstIndex(where: {$0 == index}) != nil ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
                    .padding(.trailing)
                    .onTapGesture {
                        if selection.firstIndex(where: {$0 == index}) == nil {
                            selection.append(index)
                        }else {
                            selection.remove(at: selection.firstIndex(where: {$0 == index})!)
                        }
                    }
            }
            
        }
        .frame(height: 80)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10, x: 0, y: 10)
    }
}

//struct CardItem_Previews: PreviewProvider {
//    static var previews: some View {
//        let cardVM: CardViewModel = CardViewModel(list: [Card(title: "写作业", date: Date())])
//        CardItem(index: 0).environmentObject(cardVM)
//    }
//}
