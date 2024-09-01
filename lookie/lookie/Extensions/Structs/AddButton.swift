
import SwiftUI

struct AddButton: View {
    
    let newAction: () -> Void
    let generateAction: () -> Void
    
    @State private var isOpened: Bool = false
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        VStack(alignment: .trailing, spacing: 10) {
            if isOpened {
                Button {
                    newAction()
                    isOpened.toggle()
                } label: {
                    VStack {
                        Text("New Look")
                            .font(.system(size: 14, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 24)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.rose)
                    )
                }
                
                Button {
                    generateAction()
                    isOpened.toggle()
                } label: {
                    VStack {
                        Text("Generate Image")
                            .font(.system(size: 14, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 24)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.rose)
                    )
                }
            }
            
            Button {
                isOpened.toggle()
            } label: {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isOpened ? .softBlue : .rose)
                        .frame(width: 48, height: 48)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.white)
                        .frame(width: 20, height: 2)
                        .rotationEffect(isOpened ? .degrees(45) : .degrees(0))
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.white)
                        .frame(width: 2, height: 20)
                        .rotationEffect(isOpened ? .degrees(45) : .degrees(0))
                }
            }
        }
        .padding(.trailing, 20)
        .padding(.bottom, 20)
        .animation(.bouncy, value: isOpened)
    }
    
}
