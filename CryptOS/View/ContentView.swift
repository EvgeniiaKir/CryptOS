//
//  ContentView.swift
//  CryptOS
//
//  Created by Evgeniia Kiriushina on 07.07.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var results = [Crypto]()
    @State private var openDetails: Bool = false
    @State var currentCrypto = DetailedCrypto()
    @State var weekPrices = [(date: String, price: Double)]()
    var apiManager = ApiManager()
    
    var body: some View {
        VStack {
            Text("CryptOS")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            List(results, id: \.id) { item in
                Button(action: {
                    Task {
                        await apiManager.loadDetailedData(id: item.id, results: &currentCrypto)
                        await apiManager.loadPricesData(id: item.id, results: &weekPrices)
                    }
                    self.openDetails = true
                }) {
                    HStack(spacing: 20) {
                        AsyncImage(url: URL(string: item.image), scale: 2) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        .frame(width: 45)
                        Text(item.name)
                        Spacer()
                        Text("\(item.current_price) €")
                    }
                }
                .fullScreenCover(isPresented: $openDetails, content: {
                    DetailsView(currentCrypto: $currentCrypto, weekPrices: $weekPrices)
                })
            }
            .task {
                await apiManager.loadGeneralData(results: &results)
            }
            .listStyle(.plain)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
