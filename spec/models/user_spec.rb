require 'rails_helper'

describe User do
  let(:user) { build(:user, name: name, email: email,
                      password: password, password_confirmation: confirmation) }
  let(:name) { "テストくん" }
  let(:email) { "test@example.com" }
  let(:password) { "hogehoge" }
  let(:confirmation) { "hogehoge" }

  it { expect(user).to be_valid }

  describe "バリデーション" do
    describe "名前" do
      context "入力されていない時" do
        let(:name) { "" }

        it "バリデーションに失敗する" do
          expect(user).to be_invalid
        end
      end
    end

    describe "メールアドレス" do
      context "入力されていない時" do
        let(:email) { "" }

        it "バリデーションに失敗する" do
          expect(user).to be_invalid
        end
      end

      context "既に存在する時" do
        let!(:other_user) { create(:user, email: "other@exmple.com") }

        context "既存ユーザのメールアドレスと大文字・小文字区別なく重複するとき" do
          it "バリデーションに失敗する" do
            expect(user).to be_valid
            user.email = other_user.email.upcase
            expect(user).to be_invalid
          end
        end
      end

      describe "フォーマット" do
        context "正しくない時" do
          it "バリデーションに失敗する" do
            # gem (email_validator) 部分なので、パターンはこの程度とする
            %w(test @exmple.com test@example test@example@com).each do |email|
              user.email = email
              expect(user).to be_invalid
            end
          end
        end
      end
    end

    describe "パスワード" do
      context "入力されていない時" do
        let(:password) { "" }
        let(:confirmation) { "" }

        it "バリデーションに失敗する" do
          expect(user).to be_invalid
        end
      end

      describe "文字数" do
        context "7文字の時" do
          let(:password) { "a" * 7 }
          let(:confirmation) { "a" * 7 }

          it "バリデーションに失敗する" do
            expect(user).to be_invalid
          end
        end

        context "8文字の時" do
          let(:password) { "a" * 8 }
          let(:confirmation) { "a" * 8 }

          it "バリデーションが通る" do
            expect(user).to be_valid
          end
        end

        context "9文字の時" do
          let(:password) { "a" * 9 }
          let(:confirmation) { "a" * 9 }

          it "バリデーションが通る" do
            expect(user).to be_valid
          end
        end
      end

      context "確認用パスワードが入力されていない時" do
        let(:confirmation) { "" }

        it "バリデーションに失敗する" do
          expect(user).to be_invalid
        end
      end
    end
  end
end
