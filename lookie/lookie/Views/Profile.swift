
import SwiftUI
import SDWebImageSwiftUI

struct Profile: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var isShowNewlook: Bool = false
    @State private var isShowGenerateImage: Bool = false
    
    @State private var city: String = "No data"
    @State private var temp: String = "0°"
    @State private var weather: String = "No data"
    
    var body: some View {
        makeContent()
            .background(.backgroundWhite)
            .task {
                await fetchWeather()
            }
            .fullScreenCover(isPresented: $isShowNewlook) {
                NewLook()
                    .environmentObject(viewModel)
            }
            .fullScreenCover(isPresented: $isShowGenerateImage) {
                GenerateImage()
                    .environmentObject(viewModel)
            }
    }
    
    private func makeContent() -> some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 24) {
                ProfileBar(buttonAction: {
                    
                })
                makeCardsGrid()
                Spacer()
            }
            .padding(.top, 24)
            .padding(.horizontal, 20)
            
            AddButton(newAction: {
                isShowNewlook.toggle()
            }, generateAction: {
                isShowGenerateImage.toggle()
            })
        }
    }
    
    private func makeCardsGrid() -> some View {
        VStack(spacing: 7) {
            LongCard(header: "3 looks", name: "Outfits", numberOfItems: 1, images: [Image("ImagePlaceholder")]) {
                
            }
            HStack(spacing: 7) {
                RectCard(header: "10 looks", name: "Upper-wear") {}
                WeatherCard(city: city, temp: temp, weather: weather) 
            }
            HStack(spacing: 7) {
                RectCard(header: "64 looks", name: "Shoes") {}
                RectCard(header: "123 looks", name: "Bottom-wear") {}
            }
        }
    }
    
    private func fetchWeather() async {
        let weatherResponse = await viewModel.fetchWeather()
        if let name = weatherResponse?.name {
            city = name
        }
        if let temperature = weatherResponse?.main.temp {
            temp = "\(Int(temperature))°"
        }
        if let weatherType = weatherResponse?.weather.first?.main {
            weather = weatherType
        }
    }
    
}

#Preview {
    Profile()
}
