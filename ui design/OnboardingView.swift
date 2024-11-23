import SwiftUI

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            image: "clock.circle.fill",
            title: "智能计时",
            description: "为每个清洁任务精确计时，帮助您更好地规划时间"
        ),
        OnboardingPage(
            image: "calendar.circle.fill",
            title: "任务管理",
            description: "轻松管理每日、每周、每月的清洁任务"
        ),
        OnboardingPage(
            image: "chart.bar.fill",
            title: "整洁评分",
            description: "通过照片记录和评分，追踪居室整洁度"
        ),
        OnboardingPage(
            image: "checklist.circle.fill",
            title: "清洁清单",
            description: "管理清洁用品，及时补充库存"
        )
    ]
    
    var body: some View {
        ZStack {
            // 背景渐变
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo和标题
                VStack(spacing: 20) {
                    Image(systemName: "sparkles.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("清洁助手")
                        .font(.largeTitle)
                        .bold()
                }
                
                // 页面指示器
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 30) {
                            Image(systemName: pages[index].image)
                                .font(.system(size: 60))
                                .foregroundColor(.blue)
                            
                            Text(pages[index].title)
                                .font(.title2)
                                .bold()
                            
                            Text(pages[index].description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 40)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 300)
                
                Spacer()
                
                // 开始使用按钮
                Button(action: {
                    withAnimation {
                        showOnboarding = false
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "开始使用" : "继续")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 50)
            }
        }
    }
} 