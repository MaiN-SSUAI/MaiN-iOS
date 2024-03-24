//
//  NewMonthView.swift
//  MaiN
//
//  Created by 김수민 on 1/23/24.
//

import SwiftUI

struct NewMonthView: UIViewRepresentable {
    @Binding var selectedDate: Date

    func makeUIView(context: Context) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
        return datePicker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = selectedDate
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: NewMonthView

        init(_ parent: NewMonthView) {
            self.parent = parent
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            parent.selectedDate = sender.date
        }
    }
}

struct NewPreviews: PreviewProvider {
    @State static var previewDate = Date()

    static var previews: some View {
        NewMonthView(selectedDate: $previewDate)
    }
}
