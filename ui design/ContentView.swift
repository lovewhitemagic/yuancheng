//
//  ContentView.swift
//  CleaningAssistant
//

import SwiftUI

struct ContentView: View {
    @StateObject private var themeManager = ThemeManager()
    @State private var showOnboarding = true
    @State private var columnCount: Int = 2
    @State private var taskSections: [TaskSection] = [
        TaskSection(
            title: "每日清洁",
            tasks: [
                CleaningTask(name: "整理床铺", isCompleted: true, tools: ["床单", "枕套"]),
                CleaningTask(name: "擦拭桌面", isCompleted: false, tools: ["抹布", "清洁剂"]),
                CleaningTask(name: "清理垃圾", isCompleted: false, tools: ["垃圾袋"])
            ],
            isExpanded: true
        ),
        TaskSection(
            title: "每周清洁",
            tasks: [
                CleaningTask(name: "吸尘", isCompleted: false, tools: ["吸尘器"]),
                CleaningTask(name: "拖地", isCompleted: false, tools: ["拖把", "清洁剂"]),
                CleaningTask(name: "清洁浴室", isCompleted: false, tools: ["刷子", "消毒剂"])
            ],
            isExpanded: false
        ),
        TaskSection(
            title: "每月清洁",
            tasks: [
                CleaningTask(name: "清洁窗户", isCompleted: false, tools: ["玻璃清洁剂", "抹布"]),
                CleaningTask(name: "深度除尘", isCompleted: false, tools: ["除尘刷", "吸尘器"])
            ],
            isExpanded: false
        )
    ]
    
    var body: some View {
        if showOnboarding {
            OnboardingView(showOnboarding: $showOnboarding)
        } else {
            TabView {
                HomeView(taskSections: $taskSections, columnCount: $columnCount)
                    .tabItem {
                        Label("首页", systemImage: "house")
                    }
                
                CleaningCalendarView()
                    .tabItem {
                        Label("日历", systemImage: "calendar")
                    }
                
                ChecklistView()
                    .tabItem {
                        Label("清单", systemImage: "list.bullet")
                    }
                
                SettingsView()
                    .environmentObject(themeManager)
                    .tabItem {
                        Label("设置", systemImage: "gear")
                    }
            }
            .preferredColorScheme(themeManager.colorScheme)
        }
    }
}

#Preview {
    ContentView()
}
