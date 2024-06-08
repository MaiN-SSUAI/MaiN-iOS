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
        if vm.dayOrWeek == "day" {
            if vm.isLoading {
                DefaultLoadingView()
            } else {
                ZStack() {
                    ScrollView() {
                        HStack(spacing: 0) {
                            TimeView().padding(.top, 5).padding(.trailing, 7)
                            DayReservationView(vm: vm)
                        }
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                vm.isRegisterModalPresented = true
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(.blue04)
                                        .frame(width: 60, height: 60)
                                        .shadow(color: .gray, radius: 3, x: 1, y: 1)
                                    Text("+")
                                        .font(.bold(size: 40))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.bottom, 25).padding(.trailing, 15)
                        }
                    }
                }
            }
        } else {
            Rectangle().foregroundColor(.blue)
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
