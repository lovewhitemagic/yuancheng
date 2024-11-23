import SwiftUI

struct TaskDetailView: View {
    let taskName: String
    let frequency: String
    let reminderTime: Date?
    @State private var isEditing = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        List {
            Section("任务信息") {
                HStack {
                    Text("频率")
                    Spacer()
                    Text(frequency)
                        .foregroundColor(.gray)
                }
                
                if let reminderTime = reminderTime {
                    HStack {
                        Text("提醒时间")
                        Spacer()
                        Text(reminderTime.formatted(date: .omitted, time: .shortened))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Section("进度记录") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("本周完成情况")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<7) { day in
                            Circle()
                                .fill(day < 3 ? Color.green : Color.gray.opacity(0.3))
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section("相关工具") {
                ForEach(["吸尘器", "拖把", "清洁剂"], id: \.self) { tool in
                    NavigationLink(destination: Text(tool)) {
                        HStack {
                            Image(systemName: "wrench.fill")
                            Text(tool)
                        }
                    }
                }
            }
            
            Section {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    HStack {
                        Spacer()
                        Text("删除任务")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(taskName)
        .toolbar {
            Button("编辑") {
                isEditing = true
            }
        }
        .sheet(isPresented: $isEditing) {
            // TODO: 实现编辑视图
        }
        .alert("确认删除", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                // TODO: 实现删除逻辑
            }
        } message: {
            Text("删除后无法恢复，是否确认删除？")
        }
    }
} 