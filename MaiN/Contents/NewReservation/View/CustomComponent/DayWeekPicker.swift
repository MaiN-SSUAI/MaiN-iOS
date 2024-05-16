//
//  DayWeekPicker.swift
//  MaiN
//
//  Created by 김수민 on 5/16/24.
//

import SwiftUI

struct DayWeekPicker: View {
    let items = ["day", "week"]
    @State private var selectedItem = "day"
    
    var body: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                Button(action: {
                    self.selectedItem = item
                }) {
                    Text(item)
                        .font(Font.custom(selectedItem == item ? "Lato-SemiBold" : "Lato-Regular", size: 15))
                        .foregroundColor(selectedItem == item ? .black : .gray04)
                        .padding(.horizontal,   11).padding(.vertical, 4)
                        .background(selectedItem == item ? .white : .EFEFEF)
                        .cornerRadius(5)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 2)
        .background(.EFEFEF)
        .cornerRadius(5)
        .padding()
    }
}

#Preview {
    DayWeekPicker()
}
