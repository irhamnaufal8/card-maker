import PhotosUI
import SwiftUI

struct TopToolbarView: View {
    
    @EnvironmentObject var manager: CanvasManager
    
    var body: some View {
        HStack(spacing: 16) {
            Menu { 
                Picker("Background Color", selection: $manager.bgColor) { 
                    ForEach(ThemeColor.allCases.dropLast(), id: \.self) { tag in
                        Image(systemName: "circle.fill")
                            .tint(tag.bgColor)
                            .tag(tag)
                    }
                }
                .pickerStyle(.palette)
            } label: { 
                Circle()
                    .fill(manager.bgColor.bgColor)
                    .frame(width: 24, height: 24)
                    .overlay {
                        Circle()
                            .inset(by: 0.5)
                            .stroke(Color.black)
                    }
            }
            
            PhotosPicker(selection: $manager.photo, matching: .images) { 
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 22))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.blue, Color.pink)
            }
            
            Button {
                manager.isShowStickerList = true
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Color.pink)
            }
            
            Divider()
            
            Menu("Export") {
                Button {
                    manager.saveAsPhoto()
                } label: {
                    Label("Save as a Photo", systemImage: "photo")
                }
                .onAppear {
                    manager.saveAsPDF()
                }
                .onDisappear {
                    manager.pdfURL = nil
                }
                
                if let pdfURL = manager.pdfURL {
                    ShareLink(item: pdfURL) { 
                        Label("Save as a PDF", systemImage: "doc.text")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: 32)
        .padding()
        .background(
            Color.white.ignoresSafeArea()
                .shadow(color: .black.opacity(0.1), radius: 10)
        )
    }
}
