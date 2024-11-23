import SwiftUI

struct HomeView: View {
    @State private var showAddTask = false
    @State private var selectedFrequency = "每日"
    @Namespace private var namespace
    @State private var editingTask: EditTaskIndices? = nil
    @Binding var taskSections: [TaskSection]
    
    let frequencies = ["每日", "每周", "每月"]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(taskSections: Binding<[TaskSection]>) {
        self._taskSections = taskSections
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 顶部频率选择器
                HStack(spacing: 0) {
                    ForEach(frequencies, id: \.self) { frequency in
                        Button(action: {
                            withAnimation {
                                selectedFrequency = frequency
                            }
                        }) {
                            Text(frequency)
                                .font(.headline)
                                .foregroundColor(selectedFrequency == frequency ? .blue : .gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background {
                                    if selectedFrequency == frequency {
                                        Rectangle()
                                            .fill(Color.blue)
                                            .frame(height: 2)
                                            .matchedGeometryEffect(id: "underline", in: namespace)
                                            .position(x: UIScreen.main.bounds.width / 6, y: 40)
                                    }
                                }
                        }
                    }
                }
                .background(Color(.systemBackground))
                .overlay(
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1),
                    alignment: .bottom
                )
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(taskSections.indices, id: \.self) { sectionIndex in
                            if taskSections[sectionIndex].title.contains(selectedFrequency) {
                                ForEach(taskSections[sectionIndex].tasks.indices, id: \.self) { taskIndex in
                                    let task = taskSections[sectionIndex].tasks[taskIndex]
                                    TaskCard(task: task) {
                                        withAnimation {
                                            taskSections[sectionIndex].tasks[taskIndex].isCompleted.toggle()
                                            if taskSections[sectionIndex].tasks[taskIndex].isCompleted {
                                                taskSections[sectionIndex].tasks[taskIndex].completedDate = Date()
                                                let task = taskSections[sectionIndex].tasks.remove(at: taskIndex)
                                                taskSections[sectionIndex].tasks.append(task)
                                            }
                                        }
                                    } editAction: {
                                        editTask(sectionIndex: sectionIndex, taskIndex: taskIndex)
                                    }
                                }
                            }
                        }
                        
                        // 添加新任务卡片
                        Button(action: {
                            showAddTask = true
                        }) {
                            VStack(spacing: 12) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.blue)
                                Text("添加新任务")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("清洁助手")
            .sheet(isPresented: $showAddTask) {
                AddTaskView(taskSections: $taskSections)
            }
            .sheet(item: $editingTask) { indices in
                EditTaskView(task: $taskSections[indices.sectionIndex].tasks[indices.taskIndex])
            }
        }
    }
    
    private func editTask(sectionIndex: Int, taskIndex: Int) {
        editingTask = EditTaskIndices(sectionIndex: sectionIndex, taskIndex: taskIndex)
    }
}