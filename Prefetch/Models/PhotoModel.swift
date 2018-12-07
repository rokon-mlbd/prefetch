//
//  PhotoModel.swift
//  Prefetch
//
//  Created by Mohammed Rokon Uddin on 7/12/18.
//  Copyright © 2018 Monstar Lab Bangladesh Ltd. All rights reserved.
//

import Foundation

struct PhotoModel {
    public private(set) var url: URL?
    let order: Int

    init(url: String?, order: Int) {
        self.url = url?.toURL
        self.order = order
    }
}

public extension String {
    var toURL: URL? {
        return URL(string: self)
    }
}
