
import SwiftUI

struct ImageViewCard: View {
    
    let url: String
    let isLiked: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image("Heart")
                .renderingMode(.template)
                .foregroundStyle(.backgroundWhite)
                .background(
                    Circle()
                        .fill(.black)
                        .opacity(0.26)
                        .frame(width: 28, height: 28)
                        .blur(radius: 6)
                )
                .padding(.trailing, 4)
                .padding(.top, 4)
            
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 240)
                    .clipped()
            } placeholder: {
                Color.gray.frame(height: 150)
            }
            .cornerRadius(16)
        }
        .frame(maxWidth: .infinity, maxHeight: 240)
    }
    
}
