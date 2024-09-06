//
//  AuthManager.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/1.
//
import FirebaseAuth
import AuthenticationServices
import FirebaseFirestore
import CryptoKit

enum AuthState {
    case signedIn
    case signedOut
}

class AuthManager: ObservableObject {
    
    @Published var authState: AuthState = .signedOut
    private var currentNonce: String?
    private let db = Firestore.firestore()

    init() {
        checkCurrentUser()
    }
    
    func checkCurrentUser() {
        authState = Auth.auth().currentUser != nil ? .signedIn : .signedOut
    }
    
    // MARK: Sign In With Apple
    func signInWithApple(authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = appleIDCredential.identityToken,
              let idTokenString = String(data: identityToken, encoding: .utf8),
              let nonce = currentNonce else {
            return
        }
        
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let authResult = authResult {
                self?.addUser(user: authResult.user)
                self?.authState = .signedIn
            } else {
                self?.authState = .signedOut
            }
        }
    }
    
    // MARK: Sign In Anonymously
    func signInAnonymously() {
        Auth.auth().signInAnonymously { [weak self] authResult, error in
            if let error = error {
                print("Error signing in anonymously: \(error.localizedDescription)")
                return
            }
            if let authResult = authResult {
                self?.addUser(user: authResult.user)
                self?.authState = .signedIn
            }
        }
    }

    // MARK: Signed Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            authState = .signedOut
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else { return }
        
        let userId = user.uid
        authState = .signedOut
        // Delete the user's document and all associated todos
        db.collection("Users").document(userId).delete { error in
            if let error = error {
                print("Error deleting user document: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func prepareRequest(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = AppleSignInCoordinator.shared.randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = AppleSignInCoordinator.shared.sha256(nonce)
    }

    private func addUser(user: User) {
        let userData: [String: Any] = [
            "uid": user.uid,
            "email": user.email ?? "",
            "name": user.displayName ?? "Anonymous"
        ]
        
        db.collection("Users").document(user.uid).setData(userData) { error in
            if let error = error {
                print("Error adding user to Firestore: \(error.localizedDescription)")
            } else {
                print("User added to Firestore successfully")
            }
        }
    }
}
