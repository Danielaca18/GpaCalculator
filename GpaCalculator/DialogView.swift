//
//  CourseDialog.swift
//  StudentView
//
//  Created by Daniel Castro on 2023-02-13.
//

import SwiftUI

struct DialogView: View {
    @Binding var active: Bool
    @Binding var completed: Bool
    @Binding var nameField: String
    @Binding var gpaField: String
    @Binding var creditField: String

    var body: some View {
        VStack(spacing: 0) {
            Text("Add Course")
                .font(.system(size: 18, weight: .bold))
                .padding(.bottom, 15).padding(.top, 20)
            TextField("Enter name", text: $nameField)
                .padding(.horizontal, 30)
            Divider().overlay(.black).padding(.horizontal, 30)
                .frame(height:0.3).padding(.bottom, 5)
            TextField("Enter gpa", text: $gpaField)
                .padding(.horizontal, 30).padding(.top, 10)
                .keyboardType(.decimalPad)
            Divider().overlay(.black)
                .padding(.horizontal, 30)
                .frame(height:0.3).padding(.bottom, 5)
            TextField("Enter credit", text: $creditField)
                .padding(.horizontal, 30).padding(.top, 10)
                .keyboardType(.numberPad)
            Divider().overlay(.black).padding(.horizontal, 30)
                .padding(.bottom, 25)
            
            Divider()
            HStack(alignment: .center) {
                Button("Close") {
                     active.toggle()
                 }.frame(maxWidth: .infinity)
                    .foregroundColor(.accentColor)
                 Divider()
                 Button("Ok") {
                     if validate() {
                         completed.toggle()
                         active.toggle()
                     }
                 }.frame(maxWidth:.infinity)
                    .foregroundColor(.accentColor)
            }
            
         }.frame(width: UIScreen.main.bounds.width/2+25, height: 220)
            .background(
                UITraitCollection.current.userInterfaceStyle == .dark ? Color(UIColor.darkGray) : .white)
         .cornerRadius(20)
    }
    
    func validate() -> Bool {
        let valid = !nameField.isEmpty &&
            !gpaField.isEmpty && !creditField.isEmpty
        
        return valid
    }
    
}

struct DialogView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
