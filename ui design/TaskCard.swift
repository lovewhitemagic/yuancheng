import SwiftUI

struct TaskCard: View {
    let task: CleaningTask
    let completeAction: () -> Void
    let editAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 图片区域
            ZStack(alignment: .topTrailing) {
                if let imageData = task.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 120)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                        )
                }
                
                // 完成状态和编辑按钮
                HStack(spacing: 8) {
                    Button(action: editAction) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .background(Color.white.clipShape(Circle()))
                    }
                    
                    Button(action: completeAction) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle.fill")
                            .font(.title2)
                            .foregroundColor(task.isCompleted ? .green : .white)
                            .background(Color.white.clipShape(Circle()))
                    }
                }
                .padding(8)
            }
            
            // 任务信息
            VStack(alignment: .leading, spacing: 8) {
                Text(task.name)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .gray : .primary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(task.tools, id: \.self) { tool in
                            Text(tool)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding(12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
} 