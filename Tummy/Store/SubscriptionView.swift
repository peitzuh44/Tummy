//
//  StoreView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/5.
//

import SwiftUI
import StoreKit
struct SubscriptionView: View {
    
    @EnvironmentObject var storeVM: StoreViewModel
    @State var isPurchased = false
    
    var body: some View {
        VStack {
            ForEach(storeVM.subscriptions) { product in
                Button {
                    Task {
                        await buy(product: product)
                    }
                } label: {
                    VStack {
                        HStack {
                            Text(product.displayPrice)
                            Text(product.displayName)
                        }
                        Text(product.description)
                    }.padding()
                        .foregroundStyle(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20.0)
                            .fill(Color.blue))
                }
                
            }
            
        }
    }
    
    // buy
    private func buy(product: Product) async {
        do {
            if try await storeVM.purchase(product) != nil {
                isPurchased = true
            }
        }
        catch {
            print("purchase failed")
        }
    }
}

