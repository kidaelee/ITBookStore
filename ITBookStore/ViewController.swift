//
//  ViewController.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/24.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        test()
    }
    
    func test() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.setImage(with: "https://itbook.store/img/books/9781484206485.png")
        
        imageView.cancelImageRequest()
        
        self.view.addSubview(imageView)
    }

}

