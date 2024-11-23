import SwiftUI

struct ChecklistItemDetailView: View {
    let item: ChecklistItem
    @State private var isEditing = false
    
    var body: some View {
        List {
            Section("基本信息") {
                LabeledContent("物品名称", value: item.name)
                LabeledContent("使用频率", value: item.frequency)
                LabeledContent("库存数量", value: "\(item.stock)个")
                    .foregroundColor(item.stockStatus.color)
                LabeledContent("单价", value: String(format: "¥%.2f", item.price))
            }
            
            Section("购买记录") {
                LabeledContent("上次购买", value: item.lastPurchaseDate.formatted(date: .abbreviated, time: .omitted))
                LabeledContent("总支出", value: String(format: "¥%.2f", item.price * Double(item.stock)))
            }
            
            Section("补货提醒") {
                Toggle("库存不足提醒", isOn: .constant(true))
                Stepper("库存预警阈值: 2", value: .constant(2))
            }
            
            Section("备注") {
                Text("这里是关于\(item.name)的使用说明和注意事项...")
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle(item.name)
        .toolbar {
            Button("编辑") {
                isEditing = true
            }
        }
        .sheet(isPresented: $isEditing) {
            EditChecklistItemView(item: item)
        }
    }
}

struct EditChecklistItemView: View {
    let item: ChecklistItem
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var frequency: String
    @State private var stock: Int
    @State private var price: Double
    
    init(item: ChecklistItem) {
        self.item = item
        _name = State(initialValue: item.name)
        _frequency = State(initialValue: item.frequency)
        _stock = State(initialValue: item.stock)
        _price = State(initialValue: item.price)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("基本信息") {
                    TextField("物品名称", text: $name)
                    TextField("使用频率", text: $frequency)
                    Stepper("库存数量: \(stock)", value: $stock)
                    TextField("单价", value: $price, format: .currency(code: "CNY"))
                }
            }
            .navigationTitle("编辑物品")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        // TODO: 实现保存逻辑
                        dismiss()
                    }
                }
            }
        }
    }
} 