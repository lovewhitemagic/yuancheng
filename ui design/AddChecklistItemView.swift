import SwiftUI

struct AddChecklistItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var frequency = "每月"
    @State private var stock = 1
    @State private var price = 0.0
    @State private var enableNotification = true
    @State private var stockThreshold = 2
    
    let frequencies = ["每日", "每周", "每月"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("基本信息") {
                    TextField("物品名称", text: $name)
                    
                    Picker("使用频率", selection: $frequency) {
                        ForEach(frequencies, id: \.self) { freq in
                            Text(freq).tag(freq)
                        }
                    }
                    
                    Stepper("库存数量: \(stock)", value: $stock, in: 0...100)
                    
                    TextField("单价", value: $price, format: .currency(code: "CNY"))
                        .keyboardType(.decimalPad)
                }
                
                Section("补货提醒") {
                    Toggle("库存不足提醒", isOn: $enableNotification)
                    
                    if enableNotification {
                        Stepper("库存预警阈值: \(stockThreshold)", value: $stockThreshold, in: 1...10)
                    }
                }
            }
            .navigationTitle("添加物品")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveItem()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveItem() {
        // TODO: 实现保存逻辑
    }
} 