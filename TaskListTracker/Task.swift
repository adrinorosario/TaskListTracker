//
//  Task.swift
//  TaskListTracker
//
//  Created by Adrino Rosario on 21/11/24.
//

import Foundation
import SwiftData

//struct Task: Identifiable {
//    var id = UUID()
//    var taskName: String
//    var description: String?
//    var priority: String // low, medium, high
//    var status: String // in-progress, paused, completed, pending, abandoned
//    var startDate = Date.now
//    var endDate: Date
////    var subTasks: [SubTask]?
//}
//
////struct SubTask: Identifiable {
////    var id = UUID()
////    var subTaskName: String
////    var status: String // in-progress, completed, pending
////}

@Model
class Tasks {
    var id = UUID()
    var taskName: String
    var taskDescription: String
    var priority: String // low, medium, high
    var status: String // in-progress, paused, completed, pending, abandoned
    var startDate = Date.now
    var endDate: Date
    
    init(id: UUID = UUID(), taskName: String, taskDescription: String, priority: String, status: String, startDate: Foundation.Date = Date.now, endDate: Date) {
        self.id = id
        self.taskName = taskName
        self.taskDescription = taskDescription
        self.priority = priority
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
    }
}
