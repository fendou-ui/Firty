import UIKit
import SVProgressHUD

class Lady_SimpleMoodViewController: UIViewController {
    
    private var lady_titleView: UIView!
    private var lady_moodLabel: UILabel!
    private var lady_moodButtons: [UIButton] = []
    
    private let lady_moodOptions = [
        ["emoji": "😊", "name": "Happy"],
        ["emoji": "😢", "name": "Sad"],
        ["emoji": "😡", "name": "Angry"],
        ["emoji": "😴", "name": "Tired"],
        ["emoji": "😍", "name": "Excited"],
        ["emoji": "😰", "name": "Anxious"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lady_createViews()
        lady_setupUI()
        lady_loadTodayMood()
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
        
        // 创建心情标签
        lady_moodLabel = UILabel()
        lady_moodLabel.text = "How are you feeling today?"
        lady_moodLabel.textAlignment = .center
        lady_moodLabel.font = UIFont.boldSystemFont(ofSize: 20)
        lady_moodLabel.numberOfLines = 0
        lady_moodLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lady_moodLabel)
        
        // 创建心情按钮
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        for (index, mood) in lady_moodOptions.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle("\(mood["emoji"]!) \(mood["name"]!)", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            button.layer.cornerRadius = 12
            button.tag = index
            button.addTarget(self, action: #selector(lady_moodSelected(_:)), for: .touchUpInside)
            
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            stackView.addArrangedSubview(button)
            lady_moodButtons.append(button)
        }
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 标题视图约束
            lady_titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lady_titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lady_titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lady_titleView.heightAnchor.constraint(equalToConstant: 80),
            
            // 心情标签约束
            lady_moodLabel.topAnchor.constraint(equalTo: lady_titleView.bottomAnchor, constant: 30),
            lady_moodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lady_moodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 按钮堆栈约束
            stackView.topAnchor.constraint(equalTo: lady_moodLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func lady_setupUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func lady_loadTodayMood() {
        let today = lady_getTodayString()
        if let todayMood = UserDefaults.standard.object(forKey: "lady_mood_\(today)") as? [String: String] {
            lady_moodLabel.text = "Today you're feeling \(todayMood["name"] ?? "")! \(todayMood["emoji"] ?? "")"
        }
    }
    
    @objc private func lady_moodSelected(_ sender: UIButton) {
        let selectedMood = lady_moodOptions[sender.tag]
        
        // 保存心情
        let today = lady_getTodayString()
        var moodData = selectedMood
        moodData["date"] = today
        moodData["time"] = lady_getCurrentTimeString()
        
        UserDefaults.standard.setValue(moodData, forKey: "lady_mood_\(today)")
        
        // 更新显示
        lady_moodLabel.text = "Today you're feeling \(selectedMood["name"]!)! \(selectedMood["emoji"]!)"
        
        // 添加动画效果
        UIView.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform.identity
            }
        }
        
        SVProgressHUD.showSuccess(withStatus: "Mood saved! 😊")
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
}
