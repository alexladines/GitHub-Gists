//
//  GistsTableViewController.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 8/21/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import UIKit
import Alamofire

class GistsTableViewController: UITableViewController {
    // MARK: - Properties

    // MARK: - IBOutlets

    // MARK: - IBActions

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gists"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GitHubAPIManager.shared.printPublicGists()
    }

    // MARK: - Methods

    // MARK: - Navigation

    // MARK: - Data Persistance

    // MARK: - UITableViewDataSource

    // MARK: - UITableViewDelegate

}
