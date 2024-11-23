import SwiftUI

struct ToolSelectionView: View {
    @Binding var selectedTools: Set<String>
    
    let availableTools = [
        "吸尘器",
        "拖把",
        "抹布",
        "清洁剂",
        "扫把",
        "垃圾袋",
        "水桶",
        "海绵"
    ]
    
    var body: some View {
        List {
            ForEach(availableTools, id: \.self) { tool in
                Button {
                    if selectedTools.contains(tool) {
                        selectedTools.remove(tool)
                    } else {
                        selectedTools.insert(tool)
                    }
                } label: {
                    HStack {
                        Text(tool)
                        Spacer()
                        if selectedTools.contains(tool) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .navigationTitle("选择工具")
    }
} 