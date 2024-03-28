import SwiftUI
//#-learning-task(StickerModel)

struct StickerModel: Identifiable {
    var id = UUID()
    /*#-code-walkthrough(3.image)*/
    var image: Image
    /*#-code-walkthrough(3.image)*/
    /*#-code-walkthrough(3.isActive)*/
    var isActive = false
    /*#-code-walkthrough(3.isActive)*/
    /*#-code-walkthrough(3.stickerProperties)*/
    var position: CGPoint = .zero
    var scale: CGFloat = 1.0
    var rotation: Angle = .zero
    /*#-code-walkthrough(3.stickerProperties)*/
    
    /*#-code-walkthrough(3.staticList)*/
    static let stickerList: [StickerModel] = [
        .init(image: Image("sticker 1")),
        .init(image: Image("sticker 2")),
        .init(image: Image("sticker 3")),
        .init(image: Image("sticker 4")),
        .init(image: Image("sticker 5")),
        .init(image: Image("sticker 6")),
        .init(image: Image("sticker 7")),
        .init(image: Image("sticker 8")),
        .init(image: Image("sticker 9")),
        .init(image: Image("sticker 10")),
        .init(image: Image("sticker 11")),
        .init(image: Image("sticker 12")),
        .init(image: Image("sticker 13")),
        .init(image: Image("sticker 14")),
        .init(image: Image("sticker 15")),
        .init(image: Image("sticker 16")),
        .init(image: Image("sticker 17")),
        .init(image: Image("sticker 18")),
        .init(image: Image("sticker 19")),
        .init(image: Image("sticker 20")),
        .init(image: Image("sticker 21")),
        .init(image: Image("sticker 22")),
        .init(image: Image("sticker 23")),
        .init(image: Image("sticker 24")),
    ]
    /*#-code-walkthrough(3.staticList)*/
}
