//
//  ImageViewController.swift
//  Prefetch
//
//  Created by Mohammed Rokon Uddin on 7/12/18.
//  Copyright © 2018 Monstar Lab Bangladesh Ltd. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    let photoDataStore = PhotoDataStore()
    let loadingQueue = OperationQueue()
    var loadingOperations = [IndexPath : DataLoadOperation]()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
    }
}

// MARK:- TableView Delegate
extension ImageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ImageTableViewCell else { return }

        let updateCellClosure: (PhotoModel?) -> () = { [unowned self] (photo) in
            cell.updateAppearanceFor(photo?.image, animated: true)
            self.loadingOperations.removeValue(forKey: indexPath)
        }

        if let dataLoader = loadingOperations[indexPath] {
            if let image = dataLoader.photo?.image {
                cell.updateAppearanceFor(image, animated: false)
                loadingOperations.removeValue(forKey: indexPath)
            } else {
                dataLoader.loadingCompleteHandler = updateCellClosure
            }
        } else {
            if let dataLoader = photoDataStore.loadPhoto(at: indexPath.row) {
                dataLoader.loadingCompleteHandler = updateCellClosure
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
}

// MARK:- TableView Datasource
extension ImageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoDataStore.numberOfPhoto
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as? ImageTableViewCell else {
            fatalError("Sorry could not load cell")
        }
        cell.updateAppearanceFor(.none, animated: false)
        return cell
    }
}

// MARK:- TableView DataSourcePrefetching
extension ImageViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = loadingOperations[indexPath] {
                return
            }
            if let dataLoader = photoDataStore.loadPhoto(at: indexPath.row) {
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataLoader = loadingOperations[indexPath] {
                dataLoader.cancel()
                loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
}
