//
//  MasterViewController.swift
//  GitHub Gists
//
//  Created by Alex Ladines on 7/23/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var gists = [Gist]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    // Data loading usually goes in viewWillAppear but I will use a login view and I can't present a new vc until the current vc is finished appearing
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadGists()

    }

    func loadGists() {
//        // Dummy data to get the tableView to show something
//        let alexladines = Gist.Owner(login: "alexladines", avatarURL: URL(string: "https://grokswift.com//a_test_avatar_url"))
//        let gist1 = Gist(id: "1", gistDescription: "The first gist", url: URL(string: "https://grokswift.com//test_gist_url_1")!, owner: alexladines)
//        let gist2 = Gist(id: "2", gistDescription: "The second gist", url: URL(string: "https://grokswift.com//test_gist_url_2")!, owner: alexladines)
//        let gist3 = Gist(id: "3", gistDescription: "The third gist", url: URL(string: "https://grokswift.com//test_gist_url_3")!, owner: alexladines)
//        gists = [gist1, gist2, gist3]
//
//        // Tell the table view to reload
//        self.tableView.reloadData()
        GitHubAPIManager.shared.printPublicGists()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc
    func insertNewObject(_ sender: Any) {
        let alert = UIAlertController(title: "Not Implemented", message: "Can't create new gists yet, will implement later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow,
                let controller = (segue.destination as? UINavigationController)?
                    .topViewController as? DetailViewController {
                let gist = gists[indexPath.row]
                controller.detailItem = gist
                controller.navigationItem.leftBarButtonItem =
                    self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }

    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let gist = gists[indexPath.row]
        cell.textLabel?.text = gist.gistDescription
        cell.detailTextLabel?.text = gist.owner?.login
        // TODO: set cell.imageView to display image at gist.ownerAvatarURL
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            gists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

