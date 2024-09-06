//
//  AddFoodItemSheet.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/2.
//

import SwiftUI

struct AddFoodItemSheet: View {
    
    @State private var name: String = ""
    @State private var quantity: Int = 1
    @State private var unit: String = ""
    @Environment(\.presentationMode) var presentationMode
    var onAdd: (FoodItem) -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("Item name", text: $name, prompt: Text("Item"))
                Stepper(value: $quantity, in: 1...100) {
                    Text("Quantity \(quantity)")
                }
                TextField("Unit (e.g., slice, cup)", text: $unit)
            }
            .navigationTitle("Add Food Item")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let newItem = FoodItem(id: UUID().uuidString, name: name, quantity: quantity, unit: unit)
                        onAdd(newItem)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                    }

                }
            }
        }
    }
}

