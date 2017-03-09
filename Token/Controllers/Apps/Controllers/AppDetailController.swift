import UIKit
import SweetUIKit

class AppDetailController: UIViewController {
    var appsAPIClient: AppsAPIClient

    public var app: App

    let yap: Yap = Yap.sharedInstance

    lazy var avatar: UIImageView = {
        let view = UIImageView(withAutoLayout: true)
        view.clipsToBounds = true

        return view
    }()

    lazy var nameLabel: UILabel = {
        let view = UILabel(withAutoLayout: true)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.font = Theme.bold(size: 20)

        return view
    }()

    lazy var addContactButton: UIButton = {
        let view = UIButton(withAutoLayout: true)
        view.setTitleColor(Theme.darkTextColor, for: .normal)
        view.addTarget(self, action: #selector(didTapAddContactButton), for: .touchUpInside)

        view.layer.cornerRadius = 4.0
        view.layer.borderColor = Theme.borderColor.cgColor
        view.layer.borderWidth = 1.0

        return view
    }()

    lazy var messageContactButton: UIButton = {
        let view = UIButton(withAutoLayout: true)
        view.setAttributedTitle(NSAttributedString(string: "Message", attributes: [NSFontAttributeName: Theme.semibold(size: 13)]), for: .normal)
        view.setTitleColor(Theme.darkTextColor, for: .normal)
        view.setTitleColor(Theme.tintColor, for: .highlighted)
        view.addTarget(self, action: #selector(didTapMessageContactButton), for: .touchUpInside)

        view.layer.cornerRadius = 4.0
        view.layer.borderColor = Theme.borderColor.cgColor
        view.layer.borderWidth = 1.0

        return view
    }()

    lazy var aboutSeparatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = Theme.borderColor

        return view
    }()

    lazy var aboutTitleLabel: UILabel = {
        let view = UILabel(withAutoLayout: true)
        view.text = "About"
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 15)

        return view
    }()

    lazy var aboutContentLabel: UILabel = {
        let view = UILabel(withAutoLayout: true)

        return view
    }()

    lazy var locationSeparatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = Theme.borderColor

        return view
    }()

    lazy var locationTitleLabel: UILabel = {
        let view = UILabel(withAutoLayout: true)
        view.text = "Location"
        view.textColor = Theme.darkTextColor
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 15)

        return view
    }()

    lazy var locationContentLabel: UILabel = {
        let view = UILabel(withAutoLayout: true)

        return view
    }()

    private init() {
        fatalError()
    }

    init(app: App, appsAPIClient: AppsAPIClient = .shared) {
        self.app = app
        self.appsAPIClient = appsAPIClient

        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }

    open override func loadView() {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true

        self.view = scrollView
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Theme.viewBackgroundColor
        self.automaticallyAdjustsScrollViewInsets = false
        self.addSubviewsAndConstraints()

        self.title = self.app.displayName
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.nameLabel.text = self.app.displayName
        self.aboutContentLabel.text = self.app.category

        if let image = self.app.image {
            self.avatar.image = image
        } else {
            AppsAPIClient.shared.downloadImage(for: self.app) { image in
                self.avatar.image = image
            }
        }

        self.updateButton()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func addSubviewsAndConstraints() {
        self.view.addSubview(self.avatar)
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.addContactButton)
        self.view.addSubview(self.messageContactButton)

        self.view.addSubview(self.aboutSeparatorView)
        self.view.addSubview(self.aboutTitleLabel)
        self.view.addSubview(self.aboutContentLabel)

        self.view.addSubview(self.locationSeparatorView)
        self.view.addSubview(self.locationTitleLabel)
        self.view.addSubview(self.locationContentLabel)

        let height: CGFloat = 38.0
        let marginHorizontal: CGFloat = 20.0
        let marginVertical: CGFloat = 16.0
        let avatarSize: CGFloat = 166

        self.avatar.set(height: avatarSize)
        self.avatar.set(width: avatarSize)
        self.avatar.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: marginHorizontal).isActive = true
        self.avatar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        self.nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: self.avatar.bottomAnchor, constant: marginVertical).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: marginHorizontal).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -marginHorizontal).isActive = true

        self.messageContactButton.set(height: height)
        self.messageContactButton.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: marginVertical).isActive = true
        self.messageContactButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: marginHorizontal).isActive = true
        self.messageContactButton.rightAnchor.constraint(equalTo: self.addContactButton.leftAnchor, constant: -marginHorizontal).isActive = true

        self.messageContactButton.widthAnchor.constraint(equalTo: self.addContactButton.widthAnchor).isActive = true

        self.addContactButton.set(height: height)
        self.addContactButton.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: marginVertical).isActive = true
        self.addContactButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -marginHorizontal).isActive = true

        // We set the view and separator width cosntraints to be the same, to force the scrollview content size to conform to the window
        // otherwise no view is requiring a width of the window, and the scrollview contentSize will shrink to the smallest
        // possible width that satisfy all other constraints.
        self.aboutSeparatorView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.aboutSeparatorView.set(height: 1.0)
        self.aboutSeparatorView.topAnchor.constraint(equalTo: self.addContactButton.bottomAnchor, constant: marginVertical).isActive = true
        self.aboutSeparatorView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.aboutSeparatorView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

        self.aboutTitleLabel.set(height: 32)
        self.aboutTitleLabel.topAnchor.constraint(equalTo: self.aboutSeparatorView.bottomAnchor, constant: marginVertical).isActive = true
        self.aboutTitleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: marginHorizontal).isActive = true
        self.aboutTitleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -marginHorizontal).isActive = true

        self.aboutContentLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        self.aboutContentLabel.topAnchor.constraint(equalTo: self.aboutTitleLabel.bottomAnchor, constant: marginVertical).isActive = true
        self.aboutContentLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: marginHorizontal).isActive = true
        self.aboutContentLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -marginHorizontal).isActive = true

        self.locationSeparatorView.set(height: 1.0)
        self.locationSeparatorView.topAnchor.constraint(equalTo: self.aboutContentLabel.bottomAnchor, constant: marginVertical).isActive = true
        self.locationSeparatorView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.locationSeparatorView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

        self.locationTitleLabel.set(height: 32)
        self.locationTitleLabel.topAnchor.constraint(equalTo: self.locationSeparatorView.bottomAnchor, constant: marginVertical).isActive = true
        self.locationTitleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: marginHorizontal).isActive = true
        self.locationTitleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -marginHorizontal).isActive = true

        self.locationContentLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        self.locationContentLabel.topAnchor.constraint(equalTo: self.locationTitleLabel.bottomAnchor, constant: marginVertical).isActive = true
        self.locationContentLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: marginHorizontal).isActive = true
        self.locationContentLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -marginHorizontal).isActive = true

        self.locationContentLabel.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
    }

    func displayQRCode() {
        let controller = QRCodeController(string: User.current!.address)
        self.present(controller, animated: true)
    }

    func updateButton() {
        let isContactAdded = false // add real logic
        let fontColor = isContactAdded ? Theme.greyTextColor : Theme.darkTextColor
        let title = isContactAdded ? "✓ Added" : "Add app"

        self.addContactButton.setAttributedTitle(NSAttributedString(string: title, attributes: [NSFontAttributeName: Theme.semibold(size: 13), NSForegroundColorAttributeName: fontColor]), for: .normal)
        self.addContactButton.removeTarget(nil, action: nil, for: .allEvents)
        self.addContactButton.addTarget(self, action: #selector(didTapAddContactButton), for: .touchUpInside)
    }

    func didTapMessageContactButton() {
    }

    func didTapAddContactButton() {
    }
}