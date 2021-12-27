//
//  SearchiewController.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/26.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SearchiewController: UITableViewController {
    private lazy var searchController: UISearchController = {
        let searchController =  UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.searchBar.autocapitalizationType = .none
        return searchController
    }()
    
    private var searchBar: UISearchBar {
        searchController.searchBar
    }
    
    private lazy var searchResultController: SearchResultViewController = {
        let searchResultViewController = SearchResultViewController.instantiateFromStoryboard()
        searchResultViewController.delegate = self
        return searchResultViewController
    }()
    
    private var viewModel = SearchViewModel()
    private var searchKeywordSubject = PublishSubject<String>()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureSearchController()
        bindUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.sizeToFit()
    }
    
    private func configureSearchController() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func bindUI() {
        tableView.dataSource = nil
        tableView.delegate = nil
        
        let sharedSearchKeyworkd = searchBar.rx.searchButtonClicked
            .compactMap { [weak self] _ -> String? in
                self?.searchBar.text
            }
            .share()
        
        sharedSearchKeyworkd
            .bind(to: searchKeywordSubject)
            .disposed(by: disposeBag)
        
        sharedSearchKeyworkd
            .bind(to: searchResultController.searchITBookSubject)
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext:  { [weak self] keyword in
                self?.searchController.isActive = true
                self?.searchBar.text = keyword
                self?.searchBar.endEditing(true)
                self?.searchKeywordSubject.onNext(keyword)
                self?.searchResultController.searchITBookSubject.onNext(keyword)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(searchITBooks: searchKeywordSubject.asObservable()))
                
        output.recentlySearchKeyword
            .drive(tableView.rx.items(cellIdentifier: "History", cellType: UITableViewCell.self)) { index, keyword, cell in
                cell.textLabel?.text = keyword
            }
            .disposed(by: disposeBag)
    }
    
    private func goToitBookDetailView(with itBook: ITBook) {
        let vc = ITBookDetailViewController.instantiateFromStoryboard()
        vc.bookSubject.onNext(itBook)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchiewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension SearchiewController: SearchResultViewControllerDelegate {
    func didSelectedITBook(_ itBook: ITBook) {
        goToitBookDetailView(with: itBook)
    }
}
