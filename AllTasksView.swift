//
//  AllTasksView.swift
//  TaskListTracker
//
//  Created by Adrino Rosario on 22/11/24.
//

import SwiftData
import SwiftUI

struct AllTasksView: View {
    @Environment(\.modelContext) var modelContext
    @Query var tasks: [Tasks]
    
    var statuses = [
        "In Progress",
        "In Review",
        "On Hold",
        "Completed",
    ]
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    @State private var selectedStatus: String = "In Progress"
    @State private var showIndividualTaskView: Bool = false
    
    var filteredTasks: [Tasks] {
        tasks.filter { $0.status == selectedStatus }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(statuses, id:\.self) { status in
                        Button {
                            selectedStatus = status
                        } label: {
                            RoundedRectangle(cornerRadius: 50)
                                .fill(selectedStatus == status ? .blue : .black)
                                .frame(width: 100, height: 40)
                                .overlay {
                                    Text(status)
                                        .foregroundStyle(.white)
                                        .font(.callout)
                                }
                        }
                    }
                }
                .padding()
            }
            
            if filteredTasks.count < 1 {
                ContentUnavailableView("No tasks found", systemImage: "exclamationmark.magnifyingglass", description: Text("No task found. Please add a task to see them here"))
            } else {
                List {
                    ForEach(filteredTasks) { task in
                        VStack {
                            Button {
                                showIndividualTaskView.toggle()
                            } label: {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(returnColors(for: task.status))
                                    .frame(height: 130)
                                    .overlay {
                                        VStack(alignment: .leading, spacing: 10) {
                                            VStack(alignment: .leading) {
                                                Text("\(task.taskName)")
                                                    .font(.title)
                                                    .foregroundStyle(.black)
                                                    .lineLimit(1)
                                                
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
                                        .padding(.horizontal)
                                    }
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .sheet(isPresented: $showIndividualTaskView) {
                                IndividulTaskView(task: task)
                            }
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                .navigationTitle(selectedStatus)
                .listStyle(.plain)
            }
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        for offset in offsets {
            let task = filteredTasks[offset]
            modelContext.delete(task)
        }
    }
    
    func returnColors(for status: String) -> LinearGradient {
        switch status {
        case "Completed":
            return LinearGradient(colors: [.green, .mint], startPoint: .top, endPoint: .bottom)
        case "In Progress":
            return LinearGradient(colors: [.blue, .teal], startPoint: .top, endPoint: .bottom)
        case "In Review":
            return LinearGradient(colors: [.red, .purple], startPoint: .top, endPoint: .bottom)
        case "On Hold":
            return LinearGradient(colors: [.orange, .yellow], startPoint: .top, endPoint: .bottom)
        default:
            return LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Tasks.self, configurations: config)
        
        return AllTasksView()
            .modelContainer(container)
    } catch {
        return Text("Error: \(error.localizedDescription)")
    }
}
