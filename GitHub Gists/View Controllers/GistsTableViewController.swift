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
    var gists: [Gist] = []

    // MARK: - IBOutlets

    // MARK: - IBActions

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gists"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGist))
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadGists()
        
    }

    // MARK: - Methods
    func loadGists() {
        GitHubAPIManager.shared.fetchPublicGists { (result) in
            guard result.error == nil else {
                self.handleLoadGistsError(result.error!)
                return
            }

            if let fetchedGists = result.value {
                self.gists = fetchedGists
            }

            self.tableView.reloadData()

        }
    }

    func handleLoadGistsError(_ error: Error) {
        // TODO: show error

    }

    func addSampleData() {
        let owner = Gist.Owner(login: "abc", avatarURL: URL(string: "https://hello.com"))
        let gist1 = Gist(url: URL(string: "https://abc.com")!, id: "alexladines", gistDescription: "Hello World", owner: owner)
        gists.append(gist1)
        tableView.reloadData()
    }

    @objc func addGist() {
        let alert = UIAlertController(title: "Not Implemented Yet", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    // MARK: - Navigation

    // MARK: - Data Persistance

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gists.count
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Gist", for: indexPath)

        let gist = gists[indexPath.row]

        cell.textLabel?.text = gist.gistDescription
        cell.detailTextLabel?.text = gist.owner?.login

        // TODO: set cell.imageView to display image at gist.ownerAvatarURL

        return cell

    }

    // Cells will not be editable for now
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            gists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class,
            // insert it into the array, and add a new row to the table view.
        }
    }

}
