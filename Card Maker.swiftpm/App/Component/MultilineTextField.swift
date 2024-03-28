import SwiftUI
//#-learning-task(MultilineTextField)

/*#-code-walkthrough(1.textFieldType)*/
enum TextFieldType {
    case title
    case message(Bool, () -> Void)
}
/*#-code-walkthrough(1.textFieldType)*/

struct MultilineTextField: View {
    
    /*#-code-walkthrough(1.properties)*/
    @Binding private var text: TextModel
    @Binding private var isRendering: Bool
    private let type: TextFieldType
    private let delete: (() -> Void)?
    /*#-code-walkthrough(1.properties)*/
    
    /*#-code-walkthrough(1.isFocused)*/
    @FocusState private var isFocused: Bool
    /*#-code-walkthrough(1.isFocused)*/
    
    private var style: Font.TextStyle {
        switch type {
        case .title: .largeTitle
        case .message: .body
        }
    }
    
    private var frameAlignment: Alignment {
        switch text.alignment {
        case .leading: .leading
        case .center: .center
        case .trailing: .trailing
        }
    }
    
    init(
        text: Binding<TextModel>,
        isRendering: Binding<Bool>,
        type: TextFieldType = .title,
        delete: (() -> Void)? = nil
    ) {
        self._text = text
        self._isRendering = isRendering
        self.type = type
        self.delete = delete
    }
    
    var body: some View {
        /*#-code-walkthrough(1.group)*/
        Group {
            if isRendering {
                Text(text.text)
                    .frame(maxWidth: .infinity, alignment: frameAlignment)
            } else {
                TextField("Your text here..", text: $text.text, axis: .vertical)
            }
        }
        /*#-code-walkthrough(1.group)*/
        .foregroundStyle(text.color.color)
        /*#-code-walkthrough(1.textStyleModifiers)*/

        /*#-code-walkthrough(1.textStyleModifiers)*/
        .onSubmit {
            text.text.append("\n")
            isFocused = true
        }
        .overlay {
            if isFocused {
                Rectangle()
                    .stroke(Color.pink, lineWidth: 1)
                    .overlay(alignment: .topTrailing) {
                        menuButton
                            .offset(x: 12, y: -12)
                    }
            }
        }
        .overlay(alignment: .bottom) {
            if isFocused {
                plusButton
                    .offset(y: 32)
            }
        }
    }
    
    @ViewBuilder
    private var menuButton: some View {
        Menu {
            Picker(selection: $text.typography) {
                ForEach(Font.Design.allCases, id: \.self) { tag in
                    Text(tag.name)
                        .font(.system(.body, design: tag))
                        .tag(tag)
                }
            } label: {
                Label("Typography", systemImage: "textformat")
            }
            .pickerStyle(.menu)
            
            Picker("Color", selection: $text.color) {
                ForEach(ThemeColor.allCases.dropLast(), id: \.self) { tag in
                    Image(systemName: "circle.fill")
                        .tint(tag.color)
                        .tag(tag)
                }    
            }
            .pickerStyle(.palette)
            
            Picker("Alignment", selection: $text.alignment) {
                Image(systemName: "text.alignleft")
                    .tag(TextAlignment.leading)
                
                Image(systemName: "text.aligncenter")
                    .tag(TextAlignment.center)
                
                Image(systemName: "text.alignright")
                    .tag(TextAlignment.trailing)
            }
            .pickerStyle(.palette)
            
            Menu {
                Button {
                    text.isBold.toggle()
                } label: {
                    Label("Bold", systemImage: text.isBold ? "checkmark" : "bold")
                }
                
                Button {
                    text.isItalic.toggle()
                } label: {
                    Label("Italic", systemImage: text.isItalic ? "checkmark" : "italic")
                }
                
                Menu { 
                    Picker("Underline Style", selection: $text.underline) {
                        ForEach(UnderlinePattern.allCases, id: \.self) { tag in
                            Text(tag.rawValue)
                                .tag(tag)
                        }
                    }
                    
                    Picker("Color", selection: $text.underlineColor) {
                        ForEach(ThemeColor.allCases.dropLast(), id: \.self) { tag in
                            Image(systemName: "circle.fill")
                                .tint(tag.color)
                                .tag(tag)
                        }
                    }
                    .pickerStyle(.palette)
                } label: { 
                    Label("Underline", systemImage: "underline")
                }
            } label: {
                Label("Font Style", systemImage: "bold.italic.underline")
            }
            
            Button(role: .destructive) { 
                delete?()
            } label: { 
                Label("Delete", systemImage: "trash")
            }
        } label: { 
            Image(systemName: "ellipsis.circle.fill")
                .font(.system(size: 32))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.black, Color.white)
                .shadow(color: .black.opacity(0.2), radius: 10)
        }
    }
    
    @ViewBuilder
    private var plusButton: some View {
        Group {
            switch type {
            case .message(let isShow, let action):
                if isShow {
                    Button {
                        action()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.black, Color.white)
                            .shadow(color: .black.opacity(0.2), radius: 10)
                    }
                }
            default:
                EmptyView()
            }
        }
    }
}

fileprivate struct Preview: View {
    
    @State private var text = TextModel.title
    
    var body: some View {
        ZStack {
            Color.white
            MultilineTextField(text: $text, isRendering: .constant(false))
                .padding(32)
        }
    }
}

struct MultilineTextField_Preview: PreviewProvider {
    static var previews: some View {
        Preview()
    }
}
