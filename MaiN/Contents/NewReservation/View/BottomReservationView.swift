//
//  BottomReservationView.swift
//  MaiN
//
//  Created by 김수민 on 5/20/24.
//

import SwiftUI

struct BottomReservationView: View {
    @ObservedObject var vm: ReservationViewModel
    let studentId: String = TokenManager.shared.studentId ?? ""
    var body: some View {
        if vm.dayOrWeek == "day" {
            if vm.isWeekLoading || vm.isLoading {
                DefaultLoadingView()
            } else {
                if !vm.reservations.isEmpty {
                    ZStack() {
                        ScrollView() {
                            HStack(alignment: .top, spacing: 8) {
                                TimeView()
                                DayReservationView(vm: vm)
                                    .padding(.top, 5)
                            }
                            .padding(.horizontal, 14)
                            .padding(.top, 15)
                            .padding(.bottom, 30)
                        }
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    vm.checkUser(user: studentId, date: vm.selectedDate.toDateString()) { result in
                                        if result == "성공" {
                                            vm.isRegisterModalPresented = true
                                        } else {
                                            if !(result == "토큰 만료"){
                                                vm.alertMessage = result
                                                vm.showAlert = true
                                            }
                                        }
                                    }
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
                } else {
                    NoReservationDayView(vm: vm)
                }
            }
        } else {
            if vm.isWeekLoading {
                DefaultLoadingView()
            } else {
                if !(vm.weekReservations.allSatisfy { $0.isEmpty }) {
                    ScrollView() {
                        ZStack(alignment: .topLeading) {
                            TimeNumberView().padding(.leading, 10)
                            HStack(alignment: .top, spacing: 0) {
                                Rectangle()
                                    .frame(maxWidth: 1, maxHeight: .infinity)
                                    .foregroundColor(.gray05)
                                ForEach(0..<7, id: \.self) { index in
                                    WeekReservationView(vm: vm, index: index)
                                    Rectangle()
                                        .frame(maxWidth: 1, maxHeight: .infinity)
                                        .foregroundColor(.gray05)
                                }
                            }
                            .padding(.leading, 28)
                            .padding(.trailing, 20)
                            .padding(.top, 5)
                        }
                    }.padding(.bottom, 30)
                } else {
                    NoReservationWeekView(vm: vm)
                }
            }
        }
    }
}

struct TimeNumberView: View {
    private let timeArray: [Int] = Array(0..<24)

    var body: some View {
        ZStack(alignment: .top) {
            ForEach(Array(timeArray.enumerated()), id: \.element) { index, time in
                Text("\(time)")
                    .font(.interRegular(size: 12))
                    .foregroundColor(.gray01)
                    .frame(width: 14)
                    .padding(.top, CGFloat(36 * index))
                    .padding(.trailing, 4)
            }
        }
    }
}

struct DayReservationView: View {
    @ObservedObject var vm: ReservationViewModel
    let colorSet: [ButtonColor] = [.green, .orange, .red, .purple, .blue]
    
    var body: some View {
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
            
            //MARK: 예약 버튼들
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
}

struct WeekReservationView: View {
    @ObservedObject var vm: ReservationViewModel
    let index: Int
    
    let colorSet: [ButtonColor] = [.green, .orange, .red, .purple, .blue]
    init(vm: ReservationViewModel, index: Int) {
        self.vm = vm
        self.index = index
    }
    var body: some View {
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
            
            //MARK: 예약 버튼들
            ZStack(alignment: .top) {
                ForEach(Array(vm.weekReservations[index].enumerated()), id: \.element) { index, reservation in
                    let selectedIndex = (self.convertIsoDateTimeToHour(isoDateTime: reservation.start) ?? 0 + (self.convertIsoDateTimeToHour(isoDateTime: reservation.end) ?? 0)) % colorSet.count
                    DayReservationButton(
                        vm: vm,
                        reservation: reservation,
                        color: colorSet[selectedIndex]
                    )
                }
            }
        }
    }
    
    func convertIsoDateTimeToHour(isoDateTime: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = formatter.date(from: isoDateTime) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            return hour
        } else {
            print("ddddd")
            return nil
        }
    }
}
