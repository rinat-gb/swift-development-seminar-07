//
//  AuthorizationViewController.swift
//  IntermediateCertification
//
//  Created by Ринат on 03.09.2023.
//

import UIKit
import WebKit

class AuthorizationViewController: UIViewController, WKNavigationDelegate {
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // cliend_id своего приложения VK я храню в Info.plist всего проекта
        // и поэтому читаю его оттуда для последующей вставки в URL
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "ClientID") else {
            // при ошибке чтения cliend_id пишем об ошибке красным цветом и больше ничего не делаем
            let labelView = UILabel()
            labelView.text = "Ошибка чтения cliend_id"
            labelView.textAlignment = .center
            labelView.textColor = .red
            labelView.backgroundColor = .systemBackground
            labelView.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(labelView)

            NSLayoutConstraint.activate([
                labelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                labelView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                labelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                labelView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            ])

            return
        }
        // иначе пытаемся авторизоваться вконтакте
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])

        let url = URL(string:
            "https://oauth.vk.com/authorize?" +
                "client_id=\(clientID)&" +
                "redirect_uri=https://oauth.vk.com/blank.html&" +
                "scope=262150&" +
                "display=mobile&" +
                "response_type=token")
        webView.load(URLRequest(url: url!))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = Theme.currentTheme.backgroundColor
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
    {
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        NetworkService.accessToken = params["access_token"] ?? "invalid_token"
        NetworkService.userID = params["user_id"] ?? "invalid_user_id"

        decisionHandler(.cancel)
        webView.removeFromSuperview()

        enterTabView()
    }

    private func enterTabView() {
        let friendsViewController = UINavigationController(rootViewController: FriendTableViewController())
        friendsViewController.tabBarItem.title = Constants.Titles.friendsTitle

        let groupsViewController = UINavigationController(rootViewController: GroupsTableViewController())
        groupsViewController.tabBarItem.title = Constants.Titles.groupsTitle

        let photosViewController = UINavigationController(rootViewController:
            PhotosCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        photosViewController.tabBarItem.title = Constants.Titles.photosTitle

        let tabsControllers = [friendsViewController, groupsViewController, photosViewController]
        let tabBarVC = UITabBarController()
        tabBarVC.viewControllers = tabsControllers

        // убираем более ненужный view controller для авторизации
        // и устанавливаем tab bar controller в качестве root controller
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let firstWindow = firstScene.windows.first
        else {
            return
        }
        firstWindow.rootViewController = tabBarVC
    }
}
