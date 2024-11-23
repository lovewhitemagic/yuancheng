import SwiftUI

struct AddToolView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var toolName = ""
    @State private var frequency = "每日"
    @State private var description = ""
    @State private var stockThreshold = 2
    @State private var enableNotification = true
    
    let frequencies = ["每日", "每周2-3次", "每周", "每月"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("基本信息") {
                    TextField("工具名称", text: $toolName)
                    
                    Picker("使用频率", selection: $frequency) {
                        ForEach(frequencies, id: \.self) { freq in
                            Text(freq)
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
            .navigationTitle("添加工具")
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