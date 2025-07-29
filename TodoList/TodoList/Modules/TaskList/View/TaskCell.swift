//
//  TaskCell.swift
//  TodoList
//
//  Created by Kirill Severin on 29.07.25.
//

import UIKit

final class TaskCell: UITableViewCell {
    
    static let identifier = "TaskCell"
    
    private let statusIcon = UIImageView()
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let dateLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        statusIcon.contentMode = .scaleAspectFit
        statusIcon.tintColor = .systemYellow
        statusIcon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusIcon)
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        [titleLabel,descLabel,dateLabel].forEach {
            $0.numberOfLines = 0
            stackView.addArrangedSubview($0)
        }
        
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        descLabel.font = .preferredFont(forTextStyle: .subheadline)
        dateLabel.font = .preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            statusIcon.widthAnchor.constraint(equalToConstant: 24),
            statusIcon.heightAnchor.constraint(equalToConstant: 24),
            statusIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            statusIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            stackView.leadingAnchor.constraint(equalTo: statusIcon.trailingAnchor, constant: 12),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
    }
    
    func configure(with task: TaskEntity) {
        descLabel.text = task.desc
        
        if let date = task.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            dateLabel.text = formatter.string(from: date)
        } else {
            dateLabel.text = nil
        }
        
        let attributes: [NSAttributedString.Key: Any] = task.isCompleted
        ? [.foregroundColor: UIColor.secondaryLabel,
           .strikethroughStyle: NSUnderlineStyle.single.rawValue]
        : [.foregroundColor: UIColor.label]
        
        titleLabel.attributedText = NSAttributedString(string: task.title ?? "", attributes: attributes)
        
        descLabel.textColor = task.isCompleted ? .secondaryLabel : .label
        statusIcon.image = UIImage(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
    }
}
