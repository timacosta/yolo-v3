//
//  CatalogueAndSearchViewController.swift
//  yolo-v3
//
//  Created by Tim Acosta on 29/8/21.
//

import UIKit

class CatalogueAndSearchViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView?

    var viewModel: CatalogueAndSearchViewModel
    
    init(viewModel: CatalogueAndSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        viewModel.viewWasLoaded()
    }

    private func configureViewController() {
        title = "Catalogue"
    }
    
    private func configureCollectionView() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(UINib(nibName: "ImageCell", bundle: nil),
                                 forCellWithReuseIdentifier: "ImageCell")
    }

    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search objects..."
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchInCatalogue))
    }
    
    @objc private func searchInCatalogue() {
        navigationItem.searchController?.isActive = true
        navigationItem.searchController?.searchBar.becomeFirstResponder()
    }
    
    /*@objc private func scrollUp() {
        if collectionView?.contentOffset.y ?? 0 >= 50 {
            collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
            DispatchQueue.main.async { [weak self] in
                self?.collectionView?.contentOffset = CGPoint(x: 0, y: -50)
            }
        }
    }*/
}

extension CatalogueAndSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellViewModel = viewModel.viewModel(at: indexPath),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        cell.viewModel = cellViewModel
        return cell
    }
}

extension CatalogueAndSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageName = viewModel.imageCellViewModels[indexPath.row].testImage?.name,
              let imageData = UIImage(named: imageName)?.pngData() else { return }
        let imageDetailViewModel = ImageDetailViewModel(imageData: imageData)
        let imageDetailViewController = ImageDetailViewController(viewModel: imageDetailViewModel)
        imageDetailViewModel.viewDelegate = imageDetailViewController
        navigationController?.pushViewController(imageDetailViewController, animated: true)
    }
}

extension CatalogueAndSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 400)
    }
}

extension CatalogueAndSearchViewController: CatalogueAndSearchViewDelegate {
    func catalogueImagesLoaded() {
        collectionView?.reloadData()
    }
}

extension CatalogueAndSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        let testImages = ImageRepository.shared.getData().map({ ImageCellViewModel(image: $0)})
        viewModel.imageCellViewModels = testImages.filter({ (image) -> Bool in
            return image.testImage?.recognizedObjects.lowercased().contains(text) ?? false
        })
        if viewModel.imageCellViewModels.count <= 0 {
            viewModel.imageCellViewModels = testImages
        }
        collectionView?.reloadData()
    }
}
