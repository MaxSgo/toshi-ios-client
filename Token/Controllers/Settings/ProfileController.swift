import UIKit
import SweetUIKit
import CoreImage

open class ProfileController: UIViewController {

    var idAPIClient: IDAPIClient

    lazy var avatar: UIImageView = {
        let view = UIImageView(withAutoLayout: true)
        view.clipsToBounds = true

        return view
    }()

    lazy var qrCode: UIImage = {
        let image = UIImage.imageQRCode(for: User.current?.address ?? "", resizeRate: 0.8)
        let filter = CIFilter(name: "CIMaskToAlpha")!

        filter.setDefaults()
        filter.setValue(CIImage(cgImage: image.cgImage!), forKey: "inputImage")

        let cImage = filter.outputImage!

        return UIImage(ciImage: cImage)
    }()

    lazy var avatarContainer: UIImageView = {
        let view = UIImageView(withAutoLayout: true)
        view.image = #imageLiteral(resourceName: "AvatarContainer")

        return view
    }()

    lazy var nameLabel: UILabel = {
        let view = UILabel(withAutoLayout: true)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.font = Theme.bold(size: 20)

        return view
    }()

    lazy var usernameLabel: UILabel = {
        let view = UILabel(withAutoLayout: true)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.font = Theme.bold(size: 14)
        view.textColor = Theme.greyTextColor

        return view
    }()

    lazy var editProfileButton: UIButton = {
        let view = UIButton(withAutoLayout: true)
        view.setAttributedTitle(NSAttributedString(string: "Edit Profile", attributes: [NSFontAttributeName: Theme.semibold(size: 13)]), for: .normal)
        view.setTitleColor(Theme.darkTextColor, for: .normal)
        view.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)

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

    public init(idAPIClient: IDAPIClient) {
        self.idAPIClient = idAPIClient

        super.init(nibName: nil, bundle: nil)

        self.title = "Profile"
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
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let displayName = User.current?.name, displayName.length > 0, let username = User.current?.username {
            self.nameLabel.text = displayName
            self.usernameLabel.text = "@\(username)"
        } else if let username = User.current?.username {
            self.usernameLabel.text = nil
            self.nameLabel.text = "@\(username)"
        }

        self.aboutContentLabel.text = User.current?.about
        self.locationContentLabel.text = User.current?.location
        if let image = User.current?.avatar {
            self.avatar.image = image
        } else if let avatarPath = User.current?.avatarPath {
            IDAPIClient.shared.downloadAvatar(path: avatarPath) { image in
                User.current?.avatar = image
                self.avatar.image = image
            }
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.qrCode, style: .plain, target: self, action: #selector(ProfileController.displayQRCode))
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func addSubviewsAndConstraints() {
        self.view.addSubview(self.avatarContainer)
        self.view.addSubview(self.avatar)
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.usernameLabel)
        self.view.addSubview(self.editProfileButton)

        self.view.addSubview(self.aboutSeparatorView)
        self.view.addSubview(self.aboutTitleLabel)
        self.view.addSubview(self.aboutContentLabel)

        self.view.addSubview(self.locationSeparatorView)
        self.view.addSubview(self.locationTitleLabel)
        self.view.addSubview(self.locationContentLabel)

        let height: CGFloat = 38.0
        let marginHorizontal: CGFloat = 20.0
        let marginVertical: CGFloat = 12.0
        let avatarSize: CGFloat = 106
        let avatarContainerSize: CGFloat = 166

        self.avatarContainer.set(height: avatarContainerSize)
        self.avatarContainer.set(width: avatarContainerSize)
        self.avatarContainer.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: marginHorizontal).isActive = true
        self.avatarContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        self.avatar.set(height: avatarSize)
        self.avatar.set(width: avatarSize)
        self.avatar.layer.cornerRadius = avatarSize / 2

        self.avatar.centerYAnchor.constraint(equalTo: self.avatarContainer.centerYAnchor).isActive = true
        self.avatar.centerXAnchor.constraint(equalTo: self.avatarContainer.centerXAnchor).isActive = true

        self.nameLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        self.nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: self.avatarContainer.bottomAnchor, constant: marginVertical).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: marginHorizontal).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -marginHorizontal).isActive = true

        self.usernameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
        self.usernameLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: marginVertical).isActive = true
        self.usernameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: marginHorizontal).isActive = true
        self.usernameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -marginHorizontal).isActive = true

        self.editProfileButton.set(height: height)
        self.editProfileButton.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: marginHorizontal).isActive = true
        self.editProfileButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: marginHorizontal).isActive = true
        self.editProfileButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -marginHorizontal).isActive = true

        // We set the view and separator width cosntraints to be the same, to force the scrollview content size to conform to the window
        // otherwise no view is requiring a width of the window, and the scrollview contentSize will shrink to the smallest
        // possible width that satisfy all other constraints.
        self.aboutSeparatorView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.aboutSeparatorView.set(height: 1.0)
        self.aboutSeparatorView.topAnchor.constraint(equalTo: self.editProfileButton.bottomAnchor, constant: marginHorizontal).isActive = true
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

    func didTapEditProfileButton() {
        let editController = ProfileEditController(idAPIClient: self.idAPIClient)
        self.present(editController, animated: true)
    }
}