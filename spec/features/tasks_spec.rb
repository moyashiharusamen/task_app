require 'rails_helper'

feature "タスク" do
  let!(:user) { create(:user, email: "test@example.com") }
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
      visit root_path
    end

    scenario "一覧画面から作成画面に遷移できる" do
      click_link "新規登録"

      expect(page).to have_selector "h2#create_title", text: "作成"
    end
    scenario "一覧画面から詳細画面に遷移できる" do
      click_link "詳細"

      expect(page).to have_selector "h2#show_title", text: "詳細"
    end
    scenario "一覧画面から修正画面に遷移できる" do
      click_link "修正"

      expect(page).to have_selector "h2#edit_title", text: "編集"
    end
  end

  feature "タスクを作成" do
    background do
      visit new_task_path
    end

    scenario "フォームに正しい入力をして登録ボタンを押した時に、タスクが登録される" do
      # 名前は必須項目なので入力する
      fill_in :task_name, with: "add_name"
      fill_in :task_desc, with: "add_desc"

      # レコードが増えているかというのも確認
      expect{ click_button "登録する" }.to change{ Task.count }.by(1)

      # 入力内容が反映されているか確認
      expect(page).to have_selector '#show_name', text: 'add_name'
      expect(page).to have_selector '#show_desc', text: 'add_desc'

      # フラッシュメッセージが表示されているか確認
      expect(page).to have_selector '.notice', text: 'タスクを作成しました'
    end

    scenario "フォームに間違った入力をして登録ボタンを押した時に、タスクが登録されない" do
      # 名前は必須項目なので、何も入力せず進行

      # レコードが増えていないかというのも確認
      expect{ click_button "登録する" }.to change{ Task.count }.by(0)

      # エラーメッセージが出ているか確認する
      expect(page).to have_selector '#error_desc', text: 'エラーが1件あります'
    end
  end

  feature "タスクを参照" do
    background do
      visit task_path(task)
    end

    scenario "レコードの内容と表示内容が合っている" do
      expect(page).to have_selector "#show_name", text: task.name
      expect(page).to have_selector "#show_desc", text: task.description
    end

    scenario "修正ボタンがあり、押した時に編集画面に遷移できる" do
      expect(page).to have_selector '#edit_in_show_page', text: '修正'
      click_link "修正"
      expect(page).to have_selector 'h2#edit_title'
    end

    scenario "戻るボタンがあり、押した時に一覧画面に遷移できる" do
      expect(page).to have_selector '.to-top', text: 'トップへ戻る'
      click_link "トップへ戻る"
      expect(page).to have_selector 'h2#index_title'
    end
  end

  feature "タスクを変更" do
    background do
      visit edit_task_path(task)
    end

    scenario "修正内容がバリデーションを通る" do
      # 名前は必須項目なので入力
      fill_in :task_name, with: "add_name"
      fill_in :task_desc, with: "add_desc"

      click_button "更新する"

      # 入力した内容が反映されているか確認
      expect(page).to have_selector '#show_name', text: 'add_name'
      expect(page).to have_selector '#show_desc', text: 'add_desc'

      # フラッシュメッセージが表示されているか確認
      expect(page).to have_selector '.notice', text: 'タスクを修正しました'
    end

    scenario "修正内容がバリデーションを通らない" do
      # 名前は必須項目なので、何も入力せず進行
      fill_in :task_name, with: ""

      click_button "更新する"

      # エラーメッセージが出るので、それが表示されているか確認
      expect(page).to have_selector '#error_desc', text: 'エラーが1件あります'

      # エラー画面にも情報が引き継がれているかの確認
      expect(page).to have_selector '#task_desc', text: task.description
    end
  end

  feature "タスクを削除" do
    background do
      task
      visit root_path
    end

    scenario "削除ボタンを押すとタスクが削除される" do
      # レコードが消えているか確認
      expect{ click_link "削除" }.to change{ Task.count }.by(-1)

      #一覧から該当のタスクが削除されているか確認
      expect(page).not_to have_content task.name
      expect(page).not_to have_content task.description

      # 削除のフラッシュメッセージが表示されているか確認
      expect(page).to have_selector ".notice", text: "タスクを削除しました"
    end
  end

  feature "タスクの並び順" do
    let(:first_selector) { ".task_content:nth-child(2)" }
    let(:second_selector) { ".task_content:nth-child(3)" }
    let(:third_selector) { ".task_content:last-child" }

    let!(:task_1) {
      create(
        :task,
        name: "task_name_1",
        created_at: Time.current,
        priority: :middle,
        user: user
      )
    }
    let!(:task_2) {
      create(
        :task,
        name: "task_name_2",
        created_at: 2.days.ago,
        priority: :high,
        user: user
      )
    }
    let!(:task_3) {
      create(
        :task,
        name: "task_name_3",
        created_at: 1.day.ago,
        priority: :low,
        user: user
      )
    }

    background do
      visit root_path
    end

    feature "名前" do
      context "昇順をクリックした時" do
        scenario "昇順になる" do
          visit "?column=name&order=asc"

          expect(page).to have_selector first_selector , text: "task_name_1"
          expect(page).to have_selector second_selector , text: "task_name_2"
          expect(page).to have_selector third_selector , text: "task_name_3"
        end
      end

      context "降順をクリックした時" do
        scenario "降順になる" do
          visit "?column=name&order=desc"

          expect(page).to have_selector first_selector , text: "task_name_3"
          expect(page).to have_selector second_selector , text: "task_name_2"
          expect(page).to have_selector third_selector , text: "task_name_1"
        end
      end
    end

    feature "作成日" do
      context "昇順をクリックした時" do
        scenario "昇順になる" do
          visit "?column=created_at&order=asc"

          expect(page).to have_selector first_selector , text: "task_name_2"
          expect(page).to have_selector second_selector , text: "task_name_3"
          expect(page).to have_selector third_selector , text: "task_name_1"
        end
      end

      context "降順をクリックした時" do
        scenario "降順になる" do
          visit "?column=created_at&order=desc"

          expect(page).to have_selector first_selector , text: "task_name_1"
          expect(page).to have_selector second_selector , text: "task_name_3"
          expect(page).to have_selector third_selector , text: "task_name_2"
        end
      end
    end

    feature "優先度" do
      context "昇順をクリックした時" do
        scenario "昇順になる" do
          visit "?column=priority&order=asc"

          expect(page).to have_selector first_selector , text: "task_name_3"
          expect(page).to have_selector second_selector , text: "task_name_1"
          expect(page).to have_selector third_selector , text: "task_name_2"
        end
      end

      context "降順をクリックした時" do
        scenario "降順になる" do
          visit "?column=priority&order=desc"

          expect(page).to have_selector first_selector , text: "task_name_2"
          expect(page).to have_selector second_selector , text: "task_name_1"
          expect(page).to have_selector third_selector , text: "task_name_3"
        end
      end
    end
  end

  feature "検索" do
    let!(:apple) { create(:task, name: "apple", status: :todo, user: user) }
    let!(:banana) { create(:task, name: "banana", status: :doing, user: user) }
    let!(:cherry) { create(:task, name: "cherry", status: :done, user: user) }

    background do
      visit root_path
    end

    context "名前を検索した時" do
      background do
        fill_in :search_field, with: "a"
        click_button "検索"
      end

      scenario "マッチした結果が表示される" do
        expect(page).to have_selector ".task_content:nth-child(3) .task_name_line", text: "apple"
        expect(page).to have_selector ".task_content:nth-child(2) .task_name_line", text: "banana"
      end

      scenario "マッチしなかった結果が表示されない" do
        expect(page).not_to have_selector ".task_name_line", text: "cherry"
      end
    end

    context "ステータスを検索した時" do
      background do
        select "未着手", from: "status"
        click_button "検索"
      end

      scenario "マッチした結果が表示される" do
        expect(page).to have_selector ".task_name_line", text: "apple"
      end

      scenario "マッチしなかった結果が表示されない" do
        expect(page).not_to have_selector ".task_name_line", text: "blueberry"
        expect(page).not_to have_selector ".task_name_line", text: "cherry"
      end
    end

    context "名前とステータス両方で検索した時" do
      background do
        fill_in :search_field, with: "b"
        select "着手" , from: "status"
        click_button "検索"
      end

      scenario "マッチした結果が表示される" do
        expect(page).to have_selector ".task_name_line", text: "banana"
      end

      scenario "マッチしなかった結果が表示されない" do
        expect(page).not_to have_selector ".task_name_line", text: "apple"
        expect(page).not_to have_selector ".task_name_line", text: "cherry"
      end
    end
  end

  feature "ページネーション" do
    context "タスクが11個以上登録されている時" do
      background do
        11.times do |i|
          create(:task, name: "task_#{i}", user: user)
        end
        visit root_path
      end

      scenario "1ページ目にタスクが10個ある" do
        expect(all(".task_content").size).to eq(10)
      end

      scenario "2ページ目へのリンクがある" do
        expect(page).to have_selector ".page a", text: "2"
        expect(page).to have_selector ".next a", text: "次 ›"
        expect(page).to have_selector ".last a", text: "最後 »"
      end

      scenario "2ページ目にタスクが1個ある" do
        click_link "次 ›"

        expect(all(".task_content").size).to eq(1)
      end

      scenario "2ページ目でも正しい順にソートされている" do
        click_link "次 ›"

        expect(page).to have_selector ".task_name_line", text: "task_0"
      end
    end

    context "タスクが9個以下登録されている時" do
      background do
        create_list(:task, 9, user: user)
        visit root_path
      end

      scenario "1ページ目にタスクが9個ある" do
        expect(all(".task_content").size).to eq(9)
      end

      scenario "2ページ目へのリンクがない" do
        expect(page).not_to have_selector ".page a", text: "2"
        expect(page).not_to have_selector ".next a", text: "次 ›"
        expect(page).not_to have_selector ".last a", text: "最後 »"
      end

      scenario "2ページ目にタスクがない" do
        visit "?page=2"

        expect(all(".task_content").size).to eq(0)
      end
    end
  end

  feature "ログインしたユーザに紐付いたタスクのみを表示する" do
    let!(:other_user) { create(:user) }

    background do
      create(:task, name: "login_user_task", user: user)
      create(:task, name: "other_user_task", user: other_user)

      visit root_path
    end

    scenario "ユーザに紐づいたタスクが表示される" do
      expect(page).to have_selector ".task_name_line", text: "login_user_task"
    end

    scenario "ユーザに紐づいていないタスクが表示されない" do
      expect(page).not_to have_selector ".task_name_line", text: "other_user_task"
    end
  end
end
