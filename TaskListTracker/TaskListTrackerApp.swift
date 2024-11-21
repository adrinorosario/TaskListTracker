//
//  TaskListTrackerApp.swift
//  TaskListTracker
//
//  Created by Adrino Rosario on 21/11/24.
//

import SwiftData
import SwiftUI

@main
struct TaskListTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Tasks.self)
    }
}
