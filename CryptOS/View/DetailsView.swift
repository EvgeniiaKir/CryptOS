//
//  DetailsView.swift
//  CryptOS
//
//  Created by Evgeniia Kiriushina on 09.07.2022.
//

import Foundation
import SwiftUI

struct DetailsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding public var currentCrypto: DetailedCrypto
    @Binding public var weekPrices: [(date: String, price: Double)]
    @State var description : String = ""
    
    var body: some View {
        Color(red: 242/255, green: 245/255, blue: 245/255)
            .ignoresSafeArea()
            .overlay(
                ZStack {
                    VStack {
                        HStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                                weekPrices.removeAll()
                                description.removeAll()
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: 30))
                                    .foregroundColor(.black)
                            }
                            .padding(.leading, 15)
                            .padding(.top, 15)
                            Spacer()
                        }
                        Spacer()
                    }
                    VStack(spacing: 15) {
                        Text(currentCrypto.name ?? "Name")
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                            .padding(.top, 50)
                            .padding(.bottom, -20)
                        ScrollView {
                            ScrollViewReader{ value in
                                VStack(spacing: 30) {
                                    Text(currentCrypto.description ?? "Description")
                                    Text(currentCrypto.link ?? "some link")
                                        .fontWeight(.bold)
                                        .onTapGesture {
                                            UIApplication.shared.open(URL(string: currentCrypto.link!)!, options: [:])
                                        }
                                    ForEach(weekPrices, id: \.date) { item in
                                        HStack{
                                            Text("\(item.date)")
                                            Spacer()
                                            Text("\(item.price) €")
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                    }
                })
    }
}
