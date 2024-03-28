import SwiftUI
//#-learning-task(TextModel)

struct TextModel: Identifiable, Equatable {
    var id = UUID()
    var text: String
    /*#-code-walkthrough(2.typography)*/
    var typography: Font.Design = .default
    /*#-code-walkthrough(2.typography)*/
    /*#-code-walkthrough(2.alignment)*/
    var alignment: TextAlignment = .leading
    /*#-code-walkthrough(2.alignment)*/
    /*#-code-walkthrough(2.colorProperty)*/
    var color: ThemeColor = .black
    /*#-code-walkthrough(2.colorProperty)*/
    /*#-code-walkthrough(2.textStyle)*/
    var isBold = false
    var isItalic = false
    var underline: UnderlinePattern = .none
    var underlineColor: ThemeColor = .initial
    /*#-code-walkthrough(2.textStyle)*/
    
    /*#-code-walkthrough(2.static)*/
    static let title = TextModel(
        text: "Hello There!",
        typography: .serif,
        alignment: .center,
        isBold: true
    )
    
    static let tutorials: [TextModel] = [
        .init(text: "Let's write a beautiful card 📝\nBut first, you need to complete the guide so that the features of this app can work properly."),
        .init(
            text: "Tap me and tap the three-dots button!\nYou can customize the text like this 😎", 
            isItalic: true, 
            underline: .dash, 
            underlineColor: .purple
        ),
        .init(
            text: "*you can also copy an image from another app and long press on the canvas to paste it 🤫", 
            color: .blue, 
            isBold: true
        ),
    ]
    /*#-code-walkthrough(2.static)*/
}

/*#-code-walkthrough(2.colorEnum)*/
enum ThemeColor: CaseIterable {
    case black, red, orange, green, blue, purple, pink, initial
    
    var color: Color {
        switch self {
        case .black: .black
        case .red: .red
        case .orange: .orange
        case .green: .green
        case .blue: .blue
        case .purple: .purple
        case .pink: .pink
        case .initial: .clear
        }
    }
    
    var bgColor: Color {
        switch self {
        case .black: Color.white
        case .red: Color(red: 1, green: 0.89, blue: 0.89)
        case .orange: Color(red: 1, green: 0.94, blue: 0.89)
        case .green: Color(red: 0.93, green: 1, blue: 0.87)
        case .blue: Color(red: 0.89, green: 0.93, blue: 1)
        case .purple: Color(red: 0.94, green: 0.89, blue: 1)
        case .pink: Color(red: 1, green: 0.89, blue: 1)
        case .initial: Color.clear
        }
    }
}
/*#-code-walkthrough(2.colorEnum)*/

enum UnderlinePattern: String, CaseIterable {
    case none = "None"
    case solid = "Solid"
    case dot = "Dot"
    case dash = "Dash"
    case dashDot = "Dash-Dot"
    case dashDotDot = "Dash-Dot-Dot"
    
    var style: Text.LineStyle.Pattern? {
        switch self {
        case .solid: .solid
        case .dot: .dot
        case .dash: .dash
        case .dashDot: .dashDot
        case .dashDotDot: .dashDotDot
        case .none: nil
        }
    }
}

extension Font.Design: CaseIterable {
    var name: String {
        switch self {
        case .default: "Default"
        case .serif: "Serif"
        case .rounded: "Rounded"
        case .monospaced: "Monospaced"
        @unknown default: "Default"
        }
    }
    
    public static var allCases: [Font.Design] {
        [.default, .monospaced, .rounded, .serif]
    }
}
