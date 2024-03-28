import SwiftUI
//#-learning-task(StickerView)

struct StickerView: View {
    
    /*#-code-walkthrough(2.properties)*/
    @Binding var sticker: StickerModel
    @State var activate: (UUID) -> Void
    @State var delete: (UUID) -> Void
    /*#-code-walkthrough(2.properties)*/
    
    //#-learning-task(GestureLogic)
    var body: some View {
        /*#-code-walkthrough(2.stickerBaseModifier)*/
        sticker.image

        /*#-code-walkthrough(2.stickerBaseModifier)*/
        /*#-code-walkthrough(2.onTapGesture)*/
            // MARK: on tap gesture modifier
            
            .overlay {
                if sticker.isActive {
                    Rectangle()
                        .stroke(Color.pink, lineWidth: 1 / sticker.scale)
                }
            }
            .overlay(alignment: .topTrailing) {
                if sticker.isActive {
                    deleteButton
                        .scaleEffect(1 / sticker.scale)
                        .offset(x: 12, y: -12)
                }
            }
        /*#-code-walkthrough(2.onTapGesture)*/
            .scaleEffect(sticker.scale)
            .rotationEffect(sticker.rotation)
            .position(sticker.position)
        /*#-code-walkthrough(2.dragGesture)*/
        // MARK: drag gesture modifier
        
        /*#-code-walkthrough(2.roationGesture)*/
        
        /*#-code-walkthrough(2.roationGesture)*/
        /*#-code-walkthrough(2.maginificationGesture)*/
        
        /*#-code-walkthrough(2.maginificationGesture)*/
        /*#-code-walkthrough(2.dragGesture)*/
            .padding(32)
    }
    
    @ViewBuilder
    var deleteButton: some View {
        Button {
            delete(sticker.id)
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 24))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.black, Color.white)
                .shadow(color: .black.opacity(0.2), radius: 10)
        }
    }
}

fileprivate struct Preview: View {
    
    @State var sticker = StickerModel(image: Image("cat"))
    
    var body: some View {
        ZStack {
            Color.white
                .onTapGesture {
                    sticker.isActive = false
                }
            
            StickerView(
                sticker: $sticker,
                activate: { _ in
                    sticker.isActive = true
                },
                delete: { _ in}
            )
        }
    }
}

struct StickerView_Preview: PreviewProvider {
    static var previews: some View {
        Preview()
    }
}
