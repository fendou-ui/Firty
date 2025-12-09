import UIKit
import SVProgressHUD

class Lady_TabFavoritesViewController: UIViewController {
    
    private var lady_titleView: UIView!
    private var lady_titleLabel: UILabel!
    private var lady_tableView: UITableView!
    private var lady_emptyView: UIView!
    private var lady_emptyLabel: UILabel!
    private var lady_clearButton: UIButton!
    
    private var lady_favoriteItems = [[String: String]]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lady_loadFavorites()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lady_createViews()
        lady_setupUI()
        lady_setupTableView()
        lady_loadFavorites()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 标题栏设置为透明，显示背景图片
        lady_titleView.backgroundColor = .clear
    }
    
    private func lady_createViews() {
        view.backgroundColor = UIColor.systemBackground
        
        // 添加背景图片
        let backgroundImageView = UIImageView(image: UIImage(named: "lady-BJ"))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 创建标题视图
        lady_titleView = UIView()
        lady_titleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lady_titleView)
        
        // 创建标题标签
        lady_titleLabel = UILabel()
        lady_titleLabel.text = "My Favorites"
        lady_titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        lady_titleLabel.textColor = .white
        lady_titleLabel.translatesAutoresizingMaskIntoConstraints = false
        lady_titleView.addSubview(lady_titleLabel)
        
        // 创建清除按钮
        lady_clearButton = UIButton(type: .system)
        lady_clearButton.setTitle("Clear All", for: .normal)
        lady_clearButton.setTitleColor(.white, for: .normal)
        lady_clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        lady_clearButton.translatesAutoresizingMaskIntoConstraints = false
        lady_clearButton.addTarget(self, action: #selector(lady_clearAllButton(_:)), for: .touchUpInside)
        lady_titleView.addSubview(lady_clearButton)
        
        // 创建表格视图
        lady_tableView = UITableView()
        lady_tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lady_tableView)
        
        // 创建空状态视图
        lady_emptyView = UIView()
        lady_emptyView.translatesAutoresizingMaskIntoConstraints = false
        lady_emptyView.backgroundColor = UIColor.clear
        view.addSubview(lady_emptyView)
        
        lady_emptyLabel = UILabel()
        lady_emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        lady_emptyView.addSubview(lady_emptyLabel)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 标题视图约束
            lady_titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lady_titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lady_titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lady_titleView.heightAnchor.constraint(equalToConstant: 80),
            
            // 标题标签约束
            lady_titleLabel.leadingAnchor.constraint(equalTo: lady_titleView.leadingAnchor, constant: 20),
            lady_titleLabel.centerYAnchor.constraint(equalTo: lady_titleView.centerYAnchor),
            
            // 清除按钮约束
            lady_clearButton.trailingAnchor.constraint(equalTo: lady_titleView.trailingAnchor, constant: -20),
            lady_clearButton.centerYAnchor.constraint(equalTo: lady_titleView.centerYAnchor),
            
            // 表格视图约束
            lady_tableView.topAnchor.constraint(equalTo: lady_titleView.bottomAnchor),
            lady_tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lady_tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lady_tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 空状态视图约束
            lady_emptyView.topAnchor.constraint(equalTo: lady_titleView.bottomAnchor),
            lady_emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lady_emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lady_emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 空状态标签约束
            lady_emptyLabel.centerXAnchor.constraint(equalTo: lady_emptyView.centerXAnchor),
            lady_emptyLabel.centerYAnchor.constraint(equalTo: lady_emptyView.centerYAnchor)
        ])
    }
    
    private func lady_setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        
        lady_emptyLabel.text = "No favorites yet\nStart collecting your favorite conversations!"
        lady_emptyLabel.textAlignment = .center
        lady_emptyLabel.numberOfLines = 0
        lady_emptyLabel.textColor = UIColor.lightGray
        lady_emptyLabel.font = UIFont.systemFont(ofSize: 16)
    }
    
    private func lady_setupTableView() {
        lady_tableView.dataSource = self
        lady_tableView.delegate = self
        lady_tableView.backgroundColor = .clear
        lady_tableView.register(UITableViewCell.self, forCellReuseIdentifier: "favorite")
        lady_tableView.separatorStyle = .none
    }
    
    private func lady_loadFavorites() {
        if let favorites = UserDefaults.standard.object(forKey: "lady_favorites") as? [[String: String]] {
            lady_favoriteItems = favorites
        } else {
            lady_favoriteItems = []
        }
        
        lady_emptyView.isHidden = !lady_favoriteItems.isEmpty
        lady_tableView.isHidden = lady_favoriteItems.isEmpty
        lady_tableView.reloadData()
    }
    
    @objc func lady_clearAllButton(_ sender: Any) {
        let alert = UIAlertController(title: "Clear All Favorites", message: "Are you sure you want to remove all favorites?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { _ in
            self.lady_clearAllFavorites()
        })
        
        present(alert, animated: true)
    }
    
    private func lady_clearAllFavorites() {
        UserDefaults.standard.removeObject(forKey: "lady_favorites")
        lady_favoriteItems.removeAll()
        lady_emptyView.isHidden = false
        lady_tableView.isHidden = true
        lady_tableView.reloadData()
        SVProgressHUD.showSuccess(withStatus: "All favorites cleared")
    }
    
    private func lady_removeFavorite(at index: Int) {
        lady_favoriteItems.remove(at: index)
        UserDefaults.standard.setValue(lady_favoriteItems, forKey: "lady_favorites")
        
        if lady_favoriteItems.isEmpty {
            lady_emptyView.isHidden = false
            lady_tableView.isHidden = true
        }
        
        lady_tableView.reloadData()
        SVProgressHUD.showSuccess(withStatus: "Removed from favorites")
    }
}

extension Lady_TabFavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lady_favoriteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "favorite")
        let item = lady_favoriteItems[indexPath.row]
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        // 显示收藏内容
        cell.textLabel?.text = item["lady_character"] ?? "Unknown"
        cell.detailTextLabel?.text = item["lady_message"] ?? ""
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.numberOfLines = 3
        cell.detailTextLabel?.textColor = UIColor.darkGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            lady_removeFavorite(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = lady_favoriteItems[indexPath.row]
        
        let alert = UIAlertController(title: item["lady_character"] ?? "Favorite", message: item["lady_message"], preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
