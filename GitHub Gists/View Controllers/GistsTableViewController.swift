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
import SafariServices

class GistsTableViewController: UITableViewController {
    // MARK: - Properties
    var gists: [Gist] = []
    var nextPageURLString: String?
    var isLoading = false
    var dateFormatter = DateFormatter()
    var safariViewController: SFSafariViewController?

    // MARK: - IBOutlets

    // MARK: - IBActions

    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        // Add refresh control for pull to refresh
        if refreshControl == nil {
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        }

        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .long

        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadGists(urlToLoad: nil) // load first page
        GitHubAPIManager.shared.printMyStarredGistsWithOAuth2()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gists"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGist))
        
    }



    // MARK: - Methods
    func loadGists(urlToLoad: String?) {
        isLoading = true

        GitHubAPIManager.shared.fetchPublicGists(pageToLoad: urlToLoad) { (result, nextPage) in
            self.isLoading = false
            self.nextPageURLString = nextPage

            // Refresh control should stop showing now
            if self.refreshControl != nil, self.refreshControl!.isRefreshing {
                self.refreshControl?.endRefreshing()
            }

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

            // Update "last updated" title for refresh control
            let now = Date()
            let updateString = "Last Updated at " + self.dateFormatter.string(from: now)
            self.refreshControl?.attributedTitle = NSAttributedString(string: updateString)
            self.tableView.reloadData()
        }
    }

    func loadInitialData() {
        if (!GitHubAPIManager.shared.hasOAuthToken()) {

        }
    }

    func showOAuthLoginView() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            assert(false, "Misnamed VC")
            return
        }
        loginVC.delegate = self
        present(loginVC, animated: true)
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

    @objc func refresh(sender: Any) {
        nextPageURLString = nil // Don't append results
        GitHubAPIManager.shared.clearCache()
        loadGists(urlToLoad: nil)
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
extension GistsTableViewController: LoginViewControllerDelegate {
    func loginViewControllerDidFinishSelecting(_ controller: LoginViewController) {
        dismiss(animated: false, completion: nil)
        guard let authURL = GitHubAPIManager.shared.URLToStartOAuth2Login() else {
            return
        }

        // TODO: Show web page to start oauth
        safariViewController = SFSafariViewController(url: authURL)
        safariViewController?.delegate = self

        guard let webViewController = safariViewController else {
            return
        }

        present(webViewController, animated: true)
    }


}

extension GistsTableViewController: SFSafariViewControllerDelegate {

}
