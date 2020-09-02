//
//  ViewController.swift
//  StoreSearch
//
//  Created by Ufuk Canlı on 1.09.2020.
//  Copyright © 2020 Ufuk Canlı. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
        }
    }
    
    var searchResults = [SearchResult]()
    var hasSearched = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
          TableView.CellIdentifiers.nothingFoundCell)
        
        searchBar.becomeFirstResponder()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }

}

// MARK: - Helper Methods

extension SearchViewController {
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    func iTunesURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://itunes.apple.com/search?term=%@", encodedText)
        let url = URL(string: urlString)
        return url!
    }
    
    func performStoreRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            showNetworkError()
            return nil
        }
    }
    
    func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON Error: \(error.localizedDescription)")
            return []
        }
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the iTunes Store." + " Please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()

            hasSearched = true
            searchResults = []

            let url = iTunesURL(searchText: searchBar.text!)
            
            if let data = performStoreRequest(with: url) {
                searchResults = parse(data: data)
            }

            searchResults.sort { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
            
            tableView.reloadData()
        }
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchResults.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:
              TableView.CellIdentifiers.searchResultCell,
              for: indexPath) as! SearchResultCell

            let searchResult = searchResults[indexPath.row]
            
            cell.nameLabel.text = searchResult.name
            
            if searchResult.artist.isEmpty {
                cell.artistNameLabel.text = "Unknown"
            } else {
                cell.artistNameLabel.text = String(format: "%@ (%@)", searchResult.artist, searchResult.type)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
