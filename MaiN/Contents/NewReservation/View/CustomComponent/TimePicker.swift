//
//  TimePicker.swift
//  MaiN
//
//  Created by 김수민 on 6/26/24.
//

import SwiftUI

struct TimePicker: View {
    @Binding var date: Date
    
    var body: some View {
        HStack {
            Picker("Hour", selection: $date.hour) {
                ForEach(0..<24) { hour in
                    Text(String(format: "%02d", hour)).tag(hour)
                }
            }
            .frame(width: 60)
            .clipped()
            .compositingGroup()
            .padding()
            .labelsHidden()
            
            Picker("Minute", selection: $date.minute) {
                ForEach(0..<6) { minute in
                    Text(String(format: "%02d", minute * 10)).tag(minute * 10)
                }
            }
            .frame(width: 60)
            .clipped()
            .compositingGroup()
            .padding()
            .labelsHidden()
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

