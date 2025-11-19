import UIKit

class Lady_TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lady_setupTabBar()
        lady_setupViewControllers()
    }
    
    private func lady_setupTabBar() {
        // 设置 TabBar 外观
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = UIColor(red: 0.65, green: 0.72, blue: 1, alpha: 1)
        tabBar.unselectedItemTintColor = .systemGray
        
        // iOS 15+ 样式设置
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            
            // 设置选中和未选中的颜色
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.65, green: 0.72, blue: 1, alpha: 1)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor(red: 0.65, green: 0.72, blue: 1, alpha: 1)
            ]
            appearance.stackedLayoutAppearance.normal.iconColor = .systemGray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.systemGray
            ]
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        
        // 添加顶部分隔线
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    private func lady_setupViewControllers() {
        // 1. 主页
        let homeVC = Lady_HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let favoritesVC = Lady_CreateListViewController()
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(
            title: "Creation",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        // 3. 心情追踪
        let moodVC = Lady_SetUpViewController()
        let moodNav = UINavigationController(rootViewController: moodVC)
        moodNav.tabBarItem = UITabBarItem(
            title: "Mine",
            image: UIImage(systemName: "face.smiling"),
            selectedImage: UIImage(systemName: "face.smiling.fill")
        )
        
        // 4. 每日任务
        let tasksVC = Lady_TabDailyTasksViewController()
        let tasksNav = UINavigationController(rootViewController: tasksVC)
        tasksNav.tabBarItem = UITabBarItem(
            title: "Tasks",
            image: UIImage(systemName: "checkmark.circle"),
            selectedImage: UIImage(systemName: "checkmark.circle.fill")
        )
        
        // 设置所有视图控制器
        viewControllers = [homeNav, favoritesNav, tasksNav, moodNav]
        
        // 默认选中主页
        selectedIndex = 0
    }
}
