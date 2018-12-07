//
//  PhotoDataStore.swift
//  Prefetch
//
//  Created by Mohammed Rokon Uddin on 7/12/18.
//  Copyright © 2018 Monstar Lab Bangladesh Ltd. All rights reserved.
//

import Foundation
import UIKit.UIImage

let baseURL = "https://robohash.org/"

class PhotoDataStore {
    private var photos = (1...30)
                            .map { PhotoModel(url: baseURL+"\($0).png",
                                order: $0) }
    public var numberOfPhoto: Int {
        return photos.count
    }

    public func loadPhoto(at index: Int) -> DataLoadOperation? {
        if (0..<photos.count).contains(index) {
            return DataLoadOperation(photos[index])
        }
        return .none
    }
}

class DataLoadOperation: Operation {
    var image: UIImage?
    var loadingCompleteHandler: ((UIImage?) -> ())?
    private var _photo: PhotoModel
    
    init(_ photo: PhotoModel) {
        _photo = photo
    }

    override func main() {
        if isCancelled { return }
        guard let url = _photo.url else { return }
        downloadImageFrom(url) { (image) in
            DispatchQueue.main.async() {
                if self.isCancelled { return }
                self.image = image
                if let loadingCompleteHandler = self.loadingCompleteHandler {
                    loadingCompleteHandler(self.image)
                }
            }
        }
    }
}

func downloadImageFrom(_ url: URL, completeHandler: @escaping (UIImage?) -> ()) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let _image = UIImage(data: data)
            else { return }
        completeHandler(_image)
        }.resume()
}


