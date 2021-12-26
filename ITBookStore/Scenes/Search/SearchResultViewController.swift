//
//  SearchResultViewController.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/26.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class SearchResultViewController: UIViewController, StoryBoardInstantiable {
    typealias Keyworkd = String
    
    static var storyboardName: String {
        "Main"
    }
    
    let searchITBookSubject = PublishSubject<Keyworkd>()
    
    @IBOutlet private var tableView: UITableView!
    private let loadMoreSubject = PublishSubject<Void> ()
    private let sectionModelSubject = BehaviorSubject<[SearchResultSectionModel]>(value: [])
    private let viewModel = SearchResultViewModel(searchITBookUseCase: DefaultSearchITBookUseCase(repository: ITBookStoreRepository()))
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        bindUI()
        bindViewModel()
    }
    
    private func configureTableView() {
        let ITBookCell = UINib(nibName: "ITBookCell", bundle: nil)
        let loadMoreCell = UINib(nibName: "LoadMoreCell", bundle: nil)
        tableView.register(ITBookCell, forCellReuseIdentifier: "ITBookCell")
        tableView.register(loadMoreCell, forCellReuseIdentifier: "LoadMoreCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }
    
    private func bindUI() {
        let sectionDataSource = sectionReoadDataSource()
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(SearchResultSectionItem.self)
            .subscribe(onNext: { [weak self] sectionItem in
                
                
            })
            .disposed(by: disposeBag)
        
        sectionModelSubject
            .bind(to: tableView.rx.items(dataSource: sectionDataSource))
            .disposed(by: disposeBag)
        
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(searchITBooks: searchITBookSubject.asObservable(),
                                                      readMore: loadMoreSubject.asObservable()))
        output.searchResult
            .drive { [weak self] result in
                switch result {
                case .success(let booksData):
                    self?.emitDataSource(whit: booksData.books,
                                         hasMore: booksData.hasMore)
                case .failure(_):
                    break
                }
            }
            .disposed(by: disposeBag)
    }
                                                                      
    private func emitDataSource(whit itBooks: [ITBook], hasMore: Bool) {
        
        let booksSectionModel = SearchResultSectionModel.ITBookSection(title: "Books",
                                                                       itmes: itBooks.map { SearchResultSectionItem.ITBook($0)  })
        
        let loadMoreSectionModel = SearchResultSectionModel.loadMore(title: "Load more",
                                                                     items: hasMore ? [SearchResultSectionItem.loadMore] : [])
            
        
        sectionModelSubject.onNext([booksSectionModel, loadMoreSectionModel])
    }
    
    private func sectionReoadDataSource() -> RxTableViewSectionedReloadDataSource<SearchResultSectionModel>{
        return  RxTableViewSectionedReloadDataSource<SearchResultSectionModel>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch item {
                case let .ITBook(hitory: book):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ITBookCell", for: indexPath) as! ITBookCell
                    cell.bookImageView?.setImage(with: book.image, imageDownloader: DefaultImageDownloader.shared)
                    cell.titleLabel.text = book.title
                    cell.subTitleLabel.text = book.subtitle
                    cell.priceLabel.text = book.price
                    return cell
                case .loadMore:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell", for: indexPath) as! LoadMoreCell
                    cell.indicator.startAnimating()
                    return cell
                }
        })
    }
}

extension SearchResultViewController: UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch cell.self {
        case is LoadMoreCell:
            loadMoreSubject.onNext(())
        default:
            break
        }
    }
}
