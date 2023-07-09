//
//  ViewController.swift
//  NetworkGCD
//
//  Created by 이유리 on 2023/07/06.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var musicTableView: UITableView!
    
    lazy var networkManager = NetworkManager.shared
    
    // 네비게이션 바에 embed할 search VC
//    let searchController = UISearchController()
    
    // 서치 Results컨트롤러
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController)

    var musicArrays: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupSearchBar()
        setupDatas()
    }
    
    func setupTableView() {
        //테이블뷰
        musicTableView.dataSource = self
        musicTableView.delegate = self

        // xib로 cell을 만들었을 때 따로 register 과정 필요
        musicTableView.register(UINib(nibName: MusicTableViewCell.id, bundle: nil), forCellReuseIdentifier: MusicTableViewCell.id)
        
        // 유동적인 cell을 위해 필요
        musicTableView.rowHeight = 120
        musicTableView.estimatedRowHeight = UITableView.automaticDimension
        
    }
    
    // 서치바 셋팅
    func setupSearchBar() {
        self.title = "Music Search"
        navigationItem.searchController = searchController
        
        // 1) 네비게이션 바에서 서치바의 사용
//        searchController.searchBar.delegate = self
        
        
        // 2) 서치(결과)컨트롤러의 사용
        searchController.searchResultsUpdater = self
        
        // 첫글자 대문자 설정 없애기
        searchController.searchBar.autocapitalizationType = .none
    }
    
    // 데이터 셋업
    func setupDatas() {
        networkManager.getMusic(searchTerm: "popsong") { result in
            switch result {
            case .success(let musicDatas):
                // 데이터(배열)을 받아오고 난 후
                self.musicArrays = musicDatas
                // 테이블뷰 리로드 -> URLSession 자체가 비동기적으로 실행되므로 따로 main 스레드에서 실행되도록 해야함
                DispatchQueue.main.async {
                    self.musicTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return self.musicArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = musicTableView.dequeueReusableCell(withIdentifier: MusicTableViewCell.id, for: indexPath) as! MusicTableViewCell
        
        // 이미지를 다운로드 받는일은 오래걸리는 일이기때문에, 먼저 url을 다 전달 받은 다음에 로딩해야함
        cell.imageUrl = musicArrays[indexPath.row].imageUrl
        
        cell.songNameLabel.text = musicArrays[indexPath.row].songName
        cell.artistNameLabel.text = musicArrays[indexPath.row].artistName
        cell.albumNameLabel.text = musicArrays[indexPath.row].albumName
        cell.releaseDateLabel.text = musicArrays[indexPath.row].releaseDateString
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension ViewController: UISearchBarDelegate {

    // 서치바에서 글자를 입력할 때마다 호출되는 메서드
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        print(searchText) // 띄어쓰기가 있으면 "+"를 붙여서 보내야함
        let searchText = searchText.replacingOccurrences(of: " ", with: "+")

        self.musicArrays.removeAll()

        networkManager.getMusic(searchTerm: searchText) { result in
            switch result {
            case .success(let musicDatas):
                self.musicArrays = musicDatas
                DispatchQueue.main.async {
                    self.musicTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "")
        let searchText = searchController.searchBar.text? .replacingOccurrences(of: " ", with: "+")

        let vc = searchController.searchResultsController as! SearchResultViewController
        // 컬렉션뷰에 찾으려는 단어 전달
        vc.searchTerm = searchText
    }
}
