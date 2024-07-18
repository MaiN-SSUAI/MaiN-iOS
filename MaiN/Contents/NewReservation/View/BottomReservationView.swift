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
//                if !vm.reservations.isEmpty {
                TabView(selection: $vm.selectedDate) {
                    ForEach(0..<7, id: \.self) { index in
                        ZStack(alignment: .top) {
                            RefreshableScrollView {
                                HStack(alignment: .top, spacing: 8) {
                                    TimeView()
                                    DayReservationView(vm: vm)
                                        .padding(.top, 5)
                                }
                                .padding(.horizontal, 14)
                                .padding(.bottom, 30)
                                
                            } onRefresh: {
                                vm.refreshDayData()
                            } onSwipeLeft: {
                                vm.selectedDate = vm.selectedDate.addingTimeInterval(86400) // 하루 증가
                            } onSwipeRight: {
                                vm.selectedDate = vm.selectedDate.addingTimeInterval(-86400) // 하루 감소
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
                        .tag(vm.selectedDate.addingTimeInterval(TimeInterval(86400 * index)))
                    }
                }.tabViewStyle(PageTabViewStyle())
//                } else {
//                    NoReservationDayView(vm: vm)
//                }
            }
        } else {
            if vm.isWeekLoading {
                DefaultLoadingView()
            } else {
//                if !(vm.weekReservations.allSatisfy { $0.isEmpty }) {
                    RefreshableScrollView {
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
                    } onRefresh: {
                        vm.refreshWeekData()
                    } onSwipeLeft: {
                        vm.selectedDate = vm.selectedDate.addingTimeInterval(86400 * 7) // 일주일 증가
                    } onSwipeRight: {
                        vm.selectedDate = vm.selectedDate.addingTimeInterval(-86400 * 7) // 일주일 감소
                    }
                    .padding(.bottom, 30)
                }
//                } else {
//                    NoReservationWeekView(vm: vm)
//                }
//            }
        }
    }
}

// Extension or function for refreshing data in ViewModel
extension ReservationViewModel {
    func refreshDayData() {
        // Implement your data refreshing logic for day view here
    }

    func refreshWeekData() {
        // Implement your data refreshing logic for week view here
    }
}

import UIKit

struct RefreshableScrollView<Content: View>: UIViewRepresentable {
    let content: Content
    let onRefresh: () -> Void
    
    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void

    init(@ViewBuilder content: () -> Content, onRefresh: @escaping () -> Void, onSwipeLeft: @escaping () -> Void, onSwipeRight: @escaping () -> Void) {
       self.content = content()
       self.onRefresh = onRefresh
       self.onSwipeLeft = onSwipeLeft
       self.onSwipeRight = onSwipeRight
   }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        let refreshControl = UIRefreshControl()
        scrollView.backgroundColor = UIColor(Color(.systemBackground)) // 배경색 설정
        refreshControl.backgroundColor = UIColor(Color(.systemBackground)) // 배경색 설정
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl), for: .valueChanged)
        scrollView.refreshControl = refreshControl

        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = UIColor(Color(.systemBackground)) // 배경색 설정
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSwipeLeft))
        swipeLeftGesture.direction = .left
        scrollView.addGestureRecognizer(swipeLeftGesture)

        let swipeRightGesture = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSwipeRight))
        swipeRightGesture.direction = .right
        scrollView.addGestureRecognizer(swipeRightGesture)

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        if let hostingController = uiView.subviews.first(where: { $0 is UIHostingController<Content> }) as? UIHostingController<Content> {
            hostingController.rootView = content
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: RefreshableScrollView

        init(_ parent: RefreshableScrollView) {
            self.parent = parent
        }

        @objc func handleRefreshControl(sender: UIRefreshControl) {
            parent.onRefresh()
            sender.endRefreshing()
        }
        
        @objc func handleSwipeLeft() {
                   parent.onSwipeLeft()
               }

           @objc func handleSwipeRight() {
               parent.onSwipeRight()
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
                    let randomNumber = Int.random(in: 0...colorSet.count-1)
                    DayReservationButton(
                        vm: vm,
                        reservation: reservation,
                        color: colorSet[randomNumber]
                    )
                }
            }
        }
    }
}
