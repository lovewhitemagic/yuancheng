import SwiftUI
import PhotosUI

struct ScoreRecord: Identifiable {
    let id = UUID()
    let score: Int
    let date: Date
    let imageURL: String
    let suggestion: String
}

struct CleanlinessScoreView: View {
    @State private var showingImagePicker = false
    @State private var selectedImage: PhotosPickerItem?
    @State private var scoreRecords: [ScoreRecord] = [
        ScoreRecord(score: 85, date: Date().addingTimeInterval(-86400), 
                   imageURL: "room1", suggestion: "房间整体整洁，建议定期除尘"),
        ScoreRecord(score: 75, date: Date().addingTimeInterval(-172800), 
                   imageURL: "room2", suggestion: "床铺需要整理，地面有轻微杂物"),
        ScoreRecord(score: 90, date: Date().addingTimeInterval(-259200), 
                   imageURL: "room3", suggestion: "非常好！保持这样的整洁状态")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 当前评分展示
                    CurrentScoreCard(score: scoreRecords.first?.score ?? 0,
                                   suggestion: scoreRecords.first?.suggestion ?? "")
                    
                    // 历史记录
                    VStack(alignment: .leading, spacing: 16) {
                        Text("历史记录")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(scoreRecords) { record in
                            NavigationLink(destination: ScoreDetailView(record: record)) {
                                ScoreRecordCard(record: record)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("整洁度评分")
            .toolbar {
                PhotosPicker(selection: $selectedImage,
                           matching: .images) {
                    Image(systemName: "camera")
                }
            }
            .onChange(of: selectedImage) { _ in
                // TODO: 处理选中的图片
                analyzeImage()
            }
        }
    }
    
    private func analyzeImage() {
        // TODO: 实现图片分析逻辑
    }
}

struct CurrentScoreCard: View {
    let score: Int
    let suggestion: String
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: CGFloat(score) / 100)
                    .stroke(scoreColor, lineWidth: 12)
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(score)")
                        .font(.title)
                        .bold()
                    Text("分")
                        .font(.subheadline)
                }
            }
            
            Text(suggestion)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    var scoreColor: Color {
        switch score {
        case 90...100: return .green
        case 70..<90: return .yellow
        default: return .red
        }
    }
}

struct ScoreRecordCard: View {
    let record: ScoreRecord
    
    var body: some View {
        HStack(spacing: 16) {
            Image(record.imageURL)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(record.score)分")
                    .font(.headline)
                Text(record.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(record.suggestion)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
} 