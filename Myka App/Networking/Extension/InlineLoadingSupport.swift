import UIKit
import SDWebImage

final class PaginationFooterView: UICollectionReusableView {
    static let reuseIdentifier = "PaginationFooterView"

    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setLoading(_ loading: Bool) {
        loading ? spinner.startAnimating() : spinner.stopAnimating()
    }
}

final class TablePaginationFooterView: UIView {
    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setLoading(_ loading: Bool) {
        loading ? spinner.startAnimating() : spinner.stopAnimating()
    }
}

extension UICollectionView {
    func registerPaginationFooter() {
        register(
            PaginationFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: PaginationFooterView.reuseIdentifier
        )
    }
}

extension UITableView {
    func setPaginationFooterLoading(_ loading: Bool, height: CGFloat = 60) {
        guard loading else {
            tableFooterView = UIView(frame: .zero)
            return
        }

        let footer = TablePaginationFooterView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: height))
        footer.setLoading(true)
        tableFooterView = footer
    }
}

extension UIImageView {
    func setRemoteImage(
        _ url: URL?,
        placeholder: UIImage? = nil,
        showsIndicator: Bool = false
    ) {
        sd_imageIndicator = showsIndicator ? SDWebImageActivityIndicator.grayLarge : nil
        sd_setImage(with: url, placeholderImage: placeholder)
    }
}
