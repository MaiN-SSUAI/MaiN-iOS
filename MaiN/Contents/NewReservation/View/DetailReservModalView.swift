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
    
    var body: some View {
        VStack(spacing: 0){
                    HStack(spacing: 5){
                        Spacer().frame(height: 15)
                        Text("세부 정보").font(.normal(size: 15)).foregroundColor(.black)
                        HStack(){
                            Spacer()
                            Button(action: {}){
                                Image(systemName: "xmark").foregroundColor(.black).padding()
                            }
                        }
                    }.background(.white)
                    HStack(){
                        VStack(alignment: .leading) {
                            Text("세미나실1 / \(vm.selectedDetailReservInfo.studentIds[0])").font(.normal(size: 14)).foregroundColor(.black)
                            if vm.selectedDetailReservInfo.studentIds.count > 1 {
                                let remainingIds = vm.selectedDetailReservInfo.studentIds.dropFirst().joined(separator: ", ")
                                Text(remainingIds)
                                    .font(.interRegular(size: 12))
                                    .foregroundColor(.gray02)
                            }
                            Text("시간 : \(vm.selectedDetailReservInfo.time)")
                                .font(.interRegular(size: 12))
                                .foregroundColor(.gray02)
                            Text("사용 목적: \(vm.selectedDetailReservInfo.purpose)")
                                .font(.interRegular(size: 12))
                                .foregroundColor(.gray02)
                        }
                        .padding()
                        .padding(.leading, 18)
                        
                        Spacer()
                        Button(action: {
                            showingAlert = true
                        }) {
                            Text("삭제")
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(Color.red)
                                .cornerRadius(6)
                        }
                        .padding(.trailing, 20)
                        .alert(isPresented: $showingAlert) {
                            Alert(
                                title: Text(""),
                                message: Text("정말로 삭제하겠습니까?"),
                                primaryButton: .destructive(Text("삭제")) {
                                    vm.isDetailModalPresented = false
                                    vm.deleteReservation(reservId: vm.selectedDetailReservInfo.reservId) { result in
                                        vm.alertMessage = result
                                        vm.showAlert = true
                                        vm.trigger.toggle()
                                    }
                                },
                                secondaryButton: .cancel(Text("취소"))
                            )
                        }
                    }.background(.white)
                    Spacer().background(.white)
                }.background(.white)
    }
}
