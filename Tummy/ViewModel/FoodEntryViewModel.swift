//
//  FoodEntryViewModel.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/1.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class FoodEntryViewModel: ObservableObject {
    // Variables
    @Published var foodEntries: [FoodEntry] = []
    
    @Published var foodItemsDictionary: [String: [FoodItem]] = [:] // Dictionary to hold food items for each entry
    @Published var allTags: [Tag] = []
    @Published var selectedTags: [Tag] = []
    @Published var images: [String: UIImage] = [:]
    private let maxFreeEntries = 3 // Limit for free users
    @Published var showSubscriptionView: Bool = false // New property to control subscription page
    @Published var showMindfulEatingView: Bool = false // New property to control subscription page


    // MARK: Dependency injections to check subscription status
    var storeViewModel: StoreViewModel
    init(storeViewModel: StoreViewModel) {
          self.storeViewModel = storeViewModel
      }
      
    
    // Init firebase firestore
    let db = Firestore.firestore()
    @Published var user = Auth.auth().currentUser
    private var listenerRegistration: ListenerRegistration?
    
    // MARK: Load and cache image
    func loadImage(for entry: FoodEntry) async {
        if let cachedImage = ImageCache.shared.getImage(forKey: entry.id) {
            DispatchQueue.main.async {
                self.images[entry.id] = cachedImage
            }
            return
        }

        DispatchQueue.main.async {
            // Show a placeholder image immediately
            self.images[entry.id] = UIImage(systemName: "photo")
        }
        
        // Asynchronously load the image
        guard let photoURL = entry.photoURL, let url = URL(string: photoURL) else {
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5.0 // Adjust timeout as needed
        let session = URLSession(configuration: sessionConfig)
        
        do {
            let (data, _) = try await session.data(from: url)
            if let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.images[entry.id] = uiImage
                    ImageCache.shared.setImage(uiImage, forKey: entry.id)
                }
            }
        } catch {
            // Handle error (optional)
            print("Error loading image: \(error.localizedDescription)")
        }
    }
    
    func image(for entry: FoodEntry) -> UIImage? {
        return images[entry.id]
    }
    // MARK: Tags configuration
    
    // MARK: Fetch all tags
    func fetchTags() {
        
        guard let user = user else {
            print("User not signed in")
            return
        }
        
        db.collection("Tags")
            .whereField("createdBy", isEqualTo: user.uid)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching tags: \(error.localizedDescription)")
                    return
                }
                self.allTags = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Tag.self)
                } ?? []
            }
    }
    
    
    // TODO: Create new tag
    func createTag(name: String, category: TagCategory) {
        
        guard let user = user else {
            print("User not signed in")
            return
        }
        
        let tagRef = db.collection("Tags").document()
        let tagID = tagRef.documentID
        let tag = Tag(id: tagID, createdBy: user.uid , name: name, isSelected: true, category: category.rawValue)
        
        do {
            try tagRef.setData(from: tag)
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    // TODO: Append tag to selected tags
    func selectOrRemoveTag(tag: Tag) {
        if tag.isSelected {
            if let index = selectedTags.firstIndex(where: {$0.id == tag.id}) {
                selectedTags.remove(at: index)
                print("Remove tag \(tag.name)")
            } else {
                selectedTags.append(tag)
                print("Append tag: \(tag.name)")
            }
        }
    }
    
    // TODO: Toggle selection
    func toggleTags(tag: Tag) {
        guard let index = allTags.firstIndex(where: {$0.id == tag.id}) else { return }
        allTags[index].isSelected.toggle()
        
        // Update the tag in Firestore
        let tagRef = db.collection("Tags").document(tag.id)
        do {
            try tagRef.setData(from: allTags[index], merge: true)
        } catch {
            print("Error updating tag in Firestore: \(error)")
        }
    }
    
    // MARK: Reset tags
    func resetTags() async {
        guard let user = user else {
            print("User not log in")
            return
        }
        // database
        let tagsRef = db.collection("Tags")
        do {
            // fetch all tags created by user
            let snapshot = try await tagsRef.whereField("createdBy", isEqualTo: user.uid).getDocuments()
            let batch = db.batch()  // Create a batch to perform the updates
            
            for document in snapshot.documents {
                let tagRef = tagsRef.document(document.documentID)
                batch.updateData(["isSelected": false], forDocument: tagRef)
            }
            try await batch.commit()
            print("Successfully reset isSelected for all tags.")
            
        } catch {
            print("Error resetting tags: \(error.localizedDescription)")
            
        }
        
    }
    
    
    // MARK: Category filter
    func tags(forCategory category: String) -> [Tag] {
        return allTags.filter { $0.category.lowercased() == category.lowercased() }
    }
}



// MARK: Food Entry

extension FoodEntryViewModel {
    // TODO: Fetch Food Diary Entries
    func fetchEntries(date: Date) {
        guard let user = user else {
            print("User not login")
            return
        }
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        
        guard let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) else {
            print("Error calculating end of day")
            return
        }
        
        listenerRegistration = db.collection("FoodEntries")
            .whereField("createdBy", isEqualTo: user.uid)
            .whereField("time", isGreaterThanOrEqualTo: startOfDay)
            .whereField("time", isLessThan: endOfDay)
            .order(by: "time", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                guard let documents = querySnapshot?.documents, error == nil else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.foodEntries = documents.compactMap { try? $0.data(as: FoodEntry.self)}
                
                // Load images in the background
                Task {
                    for entry in self.foodEntries {
                        await self.loadImage(for: entry)
                    }
                }
            }
    }
    
    func fetchSelectedTags() async -> [Tag] {
        guard let user = user else {
            print("User not logged in")
            return []
        }
        
        do {
            let snapshot = try await db.collection("Tags")
                .whereField("createdBy", isEqualTo: user.uid)
                .whereField("isSelected", isEqualTo: true)
                .getDocuments()
            
            let tags = snapshot.documents.compactMap { try? $0.data(as: Tag.self) }
            return tags
            
        } catch {
            print("Error fetching documents: \(error.localizedDescription)")
            return []
        }
    }
    
    // Function to upload the image to Firebase Storage
    func uploadImageToFirebase(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("foodPhotos/\(UUID().uuidString).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageConversionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to convert image to data"])))
            return
        }
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let downloadURL = url else {
                    completion(.failure(NSError(domain: "URLError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve download URL"])))
                    return
                }
                
                completion(.success(downloadURL.absoluteString))
            }
        }
    }
    // MARK: Create entry
  
    func createEntry(hungerBefore: HungerScaleOption, image: UIImage?, meal: Meal, foodItems: [FoodItem]) async {
        // Check if user can add food entry
        let canAdd = await canAddFoodEntry()
        
        if canAdd {
            guard let user = user else {
                print("User not signed in")
                return
            }

            let selectedTags = await fetchSelectedTags()
            print("✅ Input Tags \(selectedTags)")
            
            let people = filterAndMapToString(tags: selectedTags, filter: .people)
            let locations = filterAndMapToString(tags: selectedTags, filter: .location)
            let reasons = filterAndMapToString(tags: selectedTags, filter: .reason)
            print("People: \(people) | Location: \(locations) | Reason: \(reasons)")
            
            let entryRef = db.collection("FoodEntries").document()
            let entryID = entryRef.documentID
            
            var photoURL = "none"
            
            if let image = image {
                await withCheckedContinuation { continuation in
                    uploadImageToFirebase(image: image) { result in
                        switch result {
                        case .success(let url):
                            photoURL = url
                        case .failure(let error):
                            print("Error uploading image: \(error)")
                        }
                        continuation.resume()
                    }
                }
            }
           
            let entry = FoodEntry(
                id: entryID,
                createdBy: user.uid,
                isRealTime: true,
                photoURL: photoURL,
                hungerBefore: hungerBefore.number,
                time: Date(),
                mealType: meal.text,
                location: locations,
                eatAlone: people.isEmpty,
                people: people,
                reason: reasons,
                fullnessAfter: 0,
                notes: "No notes for now",
                postCompleted: false
            )
            
            do {
                // Create the FoodEntry document in Firestore
                print("Creating FoodEntry with ID: \(entryID)")
                try entryRef.setData(from: entry)
                print("FoodEntry created successfully")
                
                // Add each FoodItem to the sub-collection
                for foodItem in foodItems {
                    print("Adding FoodItem with ID: \(foodItem.id) to FoodEntry with ID: \(entryID)")
                    let itemRef = entryRef.collection("FoodItems").document(foodItem.id)
                    try itemRef.setData(from: foodItem)
                    print("FoodItem added successfully")
                }
                
                // Reset tags after entry is created
                await resetTags()
                
                DispatchQueue.main.async {
                    self.showMindfulEatingView = true // Show subscription page
                }
            } catch {
                print("Error creating entry or adding food items: \(error)")
            }

        } else {
            print("The user has reach limit")
            // If the user has reached the limit, show the subscription view
            DispatchQueue.main.async {
                self.showSubscriptionView = true // Show subscription page
            }        }
    }
//    // MARK: Show subscription page
//    func showSubscriptionView() {
//            DispatchQueue.main.async {
//                self.showSubscriptionView = true // Show subscription page
//            }
//    }
//    func showMindfulEatingView() {
//            DispatchQueue.main.async {
//                self.showMindfulEatingView = true // Show subscription page
//            }
//    }
    
    
    func createPastEntry(hungerBefore: HungerScaleOption, image: UIImage?, meal: Meal, foodItems: [FoodItem], fullnessAfter: HungerScaleOption, notes: String) async {
        guard let user = user else {
            print("User not signed in")
            return
        }
        
        let selectedTags = await fetchSelectedTags()
        
        print("✅ Input Tags \(selectedTags)")
        let people = filterAndMapToString(tags: selectedTags, filter: .people)
        let locations = filterAndMapToString(tags: selectedTags, filter: .location)
        let reasons = filterAndMapToString(tags: selectedTags, filter: .reason)
        print("People: \(people) | Location: \(locations) | Reason: \(reasons)")
        
        let entryRef = db.collection("FoodEntries").document()
        let entryID = entryRef.documentID
        
        var photoURL = "none"
        
        if let image = image {
            await withCheckedContinuation { continuation in
                uploadImageToFirebase(image: image) { result in
                    switch result {
                    case .success(let url):
                        photoURL = url
                    case .failure(let error):
                        print("Error uploading image: \(error)")
                    }
                    continuation.resume()
                }
            }
        }
        let entry = FoodEntry(
            id: entryID,
            createdBy: user.uid,
            isRealTime: false,
            photoURL: photoURL,
            hungerBefore: hungerBefore.number,
            time: Date(),
            mealType: meal.text,
            location: locations,
            eatAlone: people.isEmpty,
            people: people,
            reason: reasons,
            fullnessAfter: fullnessAfter.number,
            notes: notes,
            postCompleted: true
        )
        do {
            // Create the FoodEntry document
            print("Creating FoodEntry with ID: \(entryID)")
            try entryRef.setData(from: entry)
            print("FoodEntry created successfully")
            // Add each FoodItem as a sub-collection
            for foodItem in foodItems {
                print("Adding FoodItem with ID: \(foodItem.id) to FoodEntry with ID: \(entryID)")
                let itemRef = entryRef.collection("FoodItems").document(foodItem.id)
                try itemRef.setData(from: foodItem)
                print("FoodItem added successfully")
            }
            await resetTags()
        } catch {
            print("Error creating entry or adding food items: \(error)")
        }
    }

    func filterAndMapToString(tags: [Tag], filter category: TagCategory) -> [String] {
        let result = tags.filter {$0.category.lowercased() == category.rawValue.lowercased()}.map { $0.name}
        return result
    }
    
    // MARK: Update post food info
    
    func updatePostFoodInfo(entry: FoodEntry, fullness: HungerScaleOption, notes: String) async throws {
        
        // Define the entry reference
        let entryRef = db.collection("FoodEntries").document(entry.id)
        
        // Prepare the fields to be updated
        let updatedFields: [String: Any] = [
            "fullnessAfter": fullness.number,
            "notes": notes,
            "postCompleted": true
        ]
        
        do {
            try await entryRef.updateData(updatedFields)
            print("Entry successfully updated!")
            
        } catch {
            print("Error updating entry: \(error.localizedDescription)")
            throw error
        }
    }
    
    // TODO: Delete Entry
    
    func deleteEntry(entryID: String) async {
        let entryRef = db.collection("FoodEntries").document(entryID)
        do {
            try await entryRef.delete()
            print("Document successfully removed!")
        } catch {
            print("Error removing document: \(error)")
        }
    }
    
}

// MARK: Add Item
extension FoodEntryViewModel {
    func addItemToEntry(name: String, quantity: Int, unit: String, entryID: String) {
        let itemRef = db.collection("FoodEntries").document(entryID).collection("FoodItems").document()
        
        let itemID = itemRef.documentID
        
        let item = FoodItem(id: itemID, name: name, quantity: quantity, unit: unit)
        
        do {
            try itemRef.setData(from: item)
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    func fetchFoodItems(for entry: FoodEntry) async {
        let entryID = entry.id
        let foodItemsRef = db.collection("FoodEntries").document(entryID).collection("FoodItems")
        
        do {
            let snapshot = try await foodItemsRef.getDocuments()
            let foodItems = snapshot.documents.compactMap { document -> FoodItem? in
                try? document.data(as: FoodItem.self)
            }
            DispatchQueue.main.async {
                self.foodItemsDictionary[entryID] = foodItems
            }
        } catch {
            print("Error fetching food items: \(error)")
        }
    }
    
    func foodItems(for entry: FoodEntry) -> [FoodItem] {
        return foodItemsDictionary[entry.id] ?? []
    }
    
    
    // TODO: Delete food item
    
    func deleteFoodItem(entryID: String, itemID: String) async {
        let itemRef = db.collection("FoodEntries").document(entryID).collection("FoodItems").document(itemID)
        do {
            try await itemRef.delete()
            print("Document successfully removed!")
        } catch {
            print("Error removing document: \(error)")

        }
        
    }
}

class ImageCache {
    static let shared = ImageCache()
    private var cache: [String: UIImage] = [:]
    
    private init() {}
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache[key] = image
    }
    
    func getImage(forKey key: String) -> UIImage? {
        return cache[key]
    }
}

extension FoodEntryViewModel {
    
    // Fetch number of food entries created by the current user
    func fetchUserFoodEntryCount(completion: @escaping (Int?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        // Query the FoodEntries collection for documents created by the current user
        db.collection("FoodEntries")
            .whereField("createdBy", isEqualTo: userUID)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    let documentCount = snapshot?.documents.count ?? 0
                    print("Fetched \(documentCount) food entries for user \(userUID)") // Debugging
                    completion(documentCount, nil)
                }
            }
    }
    
    // Update canAddFoodEntry to be async
    func canAddFoodEntry() async -> Bool {
        return await withCheckedContinuation { continuation in
            fetchUserFoodEntryCount { count, error in
                if let error = error {
                    print("Error fetching food entries count: \(error.localizedDescription)")
                    continuation.resume(returning: false)
                    return
                }
                
                // Log the number of food entries and subscription status for debugging
                print("Food entry count: \(count ?? 0)")
                print("Has subscription: \(self.storeViewModel.purchasedSubscriptions.count > 0)")
                
                // Check if the user has purchased a subscription
                let hasSubscription = !self.storeViewModel.purchasedSubscriptions.isEmpty
                
                // Check if the user is allowed to add more entries (subscription or free limit)
                let canAdd = hasSubscription || (count ?? 0) < self.maxFreeEntries
                print("Can add food entry: \(canAdd)") // Debugging
                continuation.resume(returning: canAdd)
            }
        }
    }

}
