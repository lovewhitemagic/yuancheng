import SwiftUI
import PhotosUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var taskName = ""
    @State private var selectedFrequency = TaskFrequency.daily
    @State private var selectedTools: Set<String> = []
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var selectedImage: UIImage?
    @Binding var taskSections: [TaskSection]
    
    enum TaskFrequency: String, CaseIterable {
        case daily = "每日"
        case weekly = "每周"
        case monthly = "每月"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("任务信息") {
                    TextField("任务名称", text: $taskName)
                    
                    Picker("任务频率", selection: $selectedFrequency) {
                        ForEach(TaskFrequency.allCases, id: \.self) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                        }
                    }
                }
                
                Section("照片") {
                    HStack {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                showingCamera = true
                            }) {
                                VStack {
                                    Image(systemName: "camera")
                                        .font(.system(size: 24))
                                    Text("拍照")
                                        .font(.caption)
                                }
                            }
                            
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                VStack {
                                    Image(systemName: "photo.on.rectangle")
                                        .font(.system(size: 24))
                                    Text("相册")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .frame(height: 100)
                }
                
                Section("工具选择") {
                    NavigationLink(destination: ToolSelectionView(selectedTools: $selectedTools)) {
                        HStack {
                            Text("所需工具")
                            Spacer()
                            Text("\(selectedTools.count)个已选")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("添加任务")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveTask()
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingCamera) {
                ImagePicker(image: $selectedImage, sourceType: .camera)
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
            }
        }
    }
    
    private func saveTask() {
        // 创建新任务
        let newTask = CleaningTask(
            name: taskName,
            isCompleted: false,
            tools: Array(selectedTools),
            imageData: selectedImage?.jpegData(compressionQuality: 0.8)
        )
        
        // 根据选择的频率确定添加到哪个分类
        let sectionTitle: String
        switch selectedFrequency {
        case .daily:
            sectionTitle = "每日清洁"
        case .weekly:
            sectionTitle = "每周清洁"
        case .monthly:
            sectionTitle = "每月清洁"
        }
        
        // 找到对应的分类并在顶部插入新任务
        if let sectionIndex = taskSections.firstIndex(where: { $0.title == sectionTitle }) {
            taskSections[sectionIndex].tasks.insert(newTask, at: 0)
        }
        
        dismiss()
    }
}

// 图片选择器
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.modalPresentationStyle = .fullScreen
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                let fixedImage = image.fixOrientation()
                parent.image = fixedImage
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// 添加UIImage扩展来修复图片方向
extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage ?? self
    }
} 