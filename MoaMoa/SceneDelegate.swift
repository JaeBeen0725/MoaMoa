//
//  SceneDelegate.swift
//  MoaMoa
//
//  Created by Jae Oh on 2023/09/27.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let realm = try! Realm()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        

        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        let categoryViewController = UINavigationController(rootViewController: CategoryViewController())
//        let settingViewControlelr = UINavigationController(rootViewController: SettingViewController())

        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([homeViewController, categoryViewController], animated: false)
        
        let isLaunched = UserDefaults.standard.bool(forKey: "isLaunched")
        if isLaunched == false {
            let allData = CateGoryRealm(title: "All")
            let likeData = CateGoryRealm(title: "Like")
            try! realm.write{
                realm.add(allData)
                realm.add(likeData)
            }
        
      UserDefaults.standard.set(true, forKey: "isLaunched")

            if let item = tabBarController.tabBar.items {
               item[0].title = "홈화면"
                item[0].image = UIImage(systemName: "house")
    
                item[1].title = "카테고리"
                item[1].image = UIImage(systemName: "line.3.horizontal")
                
//                item[2].title = "설정"
//                item[2].image = UIImage(systemName: "gearshape")
                
                tabBarController.tabBar.tintColor = UIColor(named: "reversedSystemBackgroundColor")

            }
        } else {
            if let item = tabBarController.tabBar.items {
                item[0].title = "홈화면"
                item[0].image = UIImage(systemName: "house")
                
                item[1].title = "카테고리"
                item[1].image = UIImage(systemName: "line.3.horizontal")
                
//                item[2].title = "설정"
//                item[2].image = UIImage(systemName: "gearshape")
                
                tabBarController.tabBar.tintColor = UIColor(named: "reversedSystemBackgroundColor")

            }
          
        }
        
        

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

