import SwiftUI
import PhotosUI

struct EditTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var task: CleaningTask
    @State private var taskName: String
    @State private var selectedTools: Set<String>
    @State private var showingImagePicker = false
    @State private var showingPhotoOptions = false
    @State private var selectedImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    init(task: Binding<CleaningTask>) {
        self._task = task
        self._taskName = State(initialValue: task.wrappedValue.name)
        self._selectedTools = State(initialValue: Set(task.wrappedValue.tools))
        if let imageData = task.wrappedValue.imageData {
            self._selectedImage = State(initialValue: UIImage(data: imageData))
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("任务信息") {
                    TextField("任务名称", text: $taskName)
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
                        
                        Button(action: {
                            showingPhotoOptions = true
                        }) {
                            VStack {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.system(size: 24))
                                Text("选择照片")
                                    .font(.caption)
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
            .navigationTitle("编辑任务")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveChanges()
                        dismiss()
                    }
                }
            }
            .confirmationDialog("选择照片来源", isPresented: $showingPhotoOptions) {
                Button("拍照") {
                    showingImagePicker = true
                    sourceType = .camera
                }
                Button("从相册选择") {
                    showingImagePicker = true
                    sourceType = .photoLibrary
                }
                Button("取消", role: .cancel) {}
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: sourceType)
            }
        }
    }
    
    private func saveChanges() {
        task.name = taskName
        task.tools = Array(selectedTools)
        task.imageData = selectedImage?.jpegData(compressionQuality: 0.8)
    }
} 