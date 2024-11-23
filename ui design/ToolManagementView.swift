import SwiftUI

struct Tool: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    var frequency: String
    var stock: Int
    var needsRestock: Bool { stock < 2 }
}

struct ToolManagementView: View {
    @State private var tools: [Tool] = [
        Tool(name: "吸尘器", icon: "vacuum.cleaner", frequency: "每周2次", stock: 1),
        Tool(name: "拖把", icon: "mop", frequency: "每日", stock: 1),
        Tool(name: "清洁剂", icon: "spray.bottle", frequency: "每周", stock: 1),
        Tool(name: "抹布", icon: "cloth", frequency: "每日", stock: 3)
    ]
    @State private var showingAddTool = false
    
    var body: some View {
        NavigationView {
            List {
                // 需要补货的工具
                if !toolsNeedingRestock.isEmpty {
                    Section("补货提醒") {
                        ForEach(toolsNeedingRestock) { tool in
                            ToolRowView(tool: tool)
                                .listRowBackground(Color.red.opacity(0.1))
                        }
                    }
                }
                
                // 所有工具列表
                Section("所有工具") {
                    ForEach(tools) { tool in
                        NavigationLink(destination: ToolDetailView(tool: tool)) {
                            ToolRowView(tool: tool)
                        }
                    }
                }
            }
            .navigationTitle("工具管理")
            .toolbar {
                Button(action: { showingAddTool = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddTool) {
                AddToolView()
            }
        }
    }
    
    var toolsNeedingRestock: [Tool] {
        tools.filter { $0.needsRestock }
    }
}

struct ToolRowView: View {
    let tool: Tool
    
    var body: some View {
        HStack {
            Image(systemName: tool.icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(tool.name)
                    .font(.headline)
                Text("使用频率: \(tool.frequency)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if tool.needsRestock {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
    }
}

struct ToolDetailView: View {
    let tool: Tool
    @State private var isEditing = false
    
    var body: some View {
        List {
            Section("基本信息") {
                LabeledContent("使用频率", value: tool.frequency)
                LabeledContent("库存数量", value: "\(tool.stock)个")
            }
            
            Section("使用说明") {
                Text("这里是\(tool.name)的详细使用说明和注意事项...")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            
            Section("补货设置") {
                Toggle("库存不足提醒", isOn: .constant(true))
                Stepper("库存预警阈值: 2", value: .constant(2))
            }
        }
        .navigationTitle(tool.name)
        .toolbar {
            Button("编辑") {
                isEditing = true
            }
        }
    }
} 