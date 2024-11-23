import SwiftUI

struct TaskSectionView: View {
    @Binding var section: TaskSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                withAnimation {
                    section.isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(section.title)
                        .font(.headline)
                    Spacer()
                    Image(systemName: section.isExpanded ? "chevron.up" : "chevron.down")
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            
            if section.isExpanded {
                VStack(spacing: 8) {
                    ForEach($section.tasks) { $task in
                        TaskRowView(task: $task)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct TaskRowView: View {
    @Binding var task: CleaningTask
    
    var body: some View {
        HStack {
            Button(action: {
                task.isCompleted.toggle()
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.name)
                    .strikethrough(task.isCompleted)
                
                HStack {
                    ForEach(task.tools, id: \.self) { tool in
                        Text(tool)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
} 