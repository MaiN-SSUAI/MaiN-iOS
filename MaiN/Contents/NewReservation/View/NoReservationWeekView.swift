//
//  NoReservationWeekView.swift
//  MaiN
//
//  Created by 김수민 on 6/22/24.
//

import SwiftUI

struct NoReservationWeekView: View {
    @ObservedObject var vm: ReservationViewModel
    
    var body: some View {
        ScrollView() {
            ZStack(alignment: .leading) {
                TimeNumberView().padding(.leading, 10)
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(maxWidth: 1, maxHeight: .infinity)
                        .foregroundColor(.gray05)
                    ForEach(0..<7, id: \.self) { index in
                        ZStack(alignment: .top) {
                            //MARK: 시간 그리드
                            ZStack(alignment: .top) {
                                ForEach(0..<24, id: \.self) { index in
                                        Rectangle()
                                            .frame(maxWidth: .infinity, maxHeight: 1)
                                            .foregroundColor(.gray05)
                                    .padding(.top, CGFloat(36 * index))
                                }
                            }
                        }
                        Rectangle()
                            .frame(maxWidth: 1, maxHeight: .infinity)
                            .foregroundColor(.gray05)
                    }
                }
                .padding(.leading, 28)
                .padding(.trailing, 20)
            }.padding(.top, 10)
        }
    }
}

#Preview {
    NoReservationWeekView(vm: ReservationViewModel())
}
