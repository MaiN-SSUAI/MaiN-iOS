//
//  TimePicker.swift
//  MaiN
//
//  Created by 김수민 on 6/26/24.
//

import SwiftUI

struct StartTimePicker: View {
    //MARK: ViewModel
    @ObservedObject var vm: ReservationViewModel
    
    //MARK: State Property - View
    @State var isTimePickerVisible = false {
        didSet {
            if isTimePickerVisible {
                isDatePickerVisible = false
            }
        }
    }
    
    @State var isDatePickerVisible = false {
        didSet {
            if isDatePickerVisible {
                isTimePickerVisible = false
            }
        }
    }
    
    //MARK: State Property - Data
    @Binding var time: String
    @Binding var selectedDate: Date
    @State var selectedHour = 0
    @State var selectedMinute = 0
    @State var selectedPeriod = 0
    
    //MARK: Property
    var hours: [Int] {
        Array(1...12)
    }
    
    var minutes: [Int] {
        Array(stride(from: 0, to: 60, by: 10))
    }
    
    var periods = ["AM", "PM"]
    
    //MARK: View
    var body: some View {
        VStack {
            HStack {
                Text("시작 시간")
                    .font(.interRegular(size: 14))
                    .padding(.leading, 25).padding(.vertical, 15)
                    .foregroundColor(.black)
                Button(action: {
                    vm.endPickerOff = true
                    vm.startPickerOff = false
                    isDatePickerVisible.toggle()
                }) {
                    HStack(spacing: 0) {
                        Text("\(selectedDate.toDateString())").font(.interRegular(size: 14)).padding(.trailing, 10)
                            .foregroundColor(.black)
                            .padding(.leading, 85)
                        Spacer()
                    }
                }
                Button(action: {
                    vm.endPickerOff = true
                    vm.startPickerOff = false
                    isTimePickerVisible.toggle()
                }) {
                    Text(formattedTimeDisplay())
                        .font(.interRegular(size: 14))
                        .foregroundColor(.black)
                        .padding()
                }
            }

            //MARK: Picker
            if !vm.startPickerOff {
                if isTimePickerVisible {
                    HStack(spacing: 4) {
                        Picker("Hour", selection: $selectedHour) {
                            ForEach(0..<hours.count, id: \.self) { index in
                                Text("\(self.hours[index])")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .clipped()
                        
                        Picker("Minute", selection: $selectedMinute) {
                            ForEach(0..<minutes.count, id: \.self) { index in
                                Text(String(format: "%02d", self.minutes[index]))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .clipped()
                        
                        Picker("Period", selection: $selectedPeriod) {
                            ForEach(0..<periods.count, id: \.self) {
                                Text(self.periods[$0])
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .clipped()
                    }
                    .frame(height: 150)
                    .pickerStyle(WheelPickerStyle())
                    .onDisappear {
                        isTimePickerVisible = false
                    }
                }
                
                if isDatePickerVisible {
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .environment(\.locale, Locale(identifier: "ko_KR"))
                }
            }
        }.background(.white)
            .onChange(of: selectedDate) { _ in
                time = formattedTime()
            }
            .onChange(of: selectedHour) { _ in
                time = formattedTime()
            }
            .onChange(of: selectedMinute) { _ in
                time = formattedTime()
            }
            .onChange(of: selectedPeriod) { _ in
                time = formattedTime()
            }
            .onAppear {
                time = formattedTime()
            }
    }
    
    func formattedTimeDisplay() -> String {
        guard hours.indices.contains(selectedHour),
              minutes.indices.contains(selectedMinute),
              periods.indices.contains(selectedPeriod) else {
            return "Invalid Time"
        }
        
        return "\(String(hours[selectedHour])):\(String(format: "%02d", minutes[selectedMinute])) \(periods[selectedPeriod])"
    }
    
    func formattedTime() -> String {
        guard hours.indices.contains(selectedHour),
              minutes.indices.contains(selectedMinute),
              periods.indices.contains(selectedPeriod) else {
            return ""
        }

        let calendar = Calendar.current
        let hour = (periods[selectedPeriod] == "PM" && hours[selectedHour] != 12) ? (hours[selectedHour] + 12) : (periods[selectedPeriod] == "AM" && hours[selectedHour] == 12) ? 0 : hours[selectedHour]

        let minute = minutes[selectedMinute]
        
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        components.hour = hour
        components.minute = minute
        components.second = 0
        components.nanosecond = 0
        
        if let combinedDate = calendar.date(from: components) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            formatter.timeZone = TimeZone(secondsFromGMT: 9 * 3600) // +09:00 시간대
            return formatter.string(from: combinedDate)
        } else {
            return ""
        }
    }
}

extension Date {
    var hour: Int {
        get { Calendar.current.component(.hour, from: self) }
        set {
            self = Calendar.current.date(bySettingHour: newValue, minute: self.minute, second: 0, of: self) ?? self
        }
    }
    
    var minute: Int {
        get { Calendar.current.component(.minute, from: self) }
        set {
            self = Calendar.current.date(bySettingHour: self.hour, minute: newValue, second: 0, of: self) ?? self
        }
    }
}

