//
//  TalkViewController.swift
//  Asher
//
//  Created by chuchu on 7/18/24.
//

import UIKit

final class TalkViewController: UIViewController {
    override func loadView() {
        view = TalkView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .chatBackground
    }
}
