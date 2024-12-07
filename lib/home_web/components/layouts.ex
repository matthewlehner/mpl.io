defmodule HomeWeb.Layouts do
  use HomeWeb, :html

  embed_templates "layouts/*"

  def footer(assigns) do
    ~H"""
    <footer class="max-w-prose w-full mx-auto mt-32 px-4 sm:px-6">
      <div class="border-t border-zinc-100 pb-16 pt-10 dark:border-zinc-700/40">
        <div class="flex flex-row items-center justify-between gap-6">
          <%!--
          <div class="flex flex-wrap justify-center gap-x-6 gap-y-1 text-sm font-medium text-zinc-800 dark:text-zinc-200">
            <.footer_link href="/about">About</.footer_link>
            <.footer_link href="/projects">Projects</.footer_link>
            <.footer_link href="/speaking">Speaking</.footer_link>
            <.footer_link href="/uses">Uses</.footer_link>
          </div>
          --%>
          <p class="text-sm text-zinc-400 dark:text-zinc-500">
            &copy; {Date.utc_today() |> Map.get(:year)} Matthew Lehner. All rights reserved. For real.
          </p>
        </div>
      </div>
    </footer>
    """
  end

  attr :rest, :global, include: ~w(href)
  slot :inner_block, required: true

  def footer_link(assigns) do
    ~H"""
    <.link {@rest} class="transition hover:text-teal-500 dark:hover:text-teal-400">
      {render_slot(@inner_block)}
    </.link>
    """
  end
end
