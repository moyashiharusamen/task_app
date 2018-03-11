require "rails_helper"

feature "ユーザ管理" do
  let!(:user) { create(:user, name: "user", email: "test@example.com") }
  let(:task) { create(:task, user: user) }

  background do
    visit login_path

    fill_in :login_email, with: user.email
    fill_in :login_password, with: "hogehoge"
    click_button "ログイン"
  end

  feature "一覧画面" do
    background do
      task
      click_link "ユーザ一覧"
    end

    scenario "ユーザが一覧で表示されている" do
      expect(page).to have_selector ".user_name_line", text: "user"
    end

    scenario "タスク数が表示されている" do
      expect(page).to have_selector ".user_task_size_line", text: user.tasks.count
    end
  end

  feature "ユーザ詳細画面" do
    background do
      task
      visit admin_user_path(user)
    end

    scenario "ユーザの情報が表示されている" do
      expect(page).to have_selector "#user_show_name", text: user.name
      expect(page).to have_selector "#user_show_email", text: user.email
    end

    scenario "ユーザに紐付いたタスク一覧が表示されている" do
      expect(page).to have_selector ".task_name_line", text: task.name
    end
  end

  feature "ユーザを作成" do
    background do
      visit new_admin_user_path
    end

    scenario "フォームに正しい入力をして登録ボタンを押すと、ユーザが登録される" do
      fill_in :user_name, with: "other_user"
      fill_in :user_email, with: "other_user@example.com"
      fill_in :user_password, with: "hogehoge"
      fill_in :user_password_confirmation, with: "hogehoge"

      expect{ click_button "登録する" }.to change{ User.count }.by(1)

      expect(page).to have_selector "#user_show_name", text: "other_user"
      expect(page).to have_selector "#user_show_email", text: "other_user@example.com"

      expect(page).to have_selector ".notice", text: "ユーザを作成しました"
    end

    scenario "フォームに正しい入力をせず登録ボタンを押すと、ユーザが登録されない" do
      fill_in :user_name, with: ""
      fill_in :user_email, with: ""
      fill_in :user_password, with: ""
      fill_in :user_password_confirmation, with: ""

      expect{ click_button "登録する" }.to change{ User.count }.by(0)

      expect(page).to have_selector "#error_desc", text: "エラーが6件あります"
    end
  end

  feature "ユーザを更新" do
    background do
      visit edit_admin_user_path(user)
    end

    scenario "フォームに入力した修正内容が正しく反映される" do
      fill_in :user_name, with: "other_user"
      fill_in :user_email, with: "other_user@example.com"
      fill_in :user_password, with: "hogehoge"
      fill_in :user_password_confirmation, with: "hogehoge"

      click_button "更新する"

      expect(page).to have_selector "#user_show_name", text: "other_user"
      expect(page).to have_selector "#user_show_email", text: "other_user@example.com"

      expect(page).to have_selector ".notice", text: "ユーザを修正しました"
    end

    scenario "フォームに入力した修正内容が反映されない" do
      fill_in :user_password, with: ""
      fill_in :user_password_confirmation, with: ""

      click_button "更新する"

      expect(page).to have_selector "#error_desc", text: "エラーが2件あります"
    end
  end
end
