//
//  DetailReservModalView.swift
//  MaiN
//
//  Created by 김수민 on 6/11/24.
//

import SwiftUI

struct DetailReservModalView: View {
    @ObservedObject var vm: ReservationViewModel
    @State private var showingAlert = false
    let userId: String = UserDefaults.standard.string(forKey: "studentNumber") ?? "0"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                // MARK: 제목
                HStack() {
                    Text("세미나실 2").font(.interRegular(size: 20))
                    Text("예약 정보").font(.interRegular(size: 20))
                }
                .padding(.leading, 25)
                .padding(.top, 30)
                
                Divider()
                    .padding(.horizontal, 25)
                    .padding(.vertical, 20)
                // MARK: 시간
                HStack() {
                    Text("시작 시간")
                        .font(.interRegular(size: 14))
                        .foregroundColor(.black)
                    Spacer()
                    Text("\(vm.selectedDetailReservInfo.startTime)")
                        .font(.interRegular(size: 14))
                        .foregroundColor(.blue04)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 8)
                HStack() {
                    Text("종료 시간")
                        .font(.interRegular(size: 14))
                        .foregroundColor(.black)
                    Spacer()
                    Text("\(vm.selectedDetailReservInfo.endTime)")
                        .font(.interRegular(size: 14))
                        .foregroundColor(.blue04)
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 8)
                
                // MARK: 사용목적
                HStack() {
                    Text("사용 목적")
                        .font(.interRegular(size: 14))
                        .foregroundColor(.black)
                    Spacer()
                    Text("\(vm.selectedDetailReservInfo.purpose)")
                        .font(.interRegular(size: 14))
                        .foregroundColor(.blue04)
                }
                .padding(.horizontal, 25)
                .padding(.top, 8)
                
                Divider()
                    .padding(.horizontal, 25)
                    .padding(.vertical, 15)
                
                // MARK: 이용자
                VStack(spacing: 0) {
                    HStack() {
                        Text("이용자")
                            .font(.interRegular(size: 14))
                            .padding(.leading, 25)
                            .padding(.bottom, 15)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    
                    ScrollView(.horizontal) {
                        HStack() {
                            ForEach(Array(vm.selectedDetailReservInfo.studentIds.enumerated()), id: \.element) { index, studentId in
                                Text("\(studentId)").font(.interRegular(size: 14))
                                    .frame(width: 90, height: 30)
                                    .background(.blue04)
                                    .foregroundColor(.white)
                                    .cornerRadius(30)
                                    .padding(3)
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 5)
                }
                
                // MARK: 삭제
                HStack() {
                    Spacer()
                    if vm.selectedDetailReservInfo.studentIds.contains(userId) {
                        Button(action: {
                            showingAlert = true
                        }) {
                            HStack(spacing: 10) {
                                Image("ic_trash").resizable().frame(width: 24, height: 24)
                                
                                Text("삭제")
                                    .font(.system(size: 15))
                                    .foregroundColor(.red01)
                            }
                            .padding(.leading, 15)
                            .padding(.trailing, 25)
                            .padding(.vertical, 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.red01, lineWidth: 2)
                            )
                        }
                        .padding(.trailing, 20)
                        .alert(isPresented: $showingAlert) {
                            Alert(
                                title: Text(""),
                                message: Text("예약을 삭제하시겠습니까?"),
                                primaryButton: .destructive(Text("삭제")) {
                                    vm.isLoading = true
                                    vm.isWeekLoading = true
                                    vm.isDetailModalPresented = false
                                    vm.deleteReservation(reservId: vm.selectedDetailReservInfo.reservId) { result in
                                        if !(result == "토큰 만료"){
                                            vm.trigger.toggle()
                                            vm.alertMessage = result
                                            vm.showAlert = true
                                        }
                                    }
                                },
                                secondaryButton: .cancel(Text("취소"))
                            )
                        }
                    }
                }
            }
            .background(Color.white)
            Spacer()
                .background(Color.white)
        }
    }
}

