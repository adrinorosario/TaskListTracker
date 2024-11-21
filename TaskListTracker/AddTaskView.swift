//
//  AddTaskView.swift
//  TaskListTracker
//
//  Created by Adrino Rosario on 21/11/24.
//

import SwiftData
import SwiftUI

struct AddTaskView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var taskName: String = ""
    @State private var description: String = ""
    @State private var priority: String = ""
    @State private var status: String = ""
    @State private var endDate: Date = Date.now
    
    var priorities = [
        "Low",
        "Medium",
        "High"
    ]
    
    var statuses = [
        "In Progress",
        "In Review",
        "On Hold",
        "Completed",
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter the name of the task", text: $taskName)
                
                TextField("Describe the task (optional)", text: $description, axis: .vertical)
                
                Picker("Priority", selection: $priority) {
                    ForEach(priorities, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Status", selection: $status) {
                    ForEach(statuses, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                
                DatePicker(selection: $endDate, in: Date.now..., displayedComponents: .date) {
                    Text("Select an end date")
                }
                
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                Button("Add task") {
                    let task = Tasks(taskName: taskName, taskDescription: description, priority: priority, status: status, endDate: endDate)
                    modelContext.insert(task)
                    dismiss()
                }
                .disabled(validateForm())
            }
        }
    }
    
    func validateForm() -> Bool {
        if taskName.isEmpty || taskName == "" || taskName.trimmingCharacters(in: .whitespaces) == "" {
            return true
        } else if priority.isEmpty {
            return true
        } else if status.isEmpty {
            return true
        }
        return false
    }
}

#Preview {
    AddTaskView()
}
