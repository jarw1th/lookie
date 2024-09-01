
import SwiftUI

struct LongCard: View {
    
    var header: String
    var name: String
    var numberOfItems: Int
    var images: [Image]
    
    var action: () -> Void
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        Button {
            action()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(header)
                            .font(.system(size: 14, weight: .medium))
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.softBlue)
                        Text(name)
                            .font(.system(size: 16, weight: .medium))
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.darkBlue)
                    }
                    Image("RightArrow")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(.softBlue)
                        .frame(width: 24, height: 24)
                }
                Spacer()
                if numberOfItems < 3 && images.count < 3 {
                    makePreviewImage()
                } else {
                    makePreviewImages()
                }
            }
            .padding(.leading, 16)
            .padding(.trailing, 30)
            .frame(maxWidth: .infinity)
            .frame(height: 164)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
            )
        }
    }
    
    private func makePreviewImage() -> some View {
        VStack {
            if let image = images.first {
                image
                    .resizable()
                    .frame(width: 104, height: 104)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.softBlue)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 8)
                    )
            }
        }
    }
    
    private func makePreviewImages() -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                 images[0]
                    .resizable()
                    .frame(width: 48, height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.softBlue)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 8)
                    )
                images[1]
                   .resizable()
                   .frame(width: 48, height: 48)
                   .background(
                       RoundedRectangle(cornerRadius: 8)
                           .stroke(.softBlue)
                   )
                   .clipShape(
                       RoundedRectangle(cornerRadius: 8)
                   )
            }
            HStack(spacing: 8) {
                 images[2]
                    .resizable()
                    .frame(width: 48, height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.softBlue)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 8)
                    )
                Text("+\(numberOfItems - 3)")
                    .font(.system(size: 16, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.softBlue)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.softBlue)
                            .frame(width: 48, height: 48)
                    )
            }
        }
    }
    
}

struct RectCard: View {
    
    var header: String
    var name: String
    
    var action: () -> Void
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        Button {
            action()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(header)
                            .font(.system(size: 14, weight: .medium))
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.softBlue)
                        Text(name)
                            .font(.system(size: 16, weight: .medium))
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.darkBlue)
                    }
                    Image("RightArrow")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(.softBlue)
                        .frame(width: 24, height: 24)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 164)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
            )
        }
    }
    
}

struct WeatherCard: View {
    
    var city: String
    var temp: String
    var weather: String
    
    var body: some View {
        makeContent()
    }
    
    private func makeContent() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(city)
                        .font(.system(size: 14, weight: .medium))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.softBlue)
                    Text(temp)
                        .font(.system(size: 16, weight: .medium))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.darkBlue)
                }
                HStack(spacing: 8) {
                    Image("SunnyWeather")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(.softBlue)
                        .frame(width: 24, height: 24)
                    Text(weather)
                        .font(.system(size: 14, weight: .medium))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.softBlue)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 164)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
        )
    }
    
}
