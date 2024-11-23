import SwiftUI

struct HomeView: View {
    @Binding var taskSections: [TaskSection]
    @Binding var columnCount: Int
    
    private var columns: [GridItem] {
        Array(repeating: .init(.flexible()), count: columnCount)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach($taskSections) { $section in
                        TaskSectionView(section: $section)
                    }
                }
                .padding()
            }
            .navigationTitle("清洁助手")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { columnCount = 1 }) {
                            Label("单列", systemImage: columnCount == 1 ? "checkmark" : "")
                        }
                        Button(action: { columnCount = 2 }) {
                            Label("双列", systemImage: columnCount == 2 ? "checkmark" : "")
                        }
                        Button(action: { columnCount = 3 }) {
                            Label("三列", systemImage: columnCount == 3 ? "checkmark" : "")
                        }
                    } label: {
                        Image(systemName: "square.grid.2x2")
                    }
                }
            }
        }
    }
}