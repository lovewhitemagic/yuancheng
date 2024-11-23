import SwiftUI

struct EditToolView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var toolName: String
    @State private var frequency: String
    @State private var description: String
    @State private var stockThreshold: Int
    @State private var enableNotification: Bool
    
    let frequencies = ["每日", "每周2-3次", "每周", "每月"]
    
    init(tool: Tool) {
        _toolName = State(initialValue: tool.name)
        _frequency = State(initialValue: tool.frequency)
        _description = State(initialValue: "这里是工具的详细使用说明...")
        _stockThreshold = State(initialValue: 2)
        _enableNotification = State(initialValue: true)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("基本信息") {
                    TextField("工具名称", text: $toolName)
                    
                    Picker("使用频率", selection: $frequency) {
                        ForEach(frequencies, id: \.self) { freq in
                            Text(freq).tag(freq)
                        }
                    }
                }
                
                Section("使用说明") {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section("补货设置") {
                    Toggle("库存不足提醒", isOn: $enableNotification)
                    
                    if enableNotification {
                        Stepper("库存预警阈值: \(stockThreshold)", value: $stockThreshold, in: 1...10)
                    }
                }
            }
            .navigationTitle("编辑工具")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveTool()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveTool() {
        // TODO: 实现保存逻辑
    }
} 