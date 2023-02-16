//
//  ContentView.swift
//  GpaCalculator
//
//  Created by Daniel Castro on 2023-02-15.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default)
    private var courses: FetchedResults<Course>
    
    @State private var editing: Bool = false
    
    @State private var showDialog: Bool = false
    @State private var nameField = ""
    @State private var gpaField = ""
    @State private var creditField = ""
    @State private var cGpa: String = "0.0"
    @State private var complete: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack{
                    List {
                        HStack {
                            ForEach(["Course", "Gpa", "Credits"], id: \.self) { row in
                                Text(row).frame(maxWidth: .infinity)
                                    .foregroundColor(.gray)
                            }
                        }.listRowBackground(Color.clear)
                        
                        ForEach(courses) { (course: Course) in
                            let NameBind = Binding<String>(
                                get: {course.name!},
                                set: {course.name = $0}
                            )
                            
                            let GpaBind = Binding<Float>(
                                get: {course.gpa},
                                set: {course.gpa = $0
                                    updateGpa()}
                            )
                            
                            let CreditBind = Binding<Int>(
                                get: {Int(course.credit)},
                                set: {course.credit = Int32($0)
                                    updateGpa()}
                            )
                            HStack() {
                                TextField("", text: NameBind)
                                    .multilineTextAlignment(.center)
                                TextField("", value: GpaBind, formatter: NumberFormatter())
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.center)
                                TextField("", value: CreditBind, formatter: NumberFormatter())
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.center)
                            }.listRowBackground(Color.clear)
                        }.onDelete(perform: deleteItems)
                            .onMove(perform: moveItem)
                    }
                    .navigationTitle("Gpa Calculator")
                    .toolbar {
                        ToolbarItem(placement: .primaryAction)
                        { Button("Add") {showDialog.toggle()} }
                    }
                    
                    HStack(alignment: .bottom) {
                        (Text("cGpa: ") + Text(cGpa)).font(.system(size: 25, weight: .bold))
                            .foregroundColor(Color(.systemBlue))
                    }.onAppear(perform: updateGpa)
                }.background(Color(UIColor.clear))
                if showDialog {
                    DialogView(active: $showDialog, completed: $complete, nameField: $nameField, gpaField: $gpaField, creditField: $creditField)
                        .onDisappear { complete ? addItem() : nil }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            @State var name = nameField
            @State var gpa = Float(gpaField) ?? -1
            @State var credit = Int(creditField) ?? -1
            
            if (!name.isEmpty && (gpa >= 0) && (credit >= 0)) {
                let newCourse = Course(context: viewContext)
                newCourse.name = name
                newCourse.gpa = gpa
                newCourse.credit = Int32(credit)
                
                nameField = ""
                gpaField = ""
                creditField = ""
            }

            do { try viewContext.save() }
            catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            updateGpa()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { courses[$0] }.forEach(viewContext.delete)

            do { try viewContext.save() }
            catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        updateGpa()
    }
    
    private func moveItem(source: IndexSet, destination: Int) {
        withAnimation{
            var revisedItems: [Course] = courses.map {$0}
            revisedItems.move(fromOffsets: source, toOffset: destination)
            
            do { try viewContext.save() }
            catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func updateGpa() {
        var gp = 0.0
        var credits = 0
        for course in courses {
            if course.credit > 0 {
                gp += Double(Float(course.credit) *
                             course.gpa)
                credits += Int(course.credit)
            }
        }
        cGpa = courses.count == 0 ? String(0) :
        String(format: "%.1f", Float(gp) / Float(credits))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
