//
//  ITBookDetailViewController.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/27.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ITBookDetailViewController: UIViewController, StoryBoardInstantiable, AlsertPresentable {
    typealias ISBN = String
    static var storyboardName: String { "Main" }
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var booImageView: UIImageView!
    @IBOutlet private weak var titlelabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var publisherLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var pageLabel: UILabel!
    @IBOutlet private weak var isbnLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    
    let bookSubject = BehaviorSubject<ITBook?>(value: nil)
    
    private let viewModel = ITBookDetailViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        bindData()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func initUI() {
        containerView.isHidden = true
    }
    
    private func bindData() {
        let book = bookSubject.compactMap { $0 }
            .asObservable()

        let output = viewModel.transform(input: .init(fecthITBookDetail: book))
        
        output.itBookDetail
            .drive { [weak self] result in
                switch result {
                case .success(let bookDetail):
                    self?.setITBookDetail(with: bookDetail)
                case .failure(let error):
                    self?.presentDefaultAlert(with: "Error", message: error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setITBookDetail(with itBookDetail: ITBookDetail) {
        booImageView.setImage(with: itBookDetail.image, imageDownloader: DefaultImageDownloader.shared)
        titlelabel.text = itBookDetail.title
        subtitleLabel.text = itBookDetail.subtitle
        authorLabel.text = itBookDetail.authors
        publisherLabel.text = itBookDetail.publisher
        ratingLabel.text = "Rating: \(itBookDetail.rating)"
        priceLabel.text = itBookDetail.price
        yearLabel.text = "\(itBookDetail.year)"
        pageLabel.text = "\(itBookDetail.pages)"
        isbnLabel.text = itBookDetail.isbn13
        urlLabel.text = itBookDetail.url
        descLabel.text = itBookDetail.desc
        containerView.isHidden = false
    }
}
