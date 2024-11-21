//
//  ContentView.swift
//  TaskListTracker
//
//  Created by Adrino Rosario on 21/11/24.
//

import Charts
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var tasks: [Tasks]
    
    var statuses = [
        "In Progress",
        "In Review",
        "On Hold",
        "Completed",
    ]
    
    @State private var showingAddTask: Bool = false
    @State private var isScrollDisabled: Bool = true
    
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationStack {
            Spacer()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Task Summary")
                        .font(.headline)
                        .padding(.horizontal)
                    LazyVGrid(columns: columns) {
                        ForEach(statuses, id: \.self) { status in
                            NavigationLink {
                                TaskView(status: status, color: returnColors(for: status))
                            } label: {
                                VStack {
                                    VStack(alignment: .center) {
                                        Text("\(calculateTaskCounts(for: status))")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.black)
                                            .fontDesign(.monospaced)
                                        Text(status)
                                            .font(.title3)
                                            .fontWeight(.regular)
                                            .foregroundStyle(.black)
                                            .fontDesign(.monospaced)
                                    }
                                    .padding(.vertical)
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                    .background(returnColors(for: status))
                                }
                                .clipShape(.rect(cornerRadius: 10))
                                .frame(height: 120)
                                .padding(2)
                            }
                        }
                    }
                    .padding(9)
                }
                
                
                VStack {
                    if(tasks.count > 0) {
                        DividingView()
                            .padding(.horizontal)
                        
                        Text("Task Statistics")
                            .font(.title)
                            .fontWeight(.semibold)

                        Chart {
                            ForEach(statuses, id: \.self) { status in
                                SectorMark(
                                    angle: .value("Count", calculateTaskCounts(for: status)),
                                    innerRadius: .ratio(0.618),
                                    angularInset: 1.5
                                )
                                .foregroundStyle(returnColorForChart(for: status))
                                .foregroundStyle(by: .value("Status", status))
                            }
                        }
                        .frame(minHeight: 200)
                        .chartLegend(position: .trailing, alignment: .center)
                        .padding()
                    } else {
                        Button {
                            showingAddTask.toggle()
                        } label: {
                            ContentUnavailableView("No tasks", systemImage: "plus", description: Text("Add tasks to see statistics"))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(minHeight: 300)
                
                HStack(spacing: 20) {
                    NavigationLink {
                        AllTasksView()
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.black)
                            .frame(width: 280, height: 55)
                            .overlay {
                                Text("View all tasks")
                                    .foregroundStyle(.white)
                                    .font(.title3).bold()
                            }
                    }
                    
                    Button {
                        showingAddTask.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.black)
                            .frame(width: 65, height: 65)
                            .overlay {
                                Image(systemName: "plus")
                                    .foregroundStyle(.white)
                                    .font(.largeTitle)
                            }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Dashboard")
            .toolbar {
                Button {
                    showingAddTask.toggle()
                } label: {
                    Text("Add Task")
                }
                .sheet(isPresented: $showingAddTask) {
                    AddTaskView()
                }
            }
            .scrollDisabled(isScrollDisabled)
        }
        .scrollDisabled(isScrollDisabled)
    }

    func calculateTaskCounts(for status: String) -> Int {
        var taskCount: Int = 0
        for items in tasks {
            if items.status == status {
                taskCount += 1
            }
        }
        return taskCount
    }
    
    func returnColorForChart(for status: String) -> Color {
        switch status {
        case "Completed":
            return .green
        case "In Progress":
            return .blue
        case "In Review":
            return .pink
        case "On Hold":
            return .orange
        default:
            return .white
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
        
        return ContentView()
            .modelContainer(container)
    } catch {
        return Text("Error: \(error.localizedDescription)")
    }
}
