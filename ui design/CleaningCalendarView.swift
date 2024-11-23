import SwiftUI

struct CleaningCalendarView: View {
    enum CalendarViewMode: String, CaseIterable {
        case day = "天"
        case week = "周"
        case month = "月"
    }
    
    @State private var selectedMode: CalendarViewMode = .week
    @State private var selectedDate = Date()
    @State private var showingTaskDetail = false
    @State private var selectedTask: CleaningTask?
    
    // 示例数据
    @State private var calendarDays: [CalendarDay] = [
        CalendarDay(date: Date(), tasks: [
            CleaningTask(name: "地板清洁", isCompleted: false, tools: ["拖把", "清洁剂"], date: Date()),
            CleaningTask(name: "浴室清洁", isCompleted: true, tools: ["刷子", "消毒剂"], date: Date())
        ])
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // 视图模式选择器
                    Picker("日历视图", selection: $selectedMode) {
                        ForEach(CalendarViewMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    // 日期选择器
                    DatePicker(
                        "选择日期",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    
                    // 任务列表
                    List {
                        ForEach(calendarDays) { day in
                            Section(day.date.formatted(date: .abbreviated, time: .omitted)) {
                                ForEach(day.tasks) { task in
                                    TaskRow(task: task)
                                        .onTapGesture {
                                            selectedTask = task
                                            showingTaskDetail = true
                                        }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("清洁日历")
            .sheet(isPresented: $showingTaskDetail) {
                if let task = selectedTask {
                    TaskDetailSheet(task: task)
                }
            }
        }
    }
}

struct TaskRow: View {
    let task: CleaningTask
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.name)
                    .font(.headline)
                
                if let date = task.date {
                    Text(date.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    ForEach(task.tools, id: \.self) { tool in
                        Text(tool)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
        }
        .padding(.vertical, 8)
    }
}

struct TaskDetailSheet: View {
    let task: CleaningTask
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("任务信息") {
                    LabeledContent("任务名称", value: task.name)
                    LabeledContent("执行时间", value: task.date?.formatted() ?? "")
                    LabeledContent("状态", value: task.isCompleted ? "已完成" : "未完成")
                }
                
                Section("所需工具") {
                    ForEach(task.tools, id: \.self) { tool in
                        Text(tool)
                    }
                }
                
                Section("备注") {
                    Text("这里是任务的详细说明和注意事项...")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("任务详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("完成") {
                    dismiss()
                }
            }
        }
    }
} 