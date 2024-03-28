import Combine
import PhotosUI
import SwiftUI
//#-learning-task(CanvasManager)

final class CanvasManager: NSObject, ObservableObject {
    
    /*#-code-walkthrough(1.mainProperty)*/
    @Published var bgColor: ThemeColor = .pink
    
    @Published var title: TextModel = .title
    @Published var messages: [TextModel] = TextModel.tutorials
    @Published var draggedMessage: TextModel?
    
    @Published var stickers: [StickerModel] = []
    
    @Published var photo: PhotosPickerItem?
    @Published var pdfURL: URL?
    /*#-code-walkthrough(1.mainProperty)*/
    
    /*#-code-walkthrough(1.additionalProperty)*/
    @Published var isRendering = false
    @Published var isShowToolbar = true
    @Published var isShowStickerList = false
    
    @Published var isShowAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    /*#-code-walkthrough(1.additionalProperty)*/
    
    /*#-code-walkthrough(1.keyboardPublisher)*/
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        let showPublisher = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
        
        return showPublisher
            .eraseToAnyPublisher()
    }
    /*#-code-walkthrough(1.keyboardPublisher)*/
    
    /*#-code-walkthrough(1.textFunction)*/
    func addAnotherText() {
        DispatchQueue.main.async { [weak self] in
            self?.messages.append(TextModel(text: "Write your message here.."))
        }
    }
    
    @MainActor
    func deleteText(_ text: TextModel) {
        guard messages.count > 1 else { return }
        messages.removeAll { $0.id == text.id }
    }
    /*#-code-walkthrough(1.textFunction)*/
    
    /*#-code-walkthrough(1.stickerFunction)*/
    @MainActor
    func addSticker(_ sticker: StickerModel, position: CGSize) {
        var newSticker = sticker
        newSticker.id = UUID()
        newSticker.position = CGPoint(x: position.width/2, y: position.height/2)
        stickers.append(newSticker)
        isShowStickerList = false
    }
    
    func deleteSticker(_ id: UUID) {
        DispatchQueue.main.async { [weak self] in
            self?.stickers.removeAll(where: { $0.id == id })
        }
    }
    
    func activateSticker(_ id: UUID) {
        stickers.indices.forEach { index in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.stickers[index].isActive = self.stickers[index].id == id
            }
        }
    }
    
    @MainActor
    private func unActiveAllStickers() {
        guard !stickers.isEmpty else { return }
        stickers.indices.forEach { index in
            stickers[index].isActive = false
        }
    }
    /*#-code-walkthrough(1.stickerFunction)*/
    
    @MainActor
    func addPhoto(_ photo: PhotosPickerItem, position: CGSize) {
        Task {
            if let data = try? await photo.loadTransferable(type: Data.self) {
                guard let uiImage = UIImage(data: data) else { return }
                var sticker = StickerModel(image: Image(uiImage: uiImage))
                sticker.position = CGPoint(x: position.width/2, y: position.height/2)
                self.stickers.append(sticker)
                self.photo = nil
            }
        }
    }
    
    //#-learning-task(CanvasManager)
    /*#-code-walkthrough(3.cardRenderer)*/
    @MainActor
    private func cardRenderer() -> ImageRenderer<CanvasView> {
        let renderer = ImageRenderer(content: CanvasView(manager: self))

        renderer.proposedSize = .init(width: 600, height: 800)
        renderer.scale = 3
        return renderer
    }
    /*#-code-walkthrough(3.cardRenderer)*/
    
    /*#-code-walkthrough(3.saveAsPhoto)*/
    @MainActor
    func saveAsPhoto() {
        isRendering = true
        
        guard let image = cardRenderer().uiImage else {
            isRendering = false
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(savePhotoCompleted), nil)
    }
    /*#-code-walkthrough(3.saveAsPhoto)*/
    
    /*#-code-walkthrough(3.savePhotoCompleted)*/
    @objc private func savePhotoCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        isRendering = false
        if let error {
            alertTitle = "Failed to Save Card"
            alertMessage = error.localizedDescription
        } else {
            alertTitle = "Card Saved Successfully"
            alertMessage = "Your card has been exported and is now available in the Photo Gallery"
        }
        isShowAlert = true
    }
    /*#-code-walkthrough(3.savePhotoCompleted)*/
    
    /*#-code-walkthrough(3.saveAsPDF)*/
    @MainActor
    func saveAsPDF() {
        self.isRendering = true
        let url = URL.documentsDirectory.appending(path: "My Card.pdf")
        
        cardRenderer().render { size, context in
            var mediaBox = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            guard let pdf = CGContext(url as CFURL, mediaBox: &mediaBox, nil) else { return }
            
            pdf.beginPDFPage(nil)
            context(pdf)
            pdf.endPDFPage()
            pdf.closePDF()
            self.isRendering = false
        }
        
        pdfURL = url
    }
    /*#-code-walkthrough(3.saveAsPDF)*/
    
    @MainActor
    func hideKeyboard() {
        unActiveAllStickers()
        withAnimation {
            isShowToolbar = true
        }
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIApplication {
    var keyUIWindow: UIWindow? {
        return self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }    
}
