//
//  LoadingViewController.swift
//  yolo-v3
//
//  Created by Tim Acosta on 29/8/21.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nextViewController()
    }

    func nextViewController() {
        let catalogueAndSearchViewModel = CatalogueAndSearchViewModel()
        let catalogueAndSearchViewController = CatalogueAndSearchViewController(viewModel: catalogueAndSearchViewModel)
        catalogueAndSearchViewModel.viewDelegate = catalogueAndSearchViewController
        if let window = SceneDelegate.shared.window {
            let navigationController = UINavigationController(rootViewController: catalogueAndSearchViewController)
            navigationController.navigationBar.isTranslucent = false
            window.rootViewController = navigationController
        }
    }
}
