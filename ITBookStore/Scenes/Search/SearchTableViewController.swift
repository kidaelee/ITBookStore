//
//  SearchTableViewController.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/26.
//

import Foundation
import UIKit
import Then
import RxSwift
import RxCocoa

class SearchTableViewController: UITableViewController {
    private lazy var searchController: UISearchController = {
        UISearchController(searchResultsController: searchResultController).then {
            $0.searchResultsUpdater = self as UISearchResultsUpdating
            $0.searchBar.autocapitalizationType = .none
        }
    }()
    
    private var searchBar: UISearchBar {
        searchController.searchBar
    }
    
    private lazy var searchResultController: SearchResultViewController = {
        SearchResultViewController.instantiateFromStoryboard()
    }()
    
    private var viewModel = SearchTableViewModel()
    private var searchKeywordSubject = PublishSubject<String>()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        bindUI()
        bindViewModel()
    }
    
    private func configureSearchController() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func bindUI() {
        tableView.dataSource = nil
        tableView.delegate = nil
        
        searchBar.rx.searchButtonClicked
             .compactMap { [weak self] _ -> String? in
                 self?.searchBar.text
             }
             .bind(to: searchKeywordSubject)
             .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext:  { [weak self] keyword in
                self?.searchController.isActive = true
                self?.searchBar.text = keyword
                self?.searchBar.endEditing(true)
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
}

extension SearchTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
