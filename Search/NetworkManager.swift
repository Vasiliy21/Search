//
//  NetworkManager.swift
//  Search
//
//  Created by Vasiliy on 14.10.2023.
//

import Foundation
import SwiftUI

class NetworkManager: ObservableObject {

    @Published var clubs: [Location] = []
    @Published var nameOfClubs: [Clubs] = []


    init() {
        fetchClubs()
        fetchNameOfClubs()
    }

    func fetchClubs() {
        guard let url = URL(string: "http://arsya.ru/service.php") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let clubs = try JSONDecoder().decode([Location].self, from: data)
                DispatchQueue.main.async {
                    self.clubs = clubs
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }

    func fetchNameOfClubs() {
        guard let url = URL(string: "http://arsya.ru/service.php") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let nameOfClubs = try JSONDecoder().decode([Clubs].self, from: data)
                DispatchQueue.main.async {
                    self.nameOfClubs = nameOfClubs
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }

    func fetchImage(from url: String, completion: @escaping(Data) -> Void) {
        guard let url = URL(string: url) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                completion(imageData)
            }
        }
    }
}
/// remove duplicates
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

