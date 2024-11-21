//
//  IndividulTaskView.swift
//  TaskListTracker
//
//  Created by Adrino Rosario on 21/11/24.
//

import SwiftData
import SwiftUI

struct IndividulTaskView: View {
    @Environment(\.dismiss) var dismiss
    
    let task: Tasks
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Image(systemName: "calendar.badge.clock")
                    Text("\(dateFormatter.string(from: task.endDate))")
                }
                .font(.headline)
                
                Text(task.taskDescription == "" ? "Description: No description" :  "Description: \(task.taskDescription)")
                    .font(.headline)
                
                HStack(spacing: 5) {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.black)
                        .frame(width: 150, height: 50)
                        .overlay {
                            Text("\(task.status)")
                                .foregroundStyle(.white)
                                .font(.headline)
                        }
                    
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.black)
                        .frame(width: 150, height: 50)
                        .overlay {
                            Text("\(task.priority)")
                                .foregroundStyle(.white)
                                .font(.headline)
                        }
                }
            }
            .padding()
            .navigationTitle(task.taskName)
            .toolbar {
                Button("Close") {
                    dismiss()
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Tasks.self, configurations: config)
        
        let example = Tasks(taskName: "Random Task", taskDescription: "", priority: "High", status: "Completed", endDate: Date.now)
        
        
        return IndividulTaskView(task: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
