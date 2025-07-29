defmodule HomeWeb.WheelOfLifeLiveTest do
  use ExUnit.Case, async: true

  alias HomeWeb.WheelOfLifeLive

  describe "answer_state/1" do
    test "returns :not_started when all ratings are nil" do
      state = %{
        family: %{rating: nil, definition: nil},
        emotional: %{rating: nil, definition: nil},
        social: %{rating: nil, definition: nil},
        spiritual: %{rating: nil, definition: nil},
        educational: %{rating: nil, definition: nil},
        physical: %{rating: nil, definition: nil},
        career: %{rating: nil, definition: nil},
        financial: %{rating: nil, definition: nil}
      }

      assert WheelOfLifeLive.answer_state(state) == :not_started
    end

    test "returns :partially_answered when some ratings are nil and some are integers" do
      state = %{
        family: %{rating: 7, definition: "Good family relationships"},
        emotional: %{rating: nil, definition: nil},
        social: %{rating: 5, definition: "Average social life"},
        spiritual: %{rating: nil, definition: nil},
        educational: %{rating: 8, definition: "Learning new things"},
        physical: %{rating: nil, definition: nil},
        career: %{rating: nil, definition: nil},
        financial: %{rating: 6, definition: "Stable finances"}
      }

      assert WheelOfLifeLive.answer_state(state) == :partially_answered
    end

    test "returns :partially_answered when only one rating is provided" do
      state = %{
        family: %{rating: 9, definition: "Excellent family time"},
        emotional: %{rating: nil, definition: nil},
        social: %{rating: nil, definition: nil},
        spiritual: %{rating: nil, definition: nil},
        educational: %{rating: nil, definition: nil},
        physical: %{rating: nil, definition: nil},
        career: %{rating: nil, definition: nil},
        financial: %{rating: nil, definition: nil}
      }

      assert WheelOfLifeLive.answer_state(state) == :partially_answered
    end

    test "returns :complete when all ratings are integers" do
      state = %{
        family: %{rating: 8, definition: "Strong family bonds"},
        emotional: %{rating: 7, definition: "Good emotional health"},
        social: %{rating: 6, definition: "Active social life"},
        spiritual: %{rating: 5, definition: "Some spiritual practice"},
        educational: %{rating: 9, definition: "Continuous learning"},
        physical: %{rating: 7, definition: "Regular exercise"},
        career: %{rating: 8, definition: "Fulfilling work"},
        financial: %{rating: 6, definition: "Financial stability"}
      }

      assert WheelOfLifeLive.answer_state(state) == :complete
    end

    test "returns :complete when all ratings are integers including zeros" do
      state = %{
        family: %{rating: 0, definition: "No family connection"},
        emotional: %{rating: 1, definition: "Poor emotional state"},
        social: %{rating: 2, definition: "Limited social interaction"},
        spiritual: %{rating: 3, definition: "Minimal spiritual practice"},
        educational: %{rating: 4, definition: "Basic education"},
        physical: %{rating: 5, definition: "Average physical health"},
        career: %{rating: 6, definition: "Okay career"},
        financial: %{rating: 10, definition: "Excellent finances"}
      }

      assert WheelOfLifeLive.answer_state(state) == :complete
    end
  end
end
