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
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Course.order, ascending: true)],
        animation: .default)
    private var courses: FetchedResults<Course>

    @State private var cGpa: String = "0.0"

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
                        
                        ForEach(courses) { course in
                            
                            let NameBind = Binding<String>(
                                get: {course.name!},
                                set: {course.name = $0
                                    try! viewContext.save()}
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
                            course.view(Name: NameBind, Gpa: GpaBind, Credit: CreditBind)
                            
                        }.onDelete(perform: deleteItems)
                            .onMove(perform: moveItem)
                    }
                    .navigationTitle("Gpa Calculator")
                    .toolbar {
                        ToolbarItem(placement: .primaryAction)
                        { Button("Add") {addItem()} }
                    }
                    
                    HStack(alignment: .bottom) {
                        (Text("cGpa: ") + Text(cGpa)).font(.system(size: 25, weight: .bold))
                            .foregroundColor(Color(.systemBlue))
                    }.onAppear(perform: updateGpa)
                }.background(Color(UIColor.clear))
            }
        }.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    /*
    * Adds a new course to coredata and presents associated view
    */
    public func addItem() {
        withAnimation {
            let newCourse = Course(context: viewContext)
            newCourse.id = UUID()
            newCourse.order = Int16(courses.count)
            
            updateGpa()
        }
    }

    /*
    * Removes a course from coredata and associated view
    */
    public func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { courses[$0] }.forEach(viewContext.delete)
            
            updateGpa()
        }
    }
    
    /*
    * Returns courses list
    * @Returns
    * Returns fetched results list of courses
    */
    public func getItems() -> FetchedResults<Course> {
        return courses
    }
    
    /*
    * Changes order of courses in coredata and in view
    */
    public func moveItem(source: IndexSet, destination: Int) {
        withAnimation{
            var sortedOrders: [Int16] = Array(1...Int16(courses.count))
            for (course, order) in zip(courses, sortedOrders) {
                course.order = order
            }
           
            sortedOrders.move(fromOffsets: source, toOffset: destination)
            let finalOrders : [Int16] = Array(1...Int16(courses.count))
            let mappingDict = Dictionary(uniqueKeysWithValues: zip(sortedOrders , finalOrders))
           
            for course in courses{
                course.order = mappingDict[course.order]!
            }
            
            try! viewContext.save()
        }
    }
    
    /*
    * Calculates total gpa from all course entities saved in coredata
    */
    public func updateGpa() {
        try! viewContext.save()
        
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
