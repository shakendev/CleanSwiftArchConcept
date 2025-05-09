import UIKit

@MainActor
protocol PostsDisplayLogic: AnyObject {
    func displayPosts(with items: PostsModel.FetchPosts.ViewItems)
}

final class PostsScreen: UIViewController {
    var interactor: (any PostsBusinessLogic)?
    var router: (any PostsDataPassing & PostsRoutingLogic)?

    private var posts: [PostsModel.FetchPosts.ViewItems.Post] = []

    private let loaderView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.clipsToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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

        setupTableView()

        setupRootView()
        setupViews()

        makeLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadPosts()
    }

    private func setup() {
        let interactor = PostsInteractor()
        let router = PostsRouter()
        let presenter = PostsPresenter()

        interactor.presenter = presenter

        presenter.screen = self

        router.dataStore = interactor
        router.screen = self

        self.interactor = interactor
        self.router = router
    }

    private func setupTableView() {
        tableView.register(PostsItemCell.self, forCellReuseIdentifier: "\(PostsItemCell.self)")
        tableView.isHidden = true

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupRootView() {
        view.backgroundColor = .white
        title = "Posts"
    }

    private func setupViews() {
        view.addSubview(loaderView)
        view.addSubview(tableView)
    }

    private func makeLayout() {
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadPosts() {
        loaderView.startAnimating()

        let request = PostsModel.FetchPosts.Request()

        interactor?.loadPosts(with: request)
    }
}

extension PostsScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]

        interactor?.selectPost(by: post.id)
        router?.routeToPost()
    }
}

extension PostsScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { posts.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(PostsItemCell.self)", for: indexPath
            ) as? PostsItemCell
        else { return .init() }

        let post = posts[indexPath.row]

        cell.setup(with: post)

        return cell
    }
}

extension PostsScreen: PostsDisplayLogic {
    func displayPosts(with items: PostsModel.FetchPosts.ViewItems) {
        posts = items.posts

        loaderView.stopAnimating()

        loaderView.isHidden = true
        tableView.isHidden = false

        tableView.reloadData()
    }
}
