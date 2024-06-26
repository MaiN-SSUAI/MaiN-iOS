//
//  RegisterModalView.swift
//  MaiN
//
//  Created by 김수민 on 6/8/24.
//

import SwiftUI

struct RegisterModalView: View {
    let purposes: [String] = ["학습", "회의", "수업"]
    
    //MARK: ViewModel
    @ObservedObject var vm: ReservationViewModel
    
    //MARK: Data
    @State var startTime: Date
    @State private var endTime: Date
    @State var studentId: String = ""
    @State var studentIds: [String] = [UserDefaults.standard.string(forKey: "studentNumber") ?? ""]
    @State var selectedPurpose: String = "학습"
    
    //MARK: View
    @State private var isAlertPresented = false
    
    init(vm: ReservationViewModel, startTime: Date, endTime: Date) {
        self.vm = vm
        self._startTime = State(initialValue: startTime)
        self._endTime = State(initialValue: endTime)
    }

    var body: some View {
        VStack(spacing: 5) {
            HStack() {
                Spacer()
                Text("등록하기").font(.interSemiBold(size: 15)).padding(15)
                Spacer()
            }.background(.white)
            
            ScrollView {
                VStack(spacing: 5) {
                    HStack() {
                        Text("시작 시간")
                            .font(.interRegular(size: 14))
                            .padding(.leading, 25).padding(.vertical, 15)
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(vm.selectedDate.toDateString())").font(.interRegular(size: 14)).padding(.trailing, 10)
                        DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .padding(.trailing, 15)
                    }.background(.white)
                    
                    HStack() {
                        Text("종료 시간")
                            .font(.interRegular(size: 14))
                            .padding(.leading, 25).padding(.vertical, 15)
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(vm.selectedDate.toDateString())").font(.interRegular(size: 14)).padding(.trailing, 10)
                        DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .padding(.trailing, 15)
                    }.background(.white)
                    
                    VStack(spacing: 0) {
                        HStack() {
                            Text("이용자 추가")
                                .font(.interRegular(size: 14))
                                .padding(.leading, 25)
                                .padding(.vertical, 15)
                                .foregroundColor(.black)
                            Spacer()
            
                            TextField("ex-20220000", text: $studentId)
                                .padding(7)
                                .padding(.horizontal, 10)
                                .background(.gray00)
                                .cornerRadius(30)
                                .padding(.trailing, 15)
                                .frame(width: 164, height: 26)

                            Button(action: {
                                if (studentIds.contains(studentId)) {
                                    vm.alertMessage = "이미 등록한 학생입니다."
                                    vm.showAlert = true
                                } else if !(studentId.count == 8 && studentId.first == "2" ){
                                    vm.alertMessage = "학번 8자리만 입력 가능합니다."
                                    vm.showAlert = true
                                } else {
                                    vm.checkUser(user: studentId, date: vm.selectedDate.toDateString()) { isValid in
                                        if isValid {
                                            studentIds.append(studentId)
                                            print("??\(studentIds)")
                                        } else {
                                            vm.alertMessage = "등록 가능한 학생"
                                        }
                                    }
                                }
                            }) {
                                Image("addUserButton")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            .padding(.trailing, 15)
                            .alert(isPresented: $vm.showAlert) {
                                Alert(title: Text(""), message: Text(vm.alertMessage ?? "No message"), dismissButton: .default(Text("확인")))
                            }
                        }
                        
                        ScrollView(.horizontal) {
                            HStack() {
                                ForEach(Array(studentIds.enumerated()), id: \.element) { index, studentId in
                                    StudentIdView(studentId: studentId, isDeleted: index != 0, studentIds: $studentIds)
                                }
                            }
                        }
                        .padding(.leading, 25)
                        .padding(.bottom, 5)
                    }.background(.white)
                    
                    VStack(spacing: 0) {
                        HStack() {
                            Text("사용 목적")
                                .font(.interRegular(size: 14))
                                .foregroundColor(.black)
                            Spacer()
                        }.padding(.bottom, 15)
                        HStack(spacing: 40) {
                            ForEach(purposes, id: \.self) { purpose in
                                Button(action: {
                                    selectedPurpose = purpose
                                }) {
                                    HStack {
                                        Image(systemName: selectedPurpose == purpose ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(.blue04)
                                            .padding(.trailing, 15)
                                        Text("\(purpose)")
                                            .font(.interRegular(size: 15))
                                        Spacer()
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 15)
                    .background(.white)
                    
                    Button(action: {
                        vm.isLoading = true
                        vm.isWeekLoading = true
                        vm.isRegisterModalPresented = false
                        let reserv = ReservInfo(studentIds: studentIds, purpose: selectedPurpose, startDateTimeStr: startTime.toDateTimeString(), endDateTimeStr: endTime.toDateTimeString())
                        vm.addReservation(reservInfo: reserv) { alertMessage in
                            vm.trigger.toggle()
                            vm.alertMessage = alertMessage
                            vm.showAlert = true
                        }
                    }){
                        Text("저장").font(.normal(size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(.blue04)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                }
            }
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            )
        }.background(.gray00)
    }
}

struct StudentIdView: View {
    let studentId: String
    let isDeleted: Bool
    
    @Binding var studentIds: [String]
    
    var body: some View {
        ZStack() {
            Text("\(studentId)").font(.interRegular(size: 14))
                .frame(width: 90, height: 30)
                .background(.blue04)
                .foregroundColor(.white)
                .cornerRadius(30)
                .padding(3)
            if isDeleted {
                Button(action: {
                    if let index = studentIds.firstIndex(of: studentId) {
                        studentIds.remove(at: index)
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                .offset(x: 40, y: -10)
            }
        }
    }
}
