import UIKit

final class PostsItemCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .black)
        label.textColor = .black
        label.textAlignment = .left
        label.baselineAdjustment = .alignCenters
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let postIDLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        label.baselineAdjustment = .alignCenters
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .black
        label.textAlignment = .left
        label.baselineAdjustment = .alignCenters
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupRootView()
        setupViews()

        makeLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("\(Self.self) doesn't support XIB layout")
    }

    func setup(with post: PostsModel.FetchPosts.ViewItems.Post) {
        titleLabel.text = post.title
        postIDLabel.text = post.id.formatted()
        bodyLabel.text = post.body

        selectionStyle = .none
    }

    private func setupRootView() {
        backgroundColor = .white
    }

    private func setupViews() {
        addSubview(titleLabel)
        addSubview(postIDLabel)
        addSubview(bodyLabel)
    }

    private func makeLayout() {
        NSLayoutConstraint.activate([
            postIDLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            postIDLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            postIDLabel.heightAnchor.constraint(equalToConstant: 15)
        ])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: postIDLabel.leadingAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 15)
        ])

        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
