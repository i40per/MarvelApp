//
//  DetailsHeroViewController.swift
//  MarvelApp
//
//  Created by Evgenii Lukin on 27.10.2022.
//

import UIKit

class DetailsHeroViewController: UIViewController {
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore more"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exploreMoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore more"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let idRandomHeroCollectionView = "idRandomHeroCollectionView"
    
    var heroModel: HeroMarvelModel?
    var heroesArray = [HeroMarvelModel]()
    var randomHeroesArray: [HeroMarvelModel] = []
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeroInfo()
        getRandomHeroes()
        setupViews()
        setDelegates()
        setConstraints()
    }
    
    //MARK: - SetupViews
    
    private func setupViews() {

        view.backgroundColor = #colorLiteral(red: 0.1646832824, green: 0.1647188365, blue: 0.1646810472, alpha: 1)
        
        navigationController?.navigationBar.tintColor = .white
        
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        collectionView.register(RandomHeroCollectionViewCell.self, forCellWithReuseIdentifier: idRandomHeroCollectionView)
        
        view.addSubview(scrollView)
        scrollView.addSubview(heroImageView)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(exploreMoreLabel)
        scrollView.addSubview(collectionView)
        
        let textMultiplier = 12.5
        exploreMoreLabel.font = UIFont.systemFont(ofSize: view.frame.width / textMultiplier)
    }
    
    //MARK: - SetDelegates
    
    private func setDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    //MARK: - SetupHeroInfo
    
    private func setupHeroInfo() {
        
        guard let heroModel = heroModel else { return }
        title = heroModel.name
        descriptionLabel.text = heroModel.description
        if descriptionLabel.text == "" {
            descriptionLabel.text = "The data this hero is classified as 'TOP SECRET'"
        }
        
        guard let url = heroModel.thumbnail.url else { return }
        
        NetworkImageFetch.shared.requestImage(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self.heroImageView.image = image
            case .failure(_):
                print("AlertHere")
            }
        }
    }
    
    //MARK: - GetRandomHeroes
    
    private func getRandomHeroes() {
        
        while randomHeroesArray.count < 8 {
            let randomInt = Int.random(in: 0...heroesArray.count - 1)
            randomHeroesArray.append(heroesArray[randomInt])
            let sortAr = unique(sourse: randomHeroesArray)
            randomHeroesArray = sortAr
        }
    }
    
    private func unique<S : Sequence, T : Hashable>(sourse: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in sourse {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}

//MARK: - UICollectionViewDataSourse

extension DetailsHeroViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        randomHeroesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idRandomHeroCollectionView, for: indexPath) as?
                RandomHeroCollectionViewCell else {return UICollectionViewCell()}
        
        let heroModel = randomHeroesArray[indexPath.row]
        cell.cellConfigure(model: heroModel)
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension DetailsHeroViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let heroModel = randomHeroesArray[indexPath.row]
        
        let detailsHeroViewController = DetailsHeroViewController()
        detailsHeroViewController.heroModel = heroModel
        detailsHeroViewController.heroesArray = heroesArray
        navigationController?.pushViewController(detailsHeroViewController, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension DetailsHeroViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}

//MARK: - SetConstraints

extension DetailsHeroViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            heroImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            heroImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            heroImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            heroImageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            
            descriptionLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            exploreMoreLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            exploreMoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            exploreMoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exploreMoreLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -5),
            
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
        ])
    }
}
