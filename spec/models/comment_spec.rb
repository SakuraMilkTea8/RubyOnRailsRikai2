require 'spec_helper'

describe Comment do
  describe 'association' do
    let!(:entry) { Entry.create(text: "新しいMacBook Proを買いました！") }
    context "not associated" do
      specify do
        Comment.new(text: "わー、いいなあ！")
        expect(entry.comments).to be_empty
      end
    end
    describe "parent.children.create" do
      specify do
        comment = entry.comments.create(text: "わー、いいなあ！")

        expect(entry.comments).to eq [comment]
        expect(comment).to be_persisted
      end
    end
    describe "parent.children.build" do
      specify do
        comment = entry.comments.build(text: "わー、いいなあ！")

        expect(entry.comments).to eq [comment]
        expect(comment).to_not be_persisted
      end
    end
    describe "parent.children << child" do
      specify do
        comment = Comment.new(text: "わー、いいなあ！")
        expect(comment).to_not be_persisted

        entry.comments << comment

        expect(entry.comments).to eq [comment]
        expect(comment).to be_persisted
      end
    end
    describe "parent.children = children" do
      specify do
        comment_old = Comment.new(text: "やった、コメント1番乗り！！")
        entry.comments << comment_old

        expect(entry.comments).to eq [comment_old]
        expect(comment_old).to be_persisted

        comment_1 = Comment.new(text: "わー、いいなあ！")
        comment_2 = Comment.new(text: "うらやましすぎる！！")

        entry.comments = [comment_1, comment_2]

        expect(entry.comments).to eq [comment_1, comment_2]
        expect(comment_1).to be_persisted
        expect(comment_2).to be_persisted
        expect(comment_old).to be_destroyed
      end
    end
    describe "child.parent = parent" do
      specify do
        comment = Comment.new(text: "わー、いいなあ！")
        comment.entry = entry
        comment.save

        expect(entry.comments).to eq [comment]
      end
    end
    describe "Child.new(parent: parent) / Child.create(parent: parent)" do
      specify do
        comment_1 = Comment.new(text: "わー、いいなあ！", entry: entry)
        comment_1.save

        comment_2 = Comment.create(text: "うらやましすぎる！！", entry: entry)

        expect(entry.comments).to eq [comment_1, comment_2]
      end
    end
    describe "child.parent_id = parent_id" do
      specify do
        comment = Comment.new(text: "わー、いいなあ！")
        comment.post_id = entry.id
        comment.save

        expect(entry.comments).to eq [comment]
      end
    end
    describe "Child.new(parent_id: parent_id) / Child.create(parent_id: parent_id)" do
      specify do
        comment_1 = Comment.new(text: "わー、いいなあ！", post_id: entry.id)
        comment_1.save

        comment_2 = Comment.create(text: "うらやましすぎる！！", post_id: entry.id)

        expect(entry.comments).to eq [comment_1, comment_2]
      end
    end
  end
  describe 'validation' do
    before :each do
      @entry = Entry.create(text: 'Hi.')
      @comment = Comment.new(text: 'Hello', entry: @entry)
    end
    context 'with text and entry' do
      it 'is valid' do
        expect(@comment).to be_valid
      end
    end
    context 'without text' do
      it 'is invalid' do
        @comment.text = nil
        expect(@comment).to have(1).error_on(:text)
      end
    end
    context 'without entry' do
      it 'is invalid' do
        @comment.entry = nil
        expect(@comment).to have(1).error_on(:entry)
      end
    end
  end
end