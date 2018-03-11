require 'rails_helper'

describe "タスク" do
  let(:task) { build(:task, name: task_name) }

  it "有効なファクトリであること" do
    expect(build(:task)).to be_valid
  end

  describe "バリデーション" do
    context "タスク名が入力された時" do
      let(:task_name) { "hoge" }

      it "名前があれば有効な状態であること" do
        expect(task).to be_valid
      end
    end

    context "タスク名が入力されていない時" do
      let(:task_name) { nil }

      it "名前がなければ無効な状態であること" do
        expect(task).to be_invalid
      end
    end
  end

  describe "ソート" do
    let!(:task_1) {
      create(
        :task,
        name: "task_name_1",
        description: "banana",
        expires_at: 1.day.ago,
        created_at: Time.current,
        priority: :middle
      )
    }
    let!(:task_2) {
      create(
        :task,
        name: "task_name_2",
        description: "cherry",
        expires_at: 2.days.since,
        created_at: 2.days.ago,
        priority: :high
      )
    }
    let!(:task_3) {
      create(
        :task,
        name: "task_name_3",
        description: "apple",
        expires_at: Time.current,
        created_at: 1.day.ago,
        priority: :low
      )
    }

    describe "名前" do
      it "昇順になる" do
        expect(Task.order_by("name", "asc")).to eq [task_1, task_2, task_3]
      end

      it "降順になる" do
        expect(Task.order_by("name", "desc")).to eq [task_3, task_2, task_1]
      end
    end

    describe "説明" do
      it "昇順になる" do
        expect(Task.order_by("description", "asc")).to eq [task_3, task_1, task_2]
      end

      it "降順になる" do
        expect(Task.order_by("description", "desc")).to eq [task_2, task_1, task_3]
      end
    end

    describe "期限" do
      it "昇順になる" do
        expect(Task.order_by("expires_at", "asc")).to eq [task_1, task_3, task_2]
      end

      it "降順になる" do
        expect(Task.order_by("expires_at", "desc")).to eq [task_2, task_3, task_1]
      end
    end

    describe "作成日" do
      it "昇順になる" do
        expect(Task.order_by("created_at", "asc")).to eq [task_2, task_3, task_1]
      end

      it "降順になる" do
        expect(Task.order_by("created_at", "desc")).to eq [task_1, task_3, task_2]
      end
    end

    describe "優先度" do
      it "昇順になる" do
        expect(Task.order_by("priority", "asc")).to eq [task_3, task_1, task_2]
      end

      it "降順になる" do
        expect(Task.order_by("priority", "desc")).to eq [task_2, task_1, task_3]
      end
    end
  end

  describe "検索" do
    let!(:apple) { create(:task, name: "apple", status: :todo) }
    let!(:banana) { create(:task, name: "banana", status: :doing) }
    let!(:cherry) { create(:task, name: "cherry", status: :done) }

    context "名前を検索した時" do
      it "マッチした結果が返ってくる" do
        expect(Task.search_by_name("a")).to eq [apple, banana]
      end

      it "マッチしなかったものは含まれない" do
        expect(Task.search_by_name("a")).not_to include cherry
      end

      it "未入力なら全ての結果が返ってくる"  do
        expect(Task.search_by_name("")).to eq [apple, banana, cherry]
      end
    end

    context "ステータスを検索した時" do
      it "マッチした結果が返ってくる" do
        expect(Task.search_by_status(:todo)).to include apple
      end

      it "マッチしなかったものは含まれない" do
        expect(Task.search_by_status(:todo)).not_to include [banana, cherry]
      end

      it "未入力なら全ての結果が返ってくる" do
        expect(Task.search_by_status("")).to eq [apple, banana, cherry]
      end
    end
  end
end
