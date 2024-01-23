//
//  Utility.swift
//  ios-foundation
//
//  Created by Erwin Ramadhan Edwar Putra on 22/01/24.
//

import Foundation

class Utility {
    func getDataFromUrl(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completionHandler: @escaping (Data) -> Void) {
        getDataFromUrl(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completionHandler(data)
            }
        }
    }
}
