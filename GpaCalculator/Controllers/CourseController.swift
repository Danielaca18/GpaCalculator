//
//  CourseController.swift
//  Gpa Calculator
//
//  Created by Daniel Castro on 2023-02-23.
//

import SwiftUI

class CourseController {
    private var course: Course
    
    init(course: Course) {
        self.course = course
    }
    
    /*
    * Returns view associated with course attribute
    * @return
    * CourseView
    */
    func getView() -> CourseView {
        let nameBind = Binding<String>(
            get: {self.course.Name},
            set: {self.course.Name = $0}
        )
        
        let gpaBind = Binding<Float>(
            get: {self.course.Gpa},
            set: {self.course.Gpa = $0}
        )
        
        let creditBind = Binding<Int>(
            get: {self.course.Credit},
            set: {self.course.Credit = $0}
        )
        
        let view = CourseView(name: nameBind, init_gpa: gpaBind, init_credit: creditBind)
        view.setDecimalFormat()
        
        return view
    }
    
}

struct CourseController_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
