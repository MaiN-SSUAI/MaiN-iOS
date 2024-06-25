//
//  NoReservationView.swift
//  MaiN
//
//  Created by 김수민 on 6/22/24.
//

import SwiftUI

struct NoReservationDayView: View {
    @ObservedObject var vm: ReservationViewModel
    let studentId: String = TokenManager.shared.studentId ?? ""
    var body: some View {
        ZStack() {
            ScrollView() {
                HStack(spacing: 8) {
                    TimeView()
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
                }
                .padding(.horizontal, 14)
                .padding(.top, 15)
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
    }
}

#Preview {
    NoReservationDayView(vm: ReservationViewModel())
}
