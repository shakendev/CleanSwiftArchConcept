import UIKit

@MainActor
protocol PostDisplayLogic: AnyObject {
    func displayPost(with items: PostModel.FetchPost.ViewItems)
}

final class PostScreen: UIViewController {

    var interactor: (any PostBusinessLogic)?
    var router: (any PostDataPassing & PostRoutingLogic)?

    private let loaderView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .black)
        label.textColor = .black
        label.textAlignment = .left
        label.baselineAdjustment = .alignCenters
        label.numberOfLines = 2
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .black
        label.textAlignment = .left
        label.baselineAdjustment = .alignCenters
        label.isHidden = true
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("\(Self.self) doesn't support XIB layout")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRootView()
        setupViews()

        makeLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadPost()
    }

    private func setup() {
        let interactor = PostInteractor()
        let router = PostRouter()
        let presenter = PostPresenter()

        interactor.presenter = presenter

        presenter.screen = self

        router.dataStore = interactor
        router.screen = self

        self.interactor = interactor
        self.router = router
    }

    private func setupRootView() {
        view.backgroundColor = .white
        title = "Post"
    }

    private func setupViews() {
        view.addSubview(loaderView)
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)
    }

    private func makeLayout() {
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -16)
        ])
    }

    private func loadPost() {
        loaderView.startAnimating()

        let request = PostModel.FetchPost.Request()

        interactor?.loadPost(with: request)
    }
}

extension PostScreen: PostDisplayLogic {
    func displayPost(with items: PostModel.FetchPost.ViewItems) {
        titleLabel.text = items.title
        bodyLabel.text = items.body

        loaderView.stopAnimating()

        loaderView.isHidden = true
        titleLabel.isHidden = false
        bodyLabel.isHidden = false
    }
}
