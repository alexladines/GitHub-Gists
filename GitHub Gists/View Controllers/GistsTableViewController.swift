//
//  GistsTableViewController.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 8/21/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import UIKit
import Alamofire
import PINRemoteImage

class GistsTableViewController: UITableViewController {
    // MARK: - Properties
    var gists: [Gist] = []
    var nextPageURLString: String?
    var isLoading = false

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
        loadGists(urlToLoad: nil) // load first page
        
    }

    // MARK: - Methods
    func loadGists(urlToLoad: String?) {
        isLoading = true

        GitHubAPIManager.shared.fetchPublicGists(pageToLoad: urlToLoad) { (result, nextPage) in
            self.isLoading = false
            self.nextPageURLString = nextPage

            guard result.error == nil else {
                self.handleLoadGistsError(result.error!)
                return
            }

            if let fetchedGists = result.value {
                if urlToLoad == nil {
                    // empty out the gists because we're not loading another page
                    self.gists = []
                }

                self.gists += fetchedGists
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

        // Persistent image caching library
        if let url = gist.owner?.avatarURL {
            cell.imageView?.pin_setImage(from: url, placeholderImage: UIImage(named: "placeholder.png")) { (result) in
                if let cellToUpdate = self.tableView.cellForRow(at: indexPath) {
                    cellToUpdate.setNeedsLayout()
                }
            }
        }
        else {
            cell.imageView?.image = UIImage(named: "placeholder.png")
        }

        if !isLoading {
            let rowsLoaded = gists.count
            let rowsRemaining = rowsLoaded - indexPath.row
            let rowsToLoadFromBottom = 5

            if rowsRemaining <= rowsToLoadFromBottom {
                if let nextPage = nextPageURLString {
                    self.loadGists(urlToLoad: nextPage)
                }
            }
        }
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
