

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class UserIconLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellables = Set<AnyCancellable>()
    
    func load(from path: String) {
        let storageRef = Storage.storage().reference().child(path)
        storageRef.downloadURL { url, error in
            guard let url = url else {
                print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            print("Download URL: \(url)")
            
            self.loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] in self?.image = $0 })
            .store(in: &cancellables)
    }
}

class TitleImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellables = Set<AnyCancellable>()
    
    func load(from path: String) {
        let storageRef = Storage.storage().reference().child(path)
        storageRef.downloadURL { url, error in
            guard let url = url else {
                print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Image download failed with error: \(error)")
                }
            }, receiveValue: { [weak self] in self?.image = $0 })
            .store(in: &cancellables)
    }
}

//アイコンのリサイズ
func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    let size = image.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}

//プロフィール登録
func uploadImage(selectedImage: UIImage?, name: String, profile: String, completion: @escaping (Bool) -> Void) {
    guard let resizedImage = resizeImage(image: selectedImage!, targetSize: CGSize(width: 250, height: 250)),
          let data = resizedImage.jpegData(compressionQuality: 0.5) else {
        completion(false)
        return
    }
    
    let fileName = UUID().uuidString + ".jpeg"
    let storageRef = Storage.storage().reference().child("UserIcon").child(fileName)
    
    storageRef.putData(data, metadata: nil) { _, error in
        guard error == nil else {
            print("Error uploading image: \(error!)")
            completion(false)
            return
        }
        
        let relativePath = "UserIcon/" + fileName
        
        let firestore = Firestore.firestore()
        if let currentUserId = Auth.auth().currentUser?.uid {
            firestore.collection("Users").document(currentUserId).setData([
                "name": name,
                "profile": profile,
                "icon": relativePath,
                "favorites": [String]()   // <-- ここでfavoritesフィールドを空の配列として初期化
            ]) { error in
                if let error = error {
                    print("Error saving user data: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } else {
            completion(false)
        }
    }
}

//プロフィール編集
func updateUserProfile(selectedImage: UIImage?, name: String, profile: String, completion: @escaping (Bool) -> Void) {
    guard let currentUserId = Auth.auth().currentUser?.uid else {
        completion(false)
        return
    }
    
    let firestore = Firestore.firestore()
    let userDocument = firestore.collection("Users").document(currentUserId)
    
    userDocument.getDocument { document, error in
        guard let document = document, document.exists, error == nil else {
            print("Error fetching user data: \(error!)")
            completion(false)
            return
        }
        
        if let selectedImage = selectedImage {
            guard let resizedImage = resizeImage(image: selectedImage, targetSize: CGSize(width: 250, height: 250)),
                  let data = resizedImage.jpegData(compressionQuality: 0.5) else {
                completion(false)
                return
            }
            
            let previousIconPath = document.data()?["icon"] as? String ?? ""
            let storageRef = Storage.storage().reference().child(previousIconPath)
            
            storageRef.putData(data, metadata: nil) { _, error in
                guard error == nil else {
                    print("Error uploading image: \(error!)")
                    completion(false)
                    return
                }
                
                userDocument.updateData([
                    "name": name,
                    "profile": profile
                ]) { error in
                    if let error = error {
                        print("Error updating user data: \(error)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        } else {
            userDocument.updateData([
                "name": name,
                "profile": profile
            ]) { error in
                if let error = error {
                    print("Error updating user data: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
}

