//
//  PhotoDataStore.swift
//  Prefetch
//
//  Created by Mohammed Rokon Uddin on 7/12/18.
//  Copyright © 2018 Monstar Lab Bangladesh Ltd. All rights reserved.
//

import Foundation
import UIKit.UIImage

let photoArray: [PhotoModel] = [
PhotoModel(url: "https://robohash.org/123.png", order: 0),
PhotoModel(url: "https://robohash.org/123.png", order: 1),
PhotoModel(url: "https://robohash.org/123.png", order: 2),
PhotoModel(url: "https://robohash.org/123.png", order: 3),
PhotoModel(url: "https://robohash.org/123.png", order: 4),
PhotoModel(url: "https://robohash.org/123.png", order: 5),
PhotoModel(url: "https://robohash.org/123.png", order: 6),
PhotoModel(url: "https://robohash.org/123.png", order: 7),
PhotoModel(url: "https://robohash.org/123.png", order: 8),
PhotoModel(url: "https://robohash.org/123.png", order: 9),
PhotoModel(url: "https://robohash.org/123.png", order: 10),
PhotoModel(url: "https://robohash.org/123.png", order: 11),
PhotoModel(url: "https://robohash.org/123.png", order: 12),
PhotoModel(url: "https://robohash.org/123.png", order: 13),
PhotoModel(url: "https://robohash.org/123.png", order: 14),
PhotoModel(url: "https://robohash.org/123.png", order: 15),
PhotoModel(url: "https://robohash.org/123.png", order: 16),
PhotoModel(url: "https://robohash.org/123.png", order: 17),
PhotoModel(url: "https://robohash.org/123.png", order: 18),
PhotoModel(url: "https://robohash.org/123.png", order: 19),
PhotoModel(url: "https://robohash.org/123.png", order: 20),
PhotoModel(url: "https://robohash.org/123.png", order: 21),
PhotoModel(url: "https://robohash.org/123.png", order: 22),
PhotoModel(url: "https://robohash.org/123.png", order: 23),
PhotoModel(url: "https://robohash.org/123.png", order: 24),
PhotoModel(url: "https://robohash.org/123.png", order: 25),
PhotoModel(url: "https://robohash.org/123.png", order: 26),
PhotoModel(url: "https://robohash.org/123.png", order: 27),
PhotoModel(url: "https://robohash.org/123.png", order: 28),
PhotoModel(url: "https://robohash.org/123.png", order: 29),
PhotoModel(url: "https://robohash.org/123.png", order: 30)
]

class PhotoDataStore {
    private var photos = photoArray

    public var numberOfPhoto: Int {
        return photos.count
    }

    public func loadPhoto(at index: Int) -> DataLoadOperation? {
        if photos.indices.contains(index) {
            return DataLoadOperation(photos[index])
        }
        return .none
    }

    public func update(photo: PhotoModel) {
        if let index = photos.index(where: { $0.order == photo.order }) {
            photos.replaceSubrange(index...index, with: [photo])
        }
    }
}

class DataLoadOperation: Operation {
    var photo: PhotoModel?
    var loadingCompleteHandler: ((PhotoModel) -> ())?

    private let _photo: PhotoModel

    init(_ photo: PhotoModel) {
        _photo = photo
    }

    override func main() {
        if isCancelled { return }

        let randomDelayTime = arc4random_uniform(2000) + 500
        usleep(randomDelayTime * 1000)

        if isCancelled { return }
        self.photo = _photo

        if let loadingCompleteHandler = loadingCompleteHandler {
            URLSession.shared.dataTask(with: _photo.url!) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [unowned self] in
                    self.photo?.image = image
                    loadingCompleteHandler(self.photo!)
                }
                }.resume()
        }
    }

    func downloaded(from url: URL) {

    }
    
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url)
    }
}


