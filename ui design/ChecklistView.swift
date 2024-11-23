import SwiftUI

struct ChecklistView: View {
    @State private var items: [ChecklistItem] = [
        ChecklistItem(name: "清洁剂", frequency: "每月", lastPurchaseDate: Date(), stock: 2, price: 29.9),
        ChecklistItem(name: "抹布", frequency: "每周", lastPurchaseDate: Date(), stock: 5, price: 9.9),
        ChecklistItem(name: "垃圾袋", frequency: "每周", lastPurchaseDate: Date(), stock: 0, price: 15.9)
    ]
    @State private var showingAddItem = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    NavigationLink(destination: ChecklistItemDetailView(item: item)) {
                        ChecklistItemRow(item: item)
                    }
                }
                
                // 添加新物品按钮
                Button(action: {
                    showingAddItem = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                        Text("添加新物品")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("清洁清单")
            // 移除toolbar中的添加按钮
            .sheet(isPresented: $showingAddItem) {
                AddChecklistItemView()
            }
        }
    }
}

struct ChecklistItemRow: View {
    let item: ChecklistItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                Text("频率: \(item.frequency)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("库存: \(item.stock)")
                    .foregroundColor(item.stockStatus.color)
                Text("¥\(String(format: "%.2f", item.price))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
} 