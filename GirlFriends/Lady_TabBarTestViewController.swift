import UIKit

/// 这是一个测试页面，用于快速跳转到 TabBar
/// 可以从任何地方 push 或 present 这个页面来测试 TabBar
class Lady_TabBarTestViewController: UIViewController {
    
    private var lady_titleView: UIView!
    private var lady_titleLabel: UILabel!
    private var lady_descLabel: UILabel!
    private var lady_enterButton: UIButton!
    private var lady_backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lady_setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 标题栏设置为透明，显示背景图片
        lady_titleView.backgroundColor = .clear
    }
    
    private func lady_setupViews() {
        view.backgroundColor = .systemBackground
        
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
        
        // 标题视图
        lady_titleView = UIView()
        lady_titleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lady_titleView)
        
        // 标题
        lady_titleLabel = UILabel()
        lady_titleLabel.text = "TabBar Preview"
        lady_titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        lady_titleLabel.textColor = .white
        lady_titleLabel.textAlignment = .center
        lady_titleLabel.translatesAutoresizingMaskIntoConstraints = false
        lady_titleView.addSubview(lady_titleLabel)
        
        // 描述
        lady_descLabel = UILabel()
        lady_descLabel.text = """
        Welcome to the new TabBar interface!
        
        Features included:
        
        🏠 Home - Browse characters and videos
        ❤️ Favorites - Your saved conversations
        😊 Mood - Track your daily emotions
        ✅ Tasks - Manage your daily tasks
        
        Tap the button below to enter
        """
        lady_descLabel.font = UIFont.systemFont(ofSize: 16)
        lady_descLabel.textColor = .label
        lady_descLabel.textAlignment = .center
        lady_descLabel.numberOfLines = 0
        lady_descLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lady_descLabel)
        
        // 进入按钮
        lady_enterButton = UIButton(type: .system)
        lady_enterButton.setTitle("Enter TabBar", for: .normal)
        lady_enterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        lady_enterButton.backgroundColor = UIColor(red: 0.65, green: 0.72, blue: 1, alpha: 1)
        lady_enterButton.setTitleColor(.white, for: .normal)
        lady_enterButton.layer.cornerRadius = 25
        lady_enterButton.translatesAutoresizingMaskIntoConstraints = false
        lady_enterButton.addTarget(self, action: #selector(lady_enterTabBar), for: .touchUpInside)
        view.addSubview(lady_enterButton)
        
        // 返回按钮
        lady_backButton = UIButton(type: .system)
        lady_backButton.setTitle("← Back", for: .normal)
        lady_backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        lady_backButton.setTitleColor(.systemBlue, for: .normal)
        lady_backButton.translatesAutoresizingMaskIntoConstraints = false
        lady_backButton.addTarget(self, action: #selector(lady_goBack), for: .touchUpInside)
        view.addSubview(lady_backButton)
        
        // 约束
        NSLayoutConstraint.activate([
            // 标题视图
            lady_titleView.topAnchor.constraint(equalTo: view.topAnchor),
            lady_titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lady_titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lady_titleView.heightAnchor.constraint(equalToConstant: 200),
            
            // 标题标签
            lady_titleLabel.centerXAnchor.constraint(equalTo: lady_titleView.centerXAnchor),
            lady_titleLabel.centerYAnchor.constraint(equalTo: lady_titleView.centerYAnchor),
            
            // 描述标签
            lady_descLabel.topAnchor.constraint(equalTo: lady_titleView.bottomAnchor, constant: 40),
            lady_descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            lady_descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // 进入按钮
            lady_enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lady_enterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            lady_enterButton.widthAnchor.constraint(equalToConstant: 200),
            lady_enterButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 返回按钮
            lady_backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            lady_backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    @objc private func lady_enterTabBar() {
        let tabBarController = Lady_TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        
        // 添加一个漂亮的转场动画
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        present(tabBarController, animated: false)
    }
    
    @objc private func lady_goBack() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
