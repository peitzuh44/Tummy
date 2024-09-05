//
//  StoreViewModel.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/5.
//

import Foundation
import StoreKit

typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState
class StoreViewModel: ObservableObject {
    
    @Published private (set) var subscriptions: [Product] = []
    @Published private (set) var purchasedSubscriptions: [Product] = []
    @Published private (set) var subscriptionGroupStatus: RenewalState?
    
    
    private let productIDs: [String] = ["tummy.yearly.subscription", "tummy.monthly.subscription"]
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    init() {
        Task {
            
            updateListenerTask = listenForTransaction()
            
            await requestProduct()
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: Listener to get notify that purchase status have been update (user did purchaed)
    func listenForTransaction() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    print("transaction failed verification")
                }
            }
        }
    }
    // MARK: Request and fetch product
    @MainActor
    func requestProduct() async {
        do {
            subscriptions = try await Product.products(for: productIDs)
            print(subscriptions)
        } catch {
            print("Error getting product from the server: \(error)")
        }
    }
    
    // MARK: Purchase product
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    // MARK: Check verified
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    // MARK: Update customer product status
    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                switch transaction.productType {
                case .autoRenewable:
                    if let subscription = subscriptions.first(where: {$0.id == transaction.productID}) {
                        purchasedSubscriptions.append(subscription)
                    }
                default:
                    break
                }
                await transaction.finish()
            } catch {
                print("failed update products")
            }
        }
    }
}

public enum StoreError: Error {
    case failedVerification
}
