//
//  BottomReservationView.swift
//  MaiN
//
//  Created by 김수민 on 5/20/24.
//

import SwiftUI

struct BottomReservationView: View {
    @ObservedObject var vm: ReservationViewModel

    var body: some View {
        if vm.isLoading {
            DefaultLoadingView()
        } else {
            ScrollView() {
                HStack(spacing: 0) {
                    TimeView().padding(.top, 5).padding(.trailing, 7)
                    DayReservationView(vm: vm)
                }
            }
        }
    }
}

struct TimeView: View {
    private let timeArray: [String] = (0...23).map { String(format: "%02d:00", $0) }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(timeArray, id: \.self) { time in
                Text(time)
                    .font(.normal(size: 10))
                    .foregroundColor(.gray01)
                    .padding(.bottom, 23)
            }
        }.frame(width: 30)
    }
}
