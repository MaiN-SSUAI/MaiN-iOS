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
        VStack(spacing: 0) {
            HStack(spacing: 5) {
                Spacer().frame(height: 15)
                Text("세부 정보")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                HStack(){
                    Spacer()
                    Button(action: {vm.isDetailModalPresented = false}){
                        Image(systemName: "xmark").foregroundColor(.black).padding()
                    }
                }
            }
            .background(Color.white)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("세미나실2 / \(vm.selectedDetailReservInfo.studentIds[0])")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    
                    if vm.selectedDetailReservInfo.studentIds.count > 1 {
                        let remainingIds = vm.selectedDetailReservInfo.studentIds.dropFirst().joined(separator: ", ")
                        Text("동반 이용자 : \(remainingIds)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Text("시간 : \(vm.selectedDetailReservInfo.time)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(.leading, 18)
                .padding(.vertical)
                
                Spacer()
                
                if vm.selectedDetailReservInfo.studentIds.contains(userId) {
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
                                    vm.trigger.toggle()
                                    vm.alertMessage = result
                                    vm.showAlert = true
                                }
                            },
                            secondaryButton: .cancel(Text("취소"))
                        )
                    }
                }
            }
            .background(Color.white)
            
            Spacer()
                .background(Color.white)
        }
        .background(Color.white)
    }
}

