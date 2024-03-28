import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var manager: CanvasManager
    
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            
            CanvasView(manager: manager)
            
            if manager.isShowToolbar {
                VStack(alignment: .trailing) {
                    TopToolbarView()
                        .transition(.move(edge: .top))
                    
                    Spacer()
                }
            }
        }
        .onReceive(manager.keyboardPublisher) { value in
            withAnimation {
                manager.isShowToolbar = !value
            }
        }
        .alert(manager.alertTitle, isPresented: $manager.isShowAlert) { 
            
        } message: { 
            Text(manager.alertMessage)
        }
    }
}
