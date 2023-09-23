

import SwiftUI
import Combine
import FirebaseStorage

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



