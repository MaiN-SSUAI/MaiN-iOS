//
//  NoReservationWeekView.swift
//  MaiN
//
//  Created by 김수민 on 6/22/24.
//

import SwiftUI

struct NoReservationWeekView: View {
    @ObservedObject var vm: ReservationViewModel
    let studentId: String = TokenManager.shared.studentId ?? ""
    
    var body: some View {
        ZStack() {
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
    NoReservationWeekView(vm: ReservationViewModel())
}
