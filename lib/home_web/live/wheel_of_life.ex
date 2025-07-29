defmodule HomeWeb.WheelOfLifeLive do
  use HomeWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    state = initial_state()

    {:ok,
     socket
     |> assign(:page_title, "Life Wheel")
     |> assign(:state, state)
     |> assign(:current_question, get_current_question(state))}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-2 gap-8">
      <%= case answer_state(@state) do %>
        <% :complete -> %>
          <div class="text-zinc-800 dark:text-zinc-300">
            <.wheel_of_life_svg values={chart_options(@state)} />
          </div>
        <% _ -> %>
          <.question_form current_question={@current_question} />
      <% end %>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("submit", %{"section" => section_key, "rating" => rating}, socket) do
    section_key = String.to_existing_atom(section_key)
    rating = String.to_integer(rating)
    state = Map.update!(socket.assigns.state, section_key, &Map.put(&1, :rating, rating))

    {:noreply,
     socket
     |> assign(:state, state)
     |> assign(:current_question, get_current_question(state))}
  end

  def question_form(assigns) do
    ~H"""
    <section class="rating-scale flex flex-col items-center gap-4">
      <h1 class="text-xl font-bold">Rate {@current_question} on a scale of 1 to 10</h1>
      <div class="flex flex-row gap-4">
        <button
          :for={rating <- 0..10}
          class="border-2 rounded w-12 h-12 hover:bg-blue-500 hover:text-white"
          aria-label={"Rating #{rating}"}
          phx-value-section={@current_question}
          phx-value-rating={rating}
          phx-click="submit"
        >
          {rating}
        </button>
      </div>
    </section>
    """
  end

  def initial_state do
    %{
      career: %{rating: nil, definition: nil},
      money: %{rating: nil, definition: nil},
      health: %{rating: nil, definition: nil},
      growth: %{rating: nil, definition: nil},
      relationships: %{rating: nil, definition: nil},
      environment: %{rating: nil, definition: nil},
      recreation: %{rating: nil, definition: nil},
      spirituality: %{rating: nil, definition: nil}
    }
  end

  def answer_state(state) do
    scores =
      state
      |> Enum.map(fn
        {_key, %{rating: nil}} -> :unscored
        {_key, %{rating: rating}} when is_integer(rating) -> :scored
      end)
      |> Enum.frequencies()

    case scores do
      %{unscored: _unscored, scored: _scored} -> :partially_answered
      %{unscored: unscored} when unscored > 0 -> :not_started
      %{scored: scored} when scored > 0 -> :complete
    end
  end

  def get_current_question(state) do
    state
    |> Enum.find_value(fn
      {key, %{rating: nil}} -> key
      {_key, %{rating: _}} -> false
    end)
  end

  def chart_options(answers) do
    answers
    |> Enum.map(fn {key, %{rating: rating}} ->
      # future = Enum.random(1..(10 - rating)) + rating
      future = 0
      {key, %{current: rating, future: future}}
    end)
    |> Enum.into(%{})
  end
end
