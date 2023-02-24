//
//  CourseView.swift
//  Gpa Calculator
//
//  Created by Daniel Castro on 2023-02-23.
//

import SwiftUI

struct CourseView: View {
    
    @Binding private var name: String
    @Binding private var gpa: Float
    @Binding private var credit: Int
    private let decimalFormatter = NumberFormatter()
    
    init(name: Binding<String>, init_gpa: Binding<Float>, init_credit: Binding<Int>) {
        self._name = name
        self._gpa = init_gpa
        self._credit = init_credit
    }
    
    func setDecimalFormat() {
        decimalFormatter.numberStyle = .decimal
    }
    
    var body: some View {
        
        HStack {
            TextField("", text: $name)
                .multilineTextAlignment(.center)
                .onSubmit{
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            TextField("", value: $gpa, formatter: decimalFormatter)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .onSubmit{
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            TextField("", value: $credit, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .onSubmit{
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }.listRowBackground(Color.clear)
    }
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
