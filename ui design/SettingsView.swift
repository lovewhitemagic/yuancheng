import SwiftUI

enum AppTheme: String, CaseIterable {
    case light = "浅色"
    case dark = "深色"
    case system = "跟随系统"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

class ThemeManager: ObservableObject {
    @Published var selectedTheme: AppTheme = .system
    
    var colorScheme: ColorScheme? {
        selectedTheme.colorScheme
    }
}

struct SettingsView: View {
    @StateObject private var themeManager = ThemeManager()
    @State private var enableReminders = true
    @State private var reminderFrequency = "每日"
    @State private var enableVoiceAssistant = false
    @State private var enableTips = true
    @State private var tipsFrequency = "每周"
    
    let frequencies = ["每日", "每周", "每月"]
    let tipsFrequencies = ["每日", "每周", "每月"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("主题设置") {
                    Picker("主题", selection: $themeManager.selectedTheme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                }
                
                Section("提醒设置") {
                    Toggle("开启提醒", isOn: $enableReminders)
                    
                    if enableReminders {
                        Picker("提醒频率", selection: $reminderFrequency) {
                            ForEach(frequencies, id: \.self) { frequency in
                                Text(frequency).tag(frequency)
                            }
                        }
                    }
                }
                
                Section("语音助手") {
                    Toggle("启用语音助手", isOn: $enableVoiceAssistant)
                    
                    if enableVoiceAssistant {
                        NavigationLink("设置快捷指令") {
                            VoiceCommandSettingsView()
                        }
                    }
                }
                
                Section("清洁小贴士") {
                    Toggle("接收清洁建议", isOn: $enableTips)
                    
                    if enableTips {
                        Picker("推送频率", selection: $tipsFrequency) {
                            ForEach(tipsFrequencies, id: \.self) { frequency in
                                Text(frequency).tag(frequency)
                            }
                        }
                    }
                }
                
                Section("关于") {
                    NavigationLink("使用帮助") {
                        HelpView()
                    }
                    NavigationLink("隐私政策") {
                        PrivacyPolicyView()
                    }
                    Text("版本 1.0.0")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("设置")
        }
        .preferredColorScheme(themeManager.colorScheme)
    }
}

struct VoiceCommandSettingsView: View {
    var body: some View {
        List {
            Section("可用命令") {
                Text("「开始清洁」")
                Text("「设置提醒」")
                Text("「查看任务」")
            }
        }
        .navigationTitle("语音命令")
    }
}

struct HelpView: View {
    var body: some View {
        List {
            Section("基本使用") {
                Text("如何添加任务")
                Text("如何设置提醒")
                Text("如何使用计时器")
            }
        }
        .navigationTitle("使用帮助")
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            Text("这里是隐私政策内容...")
                .padding()
        }
        .navigationTitle("隐私政策")
    }
} 