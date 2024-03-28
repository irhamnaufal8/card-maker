import SwiftUI

struct CanvasView: View {
    
    @ObservedObject var manager: CanvasManager
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                manager.bgColor.bgColor
                    .onTapGesture {
                        manager.hideKeyboard()
                    }
                    .contextMenu {
                        if let uiImage = UIPasteboard.general.image {
                            Button {
                                manager.addSticker(.init(image: Image(uiImage: uiImage)), position: geometry.size)
                            } label: {
                                Label("Paste Image", systemImage: "doc.on.clipboard")
                            }
                        }
                    }
                
                ForEach($manager.stickers) { $sticker in
                    StickerView(
                        sticker: $sticker, 
                        activate: manager.activateSticker, 
                        delete: manager.deleteSticker
                    )
                }
                
                VStack(spacing: 18) {     
                    MultilineTextField(text: $manager.title, isRendering: $manager.isRendering) { 
                        manager.title.text = ""
                    }
                    
                    ForEach($manager.messages) { $text in
                        MultilineTextField(text: $text, isRendering: $manager.isRendering, type: .message(manager.messages.last?.id == text.id, manager.addAnotherText)) {
                            manager.deleteText(text)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, 64)
                .padding(.vertical, 82)
            }
            .preferredColorScheme(.light)
            .frame(width: 600, height: 800)
            .clipped()
            .scaleEffect(calculateScale(containerSize: geometry.size))
            .frame(width: geometry.size.width, height: geometry.size.height)
            .sheet(isPresented: $manager.isShowStickerList) {
                StickerList(geometry: geometry)
            }
            .onChange(of: manager.photo) { _, selectedImage in
                guard let selectedImage else { return }
                manager.addPhoto(selectedImage, position: geometry.size)
            }
        }
    }
    
    private func calculateScale(containerSize: CGSize) -> CGFloat {
        let widthScale = containerSize.width / 600
        let heightScale = containerSize.height / 800
        return min(widthScale, heightScale)
    }
}
