//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by MacBook Air on 30/08/2023.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var loadedPetitons = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCreditsAlert))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(showFilterAlert))
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
    }
    @objc func showCreditsAlert() {
        if let url = URL(string: "https://www.hackingwithswift.com/samples/petitions-1.json") {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        let alertController = UIAlertController(title: "Credits", message: "https://api.whitehouse.gov/v1/petitions.json?limit=100", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        
        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    func filterPetitions(with searchText: String) {
        loadedPetitons += petitions
        for item in loadedPetitons {
            if item.title.lowercased().contains("\(searchText.lowercased())") {
                filteredPetitions.append(item)
            }
        }
        petitions.removeAll(keepingCapacity: true)
                petitions += filteredPetitions
                tableView.reloadData()
    }
    @objc func showFilterAlert() {
        let alertController = UIAlertController(title: "Filter Petitions", message: "Enter a search term", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Search"
        }
        
        let filterAction = UIAlertAction(title: "Filter", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first,
                  let searchText = textField.text else {
                return
            }
            self?.filterPetitions(with: searchText)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(filterAction)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
}
