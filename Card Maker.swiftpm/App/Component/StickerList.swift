import SwiftUI

struct StickerList: View {
    
    @EnvironmentObject var manager: CanvasManager
    let geometry: GeometryProxy
    
    private var columns: [GridItem] {
        return Array.init(repeating: GridItem(.flexible(minimum: 60)), count: 3)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("Stickers")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    manager.isShowStickerList = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(StickerModel.stickerList) { sticker in
                        Button {
                            manager.addSticker(sticker, position: geometry.size)
                        } label: {
                            sticker.image
                                .resizable()
                                .scaledToFit()
                                .padding()
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
        }
        .padding(.top)
    }
}
