defmodule HomeWeb.ComponentsLive do
  use HomeWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>Components Live</h1>
      <.numbered_scale />
    </div>
    """
  end

  def numbered_scale(assigns) do
    ~H"""
    <section class="rating-scale flex flex-col items-center gap-4">
      <h1 class="text-xl font-bold">Rate on a scale of 1 to 10</h1>
      <div class="flex flex-row gap-4">
        <button
          :for={score <- 0..10}
          class="border-2 rounded w-12 h-12 hover:bg-blue-500 hover:text-white"
          value={score}
          aria-label={"Rating #{score}"}
        >
          {score}
        </button>
      </div>
    </section>
    """
  end
end
