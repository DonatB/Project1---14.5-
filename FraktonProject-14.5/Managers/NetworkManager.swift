//
//  NetworkManager.swift
//  FraktonTestProject
//
//  Created by Donat Bajrami on 4.9.21.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://reqres.in/api/users"
    let cache = NSCache<NSString, UIImage>()
    let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    
//    func getSingleUserInfo(with userID: Int, completed: @escaping(Result<User, DBError>) -> Void) {
//        let endpoint = baseURL + "/\(userID)"
//
//        guard let url = URL(string: endpoint) else {
//            completed(.failure(.invalidURL))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//
//            if let _ = error {
//                completed(.failure(.unableToRequest))
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(.failure(.invalidResponse))
//                return
//            }
//
//            guard let data = data else {
//                completed(.failure(.invalidData))
//                return
//            }
//
//            do {
//                let users = try self.decoder.decode(UserInfoData.self, from: data)
//                completed(.success(users.data))
//            } catch {
//                completed(.failure(.invalidData))
//            }
//        }
//        task.resume()
//    }
    
    
    private func getGenericData<T: Codable>(with endpoint: String?, completed: @escaping (Result <T, DBError> ) -> Void) {
        var completedEndpoint = baseURL
        
        if let endpoint = endpoint {
            completedEndpoint += endpoint
        }
        print(completedEndpoint)
        
        guard let url = URL(string: completedEndpoint) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let data = try self.decoder.decode(UserDataWrapper<T>.self, from: data)
                completed(.success(data.data))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func getUsers(perPage: Int, completed: @escaping(Result<[User], DBError>) -> Void) {
        let endpoint = "?per_page=\(perPage)"
        getGenericData(with: endpoint, completed: completed)
    }
    
    
    func getUsersInfo(with userID: Int, completed: @escaping(Result<User, DBError>) -> Void) {
        let endpoint = "/\(userID)"
        getGenericData(with: endpoint, completed: completed)
    }
    
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}
