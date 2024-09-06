//
//  StoreView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/5.
//

import SwiftUI
import StoreKit


struct SubscriptionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var storeVM: StoreViewModel
    @State var isPurchased = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if storeVM.purchasedSubscriptions.isEmpty {
                    VStack (alignment: .leading){
                        HStack {
                            Image(systemName: "crown")
                                .foregroundStyle(Color.yellow)
                            Text("What you will get?")
                        }
                        .font(.title2)
                        VStack(alignment: .leading){
//                            BenefitItem(text: "Unlock insight tab")
                            BenefitItem(text: "Unlimited food entry")
//                            BenefitItem(text: "Access to all mindfulness guidance")
                        }
                    }
                    
                    ForEach(storeVM.subscriptions) { product in
                        Button {
                            Task {
                                await buy(product: product)
                            }
                        } label: {
                            HStack {
                                HStack {
                                    Text(product.displayPrice)
                                    Text(product.displayName)
                                }
                                Spacer()
                                Text(product.description)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .background(RoundedRectangle(cornerRadius: 20.0)
                                .fill(Color.blue))
                            .padding(.horizontal)
                        }
                        
                    }
                } else {
                    Text("You have already purchased the subscription.")
                    Text("If you want to cancel the subscription. Please go to AppStore >> Settings >> Manage Subscription")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("X")
                            .foregroundStyle(Color.accent)
                            .font(.title2)
                    }
                    
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

struct BenefitItem: View {
    
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark")
                .foregroundStyle(Color.green)
            Text(text)
        }
    }
}
