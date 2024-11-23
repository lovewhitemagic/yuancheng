import SwiftUI

struct ScoreDetailView: View {
    let record: ScoreRecord
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 照片展示
                Image(record.imageURL)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
                
                // 评分展示
                HStack {
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(record.score) / 100)
                            .stroke(scoreColor, lineWidth: 12)
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text("\(record.score)")
                                .font(.title)
                                .bold()
                            Text("分")
                                .font(.subheadline)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("评分时间")
                            .font(.headline)
                        Text(record.date.formatted())
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // 建议详情
                VStack(alignment: .leading, spacing: 12) {
                    Text("整理建议")
                        .font(.headline)
                    
                    Text(record.suggestion)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
            }
            .padding()
        }
        .navigationTitle("评分详情")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
    
    var scoreColor: Color {
        switch record.score {
        case 90...100: return .green
        case 70..<90: return .yellow
        default: return .red
        }
    }
} 