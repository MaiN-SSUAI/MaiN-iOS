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
                        ZStack(alignment: .top) {
                            TimeView()
                            DayReservationView(vm: vm)
                                .padding(.leading, 58)
                        }
                        .padding(.horizontal, 14)
                        .padding(.top, 15)
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
    private let timeArray: [String] = (0...23).map {
        let hour = $0 % 12
        let period = $0 < 12 ? "오전" : "오후"
        return String(format: "%@ %d시", period, hour == 0 ? 12 : hour)
    }

    var body: some View {
        ZStack(alignment: .top) {
            ForEach(Array(timeArray.enumerated()), id: \.element) { index, time in
                HStack(spacing: 8) {
                    Text(time)
                        .font(.interRegular(size: 12))
                        .foregroundColor(.gray01)
                        .frame(width: 50)
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundColor(.gray05)
                }
                .padding(.top, CGFloat(36 * index))
            }
        }
    }
}

struct DayReservationView: View {
    @ObservedObject var vm: ReservationViewModel
    let colorSet: [ButtonColor] = [.green, .orange, .red, .purple, .blue]
    var body: some View {
        ZStack(alignment: .top) {
            ForEach(Array(vm.reservations.enumerated()), id: \.element) { index, reservation in
                DayReservationButton(
                    vm: vm,
                    reservation: reservation,
                    color: colorSet[index % colorSet.count]
                )
            }
        }
    }
}

#Preview() {
//    TimeView()
    BottomReservationView(vm: ReservationViewModel())
}
