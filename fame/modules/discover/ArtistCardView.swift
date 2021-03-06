//
//  ArtistCardView.swift
//  fame
//
//  Created by Jeff Cohen on 4/7/17.
//  Copyright © 2017 Fame. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import PureLayout

protocol VideoPlayerDelegate {
    func display()
}

class ArtistCardView: UIView {
    
    var artist: Artist?
    var videoDelegate: VideoPlayerDelegate?
    
    var headerView: UIView = UIView.newClearAutoLayout()
    var stageNameView: UIView = UIView.newClearAutoLayout()
    
    var resumeImageView: UIImageView = UIImageView.newAutoLayout()
    var stageNameLabel: UILabel = UILabel.newAutoLayout()
    var headerSeparator: UIView = UIView.border()
    var professionLocationLabel: UILabel = UILabel.newAutoLayout()
    
    var coverImageView: UIImageView = UIImageView.newAutoLayout()
    var playButton: UIButton = UIButton.newAutoLayout()    
    
    var replayButton: UIButton = UIButton.newAutoLayout()
    var moreDetailButton: UIButton = UIButton.newAutoLayout()
    
    var resume: Resume {
        return self.artist?.resume ?? Resume()
    }
    
    init(artist: Artist?) {
        super.init(frame: CGRect())
        
        self.artist = artist
        
        self.buildView()
        self.populate()
        self.layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK - Elements
extension ArtistCardView {
    fileprivate func buildView() {
        buildHeaderView()
        
        self.addSubviews([
            self.headerView,
            self.coverImageView,
            self.playButton,
            self.replayButton,
            self.moreDetailButton])
    }
    
    fileprivate func buildHeaderView() {
        self.stageNameView.addSubviews([self.resumeImageView, self.stageNameLabel])
        
        self.headerView.addSubviews([
            self.stageNameView,
            self.headerSeparator,
            self.professionLocationLabel])
    }
}

// MARK - Layout
extension ArtistCardView {
    
    fileprivate func layout() {
        self.backgroundColor = Color.purple.uiColor
        //self.clipsToBounds = true
        //self.layoutIfNeeded()
        
        layoutHeaderView()
        layoutCoverImageView()
        layoutPlayButton()
        layoutMoreDetailButton()
        layoutReplayButton()
    }
    
    func layoutHeaderView() {
        self.headerView.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        self.headerView.autoPinEdge(toSuperviewEdge: .leading)
        self.headerView.autoPinEdge(toSuperviewEdge: .trailing)
        
        layoutStageNameView()
        layoutHeaderSeparator()
        layoutProfessionLocationLabel()
    }
    
    fileprivate func layoutStageNameView() {
        let view = self.stageNameView
        view.autoAlignAxis(toSuperviewAxis: .vertical)
        view.autoPinEdge(toSuperviewEdge: .top)
        view.autoSetDimension(.height, toSize: 28)
        
        layoutResumeImageView()
        layoutStageNameLabel()
    }
    
    fileprivate func layoutResumeImageView() {
        let view = self.resumeImageView
        view.image = #imageLiteral(resourceName: "resume")
        view.tintColor = Color.gray.uiColor
        view.autoSetDimensions(to: CGSize(width: 16, height: 16))        
        view.autoPinEdge(toSuperviewEdge: .leading)
        view.autoAlignAxis(.horizontal, toSameAxisOf: self.stageNameLabel)
    }
    
    fileprivate func layoutStageNameLabel() {
        let label = self.stageNameLabel
        label.font = WorkSans.regular.font(ofSize: 23)
        label.textColor = Color.white.uiColor
        label.autoPinEdge(.leading, to: .trailing, of: self.resumeImageView, withOffset: 10)
        label.autoPinEdge(toSuperviewEdge: .top)
        label.autoPinEdge(toSuperviewEdge: .trailing)
        label.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    fileprivate func layoutHeaderSeparator() {
        let separator = self.headerSeparator
        separator.autoAlignAxis(toSuperviewAxis: .vertical)
        separator.autoSetDimension(.height, toSize: UIView.defaultBorderThickness)
        separator.autoMatch(.width, to: .width, of: separator.superview ?? self, withMultiplier: 0.75)
        separator.autoPinEdge(.top, to: .bottom, of: self.stageNameView, withOffset: 5)
    }
    
    fileprivate func layoutProfessionLocationLabel() {
        let label = self.professionLocationLabel
        label.font = WorkSans.regular.font(ofSize: 13)
        label.textColor = Color.white.uiColor
        label.autoAlignAxis(toSuperviewAxis: .vertical)
        label.autoPinEdge(.top, to: .bottom, of: self.headerSeparator, withOffset: 5)
        label.autoPinEdge(toSuperviewEdge: .bottom)
        label.autoSetDimension(.height, toSize: 18)
    }
    
    fileprivate func layoutCoverImageView() {
        // Copy the original image format before autolayout adjustments
        // This original image will be resized later with a manually chosen Interpolation Quality
        let image = self.coverImageView.image?.copy() as? UIImage
        let view = self.coverImageView
        //view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.autoPinEdge(toSuperviewEdge: .leading)
        view.autoPinEdge(toSuperviewEdge: .trailing)
        view.autoPinEdge(.top, to: .bottom, of: self.headerView, withOffset: 10)
        view.image = image?.resized(contentMode: .scaleAspectFill, bounds: view.layer.bounds.size, interpolationQuality: .high)
        view.layer.borderColor = Color.white.cgColor
        view.layer.borderWidth = 2.0
    }
    
    fileprivate func layoutPlayButton() {
        let button = self.playButton
        button.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        button.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        button.autoAlignAxis(.horizontal, toSameAxisOf: self.coverImageView)
        button.autoAlignAxis(.vertical, toSameAxisOf: self.coverImageView)
        button.addTarget(self, action: #selector(self.playVideo), for: .touchUpInside)
        self.bringSubview(toFront: button)
    }
    
    fileprivate func layoutMoreDetailButton() {
        let button = self.moreDetailButton
        button.titleLabel?.font = WorkSans.semiBold.font(ofSize: 15)
        button.setTitleColor(Color.golden.uiColor, for: .normal)
        button.autoAlignAxis(toSuperviewAxis: .vertical)
        button.autoPinEdge(.top, to: .bottom, of: self.coverImageView, withOffset: 10)
        button.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        button.autoSetDimension(.height, toSize: 20)
    }
    
    fileprivate func layoutReplayButton() {
        let button = self.replayButton
        button.setImage(#imageLiteral(resourceName: "replay"), for: .normal)
        button.autoPinEdge(toSuperviewEdge: .leading, withInset: -15)
        button.autoAlignAxis(.horizontal, toSameAxisOf: self.moreDetailButton)
    }
}

// MARK - Populate
extension ArtistCardView {
    fileprivate func populate() {
        let stageName = self.resume.stageName ?? ""
        self.stageNameLabel.text = stageName
        self.professionLocationLabel.text = self.resume.professionInLocation
        
        self.coverImageView.image = self.resume.headShot
        
        let moreDetailText = stageName.isEmpty ? "more detail" : "more from \(stageName)"
        self.moreDetailButton.setTitle(moreDetailText, for: .normal)
    }
}

// MARK - Actions
extension ArtistCardView {
    func playVideo() {
        self.videoDelegate?.display()
    }
}

fileprivate extension UIView {
    static func newClearAutoLayout() -> Self {
        let view = self.newAutoLayout()
        view.backgroundColor = Color.clear.uiColor
        return view
    }
}
