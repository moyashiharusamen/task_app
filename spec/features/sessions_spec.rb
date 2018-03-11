require 'rails_helper'

feature "認証機能" do
  background do
    create(:user, email: "test@example.com")
    visit login_path
  end

  feature "ログイン" do
    scenario "成功する" do
      fill_in :login_email, with: "test@example.com"
      fill_in :login_password, with: "hogehoge"

      click_button "ログイン"

      expect(page).to have_selector "#index_title", text: "タスク一覧"
    end

    scenario "失敗する" do
      # 網羅的なパターンは models/user_spec.rb で実施
      fill_in :login_email, with: "error@example.com"
      fill_in :login_password, with: "error"

      click_button "ログイン"

      expect(page).to have_selector "#login_title", text: "ログイン"
      expect(page).to have_selector '.alert', text: 'メールアドレスかパスワードが間違っています'
    end
  end

  feature "ログアウト" do
    background do
      fill_in :login_email, with: "test@example.com"
      fill_in :login_password, with: "hogehoge"

      click_button "ログイン"
    end

    scenario "成功する" do
      click_link "ログアウト"

      expect(page).to have_selector "#login_title", text: "ログイン"
    end
  end

  feature "ログイン必須画面における利用制限" do
    context "ログインしていない時" do
      scenario "tasks#indexにアクセスしてもログインページに遷移する" do
        click_link "LifeMemo"

        expect(page).to have_current_path login_path
        expect(page).to have_selector "#login_title", text: "ログイン"
        expect(page).to have_selector ".alert", text: "ログインしてください"
      end
    end
  end
end
