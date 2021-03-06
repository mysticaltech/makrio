require 'spec_helper'

describe PostPresenter do
  before do
    @sm = Factory(:status_message, :public => true)
    @presenter = PostPresenter.new(@sm, bob)
    @unauthenticated_presenter = PostPresenter.new(@sm)
  end

  it 'takes a post and an optional user' do
    @presenter.should_not be_nil
  end

  describe '#as_json' do
    it 'works with a user' do
      @presenter.as_json.should be_a Hash
    end

    it 'works without a user' do
      @unauthenticated_presenter.as_json.should be_a Hash
    end
  end
  
  describe '#root' do
    it 'does not raise if the parent does not exists' do
      p = Factory(:status_message)
      p.parent = nil
      expect {
        PostPresenter.new(p).parent
      }.to_not raise_error
    end
  end
  
  describe '#next_post_path' do
    it 'returns a string of the users next post' do
      @presenter.next_post_path.should == "#{Rails.application.routes.url_helpers.post_path(@sm)}/next"
    end
  end

  describe '#previous_post_path' do
    it 'returns a string of the users next post' do
      @presenter.previous_post_path.should == "#{Rails.application.routes.url_helpers.post_path(@sm)}/previous"
    end
  end
  
  describe '#title' do 
    it 'includes the text if it is present' do
      @sm = stub(:text => "lalalalalalala", :plain_text => "lalalalalalala", :author => bob.person)
      @presenter.post = @sm
      @presenter.title.should == @sm.text
    end

    context 'with posts without text' do
      it ' displays a messaage with the post class' do
        @sm = stub(:text => "", :author => bob.person)
        @presenter.post = @sm
        @presenter.title.should == "A post from #{@sm.author.name}"
      end
    end
  end

  describe '#show_screenshot?' do
    before do
      @sm.stub(:screenshot_url => 'something')
    end

    it 'returns true if the screenshot_url is present' do
      @sm.stub(:screenshot_url => 'something')
      @presenter.show_screenshot?.should be_true
    end

    it 'returns false if the screenshot_url is not present' do
      @sm.stub(:screenshot_url => '')
      @presenter.show_screenshot?.should be_false
    end
  end

  describe '#has_gif' do
    it 'returns true if there is an image present with a .gif extension' do
      @sm.photos = [Factory(:photo_gif)]
      @sm.save
      @presenter.has_gif?.should be_true
    end

    it 'returns false if there is an non gif present' do
      @sm.photos = [Factory(:photo)]
      @sm.save
      @presenter.has_gif?.should be_false
    end 
  end
  
end
