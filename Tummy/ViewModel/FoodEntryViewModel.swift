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
    @Published var allTags: [Tag] = []
    @Published var selectedTags: [Tag] = []
    @Published var images: [String: UIImage] = [:]

    
    // Init firebase firestore
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    private var listenerRegistration: ListenerRegistration?
    
    func loadImage(for entry: FoodEntry) async {
        if let cachedImage = ImageCache.shared.getImage(forKey: entry.id) {
            DispatchQueue.main.async {
                self.images[entry.id] = cachedImage
            }
            return
        }
        
        guard let photoURL = entry.photoURL, let url = URL(string: photoURL) else {
            DispatchQueue.main.async {
                self.images[entry.id] = UIImage(systemName: "photo")
            }
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.images[entry.id] = uiImage
                    ImageCache.shared.setImage(uiImage, forKey: entry.id)
                }
            } else {
                DispatchQueue.main.async {
                    self.images[entry.id] = UIImage(systemName: "photo")
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.images[entry.id] = UIImage(systemName: "photo")
            }
        }
    }
    
    func image(for entry: FoodEntry) -> UIImage? {
        return images[entry.id]
    }

    
    // MARK: Tags configuration
    
    
    // TODO: Fetch all tags
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
    func fetchEntries(date: Date){
        guard let user = user else {
            print("User not login")
            return
        }
        
        listenerRegistration = db.collection("FoodEntries")
            .whereField("createdBy", isEqualTo: user.uid)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                guard let documents = querySnapshot?.documents, error == nil else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.foodEntries = documents.compactMap { try? $0.data(as: FoodEntry.self)}
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
    // Update the createEntry function to include the image upload and URL storage
    func createEntry(hungerBefore: HungerScaleOption, image: UIImage?) async {
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
        
        let entry = FoodEntry(id: entryID, createdBy: user.uid, isRealTime: true, photoURL: photoURL, textDescription: "none", hungerBefore: hungerBefore.number, time: Date(), mealType: "breakfast", location: locations, eatAlone: people.isEmpty, people: people, reason: reasons, fullnessAfter: 0, notes: "No notes for now", postCompleted: false)
        
        do {
            try entryRef.setData(from: entry)
            await resetTags()
        } catch {
            print("Error converting entry to data: \(error)")
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
