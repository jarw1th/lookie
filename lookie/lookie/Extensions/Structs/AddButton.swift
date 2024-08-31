
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
                        Text("New")
                            .font(.system(size: 24, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.backgroundWhite)
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(.softGreen)
                    )
                }
                
                Button {
                    generateAction()
                    isOpened.toggle()
                } label: {
                    VStack {
                        Text("Generate")
                            .font(.system(size: 24, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.backgroundWhite)
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(.goldYellow)
                    )
                }
            }
            
            Button {
                isOpened.toggle()
            } label: {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(isOpened ? .softRed : .darkBlue)
                        .frame(width: 48, height: 48)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.backgroundWhite)
                        .frame(width: 20, height: 2)
                        .rotationEffect(isOpened ? .degrees(45) : .degrees(0))
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.backgroundWhite)
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
