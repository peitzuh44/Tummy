//
//  TagManager.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/14.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class TagManager: ObservableObject {
    @Published var tags: [Tag] = []
    private var listenerRegistration: ListenerRegistration?
    @Published var isAddingNewTag: Bool = false
    @Published var newTagName: String = ""
    let db = Firestore.firestore()
    
    // MARK: Fetch Tags
    func fetchTags() {
        guard let user = Auth.auth().currentUser else {
            print("Current user not sign in")
            return
        }
        listenerRegistration = db.collection("tags")
            .whereField("createdBy", isEqualTo: user.uid)
            .whereField("createdBy", isEqualTo: "Admin")
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                guard let documents = querySnapshot?.documents, error == nil else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.tags = documents.compactMap { try? $0.data(as: Tag.self)}
            }
        
        
    }
    // MARK: Filter Tag By Categories
    func tags(forCategory category: TagCategory.RawValue) -> [Tag] {
        return tags.filter { $0.category.lowercased() == category.lowercased()}
    }
    
    
    // TODO: Craete Tag
    
    func createTag(name: String, category: TagCategory) {
        if !name.isEmpty {
            // Make sure that current user is signin so we have the uid
            guard let user = Auth.auth().currentUser else {
                print("Current user not sign in")
                return
            }
            let tagRef = db.collection("tags").document()
            let tagID = tagRef.documentID
            let tag = Tag(id: tagID, name: name, isSelected: true, category: category.rawValue)
            do {
                try
                db.collection("tags").document(tagID)
                    .setData(from: tag)
                print("Document with id: \(tagID) added sucessfully!")
            } catch {
                print("Error adding document: \(error)")
            }
        }
    }
    
    func toggleSelection(of tag: Tag) {
        if let index = tags.firstIndex(where: { $0.id == tag.id }) {
            tags[index].isSelected.toggle()
        }
    }
    
    
    
}

