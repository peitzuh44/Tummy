//
//  MealItem.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/16.
//

import SwiftUI

struct MealItemActionState: View {
    @Binding var showCamera: Bool
    @Binding var showSkip: Bool
    @Binding var showPastMeal: Bool
    @State var icon: String = "sun.horizon"
    @State var color: Color = Color.yellow
    @State var meal: String = "Breakfast"
    var body: some View {
        VStack (alignment: .leading){
            HStack (alignment: .center, spacing: 4){
                Image(systemName: icon)
                    .font(.title3)

                Text(meal)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            HStack {
                MealActionButton(buttonType: .skip, show: $showSkip)
                MealActionButton(buttonType: .camera, show: $showCamera)
                MealActionButton(buttonType: .past, show: $showPastMeal)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30.0)
                .fill(.thickMaterial)
        )
    }
}



// MARK: Meal Item
struct MealItem: View {
    @Namespace var namespace
    @State var animationID: String = ""
    @State var meal: String = "Breakfast"
    @State var color: Color = Color.yellow
    @State var icon: String = "sun.horizon"
    @State var contextTags: [Tag] = [
        Tag(name: "professor", category: .people),
        Tag(name: "Ryan Ma", category: .people),
        Tag(name: "school", category: .place),

    ]
    
    var body: some View {
        HStack {
            VStack (alignment: .leading){
                HStack {
                    HStack (alignment: .center, spacing: 8){
                        Image(systemName: icon)
                            .padding(10)
                            .frame(width: 36, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray5))
                            )
                        Text(meal)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .matchedGeometryEffect(id: animationID, in: namespace)
                    }
                    Spacer()
                    Text("7")
                        .fontWeight(.semibold)
                        .padding(10)
                        .frame(width: 36, height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray5))
                    
                    )
                }
                Text("Finished at 08:20am")
                Text("Time spent eating - 25:03")
                ScrollView(.horizontal){
                    HStack {
                        ForEach(contextTags) { tag in
                            ContextTag(contextTag: tag)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            
            }
            Spacer()
        }
        
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30.0)
                .fill(.thinMaterial)
                .shadow(radius: 4, y: 10)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 30.0)
                .stroke(lineWidth: 1.5)
                .foregroundStyle(color)

        }
        
    }
}

#Preview {
    MealItem()
    
}

struct ContextTag: View {
    
    var contextTag: Tag
    
    var body: some View {
        Text(contextTag.name)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(Color(.systemGray5))
            )
    }
}



struct MealActionButton: View {
    
    var buttonType: MealActionButtonType
    @Binding var show: Bool
    var body: some View {
        Button {
            withAnimation {
                show = true

            }
            
        } label: {
            VStack (spacing: 8){
                Image(systemName: buttonType.icon)
                    .font(.title2)
                Text(buttonType.text)
                    .fontWeight(.medium)
                    .font(.callout)

            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .foregroundStyle(Color.white)
            .frame(width: 100)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(buttonType.color)
            )
        }


    }
}




enum MealActionButtonType {
    case skip, camera, past
    
    var text: String {
        switch self {
        case .skip:
            return "Skip"
        case .camera:
            return "Camera"
        case .past:
            return "Past"
        }
    }
    
    var icon: String {
        switch self {
        case .skip:
            return "forward.frame"
        case .camera:
            return "camera"
        case .past:
            return "clock.arrow.circlepath"
        }
    }
    
    var color: Color {
        switch self {
        case .skip:
            return Color.orange
        case .camera:
            return Color.green
        case .past:
            return Color.blue
        }
    }
}
