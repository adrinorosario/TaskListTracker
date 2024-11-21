//
//  TaskView.swift
//  TaskListTracker
//
//  Created by Adrino Rosario on 21/11/24.
//

import SwiftData
import SwiftUI

struct TaskView: View {
    @Environment(\.modelContext) var modelContext
    @Query var tasks: [Tasks]
    
    let status: String
    var color: LinearGradient
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    @State private var showIndividualTaskView: Bool = false
    
    var filteredTasks: [Tasks] {
        tasks.filter { $0.status == status }
    }
    
    var body: some View {
        NavigationStack {
            if filteredTasks.count < 1 {
                ContentUnavailableView("No tasks found", systemImage: "exclamationmark.magnifyingglass", description: Text("No task found. Please add a task to see them here"))
                    .navigationTitle(status)
            } else {
                List {
                    ForEach(filteredTasks) { task in
                        Button {
                            showIndividualTaskView.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(color)
                                .frame(height: 130)
                                .overlay {
                                    VStack(alignment: .leading, spacing: 10) {
                                        VStack(alignment: .leading) {
                                            Text("\(task.taskName)")
                                                .font(.title)
                                                .foregroundStyle(.black)
                                            
                                            HStack {
                                                Image(systemName: "calendar.badge.clock")
                                                    .foregroundStyle(.black)
                                                Text("\(dateFormatter.string(from: task.endDate))")
                                                    .foregroundStyle(.black)
                                            }
                                            .font(.subheadline)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        VStack(alignment: .leading) {
                                            HStack(spacing: 5) {
                                                RoundedRectangle(cornerRadius: 30)
                                                    .fill(.black)
                                                    .frame(width: 120, height: 30)
                                                    .overlay {
                                                        Text("\(task.status)")
                                                            .foregroundStyle(.white)
                                                            .font(.subheadline)
                                                    }
                                                
                                                RoundedRectangle(cornerRadius: 30)
                                                    .fill(.black)
                                                    .frame(width: 120, height: 30)
                                                    .overlay {
                                                        Text("\(task.priority)")
                                                            .foregroundStyle(.white)
                                                            .font(.subheadline)
                                                    }
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding()
                                }
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .sheet(isPresented: $showIndividualTaskView) {
                            IndividulTaskView(task: task)
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                .listStyle(.plain)
                .navigationTitle(status)
                .padding()
                .toolbar {
                    EditButton()
                }
            }
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        for offset in offsets {
            let task = filteredTasks[offset]
            modelContext.delete(task)
        }
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Tasks.self, configurations: config)
        
        return TaskView(status: "Completed", color: LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom))
            .modelContainer(container)
    } catch {
        return Text("Error: \(error.localizedDescription)")
    }
}
