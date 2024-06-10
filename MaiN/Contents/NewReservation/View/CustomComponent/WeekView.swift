//
//  WeekView.swift
//  MaiN
//
//  Created by 김수민 on 1/9/24.
//

import SwiftUI

struct WeekView: View {
    @ObservedObject var vm: ReservationViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { offset in
                        let day = Calendar.current.date(byAdding: .day, value: offset, to: vm.selectedDate.startOfWeek!)!
                        let dayString = dayOfWeekFormatter.string(from: day)
                        
                        let dateString = dateOfWeekFormatter.string(from: day)
                        Button(action: {
                            if (vm.dayOrWeek == "week") {vm.dayOrWeek = "day"}
                            self.updateSelectedDate(to: day)
                            vm.selectedDateIndex = offset
                        }){
                            VStack(alignment: .center, spacing: 2) {
                                Text(dateString)
                                    .foregroundColor(.black00)
                                    .font(isSameDay(day1: day, day2: Date()) ? /*.interExtraBold(size: 18) : .interSemiBold(size: 18)*/
                                        .bold(size: 18) :
                                            .interSemiBold(size: 18))
                                Text(dayString)
                                    .foregroundColor(.gray03)
                                    .font(.interRegular(size: 13))
                            }
                            .frame(width: geometry.size.width/7, height: 60)
                            .background( vm.dayOrWeek == "day" && isSameDate(day1: day, day2: vm.selectedDate) ? .selectedCalendar : Color.white)
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }.frame(height: 60)
    }

    private func updateSelectedDate(to newDate: Date) {
        vm.changeDate(date: newDate)
    }
    
    //같은 요일인지 확인
    private func isSameDay(day1: Date, day2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(day1, inSameDayAs: day2)
    }
    
    //같은 날짜인지 확인
    private func isSameDate(day1: Date, day2: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: day1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: day2)
        return components1.year == components2.year && components1.month == components2.month && components1.day == components2.day
    }
}

func changeToKorean(englishDate: String) -> String {
    switch englishDate {
    case "Mon":
        return "월"
    case "Tue":
        return "화"
    case "Wed":
        return "수"
    case "Thu":
        return "목"
    case "Fri":
        return "금"
    case "Sat":
        return "토"
    case "Sun":
        return "일"
    default:
        return "알 수 없음"
    }
}

let dayOfWeekFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E"
    return formatter
}()

let dateOfWeekFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter
}()

extension Date {
    var startOfWeek: Date? {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return startOfWeek
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()
