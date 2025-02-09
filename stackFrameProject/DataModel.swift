//
//  DataModel.swift
//  stackFrameProject
//
//  Created by admin@33 on 05/02/25.
//

import Foundation
import Combine

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchData(completion: @escaping (APIResponse?) -> Void) {
        guard let url = URL(string: "https://api.mocklets.com/p6764/test_mint") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(apiResponse)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}
