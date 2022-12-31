//
//  SettingsViewController.swift
//  BVURam
//
//  Created by Vardhan Chopada on 12/22/22.
//

import UIKit
import SafariServices

struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}

final class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        configureModels()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    
    
    private func configureModels() {
        data.append([
            SettingCellModel(title: "Edit Profile") {
                [weak self] in self?.didTapEditProfile()
            },
            SettingCellModel(title: "Invite Friends") {
                [weak self] in self?.didTapInviteFriends()
            },
            SettingCellModel(title: "Save Post") {
                [weak self] in self?.didTapSavePost()
            },
        ])
        data.append([
            SettingCellModel(title: "Terms of Service", handler: {
                [weak self] in self?.openURL(type: .terms)
            })])
        data.append([
            SettingCellModel(title: "Privacy Policy", handler: {
                [weak self] in self?.openURL(type: .privacy)
            })])
        data.append([
            SettingCellModel(title: "Help / Feedback", handler: {
                [weak self] in self?.openURL(type: .help)
            })])
        
        data.append([
            SettingCellModel(title: "Log Out", handler: {
                [weak self] in self?.didTapLogOut()
            })])
    }
    
    private func didTapEditProfile() {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private func didTapInviteFriends() {
       
    }
    
    private func didTapSavePost() {
        
    }
    
    enum SettingsURLType {
        case terms, privacy, help
    }
    
    private func openURL(type: SettingsURLType) {
        let urlString: String
        switch type {
        case .terms : urlString = "https://github.com/varxcx"
        case .privacy: urlString = "https://github.com/varxcx"
        case .help: urlString = "https://github.com/varxcx"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut { success in
                DispatchQueue.main.async {
                    if success {
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                        
                    } else {
                        fatalError("Could Not Log Out")
                    }
                }
                
            }
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet,animated: true)
    }
    
}




extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = data[indexPath.section][indexPath.row]
        model.handler()
        
    }
}
