import UIKit
import SVProgressHUD

class Lady_MoodTrackerViewController: UIViewController {
    
    @IBOutlet weak var lady_titleView: UIView!
    @IBOutlet weak var lady_currentMoodView: UIView!
    @IBOutlet weak var lady_currentMoodLabel: UILabel!
    @IBOutlet weak var lady_currentMoodEmoji: UILabel!
    @IBOutlet weak var lady_moodCollectionView: UICollectionView!
    @IBOutlet weak var lady_historyTableView: UITableView!
    @IBOutlet weak var lady_segmentControl: UISegmentedControl!
    
    private var lady_moodOptions = [
        ["emoji": "😊", "name": "Happy", "color": "#FFD700"],
        ["emoji": "😢", "name": "Sad", "color": "#87CEEB"],
        ["emoji": "😡", "name": "Angry", "color": "#FF6B6B"],
        ["emoji": "😴", "name": "Tired", "color": "#DDA0DD"],
        ["emoji": "😍", "name": "Excited", "color": "#FF69B4"],
        ["emoji": "😰", "name": "Anxious", "color": "#FFA500"],
        ["emoji": "🤔", "name": "Thoughtful", "color": "#98FB98"],
        ["emoji": "😌", "name": "Peaceful", "color": "#E6E6FA"]
    ]
    
    private var lady_moodHistory = [[String: String]]()
    private var lady_currentSelectedMood: [String: String]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lady_loadMoodData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lady_setupUI()
        lady_setupCollectionView()
        lady_setupTableView()
        lady_loadMoodData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lady_titleView.lady_colorGradient(lady_colors: [UIColor(red: 0.65, green: 0.72, blue: 1, alpha: 1), UIColor(red: 1, green: 0.8, blue: 1, alpha: 1)])
    }
    
    private func lady_setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        
        lady_currentMoodView.layer.cornerRadius = 15
        lady_currentMoodView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        lady_currentMoodView.layer.shadowColor = UIColor.black.cgColor
        lady_currentMoodView.layer.shadowOffset = CGSize(width: 0, height: 2)
        lady_currentMoodView.layer.shadowRadius = 4
        lady_currentMoodView.layer.shadowOpacity = 0.1
        
        lady_segmentControl.selectedSegmentIndex = 0
        lady_updateViewMode()
    }
    
    private func lady_setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        
        lady_moodCollectionView.collectionViewLayout = layout
        lady_moodCollectionView.dataSource = self
        lady_moodCollectionView.delegate = self
        lady_moodCollectionView.backgroundColor = .clear
        lady_moodCollectionView.register(UINib(nibName: "Lady_MoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "mood")
    }
    
    private func lady_setupTableView() {
        lady_historyTableView.dataSource = self
        lady_historyTableView.delegate = self
        lady_historyTableView.backgroundColor = .clear
        lady_historyTableView.register(UINib(nibName: "Lady_MoodHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "history")
        lady_historyTableView.separatorStyle = .none
    }
    
    private func lady_loadMoodData() {
        // 加载今日心情
        let today = lady_getTodayString()
        if let todayMood = UserDefaults.standard.object(forKey: "lady_mood_\(today)") as? [String: String] {
            lady_currentSelectedMood = todayMood
            lady_updateCurrentMoodDisplay()
        } else {
            lady_currentMoodLabel.text = "How are you feeling today?"
            lady_currentMoodEmoji.text = "🤗"
        }
        
        // 加载历史记录
        if let history = UserDefaults.standard.object(forKey: "lady_mood_history") as? [[String: String]] {
            lady_moodHistory = history.sorted { $0["date"] ?? "" > $1["date"] ?? "" }
        }
        
        lady_historyTableView.reloadData()
    }
    
    private func lady_updateCurrentMoodDisplay() {
        guard let mood = lady_currentSelectedMood else { return }
        
        lady_currentMoodEmoji.text = mood["emoji"]
        lady_currentMoodLabel.text = "Today you're feeling \(mood["name"] ?? "")!"
        
        if let colorHex = mood["color"] {
            lady_currentMoodView.backgroundColor = UIColor(hex: colorHex)?.withAlphaComponent(0.3)
        }
    }
    
    private func lady_saveMood(_ mood: [String: String]) {
        let today = lady_getTodayString()
        var moodWithDate = mood
        moodWithDate["date"] = today
        moodWithDate["time"] = lady_getCurrentTimeString()
        
        // 保存今日心情
        UserDefaults.standard.setValue(moodWithDate, forKey: "lady_mood_\(today)")
        
        // 更新历史记录
        lady_moodHistory.removeAll { $0["date"] == today }
        lady_moodHistory.insert(moodWithDate, at: 0)
        
        // 只保留最近30天的记录
        if lady_moodHistory.count > 30 {
            lady_moodHistory = Array(lady_moodHistory.prefix(30))
        }
        
        UserDefaults.standard.setValue(lady_moodHistory, forKey: "lady_mood_history")
        
        lady_currentSelectedMood = moodWithDate
        lady_updateCurrentMoodDisplay()
        lady_historyTableView.reloadData()
        
        SVProgressHUD.showSuccess(withStatus: "Mood saved!")
    }
    
    private func lady_getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func lady_getCurrentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
    
    @IBAction func lady_backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func lady_segmentChanged(_ sender: UISegmentedControl) {
        lady_updateViewMode()
    }
    
    private func lady_updateViewMode() {
        let isSelectMode = lady_segmentControl.selectedSegmentIndex == 0
        lady_moodCollectionView.isHidden = !isSelectMode
        lady_historyTableView.isHidden = isSelectMode
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension Lady_MoodTrackerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lady_moodOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mood", for: indexPath) as! Lady_MoodCollectionViewCell
        let mood = lady_moodOptions[indexPath.row]
        cell.lady_configureMood(with: mood)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 60) / 2
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMood = lady_moodOptions[indexPath.row]
        lady_saveMood(selectedMood)
        
        // 添加选择动画
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    cell.transform = CGAffineTransform.identity
                }
            }
        }
    }
}

// MARK: - UITableView DataSource & Delegate
extension Lady_MoodTrackerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lady_moodHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as! Lady_MoodHistoryTableViewCell
        let mood = lady_moodHistory[indexPath.row]
        cell.lady_configureMoodHistory(with: mood)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - UIColor Extension
extension UIColor {
    convenience init?(hex: String) {
        let r, g, b: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        
        return nil
    }
}
