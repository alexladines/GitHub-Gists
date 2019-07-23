//
//  DetailViewController.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 7/23/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detailItem?.gistDescription
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: Gist? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

